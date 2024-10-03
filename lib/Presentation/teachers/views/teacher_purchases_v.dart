import 'package:flutter/material.dart';
import 'package:moatmat_admin/Presentation/teachers/state/cubit/teachers_manager_cubit.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/purchase/domain/entities/purchase_item.dart';

class TeacherPurchasesV extends StatefulWidget {
  const TeacherPurchasesV({super.key, required this.state});
  final TeachersManagerTeacherPurchases state;
  @override
  State<TeacherPurchasesV> createState() => _TeacherPurchasesVState();
}

class _TeacherPurchasesVState extends State<TeacherPurchasesV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TeacherPurchasesInformation(
            items: widget.state.teacherPurchases,
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
              itemCount: widget.state.teacherPurchases.length,
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
                                if (widget.state.teacherPurchases[index].userName.isNotEmpty)
                                  Text(
                                    "اسم الطالب : ${widget.state.teacherPurchases[index].userName}",
                                  ),
                                Text(
                                  "المبلغ : ${widget.state.teacherPurchases[index].amount}",
                                ),
                                Text(
                                  "يوم/شهر : ${widget.state.teacherPurchases[index].dayAndMoth}",
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
