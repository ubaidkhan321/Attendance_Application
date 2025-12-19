import 'package:attendance_system_app/data/network/base.api.services.dart';
import 'package:attendance_system_app/data/network/network.api.services.dart';
import 'package:attendance_system_app/model/checkout.attendance.model.dart';
import 'package:attendance_system_app/resource/constant/globals.url.dart';

class CheckOutRepo {
  static BaseNetworkApi networkApi = NetworkApiClass();
  static String checkoutUrl = Global.CHECKOUT;

  static Future<CheckOutModel> checkOutRepo({required String? userId}) async {
    try {
      final response = await networkApi.postApi(checkoutUrl, {
        "user_Id": userId,
      });
      return CheckOutModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
