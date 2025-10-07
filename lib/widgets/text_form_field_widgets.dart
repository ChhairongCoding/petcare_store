
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText,
    this.icon,
    this.onPressed,
    this.validator,
    this.prefixIcon,
  });

  final String label;
  final TextEditingController controller;
  final bool? obscureText;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  @override
  State<TextFormFieldWidget> createState() =>
      _TexFormtFieldWidgetState();
}

class _TexFormtFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText ?? false,
      decoration: InputDecoration(
        hintText: widget.label,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 0.5, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 2,
            color: Colors.grey,
          ), // thicker when focused
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 0.5, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 2, color: Colors.red),
        ),
        suffixIcon: widget.icon != null
            ? IconButton(icon: Icon(widget.icon), onPressed: widget.onPressed)
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter ${widget.label}";
        }
        if (widget.validator != null) {
          return widget.validator!(value);
        }
        return null;
      },
    );
  }
}
