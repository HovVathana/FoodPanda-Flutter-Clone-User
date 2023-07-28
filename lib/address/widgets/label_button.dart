// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:foodpanda_user/constants/colors.dart';

class LabelButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onClick;
  const LabelButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onClick,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? scheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                )
              ],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : scheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(title)
      ],
    );
  }
}
