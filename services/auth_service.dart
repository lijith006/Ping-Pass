import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? verificationId;

  //Sending OTP
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Optional: Auto sign-in if possible
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Phone verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

//Verify OTP
  Future<UserCredential?> verifyOtp({
    required String otp,
    required Function(String error) onError,
  }) async {
    try {
      if (verificationId == null) {
        onError('Verification ID is null');
        return null;
      }

      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: otp);

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      onError(e.toString());
      return null;
    }
  }
}
