import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/functions/show_alert.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_admin/Presentation/tests/state/my_tests/my_tests_cubit.dart';
import 'package:moatmat_admin/Presentation/tests/state/test_information/test_information_cubit.dart';
import 'package:moatmat_admin/Presentation/tests/views/add_test_vew.dart';
import 'package:moatmat_admin/Presentation/tests/views/video_view_list.dart';
import 'package:moatmat_admin/Presentation/tests/widgets/purchases_informations_w.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../export/views/questions/export_questions_v.dart';
import '../../folders/view/add_item_to_folder_v.dart';
import '../../groups/views/group_test_details_v.dart';
import '../../tests_results/views/test_results_v.dart';

class TestDetailsView extends StatefulWidget {
  const TestDetailsView({
    super.key,
    this.test,
    this.testId,
  });
  final int? testId;
  final Test? test;
  @override
  State<TestDetailsView> createState() => _TestDetailsViewState();
}

class _TestDetailsViewState extends State<TestDetailsView> {
  late Test test;
  @override
  void initState() {
    context.read<TestInformationCubit>().init(
          test: widget.test,
          testId: widget.testId,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TestInformationCubit, TestInformationState>(
        builder: (context, state) {
          if (state is TestInformationInitial) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.test.information.title),
              ),
              body: Column(
                children: [
                  TouchableTileWidget(
                    title: "تعديل",
                    iconData: Icons.edit,
                    onTap: () async {
                      if (locator<TeacherData>().options.allowUpdate) {
                        //
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddTestView(
                            test: state.test,
                          ),
                        ));
                        //
                        if (mounted) {
                          context.read<MyTestsCubit>().init();
                          Navigator.of(context).pop();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مسموح بالعملية"),
                          ),
                        );
                      }
                    },
                  ),
                  TouchableTileWidget(
                    title: "إضافة الاختبار إلى مجلد",
                    iconData: Icons.folder,
                    onTap: () async {
                      if (locator<TeacherData>().options.allowUpdate) {
                        //
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddItemToFolderView(
                              id: state.test.id,
                              isTest: true,
                              teacherEmail: state.test.teacherEmail,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مسموح بالعملية"),
                          ),
                        );
                      }
                    },
                  ),
                  TouchableTileWidget(
                    title: "تفاصيل مجموعات الطلاب",
                    iconData: Icons.people,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GroupTestDetailsView(
                            test: state.test,
                          ),
                        ),
                      );
                    },
                  ),
                  TouchableTileWidget(
                    title: "ادارة التعليقات",
                    iconData: Icons.manage_accounts,
                    onTap: () {
                      final videos = widget.test?.information.videos;
                      final testId = widget.test?.id ?? -1;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VideosListView(
                            videos: videos ?? [],
                            testId: testId,
                          ),
                        ),
                      );
                    },
                  ),
                  TouchableTileWidget(
                    title: "حذف",
                    iconData: Icons.delete,
                    onTap: () {
                      if (locator<TeacherData>().options.allowDelete) {
                        showAlert(
                          context: context,
                          title: "تأكيد",
                          body: "هل انت متاكد من انك تريد حذف الاختبار",
                          onAgree: () {
                            context.read<MyTestsCubit>().deleteTest(state.test);
                            Navigator.of(context).pop();
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مسموح بالعملية"),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: SpacingResources.mainWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TouchableTileWidget(
                          title: "تصفح نتائج الاختبار",
                          iconData: Icons.arrow_forward_ios,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TestResultsView(
                                  test: state.test,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SpacingResources.mainWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TouchableTileWidget(
                          title: "تصدير الاختبار",
                          iconData: Icons.arrow_forward_ios,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ExportQuestionsView(
                                  questions: state.test.questions,
                                  title: state.test.information.title,
                                  teacher: state.test.information.teacher,
                                  period: state.test.information.period,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  PurchasesInformation(
                    items: state.items,
                  ),
                  const SizedBox(height: SizesResources.s2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: SpacingResources.mainWidth(context), child: const Text("عمليات الشراء :")),
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
          } else if (state is TestInformationError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(state.message ?? ""),
              ),
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
