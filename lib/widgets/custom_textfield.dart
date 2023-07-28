import 'package:flutter/material.dart';

import 'package:foodpanda_user/constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  bool noIcon;
  bool isDisabled;
  String? initialValue;
  Function(String)? onChanged;
  String? errorText;
  bool isNumPad;
  int? maxLength;
  bool isAutoFocus;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.noIcon = true,
    this.isDisabled = false,
    this.initialValue,
    this.onChanged,
    this.errorText = '',
    this.isNumPad = false,
    this.isAutoFocus = false,
    this.maxLength,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode _focus = FocusNode();
  bool isNotFocus = true;
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isNotFocus = !isNotFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      focusNode: _focus,
      autofocus: widget.isAutoFocus,
      initialValue: widget.initialValue,
      style: TextStyle(
        color: widget.isDisabled ? Colors.grey[400] : Colors.black,
      ),
      readOnly: widget.isDisabled,
      keyboardType: widget.isNumPad ? TextInputType.number : null,
      controller: widget.controller,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        errorText: widget.errorText == '' ? null : widget.errorText,
        errorMaxLines: 2,
        suffixIconColor: scheme.primary,
        suffixIcon: widget.noIcon
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: isObscure
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
              ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: widget.errorText != ''
              ? Colors.red
              : widget.isDisabled
                  ? Colors.grey[700]!
                  : !isNotFocus
                      ? Colors.black
                      : Colors.grey[600],
          fontSize: widget.isDisabled
              ? 20
              : !isNotFocus
                  ? 20
                  : 15,
        ),
        contentPadding: const EdgeInsets.all(15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.isDisabled ? Colors.grey[500]! : Colors.black,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      obscureText: isObscure,
    );
  }
}
