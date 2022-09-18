import 'package:cloud_firestore/cloud_firestore.dart';

class GoalsData {
  final String goalsid;
  final int amountSaved;
  final int amountToSave;
  final String name;
  final int progress;

  GoalsData({
    required this.goalsid,
    required this.amountToSave,
    required this.amountSaved,
    required this.name,
    required this.progress,
  });
}

class BadgesData {
  final String goalsid;
  final int amountSaved;
  final int amountToSave;
  final String name;
  final int progress;

  BadgesData({
    required this.goalsid,
    required this.amountToSave,
    required this.amountSaved,
    required this.name,
    required this.progress,
  });
}


class TotalGoalsData {
  final int totalAmountSaved;
  final int totalAmountToSave;


  TotalGoalsData({
    required this.totalAmountToSave,
    required this.totalAmountSaved,
  });
}

