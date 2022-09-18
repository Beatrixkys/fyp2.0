import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screens/components/drawer.dart';
import 'package:fyp2/screens/components/header.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../services/lists/personalist.dart';
import '../services/models/persona.dart';
import '../services/models/user.dart';
import 'components/theme_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    final User? user = auth.currentUser;
    final uid = user!.uid;

    Stream<MyUserData> myUserData = DatabaseService(uid).user;
    Stream<PersonaData> myPersonaData = DatabaseService(uid).persona;

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
                        ProfilePic(myPersonaData: myPersonaData),
                        /*CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: 80,
                          backgroundImage: AssetImage(personaPic),
                        ),*/
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NameText(
                              myUserData: myUserData,
                            ),
                            Text(
                              (user.email!),
                              textAlign: TextAlign.start,
                              style: kSubTextStyle,
                            ),
                            space,
                            logOutBtn(),
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
            showPersona(myPersonaData),
            showPersonaDescription(myPersonaData),
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
              child: PersonaCardList(
                uid: uid,
                newUser: false,
              ),
            ),
            space,
          ],
        ),
      ),
    );
  }

  Widget showName() {
    var name = Provider.of<MyUserData>(context);

    return Text(
      name.name,
      textAlign: TextAlign.start,
      style: kHeadingTextStyle,
    );
  }

  Widget showPersona(myPersonaData) {
    return StreamBuilder<PersonaData>(
      stream: myPersonaData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var personaData = snapshot.data;
          var value = personaData!.pname;
          return Text(
            value,
            textAlign: TextAlign.start,
            style: kHeadingTextStyle,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget showPersonaDescription(myPersonaData) {
    return StreamBuilder<PersonaData>(
      stream: myPersonaData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var personaData = snapshot.data;
          var value = personaData!.pdescription;
          return Text(
            value,
            textAlign: TextAlign.start,
            style: kHeadingTextStyle,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget logOutBtn() {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () async {
          await _auth.signOut();

          if (!mounted) return;
          Navigator.pushNamed(context, '/');
        },
        child: Center(
          child: Text(
            'Log Out',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class NameText extends StatelessWidget {
  final Stream<MyUserData?> myUserData;

  const NameText({
    Key? key,
    required this.myUserData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyUserData? userData;

    return StreamBuilder<MyUserData?>(
      stream: myUserData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userData = snapshot.data;
          var value = userData!.name;
          return Text(
            value,
            textAlign: TextAlign.start,
            style: kHeadingTextStyle,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ProfilePic extends StatelessWidget {
  final Stream<PersonaData> myPersonaData;

  const ProfilePic({
    Key? key,
    required this.myPersonaData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PersonaData>(
      stream: myPersonaData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var personaData = snapshot.data;
          var value = personaData!.icon;
          return CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 80,
            backgroundImage: AssetImage(value),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
