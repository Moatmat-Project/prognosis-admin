import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/widgets/appbar/report_icon_w.dart';
import 'package:moatmat_admin/Core/widgets/appbar/student_search_icon.dart';
import 'package:moatmat_admin/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_admin/Presentation/teachers/state/cubit/teachers_manager_cubit.dart';
import 'package:moatmat_admin/Presentation/teachers/views/teacher_purchases_v.dart';
import 'package:moatmat_admin/Presentation/teachers/views/update_teacher_v.dart';

import '../../../Core/resources/texts_resources.dart';
import '../../../Core/widgets/appbar/search_icon_w.dart';

class AllTeachersView extends StatefulWidget {
  const AllTeachersView({super.key});

  @override
  State<AllTeachersView> createState() => _AllTeachersViewState();
}

class _AllTeachersViewState extends State<AllTeachersView> {
  @override
  void initState() {
    context.read<TeachersManagerCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الاساتذة"),
        actions: const [
          StudentsSearchIconWidget(),
          ReportIconWidget(),
        ],
      ),
      body: BlocConsumer<TeachersManagerCubit, TeachersManagerState>(
        listener: (context, state) {
          if (state is TeachersManagerTeacherPurchases) {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => TeacherPurchasesV(state: state),
              ),
            )
                .then((t) {
              context.read<TeachersManagerCubit>().init();
            });
          }
        },
        builder: (context, state) {
          if (state is TeachersManagerInitial) {
            return ListView.builder(
              itemCount: state.teachers.length,
              itemBuilder: (context, index) {
                return TouchableTileWidget(
                  title: state.teachers[index].name,
                  iconData: Icons.arrow_forward_ios,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateTeacherView(
                          teacherData: state.teachers[index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is TeachersManagerError) {
            return Center(
              child: Text(state.error ?? ""),
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
