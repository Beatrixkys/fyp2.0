class GoalsData {
  final String goalsid;
  final int amount;
  final String target;
  final String title;
  final int progress;
  //final Timestamp enddate;

  GoalsData(
      {required this.goalsid,
      required this.amount,
      required this.target,
      required this.title,
      required this.progress,
      //required this.enddate,
      
      });
}

class RecordsData {
  final String recordid;
  final String name;
  final int amount;
  final String accname;
  final String recordtype;
  final String recordcategory;

  RecordsData(
      {required this.recordid,
      required this.name,
      required this.amount,
      required this.accname,
      required this.recordtype,
      required this.recordcategory});
}

