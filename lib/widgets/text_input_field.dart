import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:madistock/constants/app_colors.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.onTap,
    required this.focus,
    required this.hint,
    required this.controller,
    required this.onChange,
    this.correct,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    List<TextInputFormatter>? inputFormatters,
  });

  final bool focus;
  final String hint;
  final TextEditingController controller;
  final VoidCallback onTap;
  final ValueChanged<String>? onChange;
  final bool? correct;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: widget.focus
            ? const LinearGradient(
          colors: [
            cca2Color,
            cca2Color,
          ],
        )
            : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        onTap: widget.onTap,
        onChanged: (value) {
          widget.onChange!(value);
        },
        keyboardType: widget.keyboardType ?? TextInputType.text,
        style: const TextStyle(
          color: blackColor,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          filled: true,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
            widget.prefixIcon,
            color: ccaColor,
          ) : null,
          fillColor: whiteColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hoverColor: blackColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 18,
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(
            color: blackColor,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}