import 'package:flutter/material.dart';
import 'package:fyp2/constant.dart';
import 'package:fyp2/services/models/user.dart';

import '../models/user.dart';

class LeaderboardList extends StatefulWidget {
  const LeaderboardList({Key? key}) : super(key: key);

  @override
  State<LeaderboardList> createState() => _LeaderboardListState();
}

class _LeaderboardListState extends State<LeaderboardList> {
  @override
  Widget build(BuildContext context) {
    List<MyUserData> friends = [
      MyUserData(
          uid: "1",
          name: "Ashley",
          email: "a@mail.com",
          persona: {'persona': "Owl", 'type': "personaDescr"},
          friends: [{'name':"Kang","progress":80}],
          progress: 80),
    ];
    

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

  final MyUserData friend;
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

class FriendRequestList extends StatefulWidget {
  const FriendRequestList({Key? key}) : super(key: key);

  @override
  State<FriendRequestList> createState() => _FriendRequestListState();
}

class _FriendRequestListState extends State<FriendRequestList> {
  @override
  Widget build(BuildContext context) {
    List<MyUserData> friends = [
      MyUserData(
          uid: "1",
          name: "Ashley",
          email: "a@mail.com",
          persona: {'persona': "Owl", 'type': "personaDescr"},
          friends: [{'name':"Kang","progress":80}],
          progress: 80),
    ];
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return FriendRequestTile(friend: friends[index]);
      },
    );
  }
}

class FriendRequestTile extends StatelessWidget {
  const FriendRequestTile({Key? key, required this.friend}) : super(key: key);

  final MyUserData friend;

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () async {},
                ),
                IconButton(
                  icon: const Icon(Icons.close_outlined),
                  onPressed: () async {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
