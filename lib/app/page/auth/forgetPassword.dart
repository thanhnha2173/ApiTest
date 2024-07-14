import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tuan_080910/app/data/api.dart'; // Đảm bảo import đúng file API của bạn

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _accountIDController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();

  final APIRepository _apiRepository = APIRepository();

  void _resetPassword() async {
    String accountID = _accountIDController.text.trim();
    String numberID = _numberIDController.text.trim();
    String newPass = _newPassController.text.trim();

    try {
      // Gọi phương thức forgetPass từ APIRepository
      Response<dynamic> res = await _apiRepository.forgetPass(accountID, numberID, newPass);

      if (res.statusCode == 200) {
        print("Password reset successfully");
        // Xử lý thành công, ví dụ như hiển thị thông báo
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Password Reset"),
              content: const Text("Password reset successfully!"),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print("Failed to reset password: ${res.statusCode}");
        // Xử lý thất bại, ví dụ như hiển thị thông báo lỗi
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Failed to reset password. Status code: ${res.statusCode}"),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on DioException catch (ex) {
      if (ex.response?.statusCode == 400) {
        print("Password reset failed with status code: ${ex.response?.statusCode}");
        print("Error message: ${ex.response?.data}");
      } else {
        print("DioException during password reset: $ex");
      }
      // Xử lý lỗi DioException, ví dụ như hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("An error occurred during password reset."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (ex) {
      print("Error during password reset: $ex");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Failed to reset password. Please check your input and try again."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _accountIDController,
              decoration: const InputDecoration(labelText: 'Account ID'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _numberIDController,
              decoration: const InputDecoration(labelText: 'Number ID'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _newPassController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
