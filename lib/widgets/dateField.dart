import 'package:flutter/material.dart';
import 'package:madistock/constants/app_colors.dart';

class DateField extends StatefulWidget {
  const DateField({
    super.key,
    required this.onTap,
    required this.focus,
    required this.enable,
    required this.hint,
    required this.controller,
    required this.onChange,
    this.correct,
    this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType,
    required bool readOnly,
  });

  final bool focus;
  final String hint;
  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback onChange;
  final bool? correct;
  final IconData? prefixIcon;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool enable;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
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
      child: TextField(
        controller: widget.controller,
        enabled: widget.enable,
        onTap: widget.onTap,
        onChanged: (value) {
          widget.onChange();
        },
        maxLines: widget.maxLines,
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
          )
              : null,
          suffixIcon: widget.correct == true
              ? const Icon(
            Icons.done,
            color: ccaColor,
          )
              : null,
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
      ),
    );
  }
}
