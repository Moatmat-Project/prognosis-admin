import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/functions/show_alert.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Presentation/teachers/views/export_purchases_excel_v.dart';
import 'package:moatmat_admin/Presentation/teachers/widgets/time_range_w.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/purchase/domain/entities/purchase_item.dart';
import '../state/manage_teacher_purchases/manage_teacher_purchases_bloc.dart';

class ManageTeacherPurchasesView extends StatefulWidget {
  const ManageTeacherPurchasesView({super.key, required this.teacherData});
  final TeacherData teacherData;
  @override
  State<ManageTeacherPurchasesView> createState() => _ManageTeacherPurchasesViewState();
}

class _ManageTeacherPurchasesViewState extends State<ManageTeacherPurchasesView> {
  @override
  void initState() {
    context.read<ManageTeacherPurchasesBloc>().add(ManageTeacherPurchasesLoadEvent(teacher: widget.teacherData));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ManageTeacherPurchasesBloc, ManageTeacherPurchasesState>(
        listener: (context, state) {
          if (state is ManageTeacherPurchasesAddPurchaseState) {
            if ((state.student != null) && !state.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback(
                (e) {
                  showAlert(
                    context: context,
                    title: "تاكيد اضافة المشترك",
                    body: 'هل انت متاكد من انك تريد اضافة ${state.student!.name} الى مشتركين المعلم؟',
                    agreeBtn: "تاكيد",
                    onAgree: () {
                      context.read<ManageTeacherPurchasesBloc>().add(
                            ManageTeacherPurchasesAddPurchaseEvent(
                              id: state.student!.id,
                              confirmed: true,
                              userData: state.student!,
                            ),
                          );
                    },
                  );
                },
              );
            }
          }
        },
        builder: (context, state) {
          if (state is ManageTeacherPurchasesInitialState) {
            return ManageTeacherPurchasesInitialView(state: state, teacherEmail: widget.teacherData.email);
          } else if (state is ManageTeacherPurchasesAddPurchaseState) {
            return ManageTeacherPurchasesAddPurchaseView(state: state);
          }

          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}

class ManageTeacherPurchasesAddPurchaseView extends StatefulWidget {
  const ManageTeacherPurchasesAddPurchaseView({super.key, required this.state});
  final ManageTeacherPurchasesAddPurchaseState state;
  @override
  State<ManageTeacherPurchasesAddPurchaseView> createState() => _ManageTeacherPurchasesAddPurchaseViewState();
}

class _ManageTeacherPurchasesAddPurchaseViewState extends State<ManageTeacherPurchasesAddPurchaseView> {
  final TextEditingController _studentIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اضافة اشتراك"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: SizesResources.s4),
            MyTextFormFieldWidget(
              controller: _studentIdController,
              hintText: "معرف الطالب",
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "الرجاء ادخال معرف الطالب";
                }

                return null;
              },
            ),
            SizedBox(height: SizesResources.s4),
            ElevatedButtonWidget(
              loading: widget.state.isLoading,
              text: "اضافة الى مشتركين المعلم",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ManageTeacherPurchasesBloc>().add(
                        ManageTeacherPurchasesAddPurchaseEvent(id: _studentIdController.text),
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ManageTeacherPurchasesInitialView extends StatefulWidget {
  const ManageTeacherPurchasesInitialView({super.key, required this.state, required this.teacherEmail});
  final ManageTeacherPurchasesInitialState state;
  final String teacherEmail;

  @override
  State<ManageTeacherPurchasesInitialView> createState() => _ManageTeacherPurchasesInitialViewState();
}

class _ManageTeacherPurchasesInitialViewState extends State<ManageTeacherPurchasesInitialView> {
  late TextEditingController _controller;
  List<PurchaseItem> items = [];
  List<PurchaseItem> search = [];
  late DateTime _starting, _ending;
  @override
  void initState() {
    //
    items = widget.state.items;
    //
    _starting = _parseToCurrentYear(items.last.createdAt!);
    //
    _ending = _parseToCurrentYear(items.first.createdAt!);
    //
    search = widget.state.items;
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      // if (_controller.text.isEmpty) {
      //   search = items;
      // } else {
      //   search = items.where((e) {
      //     return e.userName.contains(_controller.text);
      //   }).toList();
      // }
      // setState(() {});
      _applyFilters();
    });
    //
    super.initState();
  }

  void _applyFilters() {
    final query = _controller.text.toLowerCase();
    setState(() {
      search = items.where((e) {
        // filter by search
        final matchesSearch = query.isEmpty || e.userName.toLowerCase().contains(query);

        // filter by date
        final date = _parseToCurrentYear(e.createdAt!);
        final matchesDate = !date.isBefore(_starting) && !date.isAfter(_ending);

        // join
        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  DateTime _parseToCurrentYear(String datetime) {
    return DateTime.parse(datetime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              context.read<ManageTeacherPurchasesBloc>().add(ManageTeacherPurchasesStartAddPurchaseEvent());
            },
            child: Text("اضافة اشتراك"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExportPurchasesExcelView(purchases: items, teacherEmail: widget.teacherEmail),
            ),
          );
        },
        child: Icon(Icons.file_open),
      ),
      body: Column(
        children: [
          TeacherPurchasesInformation(
            items: search,
          ),
          const SizedBox(height: SizesResources.s2), //
          //
          MyTextFormFieldWidget(
            hintText: "بحث",
            controller: _controller,
            textInputAction: TextInputAction.done,
            maxLines: 1,
          ),
          const SizedBox(height: SizesResources.s2),
          TimeRangeWidget(
            limitOnDate: false,
            starting: _starting,
            ending: _ending,
            onChangeStartingDate: (date) {
              setState(() {
                _starting = date;
                if (_ending.isBefore(_starting)) {
                  _ending = _starting;
                }
              });
              _applyFilters();
            },
            onChangeEndingDate: (date) {
              setState(() {
                _ending = date;
                if (_ending.isBefore(_starting)) {
                  _starting = _ending;
                }
              });
              _applyFilters();
            },
          ),
          const SizedBox(height: SizesResources.s3),
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SpacingResources.mainWidth(context),
                child: const Text("سجل الاشتراكات :"),
              ),
            ],
          ),
          const SizedBox(height: SizesResources.s2),
          Expanded(
            child: ListView.builder(
              itemCount: search.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: SpacingResources.mainWidth(context),
                      margin: const EdgeInsets.symmetric(
                        vertical: SizesResources.s1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: SizesResources.s3,
                        vertical: SizesResources.s3,
                      ),
                      decoration: BoxDecoration(
                        color: ColorsResources.onPrimary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: ShadowsResources.mainBoxShadow,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (search[index].userName.isNotEmpty)
                                  Text(
                                    "اسم الطالب : ${search[index].userName}",
                                  ),
                                Text(
                                  "المبلغ : ${search[index].amount}",
                                ),
                                Text(
                                  "يوم/شهر : ${search[index].dayAndMoth}",
                                ),
                                SizedBox(height: SizesResources.s2),
                                Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: ColorsResources.red,
                                    ),
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(12),
                                    color: ColorsResources.red.withAlpha(20),
                                    child: InkWell(
                                      splashColor: ColorsResources.red.withAlpha(20),
                                      highlightColor: ColorsResources.red.withAlpha(20),
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        showAlert(
                                          context: context,
                                          title: "الغاء الاشتراك",
                                          body: "هل انت متأكد من الغاء الاشتراك ؟",
                                          agreeBtn: "تاكيد",
                                          onAgree: () {
                                            context.read<ManageTeacherPurchasesBloc>().add(
                                                  ManageTeacherPurchasesCancelSubscriptionEvent(
                                                    item: search[index],
                                                  ),
                                                );
                                          },
                                        );
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 3.0),
                                          child: Text(
                                            "الغاء الاشتراك",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: ColorsResources.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: SizesResources.s1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherPurchasesInformation extends StatelessWidget {
  const TeacherPurchasesInformation({super.key, required this.items});
  final List<PurchaseItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          padding: const EdgeInsets.symmetric(
            vertical: SizesResources.s3,
            horizontal: SizesResources.s3,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s2,
          ),
          decoration: BoxDecoration(
            boxShadow: ShadowsResources.mainBoxShadow,
            borderRadius: BorderRadius.circular(10),
            color: ColorsResources.onPrimary,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عدد عمليات الاشتراك',
                    style: FontsResources.styleMedium(),
                  ),
                  Text(
                    "${items.length}",
                    style: FontsResources.styleExtraBold(
                      color: ColorsResources.darkPrimary,
                    ),
                  ),
                ],
              ),
              //
              const SizedBox(height: SizesResources.s2),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'صافي مبلغ الاشتراكات',
                    style: FontsResources.styleMedium(),
                  ),
                  Text(
                    "${amount()}",
                    style: FontsResources.styleExtraBold(
                      color: ColorsResources.darkPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  int amount() {
    int sum = 0;
    for (var i in items) {
      sum += i.amount;
    }
    return sum;
  }
}
