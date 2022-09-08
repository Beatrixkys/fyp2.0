import 'package:flutter/material.dart';
import 'package:fyp2/constant.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
            ),
            title: const Text(
              'Home',
              style: kTitleTextStyle,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person_outlined,
            ),
            title: const Text(
              'Profile',
              style: kTitleTextStyle,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet_outlined,
            ),
            title: const Text(
              'Finance',
              style: kTitleTextStyle,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/finance');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.center_focus_weak_outlined,
            ),
            title: const Text(
              'Goals',
              style: kTitleTextStyle,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/goals');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.leaderboard_outlined,
            ),
            title: const Text(
              'Leaderboard',
              style: kTitleTextStyle,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/leaderboard');
            },
          ),
        ],
      ),
    );
  }
}
