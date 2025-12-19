import 'package:attendance_system_app/data/network/base.api.services.dart';
import 'package:attendance_system_app/data/network/network.api.services.dart';
import 'package:attendance_system_app/model/register.user.model.dart';
import 'package:attendance_system_app/resource/constant/globals.url.dart';

class RegisterUserRepo {
  static BaseNetworkApi networkApi = NetworkApiClass();
  static String registerUrl = Global.REGISTER_USER;
  static Future<RegisterUserModel> registerUserRepo({
    String? name,
    String? email,
    String? password,
  }) async {
    try {
      final response = await networkApi.postApi(
          registerUrl, {"name": name, "email": email, "password": password});
      return RegisterUserModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
