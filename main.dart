import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pingpass/screens/otp_verification_screen.dart';
import 'package:pingpass/screens/user_input_screen.dart';
import 'package:pingpass/screens/webview_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

class AppRoutes {
  static const String phoneNumber = '/';
  static const String otpVerification = '/otp';
  static const String webView = '/webview';

  static final routes = {
    phoneNumber: (context) => const UserInputScreen(),
    otpVerification: (context) => const OtpVerificationScreen(),
    webView: (context) => const WebviewScreen(),
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PingPass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.phoneNumber,
      routes: AppRoutes.routes,
    );
  }
}
