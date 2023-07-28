import 'package:flutter/material.dart';

import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';

class ProductAvailability extends StatefulWidget {
  String value;
  final Function(String) onChanged;
  ProductAvailability({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ProductAvailability> createState() => _ProductAvailabilityState();
}

class _ProductAvailabilityState extends State<ProductAvailability> {
  List<String> options = [
    'Remove it from my order',
    'Cancel the entire order',
    'Call me',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'If this product is not available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            builder: (
              context,
            ) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
                return Container(
                  height: 400,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 3,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[300],
                              ),
                              alignment: Alignment.center,
                            ),
                            const SizedBox(height: 25),
                            const SizedBox(
                              width: double.infinity,
                              child: Text(
                                'If this product is not available',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(0),
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    String option = options[index];
                                    return ListTile(
                                      dense: true,
                                      minLeadingWidth: 0,
                                      horizontalTitleGap: 0,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10),
                                      title: Text(option),
                                      leading: Radio(
                                        value: option,
                                        activeColor: scheme.primary,
                                        groupValue: widget.value,
                                        onChanged: (value) {
                                          // handleChange(value!);
                                          state(() {
                                            widget.value = value!;
                                          });
                                          widget.onChanged(value!);
                                        },
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      CustomTextButton(
                        text: 'Apply',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        isDisabled: false,
                      ),
                    ],
                  ),
                );
              });
            },
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: scheme.primary,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
