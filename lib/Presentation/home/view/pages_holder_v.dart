import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/widgets/material_picker_v.dart';
import 'package:moatmat_admin/Presentation/banks/views/banks_search_result_v.dart';
import 'package:moatmat_admin/Presentation/codes/views/codes_views_manager.dart';
import 'package:moatmat_admin/Presentation/requests/views/requests_view_manager.dart';
import 'package:moatmat_admin/Presentation/teachers/views/add_teacher_v.dart';
import 'package:moatmat_admin/Presentation/teachers/views/all_teachers_v.dart';
import 'package:moatmat_admin/Presentation/tests/views/tests_search_result_v.dart';

import '../../banks/views/add_bank_view.dart';
import '../../banks/views/my_banks_v.dart';
import '../../students/views/add_results_v.dart';
import '../../tests/views/add_test_vew.dart';
import '../../tests/views/my_tests_v.dart';

class PagesHolderView extends StatefulWidget {
  const PagesHolderView({super.key});

  @override
  State<PagesHolderView> createState() => _PagesHolderViewState();
}

class _PagesHolderViewState extends State<PagesHolderView> {
  int index = 0;
  late final PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(
      initialPage: index,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          index = value;
          setState(() {});
        },
        children: [
          //
          const AllTeachersView(),
          //
          MaterialPickerView(
            onPick: (s) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyTestsView(
                  material: s,
                ),
              ));
            },
            onSearch: (p0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TestsSearchResultView(keyword: p0),
                ),
              );
            },
          ),
          //
          MaterialPickerView(
            onPick: (s) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyBanksView(material: s),
              ));
            },
            onSearch: (p0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BanksSearchResultView(keyword: p0),
                ),
              );
            },
          ),
          //
          const RequestsViewManager(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorsResources.red,
        unselectedItemColor: ColorsResources.borders,
        useLegacyColorScheme: false,
        selectedItemColor: ColorsResources.primary,
        currentIndex: index,
        onTap: (value) {
          _pageController.animateToPage(
            value,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 200),
          );
          index = value;
          setState(() {});
        },
        iconSize: 20,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.group),
            ),
            label: "الاساتذة",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.quiz),
            ),
            label: "اختباراتي",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.library_books),
            ),
            label: "بنوكي",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.file_copy_sharp),
            ),
            label: "طلبات رفع",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_home,
        children: [
          SpeedDialChild(
            label: "انشاء اكواد",
            child: const Icon(Icons.qr_code),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CodesViewManager(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "إضافة استاذ",
            child: const Icon(Icons.person),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddTeacherView(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "إضافة بنك",
            child: const Icon(Icons.add),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddBankView(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "رفع ملف علامات",
            child: const Icon(Icons.account_tree_outlined),
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddResultsView(),
                ),
              );
            },
          ),
          SpeedDialChild(
            label: "إضافة أختبار",
            child: const Icon(Icons.person_pin_circle_outlined),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddTestView()),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
      ),
    );
  }
}
