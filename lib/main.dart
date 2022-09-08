//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screens/finance_screen.dart';
import 'package:fyp2/screens/goal_screen.dart';
import 'package:fyp2/screens/home_screen.dart';
import 'package:fyp2/screens/leaderboard_screen.dart';
import 'package:fyp2/screens/profile_screen.dart';
import 'package:fyp2/services/themes.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //final FirebaseAuth auth = FirebaseAuth.instance;
    //final User? user = auth.currentUser;
    //final uid=user!.uid;
    String uid = "123";

    return ChangeNotifierProvider(
        create: (context) => ThemesProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemesProvider>(context);
          return MaterialApp(
            title: "Soar",
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            initialRoute: '/home',
            routes: {
              '/': (context) => const AuthScreen(),
              '/bioauth': (context) => const BioAuthScreen(),
              '/resetpassword': (context) => const ResetPasswordScreen(),
              '/home': (context) => HomeScreen(uid: uid),
              '/profile': (context) => ProfileScreen(uid: uid),
              '/finance': (context) => FinanceScreen(uid: uid),
              '/goals': (context) => GoalScreen(uid: uid),
              '/leaderboard': (context) => LeaderboardScreen(uid: uid),
              '/managefinance': (context) => const ManageFinance(),
              '/managegoals': (context) => const ManageGoal(),
              '/addfinance': (context) => const AddFinance(),
              '/addgoal': (context) => const AddGoal(),
            },
          );
        });
  }
}
