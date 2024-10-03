import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moatmat_admin/Presentation/tests/state/my_tests/my_tests_cubit.dart';
import 'package:moatmat_admin/Presentation/tests/views/test_details_v.dart';
import 'package:moatmat_admin/Presentation/tests/views/tests_and_folders_builder_v.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/appbar/contact_us_w.dart';
import '../../../Core/widgets/appbar/report_icon_w.dart';
import '../../../Core/widgets/appbar/search_icon_w.dart';
import '../../../Core/widgets/view/search_in_tests_v.dart';
import '../../scanner/state/cubit/explore_outer_tests_cubit.dart';
import '../../scanner/views/explore_outer_tests_v.dart';
import 'add_outer_test_view.dart';
import 'add_test_vew.dart';

class MyTestsView extends StatefulWidget {
  const MyTestsView({super.key, required this.material});
  final String material;
  @override
  State<MyTestsView> createState() => _MyTestsViewState();
}

class _MyTestsViewState extends State<MyTestsView> {
  @override
  void initState() {
    context.read<MyTestsCubit>().init(material: widget.material);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyTestsCubit, MyTestsState>(
        builder: (context, state) {
          if (state is MyTestsInitial) {
            return DefaultTabController(
              length: 2, // Number of tabs
              child: Scaffold(
                appBar: AppBar(
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'الاختبارات'),
                      Tab(text: 'اختبارات خارجية'),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SearchInTestsView(
                              tests: state.tests,
                              onPick: (test) async {
                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => TestDetailsView(
                                      test: test,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.search),
                    )
                  ],
                ),
                body: TabBarView(
                  children: [
                    // First tab content
                    RefreshIndicator(
                      onRefresh: () async {
                        context.read<MyTestsCubit>().update();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: SizesResources.s2),
                        child: TestsAndFoldersViewBuilder(
                          tests: state.tests,
                          folders: const [],
                          onOpenTest: (i, t) async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TestDetailsView(
                                  test: state.tests[i],
                                ),
                              ),
                            );
                            if (mounted) {
                              context.read<MyTestsCubit>().update();
                            }
                          },
                          onOpenFolder: (i, f) async {},
                          onBack: () {},
                          onDeleteFolder: (int i, String f) {},
                          onUpdateFolder: (int i, String f) {},
                        ),
                      ),
                    ),
                    // Second tab content
                    Padding(
                      padding: const EdgeInsets.only(top: SizesResources.s2),
                      child: ExploreOuterTestsView(material: widget.material),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MyTestsError) {
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  state.exception.toString(),
                  textAlign: TextAlign.center,
                )),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: BlocBuilder<MyTestsCubit, MyTestsState>(
        builder: (context, state) {
          return SpeedDial(
            animatedIcon: AnimatedIcons.menu_home,
            children: [
              SpeedDialChild(
                label: "اضافة أختبار",
                child: const Icon(Icons.add),
                onTap: () async {
                  await Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const AddTestView(),
                        ),
                      )
                      .then(
                        (value) => context.read<MyTestsCubit>().update(),
                      );
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              SpeedDialChild(
                label: "اضافة أختبار خارجي",
                child: const Icon(Icons.add),
                onTap: () async {
                  await Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const AddOuterTestView(),
                        ),
                      )
                      .then(
                        (value) => context.read<ExploreOuterTestsCubit>().init(),
                      );
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
