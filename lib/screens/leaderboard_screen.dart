import 'package:flutter/material.dart';
import 'package:fyp2/services/lists/friendlist.dart';

import '../constant.dart';
import 'components/drawer.dart';
import 'components/header.dart';
import 'components/theme_button.dart';

class LeaderboardScreen extends StatelessWidget {
  final String uid;
  const LeaderboardScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        elevation: 0.0,
        actions: const [ChangeThemeButton()],
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            MyHeader(
                height: MediaQuery.of(context).size.height * 0.2,
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Leaderboard',
                          textAlign: TextAlign.start,
                          style: kHeadingTextStyle,
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              height: 40.0,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: const Center(
                                  child: Text(
                                    'Share',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            smallSpace,
                            Container(
                              height: 40.0,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: const Center(
                                  child: Text(
                                    'Add Friend',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            space,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.95,
              child: const LeaderboardList(),
            ),
            space,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(40)),
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    'Pending Friend Requests',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  space,
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.95,

                    child: const FriendRequestList(),
                    //populate with numbers from the database
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
