import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomOtpField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onCompleted;
  final String? Function(String?)? validator;

  const CustomOtpField({
    super.key,
    required this.controller,
    this.onCompleted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      controller: controller,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      autoFocus: true,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        inactiveColor: Colors.grey,
        selectedColor: Theme.of(context).primaryColor,
        activeColor: Theme.of(context).primaryColor,
      ),
      validator: validator,
      onChanged: (_) {},
      onCompleted: onCompleted,
    );
  }
}
