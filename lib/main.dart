import 'package:flutter/material.dart';
import 'package:tuan_080910/app/page/auth/forgetPassword.dart';
import 'package:tuan_080910/app/page/auth/login.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Thiết lập màn hình chính là LoginScreen
      home: const LoginScreen(),
      // Định nghĩa các tuyến đường
      routes: {
        '/forgot_password': (context) => ForgetPasswordScreen(),
        // Các tuyến đường khác nếu cần
      },
    );
  }
}
