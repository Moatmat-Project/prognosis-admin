import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';

import 'package:moatmat_admin/Core/resources/texts_resources.dart';
import 'package:moatmat_admin/Core/widgets/appbar/student_search_icon.dart';

import 'package:moatmat_admin/Presentation/banks/views/add_bank_view.dart';

import 'package:moatmat_admin/Presentation/banks/views/my_banks_v.dart';
import 'package:moatmat_admin/Presentation/codes/views/codes_views_manager.dart';
import 'package:moatmat_admin/Presentation/codes/views/print_students_code_view.dart';
import 'package:moatmat_admin/Presentation/notifications/state/send_notification_bloc/send_notification_bloc.dart';
import 'package:moatmat_admin/Presentation/notifications/views/send_notification_view.dart';
import 'package:moatmat_admin/Presentation/requests/views/requests_view_manager.dart';
import 'package:moatmat_admin/Presentation/schools/views/schools_view.dart';
import 'package:moatmat_admin/Presentation/students/views/add_results_v.dart';
import 'package:moatmat_admin/Presentation/students/views/add_student_balance_v.dart';
import 'package:moatmat_admin/Presentation/teachers/views/all_teachers_v.dart';

import '../../../Core/widgets/appbar/notifications_icon_w.dart';
import '../../../Core/widgets/appbar/report_icon_w.dart';

import 'package:moatmat_admin/Presentation/home/widgets/home_card_widget.dart';

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Centralize pages and nav items to keep lengths in sync.
    final pages = [
      //
      MainPage(),
      //
      MyBanksView(),
      //
      const RequestsViewManager(),
    ];

    final navItems = const [
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.home_filled),
        ),
        label: "الرئيسية",
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
    ];

    // Safely clamp index to avoid assertion when items/pages change (e.g., hot reload)
    final maxIndex = pages.length - 1;
    final safeIndex = index.clamp(0, maxIndex);
    if (safeIndex != index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          index = safeIndex;
          _pageController.jumpToPage(safeIndex);
        });
      });
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          index = value;
          setState(() {});
        },
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorsResources.background,
        unselectedItemColor: ColorsResources.borders,
        useLegacyColorScheme: false,
        selectedItemColor: ColorsResources.primary,
        currentIndex: safeIndex,
        onTap: (value) {
          final target = value.clamp(0, maxIndex);
          _pageController.animateToPage(
            target,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 200),
          );
          index = target;
          setState(() {});
        },
        iconSize: 20,
        items: navItems,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_home,
        children: [
          SpeedDialChild(
            label: "طباعة اكواد",
            child: const Icon(Icons.picture_as_pdf_outlined),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PrintStudentsCodeView(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
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
            label: "شحن رصيد طالب",
            child: const Icon(Icons.currency_exchange),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddStudentBalanceView(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "إضافة بنك",
            child: const Icon(Icons.account_balance_outlined),
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
            child: const Icon(Icons.upload_file_outlined),
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddResultsView(),
                ),
              );
            },
          ),
          // SpeedDialChild(
          //   label: "إضافة أختبار",
          //   child: const Icon(Icons.quiz_outlined),
          //   onTap: () async {
          //     await Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => const AddTestView()),
          //     );
          //     FocusManager.instance.primaryFocus?.unfocus();
          //   },
          // ),
          // SpeedDialChild(
          //   label: "إرسال اشعارات",
          //   child: const Icon(Icons.notification_add),
          //   onTap: () async {
          //     await Navigator.of(context).push(
          //       MaterialPageRoute(
          //           builder: (context) => BlocProvider(
          //                 create: (context) => locator<SendNotificationBloc>(),
          //                 child: SendNotificationView(),
          //               )),
          //     );
          //     FocusManager.instance.primaryFocus?.unfocus();
          //   },
          // ),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppBarTitles.home),
        actions: const [
          StudentsSearchIconWidget(),
          ReportIconWidget(),
          NotificationsIconWidget(),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            HomeCardWidget(
              icon: Icons.school_rounded,
              title: "ادارة الجامعات",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SchoolsView(),
                  ),
                );
              },
            ),
            HomeCardWidget(
              icon: Icons.person_pin_rounded,
              title: "ادارة الاساتذة",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllTeachersView(),
                  ),
                );
              },
            ),
            HomeCardWidget(
              icon: Icons.notification_add,
              title: "إرسال اشعارات",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => locator<SendNotificationBloc>(),
                            child: SendNotificationView(),
                          )),
                );
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
