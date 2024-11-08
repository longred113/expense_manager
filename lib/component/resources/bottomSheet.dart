import 'dart:ui';

import 'package:expense_manager/component/resources/status_notification.dart';
import 'package:expense_manager/helpers/navigation_helper.dart';
import 'package:expense_manager/ui/dashboardScreen.dart';
import 'package:flutter/material.dart';

void showNotification({
  required bool isSuccess,
  required BuildContext context,
  required String title,
  required String message,
  required String type,
  required int click,
  required int widgetClick,
}) {
  showModalBottomSheet(
    isDismissible: false,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: StatusNotification(
          title: title,
          message: message,
          isSuccess: isSuccess,
          textButton: 'Đóng',
          onButtonClick: () {
            if (type == 'add_spend' || type == 'add_revenue') {
              Navigator.popUntil(context, (route) {
                if (click++ == widgetClick) {
                  Navigator.pop(context, true);
                  return true;
                }
                return false;
              });
            } else {
              Navigator.popUntil(
                context,
                (route) {
                  if (click++ == widgetClick) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        createPageRoute(const DashboardScreen()),
                        (route) => false);
                    return true;
                  }
                  return false;
                },
              );
            }
          },
        ),
      );
    },
  );
}
