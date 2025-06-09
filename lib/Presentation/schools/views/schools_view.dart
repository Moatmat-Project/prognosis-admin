import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/functions/show_alert.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/resources/texts_resources.dart';
import 'package:moatmat_admin/Presentation/schools/widgets/school_card_widget_widget.dart';
import '../models/school_model.dart';
import '../widgets/add_school_fab_widget.dart';
import './add_or_update_school_view.dart';

class SchoolsView extends StatelessWidget {
  const SchoolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppBarTitles.schools),
      ),
      body: Padding(
        padding: EdgeInsets.all(SpacingResources.sidePadding),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: schools.length,
          itemBuilder: (context, index) {
            final school = schools[index];
            return SchoolCard(
              school: school,
              onEdit: () => _onEditSchool(context, school),
              onDelete: () => _onDeleteSchool(context, school),
            );
          },
        ),
      ),
      floatingActionButton: AddSchoolFab(onPressed: () => _navigateToAddSchool(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _onEditSchool(BuildContext context, SchoolTemp school) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (context) => AddOrUpdateSchoolView(school: school)),
        )
        .then((_) {});
  }

  void _onDeleteSchool(BuildContext context, SchoolTemp school) {
    showAlert(
      context: context,
      title: TextsResources.deleteConfirmationTitle,
      body: TextsResources.deleteConfirmationContent,
      onAgree: () {},
    );
  }

  void _navigateToAddSchool(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddOrUpdateSchoolView(),
      ),
    );
  }
}

List<SchoolTemp> schools = [
  const SchoolTemp(
    id: '1',
    name: "اسم المدرسة الأولى",
    description: "وصف موجز ومفيد عن المدرسة وميزاتها الرئيسية",
  ),
  const SchoolTemp(
    id: '2',
    name: "اسم المدرسة الأولى",
    description: "وصف موجز ومفيد عن المدرسة وميزاتها الرئيسية",
  ),
  const SchoolTemp(
    id: '3',
    name: "اسم المدرسة الأولى",
    description: "وصف موجز ومفيد عن المدرسة وميزاتها الرئيسية",
  ),
];
