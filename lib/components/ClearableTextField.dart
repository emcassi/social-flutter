import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClearableTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final Widget? prefix;
  final String? placeholder;
  final bool? obscureText;
  final Function? validator;
  final Function()? onClear;
  final BoxDecoration? decoration;
  final InputDecoration? inputDecoration;
  final int? maxLines;

  const ClearableTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.prefix,
    this.placeholder,
    this.onClear,
    this.obscureText,
    this.validator,
    this.decoration,
    this.inputDecoration,
    this.maxLines,
  });

  @override
  ClearableTextFormFieldState createState() => ClearableTextFormFieldState();
}

class ClearableTextFormFieldState extends State<ClearableTextFormField> {
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_textListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  void _textListener() {
    setState(() {
      _showClearButton = widget.controller.text.isNotEmpty;
    });
  }

  String? error = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Padding(
        padding: const EdgeInsets.only(left: 15),
          child: Text(widget.label ?? "")
      ),
      CupertinoFormRow(
        error: Text(error ?? ""),
        prefix: widget.prefix,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            CupertinoTextFormFieldRow(
              controller: widget.controller,
              placeholder: widget.placeholder,
              decoration: widget.decoration,
              obscureText: widget.obscureText ?? false,
              maxLines: widget.maxLines ?? 1,
              onChanged: (value) {
                setState(() {
                  error = widget.validator!(value);
                });
              },
            ),
            if (_showClearButton)
              GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  if (widget.onClear != null) {
                    widget.onClear!();
                  }
                },
                child: const Icon(
                  CupertinoIcons.clear_circled,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
          ],
        ),
      )
    ]);
  }
}
