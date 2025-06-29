import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/functions/parsers/period_to_text_f.dart';
import 'package:moatmat_admin/Core/functions/parsers/time_to_text_f.dart';
import 'package:moatmat_admin/Core/functions/show_alert.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/shadows_r.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/widgets/ui/divider_w.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank_information.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank_properties.dart';
import 'package:moatmat_admin/Features/requests/domain/entities/request.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test_information.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test_properties.dart';
import 'package:moatmat_admin/Presentation/requests/state/cubit/requests_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetailsView extends StatelessWidget {
  const RequestDetailsView({super.key, required this.request});
  final TeacherRequest request;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الطلب"),
        actions: [
          IconButton(
            onPressed: () {
              showAlert(
                context: context,
                title: "تاكيد",
                body: "هل انت متاكد من انك تريد حذف الطلب",
                onAgree: () {
                  context.read<RequestsCubit>().deleteRequest(request);
                  Navigator.of(context).pop();
                },
              );
            },
            icon: const Icon(
              Icons.delete,
              color: ColorsResources.red,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            const SizedBox(height: SizesResources.s2),
            //
            if (request.test != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: SpacingResources.mainWidth(context),
                    padding: const EdgeInsets.symmetric(
                      vertical: SizesResources.s4,
                      horizontal: SizesResources.s4,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: SizesResources.s2,
                      horizontal: SizesResources.s2,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: ShadowsResources.mainBoxShadow,
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsResources.onPrimary,
                    ),
                    child: Column(
                      children: [
                        TestInformationWidget(
                          information: request.test!.information,
                        ),
                        //
                        const DividerWidget(),
                        //
                        TestPropertiesInfoWidget(
                          properties: request.test!.properties,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (request.bank != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: SpacingResources.mainWidth(context),
                    padding: const EdgeInsets.symmetric(
                      vertical: SizesResources.s4,
                      horizontal: SizesResources.s4,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: SizesResources.s2,
                      horizontal: SizesResources.s2,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: ShadowsResources.mainBoxShadow,
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsResources.onPrimary,
                    ),
                    child: Column(
                      children: [
                        BankInformationWidget(
                          information: request.bank!.information,
                        ),
                        //
                      ],
                    ),
                  ),
                ],
              ),
            //
            const SizedBox(height: SizesResources.s2),
            //

            if (request.text != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: SpacingResources.mainWidth(context),
                    margin: const EdgeInsets.symmetric(
                      vertical: SizesResources.s2,
                      horizontal: SizesResources.s2,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: ShadowsResources.mainBoxShadow,
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsResources.onPrimary,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: request.text!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("تم النسخ"),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: SizesResources.s4,
                            horizontal: SizesResources.s4,
                          ),
                          child: Text(request.text!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: SizesResources.s2),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: SpacingResources.sidePadding * 2),
                Text("الملفات :"),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: request.files.length,
              itemBuilder: (context, index) {
                return Container(
                  width: SpacingResources.mainWidth(context),
                  margin: const EdgeInsets.symmetric(
                    vertical: SizesResources.s2,
                    horizontal: SizesResources.s2,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: ShadowsResources.mainBoxShadow,
                    borderRadius: BorderRadius.circular(10),
                    color: ColorsResources.onPrimary,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        openLink(request.files[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: SizesResources.s4,
                          horizontal: SizesResources.s4,
                        ),
                        child: Text(
                          request.files[index].split("/").last,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openLink(String url) async {
  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

class TestPropertiesInfoWidget extends StatelessWidget {
  const TestPropertiesInfoWidget({super.key, required this.properties});
  final TestProperties properties;
  /*
    final bool? exploreAnswers;
  final bool? showAnswers;
  final bool? timePerQuestion;
  final bool? repeatable;
  final bool? visible;
  */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text("السماح بتصفح الأسئلة"),
            const Spacer(),
            Text(properties.exploreAnswers == true ? "نعم" : "لا"),
          ],
        ),
        //
        Row(
          children: [
            const Text("اظهار الإجابات"),
            const Spacer(),
            Text(properties.showAnswers == true ? "نعم" : "لا"),
          ],
        ),
        //
        Row(
          children: [
            const Text("الوقت للسؤال الواحد"),
            const Spacer(),
            Text(properties.timePerQuestion == true ? "نعم" : "لا"),
          ],
        ),
        //
        Row(
          children: [
            const Text("قابل للاعادة"),
            const Spacer(),
            Text(properties.repeatable == true ? "نعم" : "لا"),
          ],
        ),

        //
      ],
    );
  }
}

class BankPropertiesInfoWidget extends StatelessWidget {
  const BankPropertiesInfoWidget({super.key, required this.properties});
  final BankProperties properties;
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [],
    );
  }
}

class BankInformationWidget extends StatelessWidget {
  const BankInformationWidget({super.key, required this.information});
  final BankInformation information;
  /*
  final String title; 
  final String classs; 
  final String material;
  final String teacher;
  final int price; 
  final String? video;
  */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Text("النوع"),
            Spacer(),
            Text("بنك"),
          ],
        ),
        Row(
          children: [
            const Text("العنوان"),
            const Spacer(),
            Text(information.title),
          ],
        ),
        Row(
          children: [
            const Text("الصف"),
            const Spacer(),
            Text(information.classs),
          ],
        ),
        Row(
          children: [
            const Text("المادة"),
            const Spacer(),
            Text(information.material),
          ],
        ),
        Row(
          children: [
            const Text("الاستاذ"),
            const Spacer(),
            Text(information.teacher),
          ],
        ),
        Row(
          children: [
            const Text("السعر"),
            const Spacer(),
            Text(information.price.toString()),
          ],
        ),
      ],
    );
  }
}

class TestInformationWidget extends StatelessWidget {
  const TestInformationWidget({super.key, required this.information});
  final TestInformation information;
  /*
  final int? period;
  final String? video;
  */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Text("النوع"),
            Spacer(),
            Text("اختبار"),
          ],
        ),
        Row(
          children: [
            const Text("العنوان"),
            const Spacer(),
            Text(information.title),
          ],
        ),
        Row(
          children: [
            const Text("الصف"),
            const Spacer(),
            Text(information.classs),
          ],
        ),
        Row(
          children: [
            const Text("المادة"),
            const Spacer(),
            Text(information.material),
          ],
        ),
        Row(
          children: [
            const Text("الاستاذ"),
            const Spacer(),
            Text(information.teacher),
          ],
        ),
        Row(
          children: [
            const Text("السعر"),
            const Spacer(),
            Text(information.price.toString()),
          ],
        ),
        Row(
          children: [
            const Text("المدة"),
            const Spacer(),
            Text(
              information.period != null ? periodToTextFunction(information.period!) : "فارغ",
            ),
          ],
        ),
        Row(
          children: [
            const Text("الرمز السري"),
            const Spacer(),
            Text(information.password ?? " لا يوجد"),
          ],
        ),
      ],
    );
  }
}
