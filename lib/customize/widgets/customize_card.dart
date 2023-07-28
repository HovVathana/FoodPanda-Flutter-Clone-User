import 'package:flutter/material.dart';

import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/shop_details/widgets/text_tag.dart';
import 'package:foodpanda_user/models/customize.dart';
import 'package:foodpanda_user/widgets/my_snack_bar.dart';

class CustomizeCard extends StatefulWidget {
  final Customize customize;
  final String? editCustomize;
  final Function(Choice) onRadioChanged;
  final Function(Choice value, bool isSelected) onSelectChanged;
  List<bool>? optionalIsSelected;

  CustomizeCard({
    Key? key,
    required this.customize,
    this.editCustomize,
    required this.onRadioChanged,
    required this.onSelectChanged,
    this.optionalIsSelected,
  }) : super(key: key);

  @override
  State<CustomizeCard> createState() => _CustomizeCardState();
}

class _CustomizeCardState extends State<CustomizeCard> {
  int _value = -1;

  List<dynamic> listChoice = [];

  getData() {
    if (widget.editCustomize != null && widget.customize.isRequired) {
      for (int i = 0; i < widget.customize.choices.length; i++) {
        if (widget.customize.choices[i].choice == widget.editCustomize) {
          setState(() {
            _value = i;
          });

          break;
        }
      }
    }
  }

  @override
  void initState() {
    getData();

    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.customize.isRequired
            ? scheme.primary.withOpacity(0.05)
            : Colors.white,
        border: Border.all(
          color: widget.customize.isRequired
              ? Colors.grey[300]!
              : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 20, horizontal: widget.customize.isRequired ? 15 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.customize.isVariation
                      ? 'Variation'
                      : 'Choice of ${widget.customize.title}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                widget.customize.isRequired
                    ? TextTag(
                        text: 'Required',
                        backgroundColor: scheme.primary,
                        textColor: Colors.white,
                      )
                    : TextTag(
                        text: 'Optional',
                        backgroundColor: Colors.grey[300]!,
                        textColor: Colors.grey[600]!,
                      ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              widget.customize.isRequired
                  ? 'Select one'
                  : 'Select ${widget.customize.selectAmount}',
              style: TextStyle(
                fontSize: 14,
                color: widget.customize.isRequired
                    ? scheme.primary
                    : Colors.grey[500],
                fontWeight: FontWeight.w700,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.customize.choices.length,
              itemBuilder: (context, index) {
                final choiceData = widget.customize.choices[index];

                return widget.customize.isRadio
                    ? ListTile(
                        title: Text(choiceData.choice),
                        leading: Radio(
                          value: index,
                          activeColor: scheme.primary,
                          groupValue: _value,
                          onChanged: (value) {
                            // print(choiceData.choice);
                            setState(() {
                              _value = value!;
                            });
                            widget.onRadioChanged(choiceData);
                          },
                        ),
                        trailing: Text(
                          choiceData.price != 0.0
                              ? widget.customize.isVariation
                                  ? '\$ ${choiceData.price}'
                                  : '+ \$ ${choiceData.price}'
                              : 'Free',
                        ),
                      )
                    : ListTile(
                        title: Text(choiceData.choice),
                        leading: Checkbox(
                          activeColor: scheme.primary,
                          value: widget.optionalIsSelected![index],
                          onChanged: (bool? value) {
                            if (value! &&
                                listChoice.length >
                                    widget.customize.selectAmount - 1) {
                              return openSnackbar(
                                context,
                                'You can only select ${widget.customize.selectAmount} options',
                                scheme.primary,
                              );
                            }

                            setState(() {
                              widget.optionalIsSelected![index] = value;
                              value
                                  ? listChoice.add(choiceData)
                                  : listChoice.remove(choiceData);
                            });
                            widget.onSelectChanged(choiceData, value);
                          },
                        ),
                        trailing: Text(
                          choiceData.price != 0.0
                              ? widget.customize.isVariation
                                  ? '\$ ${choiceData.price}'
                                  : '+ \$ ${choiceData.price}'
                              : 'Free',
                        ),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
