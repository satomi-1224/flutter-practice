import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InputField extends HookWidget {
  const InputField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = useState(false);

    return TextFormField(
      controller: controller,
      obscureText: obscureText && !isPasswordVisible.value,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(
                  isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
              )
            : null,
      ),
    );
  }
}
