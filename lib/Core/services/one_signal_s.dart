import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/buckets/domain/usecases/upload_file_uc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

const String appId = "dabcc56c-4c75-4252-9de1-4d7badcddd72";
const String appKey = "MmM3Zjk0YmYtNGMwYi00NTQ0LWI0MmEtODEyYjYyOTYxNGJj";

class OneSignalService {
  ///
  static Future<void> initialize() async {
    //
    try {
      await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      //
      OneSignal.initialize(appId);
      //
      await OneSignal.Notifications.requestPermission(true);
      //
      await subscribeToTopic("all");
      //
      await subscribeToTopic("admin");
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'error $e');
      await Clipboard.setData(ClipboardData(text: e.toString()));
    }
    //
  }

  ///
  static Future<void> subscribeToTopic(String topic) async {
    await OneSignal.User.addTagWithKey(topic, topic);
  }

  ///
  static Future<void> sendNotification({required String title, required String content, String? topic, String? imagePath}) async {
    ///
    final url = Uri.parse('https://api.onesignal.com/notifications');

    ///
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $appKey',
    };

    ///
    List<Map> filters = [];
    //
    if (topic != null) {
      filters.add(
        {"field": "tag", "key": topic, "relation": "=", "value": topic},
      );
    }

    ///
    final body = ({
      //
      "app_id": appId,
      //
      "filters": filters,
      //
      "headings": {
        "en": title,
        "ar": title,
      },
      "contents": {
        "en": content,
        "ar": content,
      },
    });

    ///
    if (imagePath != null) {
      final response = await locator<UploadFileUC>().call(
        material: "",
        id: '1',
        name: DateTime.now().millisecondsSinceEpoch.toString(),
        path: imagePath,
        bucket: "notifications",
      );
      response.fold(
        (l) {},
        (r) {
          body['big_picture'] = r;
        },
      );
    }

    ///
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Notification sent successfully');
        await Clipboard.setData(const ClipboardData(text: 'Notification sent successfully'));
      } else {
        Fluttertoast.showToast(msg: 'Failed to send notification: ${response.statusCode}');
        await Clipboard.setData(ClipboardData(text: 'Failed to send notification: ${response.statusCode}'));
        Fluttertoast.showToast(msg: 'Response: ${response.body}');
        await Clipboard.setData(ClipboardData(text: 'Response: ${response.body}'));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error sending notification: $e');
      await Clipboard.setData(ClipboardData(text: 'Error sending notification: $e'));
    }
  }
}
