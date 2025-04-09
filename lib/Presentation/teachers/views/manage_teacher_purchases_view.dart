import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/functions/show_alert.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';

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
      appBar: AppBar(),
      body: BlocBuilder<ManageTeacherPurchasesBloc, ManageTeacherPurchasesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return ManageTeacherPurchasesInitialView(state: state);
        },
      ),
    );
  }
}

class ManageTeacherPurchasesInitialView extends StatelessWidget {
  const ManageTeacherPurchasesInitialView({super.key, required this.state});
  final ManageTeacherPurchasesState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeacherPurchasesInformation(
          items: state.items,
        ),
        const SizedBox(height: SizesResources.s2),
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
            itemCount: state.items.length,
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
                              if (state.items[index].userName.isNotEmpty)
                                Text(
                                  "اسم الطالب : ${state.items[index].userName}",
                                ),
                              Text(
                                "المبلغ : ${state.items[index].amount}",
                              ),
                              Text(
                                "يوم/شهر : ${state.items[index].dayAndMoth}",
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
                                                  item: state.items[index],
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
