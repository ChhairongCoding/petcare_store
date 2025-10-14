import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:petcare_store/binding/init_binding.dart';
import 'package:petcare_store/config/core/routes/app_pages.dart';
import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/config/theme/app_theme.dart';
// import 'package:petcare_store/services/local_service.dart';
// import 'package:petcare_store/util/provider_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  try {
    await Supabase.initialize(
      url: dotenv.get("supabaseUrl"),
      anonKey: dotenv.get('supabaseKey'),
    );
  } catch (e) {
    throw Exception(e);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBinding(),
      color: Color(0xffF5F5F7),
      title: 'PetCare Store',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splashScreen,
      getPages: appPages,
    );
  }
}
