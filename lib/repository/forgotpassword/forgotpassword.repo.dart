import 'package:attendance_system_app/data/network/base.api.services.dart';
import 'package:attendance_system_app/data/network/network.api.services.dart';
import 'package:attendance_system_app/model/forgot.passowrd.model.dart';
import 'package:attendance_system_app/model/new.password.model.dart';
import 'package:attendance_system_app/resource/constant/globals.url.dart';

class ForgotpasswordRepository {
  static BaseNetworkApi networkApi = NetworkApiClass();
  static String forgotUrl = Global.forgotpasword;
  static String newPasswordUrl = Global.RESET_PASSWORD;
  static Future<ForgotpasswordModel> forgotpassword(
      {String? name, String? email}) async {
    try {
      final response =
          await networkApi.postApi(forgotUrl, {"name": name, "email": email});
      return ForgotpasswordModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  static Future<NewpasswordModel> newPassword(
      String? token, String? newPassword) async {
    try {
      final response = await networkApi.postApi(
          newPasswordUrl, {"token": token, "newPassword": newPassword});
      return NewpasswordModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
