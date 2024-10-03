import 'package:flutter/material.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';

import '../widgets/test_tile_w.dart';

class TestsAndFoldersViewBuilder extends StatelessWidget {
  const TestsAndFoldersViewBuilder({
    super.key,
    required this.tests,
    required this.folders,
    required this.onOpenTest,
    required this.onOpenFolder,
    required this.onBack,
    required this.onDeleteFolder,
    required this.onUpdateFolder,
  });
  final List<Test> tests;
  final List<String> folders;
  //
  final Function(int i, Test t) onOpenTest;
  final Function(int i, String f) onOpenFolder;
  final Function(int i, String f) onDeleteFolder;
  final Function(int i, String f) onUpdateFolder;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: InkWell(
      //     onTap: onBack,
      //     child: const Icon(
      //       Icons.arrow_back_ios,
      //       size: 12,
      //     ),
      //   ),
      // ),
      body: ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
        itemCount: folders.length + tests.length,
        itemBuilder: (context, index) {
          if (index < folders.length) {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // FolderWidget(
                //   folder: folders[index],
                //   onOpenFolder: () {
                //     int i = index;
                //     onOpenFolder(i, folders[index]);
                //   },
                //   onDeleteFolder: () {
                //     int i = index;
                //     onDeleteFolder(i, folders[index]);
                //   },
                //   onUpdateFolder: (f) {
                //     int i = index;
                //     onUpdateFolder(i, f);
                //   },
                // ),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TestTileWidget(
                  test: tests[index],
                  onPick: () {
                    int i = index - (folders.length);
                    onOpenTest(i, tests[index]);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
