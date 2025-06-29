import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_admin/Features/code/domain/entites/code_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Core/resources/sizes_resources.dart';

class CodeView extends StatefulWidget {
  const CodeView(
      {super.key,
      required this.codeData,
      required this.controller,
      });
  final CodeData codeData;
  final ScreenshotController controller;

  @override
  State<CodeView> createState() => _CodeViewState();
}

class _CodeViewState extends State<CodeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: widget.controller,
              child: Container(
                color: ColorsResources.primary,
                child: Column(
                  children: [
                    const SizedBox(height: SizesResources.s10),

                    //
                    SvgPicture.asset(
                      "assets/other/app-icon.svg",
                      width: MediaQuery.sizeOf(context).width / 4,
                    ),
                    //
                    const SizedBox(height: SizesResources.s4),

                    //
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          color: Colors.white,
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width / 1.55,
                            height: MediaQuery.sizeOf(context).width / 1.55,
                          ),
                        ),
                        Image.asset(
                          "assets/other/code_frame.png",
                          width: MediaQuery.sizeOf(context).width / 1.50,
                        ),
                        QrImageView(
                          eyeStyle: const QrEyeStyle(
                            color: Colors.black,
                            eyeShape: QrEyeShape.square,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            color: Colors.black,
                            dataModuleShape: QrDataModuleShape.square,
                          ),
                          data: widget.codeData.id,
                          version: QrVersions.auto,
                          size: MediaQuery.sizeOf(context).width / 1.75,
                        ),
                      ],
                    ),
                    const SizedBox(height: SizesResources.s4),
                    Text(
                      "قيمة الكود : ${widget.codeData.amount}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 27,
                      ),
                    ),
                    const SizedBox(height: SizesResources.s1),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(
                                ClipboardData(text: widget.codeData.id))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("تم نسخ الكود"),
                            ),
                          );
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SizesResources.s2,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorsResources.green,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            widget.codeData.id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: SizesResources.s10),
                  ],
                ),
              ),
            ),

            //
            const SizedBox(height: SizesResources.s10),
          ],
        ),
      ),
    );
  }
}
