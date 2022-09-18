import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screens/components/buttons.dart';
import 'package:fyp2/screens/components/cards.dart';
import 'package:fyp2/screens/components/drawer.dart';
import 'package:fyp2/screens/components/header.dart';
import 'package:fyp2/screens/components/progress_bar.dart';
import 'package:fyp2/screens/components/theme_button.dart';
import 'package:fyp2/screens/profile_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../services/database.dart';
import '../services/lists/goallist.dart';
import '../services/lists/reclist.dart';
import '../services/models/goals.dart';
import '../services/models/persona.dart';
import '../services/models/records.dart';
import '../services/models/user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    //Streams
    Stream<MyUserData> myUserData = DatabaseService(uid).user;
    Stream<PersonaData> myPersonaData = DatabaseService(uid).persona;

    final controller = ScrollController();

    return MultiProvider(
        providers: [
          StreamProvider<List<GoalsData>>.value(
              value: DatabaseService(uid).goals, initialData: const []),
          StreamProvider<List<RecordsData>>.value(
              value: DatabaseService(uid).records, initialData: const []),
        ],
        builder: (context, snapshot) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  showAvatarProgress(
                                      context, myUserData, myPersonaData),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Welcome Back,',
                                        textAlign: TextAlign.start,
                                        style: kHeadingTextStyle,
                                      ),
                                      NameText(myUserData: myUserData),
                                      AssetCard(uid: uid),
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
                        ProgressBar(
                          myUserData: myUserData,
                        ),
                        const TitleCard(
                            title: "Overview Of The Month",
                            route: "/finance",
                            button: "See More"),
                        IECards(uid: uid),
                        smallSpace,
                        const TitleCard(
                            title: "Overview Of Goals",
                            route: "/goals",
                            button: "See More"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: const GoalCardList(),
                        ),
                        smallSpace,
                        const TitleCard(
                            title: "Overview of Records",
                            route: "/finance",
                            button: ""),
                        space,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: RecordList(
                            uid: uid,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: const ShortcutButton(),
          );
        });
  }

  Widget showAvatarProgress(context, myUserData, myPersonaData) {
    return StreamBuilder<MyUserData>(
        stream: myUserData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data;
            var value = userData!.progress;
            return CircularPercentIndicator(
              radius: 90.0,
              lineWidth: 8.0,
              animation: true,
              percent: value / 100,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              center: ProfilePic(myPersonaData: myPersonaData),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
