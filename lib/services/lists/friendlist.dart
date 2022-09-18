import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/constant.dart';
import 'package:fyp2/services/models/user.dart';
import 'package:provider/provider.dart';

import '../database.dart';

class LeaderboardList extends StatefulWidget {
  const LeaderboardList({Key? key}) : super(key: key);

  @override
  State<LeaderboardList> createState() => _LeaderboardListState();
}

class _LeaderboardListState extends State<LeaderboardList> {
  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<FriendData>>(context);

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return LeaderboardTile(friend: friends[index], index: index);
      },
    );
  }
}

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({Key? key, required this.friend, required this.index})
      : super(key: key);

  final FriendData friend;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: Text(
            '${index + 1}',
            style: kHeadingTextStyle,
          ),
          title: Text(
            friend.name,
            style: kHeadingTextStyle,
          ),
          subtitle: Text(friend.email),
          trailing: Text(
            '${friend.progress}',
            style: kHeadingTextStyle,
          ),
        ),
      ),
    );
  }
}

class FriendList extends StatefulWidget {
  const FriendList({
    Key? key,
    required this.allusers,
    required this.user,
  }) : super(key: key);

  final Stream<MyUserData> user;
  final List<MyUserData> allusers;
  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    final allusers = widget.allusers;
    final user = widget.user;

    return ListView.builder(
      itemCount: allusers.length,
      itemBuilder: (context, index) {
        return FriendsTile(friend: allusers[index], user: user);
      },
    );
  }
}

class FriendsTile extends StatelessWidget {
  const FriendsTile({Key? key, required this.friend, required this.user})
      : super(key: key);

  final MyUserData friend;
  final Stream<MyUserData> user;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyUserData>(
        stream: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MyUserData myUserData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                margin: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                child: ListTile(
                  title: Text(
                    friend.name,
                  ),
                  subtitle: Text(friend.uid),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_outlined),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("user")
                          .doc(friend.uid)
                          .collection('friendrequest')
                          .doc(myUserData.uid)
                          .set({
                        'name': myUserData.name,
                        'email': myUserData.email,
                        'progress': myUserData.progress,
                      });
                    },
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class FriendRequestList extends StatefulWidget {
  final Stream<MyUserData> user;
  const FriendRequestList({Key? key, required this.user}) : super(key: key);

  @override
  State<FriendRequestList> createState() => _FriendRequestListState();
}

class _FriendRequestListState extends State<FriendRequestList> {
  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<FriendData>>(context);
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return FriendRequestTile(
          friend: friends[index],
          user: widget.user,
        );
      },
    );
  }
}

class FriendRequestTile extends StatelessWidget {
  const FriendRequestTile({Key? key, required this.friend, required this.user})
      : super(key: key);

  final FriendData friend;
  final Stream<MyUserData> user;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyUserData>(
        stream: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MyUserData myuserData = snapshot.data!;
            //= myuserData!.name;
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  title: Text(
                    friend.name,
                    style: kHeadingTextStyle,
                  ),
                  subtitle: Text(friend.email),
                  trailing: SizedBox(
                    width: 96,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_outlined),
                          onPressed: () async {
                            DatabaseService(myuserData.uid).addFriend(
                                myuserData.name,
                                myuserData.email,
                                myuserData.progress,
                                friend.name,
                                friend.email,
                                friend.progress,
                                friend.fid);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_outlined),
                          onPressed: () async {
                            DatabaseService(myuserData.uid)
                                .deleteFriendRequest(friend.fid);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
