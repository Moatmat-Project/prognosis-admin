import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moatmat_admin/Core/constant/navigation_key.dart';
import 'package:moatmat_admin/Presentation/auth/view/auth_views_manager.dart';
import 'package:moatmat_admin/Presentation/notifications/views/notifications_view.dart';
import 'package:moatmat_admin/Presentation/schools/views/schools_view.dart';
import 'Core/resources/colors_r.dart';
import 'Core/resources/spacing_resources.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorsResources.primary,
        ),
        useMaterial3: true,
        fontFamily: "Tajawal",
        scaffoldBackgroundColor: ColorsResources.background,
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: ColorsResources.primary,
              fontFamily: "Tajawal",
            ),
            foregroundColor: ColorsResources.primary,
            backgroundColor: ColorsResources.background),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorsResources.primary,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
          backgroundColor: ColorsResources.primary,
        )),
        //
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsResources.primary,
            fixedSize: Size(
              SpacingResources.mainWidth(context),
              50,
            ),
            foregroundColor: ColorsResources.whiteText1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(
                color: ColorsResources.borders,
                width: 0.5,
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar"),
      ],
      home: const AuthViewsManager(),

        navigatorKey: navigatorKey,

     routes: {
    '/notifications': (context) => const NotificationsView(),
     },
    );
  }
}
