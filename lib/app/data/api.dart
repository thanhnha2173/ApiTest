import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuan_080910/app/model/user.dart';
import 'package:dio/dio.dart';
import 'package:tuan_080910/app/model/register.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "https://huflit.id.vn:4321";

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  final API api = API();

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Response<dynamic>> forgetPass(String accountID, String numberID, String newPass) async {
  try {
    final body = FormData.fromMap({
      'AccountID': accountID,
      'NumberID': numberID,
      'NewPass': newPass,
    });

    Response res = await api.sendRequest.put(
      '/Auth/forgetPass',
      options: Options(headers: header('no token')),
      data: body,
    );

    return res; // Trả về Response<dynamic> từ Dio

  } on DioException catch (ex) {
    print("DioException during password reset: $ex");
    rethrow; // Ném lại lỗi để được xử lý trong phương thức gọi
  } catch (ex) {
    print("Error during password reset: $ex");
    rethrow; // Ném lại lỗi để được xử lý trong phương thức gọi
  }
}

  Future<String> register(Signup user) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.numberID,
        "accountID": user.accountID,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageUrl,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "password": user.password,
        "confirmPassword": user.confirmPassword
      });
      Response res = await api.sendRequest.post(
        '/Student/signUp',
        options: Options(headers: header('no token')),
        data: body,
      );
      if (res.statusCode == 200) {
        print("ok");
        return "ok";
      } else {
        print("fail");
        return "signup fail";
      }
    } on DioException catch (ex) {
      print("DioException during registration: $ex");
      return "Error during registration";
    } catch (ex) {
      print("Error during registration: $ex");
      return "Error during registration";
    }
  }

  Future<String> login(String accountID, String password) async {
    try {
      final body =
          FormData.fromMap({'AccountID': accountID, 'Password': password});
      Response res = await api.sendRequest.post(
        '/Auth/login',
        options: Options(headers: header('no token')),
        data: body,
      );
      if (res.statusCode == 200) {
        final tokenData = res.data['data']['token'];
        // Lưu token vào SharedPreferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('token', tokenData);
        print("ok login");
        return tokenData;
      } else {
        print("Login failed with status code: ${res.statusCode}");
        return "login fail";
      }
    } on DioException catch (ex) {
      if (ex.response?.statusCode == 401) {
        print("Unauthorized: Invalid credentials or token.");
        return "Unauthorized: Invalid credentials or token.";
      } else {
        print("DioException during login: $ex");
        return "Error during login";
      }
    } catch (ex) {
      print("Error during login: $ex");
      return "Error during login";
    }
  }

  Future<User> current(String token) async {
    try {
      Response res = await api.sendRequest.get(
        '/Auth/current',
        options: Options(headers: header(token)),
      );
      return User.fromJson(res.data);
    } on DioException catch (ex) {
      if (ex.response?.statusCode == 401) {
        print("Unauthorized: Token might be expired or invalid.");
        throw Exception("Unauthorized: Token might be expired or invalid.");
      } else {
        print("DioException fetching current user: $ex");
        rethrow;
      }
    } catch (ex) {
      print("Error fetching current user: $ex");
      rethrow;
    }
  }
}
