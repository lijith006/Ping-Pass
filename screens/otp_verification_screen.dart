// import 'package:flutter/material.dart';
// import 'package:pingpass/main.dart';
// import 'package:pingpass/providers/auth_provider.dart';
// import 'package:pingpass/widgets/custom_appbar.dart';
// import 'package:pingpass/widgets/custom_button.dart';
// import 'package:pingpass/widgets/custom_textformfield.dart';
// import 'package:provider/provider.dart';

// class OtpVerificationScreen extends StatefulWidget {
//   const OtpVerificationScreen({super.key});

//   @override
//   State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final _otpController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   void _verifyOtp() {
//     if (!_formKey.currentState!.validate()) return;

//     final otp = _otpController.text.trim();
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     authProvider.verifyOtp(
//       otp: otp,
//       onSuccess: (user) {
//         Navigator.pushReplacementNamed(context, AppRoutes.webView);
//       },
//       onError: (error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error)),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = context.watch<AuthProvider>().isLoading;
//     return Scaffold(
//       appBar: CustomAppBar(title: 'OTP Verification'),
//       body: Padding(
//         padding: EdgeInsets.all(24),
//         child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const Text(
//                   'Enter the OTP sent to your phone',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 CustomTextField(
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                   labelText: 'OTP',
//                   maxLength: 6,
//                   validator: (value) {
//                     if (value == null || value.isEmpty || value.length != 6) {
//                       return 'Enter valid 6-digit OTP';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 24,
//                 ),
//                 CustomButton(
//                   onPressed: _verifyOtp,
//                   text: 'Verify',
//                   isLoading: isLoading,
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }
//---------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:pingpass/main.dart';
import 'package:pingpass/providers/auth_provider.dart';
import 'package:pingpass/widgets/custom_appbar.dart';
import 'package:pingpass/widgets/custom_button.dart';
import 'package:pingpass/widgets/custom_otp_screen.dart';
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
        // Navigator.pushReplacementNamed(context, AppRoutes.webView);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.webView,
          (route) => false,
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Start OTP timer after first frame build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).startOtpTimer();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
                CustomOtpField(
                  controller: _otpController,
                  validator: (value) {
                    if (value == null || value.length != 6) {
                      return 'Enter valid 6-digit OTP';
                    }
                    return null;
                  },
                  onCompleted: (value) {
                    _verifyOtp(); // Auto call when 6 digits entered
                  },
                ),

                // CustomTextField(
                //   controller: _otpController,
                //   keyboardType: TextInputType.number,
                //   labelText: 'OTP',
                //   maxLength: 6,
                //   validator: (value) {
                //     if (value == null || value.isEmpty || value.length != 6) {
                //       return 'Enter valid 6-digit OTP';
                //     }
                //     return null;
                //   },
                // ),

                const SizedBox(height: 16),

                // countdown timer
                Text(
                  authProvider.canResend
                      ? "Didn't receive OTP?"
                      : 'OTP expires in 0:${authProvider.secondsRemaining.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: authProvider.canResend ? Colors.blue : Colors.grey,
                  ),
                ),

                const SizedBox(height: 8),

                // Resend OTP button
                if (authProvider.canResend)
                  TextButton(
                    onPressed: () {
                      final phone = authProvider.phoneNumber!;
                      authProvider.sendOtp(
                        phoneNumber: phone,
                        onCodeSent: () {
                          authProvider.startOtpTimer();
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        },
                      );
                    },
                    child: const Text("Resend OTP"),
                  ),

                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                  onPressed:
                      authProvider.secondsRemaining == 0 ? null : _verifyOtp,
                  text: 'Verify',
                  isLoading: isLoading,
                ),
              ],
            )),
      ),
    );
  }
}
