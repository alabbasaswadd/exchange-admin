// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserPreferencesService {
//   static const String _userKey = 'user_data';
//   static Future<void> saveUser(Map<String, dynamic> userJson) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userKey, jsonEncode(userJson));
//   }

//   static Future<AccountDataModel?> getUserModel() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userString = prefs.getString(_userKey);
//     if (userString != null) {
//       final json = jsonDecode(userString);
//       return AccountDataModel.fromJson(json);
//     }
//     return null;
//   }

//   static Future<void> clearUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove("token");
//     await prefs.remove(_userKey);
//   }

//   static Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("token", token);
//   }

//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("token");
//     if (token != null) {
//       return token;
//     }
//     return null;
//   }

//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.containsKey("token");
//   }
// }

// class UserSession {
//   static AccountDataModel? _user;

//   /// تحميل بيانات المستخدم من SharedPreferences
//   static Future<void> init() async {
//     _user = await UserPreferencesService.getUserModel();
//   }

//   /// بيانات المستخدم
//   static AccountDataModel? get user => _user;

//   /// خصائص مختصرة
//   static String? get id => _user?.id;
//   static String? get email => _user?.email;
//   static String? get phone => _user?.phone?.toString();
//   static String? get firstName => _user?.firstName;
//   static String? get lastName => _user?.lastName;
//   static String? get userName => _user?.userName;
//   static String? get image => _user?.image;
//   static DateTime? get dateOfBirth => _user?.dateOfBirth;

//   /// العنوان
//   static AddressModel? get address => _user?.address;
//   static String? get city => _user?.address?.city;
//   static String? get street => _user?.address?.street;
//   static int? get buildingNumber => _user?.address?.buildingNumber;
//   static String? get postalCode => _user?.address?.postalCode;
//   static String? get country => _user?.address?.country;

//   /// هل مسجل دخول
//   static bool get isLoggedIn => _user != null;

//   /// تحديث
//   static Future<void> updateUser(AccountDataModel userModel) async {
//     _user = userModel;
//     await UserPreferencesService.saveUser(userModel.toJson());
//   }

//   /// تسجيل الخروج
//   static Future<void> clear() async {
//     _user = null;
//     await UserPreferencesService.clearUser();
//   }
// }
