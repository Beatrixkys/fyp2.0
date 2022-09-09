import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/finance.dart';
import 'models/goals.dart';
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

//TODO! SAVE UPDATE DELETE

//TODO!1. USER FUNCTIONS- user, persona
  Future<void> saveUser(String name, String email) async {
    return await userCollection.doc(uid).set({'name': name, 'email': email});
  }

  Future<void> savePersona(
      String? personaname, String? personaDescription) async {
    return await userCollection.doc(uid).set({
      'persona': {
        'personaname': personaname,
        'personaDescription': personaDescription
      }
    }, SetOptions(merge: true));
  }

  Future<void> updatePersona(
      String? personaname, String? personaDescription) async {
    return await userCollection.doc(uid).update(
      {
        'persona': {
          'personaname': personaname,
          'personaDescription': personaDescription
        }
      },
    );
  }

//TODO!2. FINANCE FUNCTIONS-Save and Update and Delete
  Future<void> saveAccount(String name, int amount) async {
    //doc will create a new uid of Database service
    return await accountsCollection
        .doc(uid)
        .collection('accountsdetails')
        .doc()
        .set({'name': name, 'amount': amount});
  }

  Future<void> editAccount(String name, int amount, String aid) async {
    //doc will create a new uid of Database service
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

  Future<void> addRecord(int amount, String aid) async {
    //doc will create a new uid of Database service
    await accountsCollection.doc(uid).update({
      'income': FieldValue.increment(amount),
    });
    return await accountsCollection
        .doc(uid)
        .collection('accountsdetails')
        .doc(aid)
        .update({
      'amount': FieldValue.increment(amount),
      'arecords': FieldValue.arrayUnion([
        {"amount": amount, "type": "Income"}
      ]),
    });
  }

  Future<void> subtractRecord(int amount, String aid) async {
    //doc will create a new uid of Database service
    await accountsCollection.doc(uid).update({
      'expense': FieldValue.increment(amount),
    });
    return await accountsCollection
        .doc(uid)
        .collection('accountsdetails')
        .doc(aid)
        .update({
      'amount': FieldValue.increment(-amount),
      'arecords': FieldValue.arrayUnion([
        {"amount": amount, "type": "Income"}
      ]),
    });
  }

//TODO!3.GOAL FUNCTIONS-Save and Update and Delete
  Future<void> saveGoal(
      int amountToSave, String name, int amountSaved, int progress) async {
    //doc will create a new uid of Database service
    return await goalsCollection.doc(uid).collection('goalsdetails').doc().set({
      'amountToSave': amountToSave,
      'amountSaved': amountSaved,
      'name': name,
      'progress': progress,
    });
  }

  Future<void> updateGoal(String docid, int amountToSave, String name,
      int amountSaved, int progress) async {
    //doc will create a new uid of Database service
    return await goalsCollection
        .doc(uid)
        .collection('goalsdetails')
        .doc(docid)
        .update({
      'amountToSave': amountToSave,
      'amountSaved': amountSaved,
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

  Future<void> updateGoalProgress(int amountSaved, int gProgress, int totalProgress, String docid) async {


    await userCollection.doc(uid).update({'progress': totalProgress});
    return await goalsCollection
        .doc(uid)
        .collection('goalsdetails')
        .doc(docid)
        .update({'amountSaved': amountSaved, 'progress':gProgress});
  }

  

  Future<void> addFriend(String uname, String uemail, String uprogress,
      String name, String email, int progress, String docid) async {
    //doc will create a new uid of Database service
    await userCollection.doc(docid).update({
      'friends': FieldValue.arrayUnion([
        {
          "name": uname,
          "email": uemail,
          "progress": uprogress,
        }
      ]),
    });

    return await userCollection.doc(uid).update({
      'friends': FieldValue.arrayUnion([
        {
          "name": name,
          "email": email,
          "progress": progress,
        }
      ]),
    });
  }

  Future<void> createFriendRequest(
    String name,
    String email,
    int progress,
  ) async {
    //doc will create a new uid of Database service
    return await userCollection
        .doc(uid)
        .collection('friendrequest')
        .doc()
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
      friends: data['friends'],
      persona: data['persona'],
    );
  }

//Create a SINGLE user stream
  //stream qui récupre le user courant donc
  // besoin de doc(uid)
  Stream<MyUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
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
        friends: (doc.data() as dynamic)['friends'] ?? 0,
        persona: (doc.data() as dynamic)['persona'] ?? {},
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

  List<GoalsData> _goalsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return GoalsData(
        goalsid: doc.id,
        progress: (doc.data() as dynamic)['progress'] ?? 0,
        amountSaved: (doc.data() as dynamic)['amountSaved'] ?? 0,
        amountToSave: (doc.data() as dynamic)['amountToSave'] ?? 0,
        name: (doc.data() as dynamic)['name'] ?? '',
        grecords: (doc.data() as dynamic)['grecords'] ?? [],
      );
    }).toList();
  }

  Stream<List<GoalsData>> get goals {
    final CollectionReference<Map<String, dynamic>> goalsdetailsCollection =
        goalsCollection.doc(uid).collection("goalsdetails");

    return goalsdetailsCollection.snapshots().map(_goalsListFromSnapshot);
  }

  List<AccountsData> _accountsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AccountsData(
        accountid: doc.id,
        name: (doc.data() as dynamic)['name'] ?? '',
        amount: (doc.data() as dynamic)['amount'] ?? 0,
        arecords: (doc.data() as dynamic)['arecords'] ?? [],
      );
    }).toList();
  }

  Stream<List<AccountsData>> get accounts {
    final CollectionReference<Map<String, dynamic>> accountsdetailsCollection =
        accountsCollection.doc(uid).collection("accountsdetails");
    return accountsdetailsCollection.snapshots().map(_accountsListFromSnapshot);
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

  List<FriendData> _friendsRequestListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FriendData(
        name: (doc.data() as dynamic)['name'] ?? '',
        email: (doc.data() as dynamic)['email'] ?? '',
        progress: (doc.data() as dynamic)['progress'] ?? 0,
      );
    }).toList();
  }

  Stream<List<FriendData>> get friendRequest {
    final CollectionReference<Map<String, dynamic>> friendRequestCollection =
        userCollection.doc(uid).collection("friendrequest");

    return friendRequestCollection
        .snapshots()
        .map(_friendsRequestListFromSnapshot);
  }
}
