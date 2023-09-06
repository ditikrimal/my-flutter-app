import 'package:flutter/material.dart';

class AlertSnackbar extends SnackBar {
  AlertSnackbar({
    super.key,
    required Color? statusColor,
    required String? messageStatus,
    required String? message,
    required String? secondaryMessage,
  }) : super(
          content: SizedBox(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$messageStatus",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    "$message",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "$secondaryMessage",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          )),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          backgroundColor: statusColor,
        );
}
