import 'package:attendance_system_app/data/network/base.api.services.dart';
import 'package:attendance_system_app/data/network/network.api.services.dart';
import 'package:attendance_system_app/model/delete.old.attendance.model.dart';
import 'package:attendance_system_app/resource/constant/globals.url.dart';

class DeleteOldAttendaceRepository {
  static BaseNetworkApi networkApi = NetworkApiClass();
  static String deleteAttendanceUrl = Global.DELETE_OLD_ATTENDANCE;
  static Future<DeleteOldAttendance> deletedAttendanceRepo() async {
    try {
      final response = await networkApi.postApi(deleteAttendanceUrl, {});
      return DeleteOldAttendance.fromJson(response);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
