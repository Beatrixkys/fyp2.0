import 'package:flutter/material.dart';
import 'package:fyp2/screens/components/buttons.dart';
import 'package:fyp2/screens/components/cards.dart';
import 'package:fyp2/screens/components/drawer.dart';
import 'package:fyp2/screens/components/header.dart';
import 'package:fyp2/screens/components/progress_bar.dart';
import 'package:fyp2/screens/components/theme_button.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../constant.dart';
import '../services/lists/goallist.dart';

class HomeScreen extends StatelessWidget {
  final String uid;

  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    String profileImage = 'assets/owl.png';
    double total = 1000;

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
                height: MediaQuery.of(context).size.height * 0.35,
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CircularPercentIndicator(
                              radius: 80.0,
                              lineWidth: 8.0,
                              animation: true,
                              percent: 0.80,
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor:
                                  Theme.of(context).colorScheme.secondary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              center: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                radius: 50.0,
                                backgroundImage: AssetImage(
                                  profileImage,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Welcome Back, \n Beatrix Kang',
                                  textAlign: TextAlign.start,
                                  style: kHeadingTextStyle,
                                ),
                                Text(
                                  'Total Assets: \n RM $total',
                                  textAlign: TextAlign.start,
                                  style: kSubTextStyle,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  smallSpace,
                  const ProgressBar(percent: 0.8, progress: "80%"),
                  const TitleCard(
                      title: "Overview Of The Month",
                      route: "/",
                      button: "See More"),
                  Row(
                    children: const [
                      ExpenseCard(title: "Income", amount: "5000"),
                      ExpenseCard(title: "Expense", amount: "5000"),
                    ],
                  ),
                  smallSpace,
                  const TitleCard(
                      title: "Overview Of Goals",
                      route: "/managegoals",
                      button: "Manage"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const GoalCardList(),
                  ),
                  smallSpace,
                  const TitleCard(
                      title: "Overview Of Records",
                      route: "/",
                      button: "Manage"),
                  /*
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const RecordList(),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const ShortcutButton(),
    );
  }
}
