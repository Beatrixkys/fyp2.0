import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/finance.dart';
import 'models/goals.dart';
import 'models/persona.dart';
import 'models/records.dart';
import 'models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  //collection to store the users
  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("user");

  final CollectionReference<Map<String, dynamic>> accountsCollection =
      FirebaseFirestore.instance.collection("accounts");

  final CollectionReference<Map<String, dynamic>> goalsCollection =
      FirebaseFirestore.instance.collection("goals");

  final CollectionReference<Map<String, dynamic>> recordsCollection =
      FirebaseFirestore.instance.collection("records");

//TODO! SAVE UPDATE DELETE

//TODO!1. USER FUNCTIONS- user, persona
  Future<void> saveUser(String name, String email) async {
    await goalsCollection
        .doc(uid)
        .set({'totalAmountSaved': 0, 'totalAmountToSave': 0});
    await accountsCollection.doc(uid).set({'income': 0, 'expense': 0});
    return await userCollection
        .doc(uid)
        .set({'name': name, 'email': email, 'progress': 0});
  }

  Future<void> savePersona(
      String? personaname, String? personaDescription, String? icon) async {
    return await userCollection.doc(uid).collection("persona").doc(uid).set({
      'personaname': personaname,
      'personaDescription': personaDescription,
      'icon': icon,
    });
  }

  Future<void> updatePersona(
      String? personaname, String? personaDescription, String? icon) async {
    return await userCollection.doc(uid).collection("persona").doc(uid).update(
      {
        'personaname': personaname,
        'personaDescription': personaDescription,
        'icon': icon
      },
    );
  }

//TODO!2. FINANCE FUNCTIONS-Save and Update and Delete
  Future<void> saveAccount(String name, int amount) async {
    //doc will create a new uid of Database service
    await accountsCollection.doc(uid).update({
      'income': FieldValue.increment(amount),
    });
    return await accountsCollection
        .doc(uid)
        .collection('accountsdetails')
        .doc()
        .set({'name': name, 'amount': amount});
  }

  Future<void> editAccount(
      String name, int amount, int income, String aid) async {
    //TODO! Update Total Account w Appropriate Logic
    //doc will create a new uid of Database service
    await accountsCollection.doc(uid).update({
      'income': income,
    });

    return await accountsCollection
        .doc(uid)
        .collection('accountsdetails')
        .doc(aid)
        .update({'name': name, 'amount': amount});
  }

  Future<void> deleteAccount(String docid) async {
    //doc will create a new uid of Database service
    return await accountsCollection
        .doc(uid)
        .collection('accountsdetails')
        .doc(docid)
        .delete();
  }

  Future<void> addARecord(int amount, String aid, String accname) async {
    //doc will create a new uid of Database service
    await accountsCollection.doc(uid).update({
      'income': FieldValue.increment(amount),
    });
    await recordsCollection.doc(uid).collection('recordsdetails').doc().set({
      'amount': amount,
      'type': "Income (Acc: $accname)",
    });
    return await accountsCollection
        .doc(uid)
        .collection('accountsdetails')
        .doc(aid)
        .update({
      'amount': FieldValue.increment(amount),
    });
  }

  Future<void> subtractARecord(int amount, String aid, String accname) async {
    //doc will create a new uid of Database service
    await accountsCollection.doc(uid).update({
      'expense': FieldValue.increment(amount),
    });
    await recordsCollection.doc(uid).collection('recordsdetails').doc().set({
      'amount': amount,
      'type': "Expense (Acc: $accname)",
    });
    return await accountsCollection
        .doc(uid)
        .collection('accountsdetails')
        .doc(aid)
        .update({
      'amount': FieldValue.increment(-amount),
    });
  }

//TODO!3.GOAL FUNCTIONS-Save and Update and Delete
  Future<void> saveGoal(
      int amountToSave, String name, int amountSaved, int progress) async {
    //doc will create a new uid of Database service
    await goalsCollection
        .doc(uid)
        .update({'totalAmountToSave': FieldValue.increment(amountToSave)});
    return await goalsCollection.doc(uid).collection('goalsdetails').doc().set({
      'amountToSave': amountToSave,
      'amountSaved': amountSaved,
      'name': name,
      'progress': progress,
    });
  }

  Future<void> updateGoal(
      String docid,
      int amountToSave,
      int amountSaved,
      String name,
      int progress,
      int totalAmountToSave,
      int totalAmountSaved,
      int totalProgress) async {
    //doc will create a new uid of Database service

    await goalsCollection.doc(uid).update({
      'totalAmountToSave': totalAmountToSave,
      'totalAmountSaved': totalAmountSaved,
    });

    await userCollection.doc(uid).update({
      'progress': totalProgress,
    });

    return await goalsCollection
        .doc(uid)
        .collection('goalsdetails')
        .doc(docid)
        .update({
      'amountSaved': amountSaved,
      'amountToSave': amountToSave,
      'name': name,
      'progress': progress,
    });
  }

  Future<void> deleteGoal(String docid) async {
    //doc will create a new uid of Database service

    return await goalsCollection
        .doc(uid)
        .collection('goalsdetails')
        .doc(docid)
        .delete();
  }

  Future<void> addGRecord(
    int amount,
    String account,
    String gid,
    String accid,
    String gname,
    int gProgress,
    int totalProgress,
  ) async {
    await accountsCollection
        .doc(uid)
        .collection('accountsdetails')
        .doc(accid)
        .update({'amount': FieldValue.increment(-amount)});

    await userCollection.doc(uid).update({
      'progress': totalProgress,
    });

    await recordsCollection.doc(uid).collection('recordsdetails').doc().set({
      'amount': amount,
      'type': "$account (Goal: $gname)",
    });

    await goalsCollection
        .doc(uid)
        .update({'totalAmountSaved': FieldValue.increment(amount)});

    return await goalsCollection
        .doc(uid)
        .collection('goalsdetails')
        .doc(gid)
        .update({
      'amountSaved': FieldValue.increment(amount),
      'progress': gProgress,
    });
  }

  Future<void> updateRecord(String rname, int ramount, String rid) async {
    return await recordsCollection
        .doc(uid)
        .collection('recordsdetails')
        .doc(rid)
        .update({
      'type': rname,
      'amount': ramount,
    });
  }

  Future<void> deleteRecord(String docid) async {
    //doc will create a new uid of Database service

    return await recordsCollection
        .doc(uid)
        .collection('recordsdetails')
        .doc(docid)
        .delete();
  }

  Future<void> addFriend(String uname, String uemail, int uprogress,
      String name, String email, int progress, String docid) async {
    //doc will create a new uid of Database service
    await userCollection.doc(docid).collection('friend').doc(uid).set({
      "name": uname,
      "email": uemail,
      "progress": uprogress,
    });

    await userCollection.doc(uid).collection('friend').doc(docid).set({
      "name": name,
      "email": email,
      "progress": progress,
    });

    return await userCollection
        .doc(uid)
        .collection('friendrequest')
        .doc(docid)
        .delete();
  }

  Future<void> createFriendRequest(
    String fid,
    String name,
    String email,
    int progress,
  ) async {
    //doc will create a new uid of Database service
    return await userCollection
        .doc(fid)
        .collection('friendrequest')
        .doc(uid)
        .set({'name': name, 'email': email, 'progress': progress});
  }

  Future<void> deleteFriendRequest(String docid) async {
    //doc will create a new uid of Database service
    return await userCollection
        .doc(uid)
        .collection('friendrequest')
        .doc(docid)
        .delete();
  }

//TODO! READ FUNCTIONS

//TODO! SINGLE STREAM

  MyUserData _userFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return MyUserData(
      uid: snapshot.id,
      name: data['name'],
      email: data['email'],
      progress: data['progress'],
    );
  }

//Create a SINGLE user stream
  //stream qui récupre le user courant donc
  // besoin de doc(uid)
  Stream<MyUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  PersonaData _personaFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return PersonaData(
      icon: data['icon'],
      pdescription: data['personaDescription'],
      pname: data['personaname'],
    );
  }

//Create a SINGLE user stream
  //stream qui récupre le user courant donc
  // besoin de doc(uid)
  Stream<PersonaData> get persona {
    return userCollection
        .doc(uid)
        .collection("persona")
        .doc(uid)
        .snapshots()
        .map(_personaFromSnapshot);
  }

//Create a LIST of users
  //querySnapshot peut contenir 0 ou plusieurs query de snapshot
  //Create user list
  List<MyUserData> _userListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

//Create a stream of users
  // on récupere tout les users
  Stream<List<MyUserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  List<MyUserData> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MyUserData(
        uid: doc.id,
        name: (doc.data() as dynamic)['name'] ?? '',
        email: (doc.data() as dynamic)['email'] ?? '',
        progress: (doc.data() as dynamic)['progress'] ?? 0,
      );
    }).toList();
  }

/*{
              'pname': 'pname',
              'pDescription': 'pDescription',
            }] ??
            {},*/

  Stream<List<MyUserData>> get allUsers {
    return userCollection.snapshots().map(_usersListFromSnapshot);
  }

//TODO!Goals Reading Functions
  List<GoalsData> _goalsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return GoalsData(
        goalsid: doc.id,
        progress: (doc.data() as dynamic)['progress'] ?? 0,
        amountSaved: (doc.data() as dynamic)['amountSaved'] ?? 0,
        amountToSave: (doc.data() as dynamic)['amountToSave'] ?? 0,
        name: (doc.data() as dynamic)['name'] ?? '',
      );
    }).toList();
  }

  List<BadgesData> _badgeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BadgesData(
        goalsid: doc.id,
        progress: (doc.data() as dynamic)['progress'] ?? 0,
        amountSaved: (doc.data() as dynamic)['amountSaved'] ?? 0,
        amountToSave: (doc.data() as dynamic)['amountToSave'] ?? 0,
        name: (doc.data() as dynamic)['name'] ?? '',
      );
    }).toList();
  }

  Stream<List<GoalsData>> get goals {
    final CollectionReference<Map<String, dynamic>> goalsdetailsCollection =
        goalsCollection.doc(uid).collection("goalsdetails");

    return goalsdetailsCollection.snapshots().map(_goalsListFromSnapshot);
  }

  Stream<List<BadgesData>> get badges {
    final CollectionReference<Map<String, dynamic>> badgesCollection =
        goalsCollection.doc(uid).collection("badges");

    return badgesCollection.snapshots().map(_badgeListFromSnapshot);
  }

//TODO!Accounts Reading Functions
  List<AccountsData> _accountsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AccountsData(
        accountid: doc.id,
        name: (doc.data() as dynamic)['name'] ?? '',
        amount: (doc.data() as dynamic)['amount'] ?? 0,
      );
    }).toList();
  }

  Stream<List<AccountsData>> get accounts {
    final CollectionReference<Map<String, dynamic>> accountsdetailsCollection =
        accountsCollection.doc(uid).collection("accountsdetails");
    return accountsdetailsCollection.snapshots().map(_accountsListFromSnapshot);
  }

  List<RecordsData> _recordsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return RecordsData(
        amount: (doc.data() as dynamic)['amount'] ?? 0,
        recordid: doc.id,
        type: (doc.data() as dynamic)['type'] ?? '',
      );
    }).toList();
  }

//TODO! records (accounts and goals)
  Stream<List<RecordsData>> get records {
    final CollectionReference<Map<String, dynamic>> recordsdetailsCollection =
        recordsCollection.doc(uid).collection("recordsdetails");
    return recordsdetailsCollection.snapshots().map(_recordsListFromSnapshot);
  }

  IncomeExpenseData incomeExpenseFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("data not found");
    return IncomeExpenseData(
      income: data['income'],
      expense: data['expense'],
    );
  }

  Stream<IncomeExpenseData> get incomeExpense {
    return accountsCollection
        .doc(uid)
        .snapshots()
        .map(incomeExpenseFromSnapshot);
  }

  TotalGoalsData totalGoalsFromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("data not found");
    return TotalGoalsData(
      totalAmountSaved: data['totalAmountSaved'],
      totalAmountToSave: data['totalAmountToSave'],
    );
  }

  Stream<TotalGoalsData> get totalGoalsData {
    return goalsCollection.doc(uid).snapshots().map(totalGoalsFromSnapShot);
  }

  List<FriendData> _friendsRequestListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FriendData(
        name: (doc.data() as dynamic)['name'] ?? '',
        email: (doc.data() as dynamic)['email'] ?? '',
        progress: (doc.data() as dynamic)['progress'] ?? 0,
        fid: (doc.id),
      );
    }).toList();
  }

  Stream<List<FriendData>> get friendRequests {
    final CollectionReference<Map<String, dynamic>> friendRequestCollection =
        userCollection.doc(uid).collection("friendrequest");

    return friendRequestCollection
        .snapshots()
        .map(_friendsRequestListFromSnapshot);
  }

  List<FriendData> _friendsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FriendData(
        name: (doc.data() as dynamic)['name'] ?? '',
        email: (doc.data() as dynamic)['email'] ?? '',
        progress: (doc.data() as dynamic)['progress'] ?? 0,
        fid: (doc.id),
      );
    }).toList();
  }

  Stream<List<FriendData>> get friends {
    final CollectionReference<Map<String, dynamic>> friendCollection =
        userCollection.doc(uid).collection("friend");

    return friendCollection.snapshots().map(_friendsListFromSnapshot);
  }
}
