// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:foodpanda_user/constants/colors.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String action1Name;
  final String action2Name;
  final VoidCallback action1Func;
  final VoidCallback action2Func;
  bool isOneAction;

  MyAlertDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.action1Name,
    required this.action2Name,
    required this.action1Func,
    required this.action2Func,
    this.isOneAction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
              left: !isOneAction ? 15 : 0, right: 15, bottom: 15),
          child: Row(
            children: [
              !isOneAction
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: scheme.primary,
                            side: BorderSide(
                              width: 1,
                              color: scheme.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              action1Name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextButton(
                    onPressed: action2Func,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        action2Name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
