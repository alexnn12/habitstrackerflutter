import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:habits_grid/login.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "",
    anonKey: "",
  );
  await EasyLocalization.ensureInitialized();

  runApp(
      EasyLocalization(
      supportedLocales: [Locale('en') , Locale('es')],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en'),
      child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Habits Tracker',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        //material3 flag
        useMaterial3: true,


      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,

      ),


      home: const Login(title: 'Habits Open Source'),
    );
  }
}

