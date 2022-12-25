import 'package:flutter/material.dart';
import 'package:okuol_movie_app/core/constants/colors.dart';
import 'package:okuol_movie_app/locator.dart';
import 'package:okuol_movie_app/ui/widgets/splash_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'TMDB MOVIES OKOUL',
      theme: ThemeData(
          scaffoldBackgroundColor: kcPrimaryColor,
          appBarTheme:
              const AppBarTheme(backgroundColor: kcPrimaryColor, elevation: 0)),
      home: const SplashScreen(),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
