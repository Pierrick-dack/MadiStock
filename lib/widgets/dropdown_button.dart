import 'package:flutter/material.dart';
import 'package:madistock/constants/app_colors.dart';

class DropdownField<T> extends StatefulWidget {
  const DropdownField({
    super.key,
    required this.focus,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.prefixIcon,
  });

  final bool focus;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;

  @override
  State<DropdownField<T>> createState() => _DropdownFieldState<T>();
}

class _DropdownFieldState<T> extends State<DropdownField<T>> {
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
      child: DropdownButtonFormField<T>(
        value: widget.value,
        items: widget.items,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: true,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
            widget.prefixIcon,
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
        style: const TextStyle(
          color: blackColor,
          fontWeight: FontWeight.bold,
        ),
        validator: widget.validator,
        dropdownColor: whiteColor,
      ),
    );
  }
}
