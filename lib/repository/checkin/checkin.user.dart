import 'package:attendance_system_app/data/network/base.api.services.dart';
import 'package:attendance_system_app/data/network/network.api.services.dart';
import 'package:attendance_system_app/model/checkin.attendance.dart';
import 'package:attendance_system_app/resource/constant/globals.url.dart';

class CheckInRepo {
  static BaseNetworkApi networkApi = NetworkApiClass();
  static String checkInUrl = Global.CHECKIN;
  static Future<CheckInModel> checkinRepo({required String? userId}) async {
    try {
      final response = await networkApi.postApi(checkInUrl, {
        "user_Id": userId,
      });
      return CheckInModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
