// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pingpass/services/auth_service.dart';

// class AuthProvider extends ChangeNotifier {
//   final AuthService _authService = AuthService();

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? verificationId;
//   String? _error;
//   String? get error => _error;

//   //Update loading state
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   Timer? _otpTimer;
//   int _secondsRemaining = 60;
//   int get secondsRemaining => _secondsRemaining;
//   bool get canResend => _secondsRemaining == 0;

//   void startOtpTimer() {
//     _secondsRemaining = 60;
//     notifyListeners();
//     _otpTimer?.cancel();
//     _otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_secondsRemaining > 0) {
//         _secondsRemaining--;
//         notifyListeners();
//       } else {
//         timer.cancel();
//         notifyListeners();
//       }
//     });
//   }

//   void stopOtpTimer() {
//     _otpTimer?.cancel();
//     _secondsRemaining = 0;
//     notifyListeners();
//   }

// //--------------------------------------
//   //send OTP
//   Future<void> sendOtp({
//     required String phoneNumber,
//     required VoidCallback onCodeSent,
//     required Function(String error) onError,
//   }) async {
//     _setLoading(true);

//     await _authService.sendOtp(
//         phoneNumber: phoneNumber,
//         onCodeSent: (verificationId) {
//           verificationId = verificationId;
//           _setLoading(false);
//           onCodeSent();
//         },
//         onError: (err) {
//           _error = err;
//           _setLoading(false);
//           onError(err);
//         });
//   }

//   // Verify OTP
//   Future<void> verifyOtp({
//     required String otp,
//     required Function(User user) onSuccess,
//     required Function(String error) onError,
//   }) async {
//     _setLoading(true);
//     final result = await _authService.verifyOtp(
//       otp: otp,
//       onError: (err) {
//         _error = err;
//         _setLoading(false);
//         onError(err);
//       },
//     );

//     if (result != null) {
//       _setLoading(false);
//       onSuccess(result.user!);
//     }
//   }
// }
//-----------------------------------------------------
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pingpass/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  String? verificationId;
  String? _error;
  String? get error => _error;

  //Update loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Timer? _otpTimer;
  int _secondsRemaining = 60;
  int get secondsRemaining => _secondsRemaining;
  bool get canResend => _secondsRemaining == 0;

  void startOtpTimer() {
    _secondsRemaining = 60;
    notifyListeners();
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void stopOtpTimer() {
    _otpTimer?.cancel();
    _secondsRemaining = 0;
    notifyListeners();
  }

//--------------------------------------
  //send OTP
  Future<void> sendOtp({
    required String phoneNumber,
    required VoidCallback onCodeSent,
    required Function(String error) onError,
  }) async {
    _setLoading(true);

    await _authService.sendOtp(
        phoneNumber: phoneNumber,
        onCodeSent: (verificationId) {
          verificationId = verificationId;
          _setLoading(false);
          _phoneNumber = phoneNumber;
          onCodeSent();
        },
        onError: (err) {
          _error = err;
          _setLoading(false);
          onError(err);
        });
  }

  // Verify OTP
  Future<void> verifyOtp({
    required String otp,
    required Function(User user) onSuccess,
    required Function(String error) onError,
  }) async {
    _setLoading(true);
    final result = await _authService.verifyOtp(
      otp: otp,
      onError: (err) {
        _error = err;
        _setLoading(false);
        onError(err);
      },
    );

    if (result != null) {
      _setLoading(false);
      onSuccess(result.user!);
    }
  }
}
