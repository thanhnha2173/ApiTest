import 'package:flutter/material.dart';
import 'package:tuan_080910/app/data/api.dart';
import 'package:tuan_080910/mainpage.dart';
import '../register.dart';
import '../../data/sharepre.dart';
import '../../config/const.dart'; // Import file constants

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Hàm xử lý đăng nhập
  login() async {
    String token = await APIRepository().login(accountController.text, passwordController.text);
    if (token != "Unauthorized: Invalid credentials or token.") {
      var user = await APIRepository().current(token);
      saveUser(user); // Lưu thông tin người dùng vào SharedPreferences
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Mainpage()));
    } else {
      print("Login failed: Invalid credentials or token.");
      // Xử lý khi đăng nhập không thành công
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    urlLogo, // Sử dụng biến urlLogo từ file constants
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                  ),
                  const Text(
                    "LOGIN INFORMATION",
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  TextFormField(
                    controller: accountController,
                    decoration: const InputDecoration(
                      labelText: "Account",
                      icon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: login,
                          child: const Text("Login"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot_password'); // Chuyển hướng sang màn hình quên mật khẩu
                          },
                          child: const Text("Forgot Password"), // Đổi nút "Register" thành "Forgot Password"
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                    },
                    child: const Text(
                      "Don't have an account? Register here",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
