import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pingpass/main.dart';
import 'package:pingpass/providers/auth_provider.dart';
import 'package:pingpass/widgets/custom_appbar.dart';
import 'package:pingpass/widgets/custom_button.dart';
import 'package:pingpass/widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sendOtp() {
    if (!_formKey.currentState!.validate()) return;
    final phone = '+91${_phoneController.text.trim()}';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.sendOtp(
        phoneNumber: phone,
        onCodeSent: () {
          Navigator.pushNamed(context, AppRoutes.otpVerification);
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Login',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/animations/otp.json',
                    repeat: false,
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter your mobile number',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    labelText: 'Phone Number',
                    prefixText: '+91',
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Enter a valid 10 digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                    onPressed: _sendOtp,
                    text: 'Send OTP',
                    isLoading: isLoading,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
