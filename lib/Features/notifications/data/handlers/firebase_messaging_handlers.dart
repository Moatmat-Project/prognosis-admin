import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Core/resources/supabase_r.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/register_device_token_request.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/display_firebase_notification_usecase.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:moatmat_admin/Presentation/notifications/state/notifications_bloc/notifications_bloc.dart';
import 'package:moatmat_admin/Presentation/notifications/views/notifications_view.dart';
import 'package:moatmat_admin/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moatmat_admin/Core/constant/navigation_key.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 debugPrint('A background message was received in flutter_background_service plugin: ${message.messageId}');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Firebase initialized');

  await Supabase.initialize(
    url: SupabaseResources.url,
    anonKey: SupabaseResources.key,
  );
  
  debugPrint('Supabase initialized');

  if (!locator.isRegistered<DisplayFirebaseNotificationUsecase>()) {
    await initGetIt();
  }

  await locator<DisplayFirebaseNotificationUsecase>().call(message: message);
  debugPrint('DisplayFirebaseNotificationUsecase called');
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse? response) async {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Firebase initialized');

  await Supabase.initialize(
    url: SupabaseResources.url,
    anonKey: SupabaseResources.key,
  );
  
  debugPrint('Supabase initialized');

  if (!locator.isRegistered<DisplayFirebaseNotificationUsecase>()) {
    await initGetIt();
  }

    locator<NotificationsBloc>().add(GetNotifications());
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const NotificationsView()),
    );

}

class FirebaseMessagingHandlers {
  ///
  /// [firebase messaging foreground handler]
  Future<void> onData(RemoteMessage message) async {
    // debugPrint('A foreground message was received in flutter_background_service plugin: ${message.messageId}');
    await locator<DisplayFirebaseNotificationUsecase>().call(message: message);
    debugPrint('DisplayFirebaseNotificationUsecase called');
    locator<NotificationsBloc>().add(GetNotifications());
  }

  ///
  Future<void> onTokenRefreshed(String newToken) async {
    final platform = Platform.isAndroid ? 'android' : 'ios';

    await locator<RegisterDeviceTokenUseCase>().call(
      RegisterDeviceTokenRequest(
        deviceToken: newToken,
        platform: platform,
      ),
    );
  }

  ///
  void onDone() {}

  ///
  void onError(error) {}

  Future<void> onNotificationOpened(RemoteMessage message) async {
    //if (message.data['screen'] == 'notifications') {
    locator<NotificationsBloc>().add(GetNotifications());
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const NotificationsView()),
    );
    //}
  }

  /// [firebase notification initial handler]
  Future<void> onInitialNotification() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await onNotificationOpened(initialMessage);
    }
  }
}
