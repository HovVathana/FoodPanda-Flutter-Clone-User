import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;
  bool isOutlined;
  CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isDisabled,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey[400]
              : isOutlined
                  ? Colors.transparent
                  : scheme.primary,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isOutlined ? scheme.primary : Colors.transparent,
            width: isOutlined ? 1 : 0,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isOutlined ? scheme.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
