import 'package:cloud_firestore/cloud_firestore.dart';

class GoalsData {
  final String goalsid;
  final int amountSaved;
  final int amountToSave;
  final String name;
  final int progress;
  final List grecords;

  GoalsData({
    required this.goalsid,
    required this.amountToSave,
    required this.amountSaved,
    required this.name,
    required this.progress,
    required this.grecords,
  });
}
