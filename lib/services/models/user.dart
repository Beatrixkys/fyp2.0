class MyUser {
  final String uid;

  MyUser({required this.uid});
}

class MyUserData {
  final String uid;
  final String name;
  final String email;
  final Map persona;
  final int progress;
  final List friends;

  MyUserData(
      {required this.uid,
      required this.name,
      required this.email,
      required this.persona,
      required this.progress,
      required this.friends});
}

class FriendData {
  final String name;
  final int progress;
  final String email; 
  FriendData({required this.name, required this.progress, required this.email});
}
