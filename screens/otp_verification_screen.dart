import 'package:flutter/material.dart';
import 'package:pingpass/main.dart';
import 'package:pingpass/providers/auth_provider.dart';
import 'package:pingpass/widgets/custom_appbar.dart';
import 'package:pingpass/widgets/custom_button.dart';
import 'package:pingpass/widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _verifyOtp() {
    if (!_formKey.currentState!.validate()) return;

    final otp = _otpController.text.trim();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.verifyOtp(
      otp: otp,
      onSuccess: (user) {
        Navigator.pushReplacementNamed(context, AppRoutes.webView);
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      appBar: CustomAppBar(title: 'OTP Verification'),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Enter the OTP sent to your phone',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  labelText: 'OTP',
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 6) {
                      return 'Enter valid 6-digit OTP';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                  onPressed: _verifyOtp,
                  text: 'Verify',
                  isLoading: isLoading,
                ),
              ],
            )),
      ),
    );
  }
}
