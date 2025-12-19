import 'package:attendance_system_app/resource/routes/route.define.dart';
import 'package:attendance_system_app/resource/routes/route.name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("BaseUrl ${dotenv.env['BASE_URL']}");
    return GetMaterialApp(
      title: 'Distrho',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
      ),
      onGenerateRoute: Pages.onGenerateRoute,
      initialRoute: Routes.SPLASH_VIEW,
      defaultTransition: Transition.rightToLeft,
      smartManagement: SmartManagement.full,
    );
  }
}
