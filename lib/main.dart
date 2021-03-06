import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_referral/screens/auth_input_screen.dart';
import 'package:testing_referral/screens/auth_verify_screen.dart';
import 'package:testing_referral/screens/booking_confirmation_screen.dart';
import 'package:testing_referral/screens/contact_us_screen.dart';
import 'package:testing_referral/screens/feedback_screen.dart';
import 'package:testing_referral/screens/location_search_screen.dart';
import 'package:testing_referral/screens/my_rewards_screen.dart';
import 'package:testing_referral/screens/my_rides_screen.dart';
import 'package:testing_referral/screens/navigator_screen.dart';
import 'package:testing_referral/screens/map_screen.dart';
import 'package:testing_referral/screens/name_input_screen.dart';
import 'package:testing_referral/screens/referral_screen.dart';
import 'package:testing_referral/screens/report_screen.dart';
import 'package:testing_referral/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final PageTransitionsTheme zoomPageTransition = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder()
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: Colors.green,
        ),
        pageTransitionsTheme: zoomPageTransition,
      ),
      routes: {
        '/': (context) => SplashScreen(),
        AuthInputScreen.authInputScreen: (context) => AuthInputScreen(),
        AuthVerifyScreen.authVerifyScreen: (context) => AuthVerifyScreen(),
        NameInputScreen.nameInputScreen: (context) => NameInputScreen(),
        NavigatorScreen.navigatorScreen: (context) => NavigatorScreen(),
        ReferralScreen.referralScreen: (context) => ReferralScreen(),
        MapScreen.mapScreen: (context) => MapScreen(),
        ReportScreen.reportScreen: (context) => ReportScreen(),
        ContactUsScreen.contactUsScreen: (context) => ContactUsScreen(),
        MyRidesScreen.myRidesScreen: (context) => MyRidesScreen(),
        MyRewardsScreen.myRewardsScreen: (context) => MyRewardsScreen(),
        LocationSearchScreen.locationSearchScreen: (context) =>
            LocationSearchScreen(),
        BookingConfirmationScreen.bookingConfirmationScreen: (context) =>
            BookingConfirmationScreen(),
        FeedbackScreen.feedbackScreen: (context) => FeedbackScreen(),
      },
    );
  }
}
