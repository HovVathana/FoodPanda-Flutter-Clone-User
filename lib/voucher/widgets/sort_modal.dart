import 'package:flutter/material.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';

Future<void> showSortModal({
  required BuildContext context,
  required Function(String) handleApply,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (context) {
      String sortBy = 'latest';
      return StatefulBuilder(
        builder: ((context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 3,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[300],
                      ),
                      alignment: Alignment.center,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sort by',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: scheme.primary.withOpacity(0.3),
                          onTap: () {
                            setState(() {
                              sortBy = 'latest';
                            });
                          },
                          child: Ink(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        setState(() {
                          sortBy = 'latest';
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: Text('Latest (default)')),
                            Icon(
                              sortBy == 'latest'
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: scheme.primary,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          sortBy = 'expiring';
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: Text('Expiring first')),
                            Icon(
                              sortBy == 'expiring'
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: scheme.primary,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          sortBy = 'minimum';
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: Text('Lowest minimum order value')),
                            Icon(
                              sortBy == 'minimum'
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: scheme.primary,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
                color: Colors.grey[200],
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: CustomTextButton(
                  text: 'Apply',
                  onPressed: () => handleApply(sortBy),
                  isDisabled: false,
                ),
              ),
            ],
          );
        }),
      );
    },
  );
}
