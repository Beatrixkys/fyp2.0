//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screens/finance_screen.dart';
import 'package:fyp2/screens/goal_screen.dart';
import 'package:fyp2/screens/home_screen.dart';
import 'package:fyp2/screens/leaderboard_screen.dart';
import 'package:fyp2/screens/profile_screen.dart';
import 'package:fyp2/screens/setup_profile_screen.dart';
import 'package:fyp2/services/auth.dart';
import 'package:fyp2/services/models/user.dart';
import 'package:fyp2/services/themes.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: ChangeNotifierProvider(
          create: (context) => ThemesProvider(),
          builder: (context, _) {
            final themeProvider = Provider.of<ThemesProvider>(context);
            return MaterialApp(
              title: "Soar",
              themeMode: themeProvider.themeMode,
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              initialRoute: '/',
              routes: {
                '/': (context) => const AuthenticationWrapper(),
                '/bioauth': (context) => const BioAuthScreen(),
                '/resetpassword': (context) => const ResetPasswordScreen(),
                '/setupuser': (context) =>
                    const SetUpProfileAndAccountsScreen(),
                '/home': (context) => const HomeScreen(),
                '/profile': (context) => const ProfileScreen(),
                '/finance': (context) => const FinanceScreen(),
                '/goals': (context) => const GoalScreen(),
                '/leaderboard': (context) => const LeaderboardScreen(),
                '/managefinance': (context) => const ManageFinance(uid: ''),
                '/managegoals': (context) => const ManageGoal(
                      uid: '',
                    ),
                '/addfinance': (context) => const AddAccount(uid: ''),
                '/addgoal': (context) => const AddGoal(
                      uid: '',
                    ),
                '/addrecord': (context) => const AddRecordScreen(),
              },
            );
          }),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    if (user == null) {
      return const AuthScreen();
    } else {
      return const HomeScreen();
    }
  }
}
