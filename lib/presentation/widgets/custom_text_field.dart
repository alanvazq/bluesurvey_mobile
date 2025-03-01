import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? label;
  final bool isObscureText;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? errorMessage;
  final Function()? onTap;
  final String? initialValue;
  final TextEditingController? controller;
  final bool readOnly;
  final bool enabled;
  final TextInputType keyboardType;
  final int maxLines;

  const CustomTextField(
      {super.key,
      this.hint,
      this.label,
      this.isObscureText = false,
      this.onChanged,
      this.onFieldSubmitted,
      this.errorMessage,
      this.onTap,
      this.initialValue,
      this.controller,
      this.readOnly = false,
      this.enabled = true,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(4, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        enabled: enabled,
        onChanged: onChanged,
        obscureText: isObscureText,
        onFieldSubmitted: onFieldSubmitted,
        initialValue: initialValue,
        controller: controller,
        keyboardType: keyboardType,
        onTap: onTap,
        readOnly: readOnly,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        cursorColor: colors.primary,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          floatingLabelStyle: TextStyle(
            color: colors.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          labelStyle: const TextStyle(color: Color(0x6F303030), fontSize: 16),
          label: label != null ? Text(label!) : null,
          errorText: errorMessage,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC74A4A)),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC74A4A)),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.primary,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
    );
  }
}
