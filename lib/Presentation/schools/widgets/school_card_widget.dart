import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/fonts_r.dart';
 import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';


class SchoolCardWidget extends StatelessWidget {
  const SchoolCardWidget({
    super.key,
    required this.school,
    this.onTap,
  });
  final School school;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: SpacingResources.mainWidth(context),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: 150,
              width: SpacingResources.mainWidth(context),
              child: Card(
                color: ColorsResources.cardBackground,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: ColorsResources.borders, width: 0.5),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onTap,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: SizesResources.s3,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        school.information.name,
                        style: FontsResources.styleExtraBold(
                          size: 16,
                          color: ColorsResources.textPrimary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: SizesResources.s5, vertical: 1),
                        child: Text(
                          school.information.description,
                          textAlign: TextAlign.center,
                          style: FontsResources.styleMedium(
                            size: 12,
                            color: ColorsResources.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 25.0,
            right: SpacingResources.mainHalfWidth(context) - (SizesResources.iconSchoolSize / 2),
            child: Container(
              width: SizesResources.iconSchoolSize,
              height: SizesResources.iconSchoolSize,
              decoration: BoxDecoration(
                color: ColorsResources.primaryLight,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(SizesResources.s3),
                child: Icon(
                  Icons.school,
                  color: ColorsResources.primary,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
