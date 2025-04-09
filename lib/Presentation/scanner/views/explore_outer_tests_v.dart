import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Features/students/data/models/result_m.dart';
import '../../../Core/functions/show_alert.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/toucheable_tile_widget.dart';
import '../../../Core/widgets/view/search_in_results_v.dart';
import '../../../Features/students/domain/entities/result.dart';
import '../../export/views/results/choose_export_v.dart';
import '../../students/views/student_v.dart';
import '../../students/widgets/result_tile_w.dart';
import '../../tests/views/outer_test_details_v.dart';
import '../../tests/widgets/outer_test_tile_w.dart';
import '../state/cubit/explore_outer_tests_cubit.dart';

class ExploreOuterTestsView extends StatefulWidget {
  const ExploreOuterTestsView({super.key, required this.material});
  final String material;
  @override
  State<ExploreOuterTestsView> createState() => _ExploreOuterTestsViewState();
}

class _ExploreOuterTestsViewState extends State<ExploreOuterTestsView> {
  @override
  void initState() {
    context.read<ExploreOuterTestsCubit>().init(material: widget.material);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExploreOuterTestsCubit, ExploreOuterTestsState>(
        builder: (context, state) {
          if (state is ExploreOuterTestsInitial) {
            return ListView.builder(
              itemCount: state.tests.length,
              itemBuilder: (context, index) {
                return OuterTestTileWidget(
                  test: state.tests[index],
                  onPick: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OUterTestDetailsView(
                          test: state.tests[index],
                        ),
                      ),
                    );
                  },
                );
              },
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

// class ExploreOuterTestResult extends StatelessWidget {
//   const ExploreOuterTestResult({super.key, required this.results, required this.title});
//   final String title;
//   final List<Result> results;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: () {
//               showAlert(
//                 context: context,
//                 title: "حذف الاختبار",
//                 body: "هل انت متاكد من انك تريد حذف نتائج الاختبار بالكامل؟",
//                 onAgree: () {
//                   Navigator.of(context).pop();
//                   context.read<ExploreOuterTestsCubit>().deleteTestResult(results);
//                 },
//               );
//             },
//             icon: const Icon(
//               Icons.delete,
//               color: Colors.red,
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => SearchInResultsView(
//                     results: results,
//                     onPick: (r) {
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(
//                           builder: (context) => StudentView(
//                             userName: r.userName,
//                             userId: r.userId,
//                             result: r,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               );
//             },
//             icon: const Icon(
//               Icons.search,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               children: [
//                 Text(
//                   "بريد المعلم : ${results.first.teacherEmail ?? ""}",
//                   textAlign: TextAlign.start,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: ColorsResources.primary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           TouchableTileWidget(
//             title: "تصدير نتائج الاختبار",
//             iconData: Icons.arrow_forward_ios,
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => ChooseExportV(
//                     name: title,
//                     results: results,
//                   ),
//                 ),
//               );
//             },
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: results.length,
//               itemBuilder: (context, index) {
//                 return Column(
//                   children: [
//                     if (index == 0)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: SizesResources.s3),
//                         child: Row(
//                           children: [
//                             Text(
//                               "عدد النتائج : ${results.length}",
//                               style: const TextStyle(
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     const SizedBox(height: SizesResources.s1),
//                     ResultTileWidget(
//                       showName: true,
//                       result: results[index],
//                       onExploreResult: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => StudentView(
//                               userName: results[index].userName,
//                               userId: results[index].userId,
//                               result: results[index],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
