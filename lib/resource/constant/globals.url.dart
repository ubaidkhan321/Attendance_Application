// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Global {
  static String SECRET_KEY = "ThePublicanSecretKey";
  static String BASE_URL = "${dotenv.env['BASE_URL']}";
  static String loginUrl = '$BASE_URL/login';
  static String forgotpasword = '$BASE_URL/forgot-password';
  static String RESET_PASSWORD = '$BASE_URL/reset-password';
  static String REGISTER_USER = '$BASE_URL/register';
  static String DELETE_OLD_ATTENDANCE = '$BASE_URL/delete-Attendace';
  static String GET_ATTENDANCE = '$BASE_URL/get-Attendace';
  static String CHECKIN = '$BASE_URL/checkIn';
  static String CHECKOUT = '$BASE_URL/checkOut';

  static String TEACHER_ATTENDANCE = '$BASE_URL/api/submit-teacher-attandence';
}
