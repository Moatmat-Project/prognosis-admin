import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/fonts_r.dart';
import 'package:moatmat_admin/Presentation/notifications/state/notifications_bloc/notifications_bloc.dart';
import 'package:moatmat_admin/Presentation/notifications/widgets/notification_card_widget.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات'),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is NotificationsFailure) {
            return Center(
              child: Text(
                state.message,
                style: FontsResources.styleRegular(color: ColorsResources.red),
              ),
            );
          } else if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Text(
                  'لا يوجد إشعارات',
                  style: FontsResources.styleRegular(),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(SpacingResources.sidePadding),
              child: ListView.separated(
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: SizesResources.s1 / 2),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  BlocProvider.of<NotificationsBloc>(context).add(MarkNotificationAsSeen(notification.id));
                  return NotificationCard(notification: notification);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
