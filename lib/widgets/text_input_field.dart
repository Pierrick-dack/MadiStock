import 'package:flutter/material.dart';
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
    this.maxLines = 1, // Ajout de maxLines avec une valeur par défaut
    this.keyboardType, // Ajout du type de clavier
  });

  final bool focus;
  final String hint;
  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback onChange;
  final bool? correct;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final int maxLines; // Nombre maximum de lignes
  final TextInputType? keyboardType; // Type de clavier (texte, numérique, etc.)

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
          widget.onChange();
        },
        maxLines: widget.maxLines, // Utilisation de maxLines
        keyboardType: widget.keyboardType ?? TextInputType.text, // Type de clavier
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
        validator: widget.validator,
      ),
    );
  }
}
