class MyUser {
  final String uid;

  MyUser({required this.uid});
}

class MyUserData {
  final String uid;
  final String name;
  final String email;
  final int progress;

  MyUserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.progress,
  });
}

class FriendData {
  final String fid; 
  final String name;
  final int progress;
  final String email;
  FriendData({ required this.fid, required this.name, required this.progress, required this.email});
}

