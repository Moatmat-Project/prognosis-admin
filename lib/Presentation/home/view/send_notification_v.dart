import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/services/one_signal_s.dart';
import 'package:moatmat_admin/Core/widgets/fields/attachment_w.dart';
import 'package:moatmat_admin/Core/widgets/fields/drop_down_w.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';

class SendOneSignalNotificationView extends StatefulWidget {
  const SendOneSignalNotificationView({super.key});

  @override
  State<SendOneSignalNotificationView> createState() => _SendOneSignalNotificationViewState();
}

class _SendOneSignalNotificationViewState extends State<SendOneSignalNotificationView> {
  bool isLoading = false;
  List<String> items = [
    'الطالب',
    'المعلم',
    'الادمن',
    'الرفع',
    'كل التطبيقات',
  ];
  List<String> topics = [
    'app',
    'teacher',
    'admin',
    'uploader',
    'all',
  ];
  String? image;
  late String selectedItem;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String get title => titleController.text;
  String get content => contentController.text;

  @override
  void initState() {
    selectedItem = items.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ارسال اشعار"),
      ),
      body: Column(
        children: [
          //
          const SizedBox(height: SizesResources.s5),
          //
          // title
          MyTextFormFieldWidget(
            hintText: "عنوان الاشعار",
            controller: titleController,
          ),
          //
          const SizedBox(height: SizesResources.s3),
          //
          // body
          MyTextFormFieldWidget(
            hintText: "تفاصيل الاشعار",
            controller: contentController,
          ),
          //
          const SizedBox(height: SizesResources.s3),
          //
          // drop down menu
          DropDownWidget(
            items: items,
            selectedItem: selectedItem,
            hintText: "التطبيق المستهدف",
            onChanged: (p0) {
              setState(() {
                selectedItem = p0!;
              });
            },
            onSaved: (p0) {},
          ),
          //
          const SizedBox(height: SizesResources.s3),
          //
          AttachmentWidget(
            title: "ارفاق صورة",
            afterPick: (p0) {
              setState(() {
                image = p0;
              });
            },
            onDelete: () {
              setState(() {
                image = null;
              });
            },
          ),
          //
          const SizedBox(height: SizesResources.s3),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "ارسال الاشعار عام",
          loading: isLoading,
          onPressed: () async {
            //
            if (title.isEmpty || content.isEmpty) {
              Fluttertoast.showToast(msg: "يرجى ملء الحقول المطلوبة");
              return;
            }
            //
            setState(() {
              isLoading = true;
            });
            //
            String? topic;
            //
            topic = topics[items.indexOf(selectedItem)];
            //
            print(topic);
            //
            await OneSignalService.sendNotification(
              title: title,
              content: content,
              topic: topic,
              imagePath: image,
            );
            //
            setState(() {
              isLoading = false;
            });
          },
        ),
      ),
    );
  }
}
