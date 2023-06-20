import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.text,
    required this.controller,
    this.keyboardType = TextInputType.name,
    this.textInputAction = TextInputAction.done,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.inputFormatters,
    this.onChanged,
    this.prefixIcon,
    this.validator,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixColor = Colors.black,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.hint = '',
    super.key,
  });
  final String text;
  final String hint;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color suffixColor;
  final TextInputType keyboardType;
  final AutovalidateMode autovalidateMode;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          autovalidateMode: autovalidateMode,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          maxLines: maxLines,
          minLines: minLines,
          onChanged: onChanged,
          style: const TextStyle(fontFamily: 'Inter', color: Colors.black54),
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            suffixIconColor: suffixColor,
            prefixIcon: prefixIcon,
            prefixIconColor: Colors.black,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 109, 102, 102),
                fontFamily: 'Inter'),
            isDense: true,
            focusColor: Colors.black12,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.black12,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.redAccent,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.redAccent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.black12,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.black12,
              ),
            ),
          ),
        )
      ],
    );
  }
}
