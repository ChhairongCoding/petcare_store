import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    this.label,
    required this.controller,
    this.obscureText,
    this.icon,
    this.onPressed,
    this.validator,
    this.prefixIcon,
    this.hintText,
    this.keyboardType,
    this.sizeHeight,
  });

  final String? label;
  final TextEditingController controller;
  final bool? obscureText;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final double? sizeHeight;

  @override
  State<TextFormFieldWidget> createState() => _TexFormtFieldWidgetState();
}

class _TexFormtFieldWidgetState extends State<TextFormFieldWidget> {
  @override
Widget build(BuildContext context) {
  final isMultiline = widget.sizeHeight != null;

  return SizedBox(
    height: isMultiline ? widget.sizeHeight : null,
    child: TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText ?? false,
      keyboardType: widget.keyboardType,
      textAlignVertical: TextAlignVertical.top,
      maxLines: isMultiline ? null : 1,
      expands: isMultiline,
      decoration: InputDecoration(
        label: (widget.label != null && widget.label!.isNotEmpty)
            ? Text(widget.label!)
            : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,   // fixed padding, NOT sizeHeight
          horizontal: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(width: 0.5,color: Theme.of(context).hintColor ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(width: 2, color:Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 0.5, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 2, color: Colors.red),
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
    ),
  );
}
}
