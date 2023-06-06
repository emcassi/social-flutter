import 'package:flutter/material.dart';

class CountingTextField extends StatefulWidget {

  final TextEditingController controller;
  final String? Function(String?) validator;
  final String? label;
  final int maxLength;
  final int maxLines;

  const CountingTextField({
    Key? key,
    required this.controller,
    required this.validator,
    required this.maxLength,
    this.label,
    this.maxLines = 1,
  });

  @override
  State<CountingTextField> createState() => _CountingTextFieldState();
}

class _CountingTextFieldState extends State<CountingTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          onChanged: (value) {
            setState(() {
            });
          },
          decoration: InputDecoration(
            label: Text(widget.label ?? ""),
            suffix: widget.controller.text.isNotEmpty ? GestureDetector(
              onTap: () {
                widget.controller.text = "";
                setState(() {

                });
              },
              child: Icon(Icons.clear, color: Colors.red,),
            ) : null,
          ),
          maxLines: widget.maxLines,
          textInputAction: TextInputAction.newline,
        ),
        Text(
            "${widget.controller.text.length}/${widget.maxLength ?? 0}",
          style: TextStyle(
            color: widget.controller.text.length > widget.maxLength ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }
}
