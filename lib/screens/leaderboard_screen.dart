import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp2/screens/components/progress_bar.dart';
import 'package:fyp2/services/lists/friendlist.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../constant.dart';
import '../services/database.dart';
import '../services/lists/goallist.dart';
import '../services/models/goals.dart';
import '../services/models/user.dart';
import 'components/drawer.dart';
import 'components/header.dart';
import 'components/theme_button.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final sscontroller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    final User? user = auth.currentUser;
    final uid = user!.uid;

    //Stream
    Stream<MyUserData> myUserData = DatabaseService(uid).user;

    return MultiProvider(
        providers: [
          StreamProvider<List<FriendData>>.value(
              value: DatabaseService(uid).friends, initialData: const []),
          StreamProvider<List<BadgesData>>.value(
              value: DatabaseService(uid).badges, initialData: const []),
        ],
        builder: (context, snapshot) {
          return Screenshot(
            controller: sscontroller,
            child: Scaffold(
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
                                    addFriend(uid, myUserData),
                                    smallSpace,
                                    shareProgress(),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                    space,
                    ProgressBar(myUserData: myUserData),
                    space,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.22,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: const BadgeCardList(),
                    ),
                    space,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: const LeaderboardList(),
                    ),
                    space,
                    friendRequestContainer(uid, myUserData),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget shareProgress() {
    return Container(
      height: 40.0,
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () async {
          final image = await sscontroller.capture();
          await saveImage(image!);
          await saveShare(image);
        },
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
    );
  }

  Widget addFriend(uid, myUserData) {
    void _showSearchFriends() {
      showDialog(
          context: context,
          builder: (context) {
            return SearchPopUp(uid: uid, user: myUserData);
          });
    }

    return Container(
      height: 40.0,
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () => _showSearchFriends(),
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
    );
  }

  Widget friendRequestContainer(uid, myUserData) {
    return StreamProvider<List<FriendData>>.value(
      initialData: const [],
      value: DatabaseService(uid).friendRequests,
      child: Container(
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

              child: FriendRequestList(
                user: myUserData,
              ),
              //populate with numbers from the database
            ),
          ],
        ),
      ),
    );
  }
}

class SearchPopUp extends StatefulWidget {
  const SearchPopUp({Key? key, required this.uid, required this.user})
      : super(key: key);

  final String uid;
  final Stream<MyUserData> user;
  @override
  State<SearchPopUp> createState() => _SearchPopUpState();
}

class _SearchPopUpState extends State<SearchPopUp> {
  final TextEditingController _searchController = TextEditingController();

  List<MyUserData> userList = [];
  List<MyUserData> newList = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void getUsers() async {
    List<MyUserData> list = await DatabaseService(widget.uid).allUsers.first;
    userList = list;
  }

  void searchUsers(String query) {
    final newList = userList.where((friend) {
      final friends = friend.email.toString().toLowerCase();
      final input = query.toLowerCase();
      return friends.contains(input);
    }).toList();

    setState(() {
      userList = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    String searchText = '';

    getUsers();

    return Dialog(
      child: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Search Friends",
                style: kHeadingTextStyle,
              ),
              TextField(
                controller: _searchController,
                onChanged: (String? value) {
                  setState(() {
                    searchText = value!;
                    searchUsers(searchText);
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              space,
              SizedBox(
                width: 350,
                height: 220,
                child: FriendList(
                  allusers: userList,
                  user: widget.user,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> saveImage(Uint8List bytes) async {
  await (Permission.storage).request();
  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');
  final name = 'screenshot_$time';
  final result = await ImageGallerySaver.saveImage(bytes, name: name);
  return result['filePath'];
}

Future saveShare(Uint8List bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final image = File('${directory.path}/progress.png');
  image.writeAsBytesSync(bytes);
  await Share.shareFiles([image.path]);
}
