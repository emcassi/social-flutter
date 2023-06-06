import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/components/ClearableTextField.dart';

class ClearableSecureTextField extends StatefulWidget {

  final String label;
  final String? placeholder;
  final TextEditingController controller;
  final Function validator;
  final BoxDecoration? decoration;

  const ClearableSecureTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.placeholder,
    this.decoration,
  });
  @override
  State<ClearableSecureTextField> createState() => _ClearableSecureTextFieldState();
}

class _ClearableSecureTextFieldState extends State<ClearableSecureTextField> {

  bool secure = true;

  @override
  Widget build(BuildContext context) {
    return ClearableTextFormField(
      placeholder: widget.placeholder,
      label: widget.label,
      controller: widget.controller,
      obscureText: secure,
      decoration: widget.decoration,
      validator: widget.validator,
      prefix: GestureDetector(
        child: Icon(secure ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill),
        onTap: () {
          setState(() {
            secure = !secure;
          });
        },
      ),
    );
  }
}
