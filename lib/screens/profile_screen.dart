import 'package:flutter/material.dart';
import 'package:fyp2/screens/components/drawer.dart';
import 'package:fyp2/screens/components/header.dart';

import '../constant.dart';
import '../services/lists/personalist.dart';
import 'components/theme_button.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    String personaPic = 'assets/owl.png';

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
              height: MediaQuery.of(context).size.height * 0.4,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: 80,
                          backgroundImage: AssetImage(personaPic),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              ('Beatrix Kang'),
                              textAlign: TextAlign.start,
                              style: kHeadingTextStyle,
                            ),
                            const Text(
                              ('b@mail.com'),
                              textAlign: TextAlign.start,
                              style: kSubTextStyle,
                            ),
                            space,
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.pushNamed(context, '/');
                                },
                                child: Center(
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            space,
            const Text('PERSONA TYPE', style: kTitleTextStyle),
            const Text(
              "Owl",
              textAlign: TextAlign.start,
              style: kHeadingTextStyle,
            ),
            const Text(
              "Consistency Based",
              textAlign: TextAlign.start,
              style: kSubTextStyle,
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.05,
              thickness: 4,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const Text('Change Persona', style: kTitleTextStyle),
            space,
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.4,
              child: const PersonaCardList(),
            ),
            space,
          ],
        ),
      ),
    );
  }
}
