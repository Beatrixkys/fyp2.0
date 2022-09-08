import 'package:flutter/material.dart';
import 'package:fyp2/services/models/goals.dart';
import 'package:fyp2/services/validator.dart';

import '../../constant.dart';
import '../../screens/components/round_components.dart';

class RecordList extends StatefulWidget {
  const RecordList({Key? key}) : super(key: key);

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  @override
  Widget build(BuildContext context) {
    List<RecordsData> records = [
      RecordsData(
          recordid: "1",
          name: "Shopping",
          amount: 50,
          accname: "Bank",
          recordtype: "Income",
          recordcategory: "Shopping"),
      RecordsData(
          recordid: "1",
          name: "Shopping",
          amount: 50,
          accname: "Bank",
          recordtype: "Income",
          recordcategory: "Shopping"),
      RecordsData(
          recordid: "1",
          name: "Shopping",
          amount: 50,
          accname: "Bank",
          recordtype: "Income",
          recordcategory: "Shopping"),
      RecordsData(
          recordid: "1",
          name: "Shopping",
          amount: 50,
          accname: "Bank",
          recordtype: "Income",
          recordcategory: "Shopping"),
    ];

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: records.length,
      itemBuilder: (context, index) {
        return RecordsTile(record: records[index]);
      },
    );
  }
}

class RecordsTile extends StatelessWidget {
  const RecordsTile({
    Key? key,
    required this.record, //required this.uid
  }) : super(key: key);

  final RecordsData record;
  //final String uid;

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 500,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: RecordSettingsForm(
                //uid: uid,
                rid: record.recordid,
                rname: record.name,
                ramount: record.amount,
                rtype: record.recordtype,
                raccname: record.accname,
                rcategory: record.recordcategory,
              ),
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage('assets/cash.png'),
          ),
          title: Text(
            record.name,
            style: kTitleTextStyle,
          ),
          subtitle: Text('RM ${record.amount} of ${record.recordtype} '),
          trailing: SizedBox(
            width: 96,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _showSettingsPanel(),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outlined),
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

class RecordSettingsForm extends StatefulWidget {
  const RecordSettingsForm(
      {Key? key,
      //required this.uid,
      required this.rid,
      required this.rname,
      required this.ramount,
      required this.raccname,
      required this.rcategory,
      required this.rtype})
      : super(key: key);

  //final String uid;
  final String rid;
  final String rname;
  final int ramount;
  final String raccname;
  final String rcategory;
  final String rtype;

  @override
  State<RecordSettingsForm> createState() => _RecordSettingsFormState();
}

class _RecordSettingsFormState extends State<RecordSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  final val = Validator();

  @override
  Widget build(BuildContext context) {
    String name = widget.rname;
    String amount = widget.ramount.toString();
    String dropdownaccvalue = widget.raccname;
    String dropdownreccatvalue = widget.rcategory;
    String dropdownrectypevalue = widget.rtype;

    //mockdb

    var accounts = ['Bank', 'Cash', 'E-Wallet'];
    var record = ['Leisure', 'Work', 'Transport'];
    var recordType = ['Income', 'Expense'];

    return Form(
      key: _formKey,
      child: SizedBox(
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Edit Account',
                style: kHeadingTextStyle,
              ),
              space,
              const Text(
                'Record Name',
                style: kSubTextStyle,
              ),
              RoundTextField(
                  controller: nameController,
                  title: name,
                  isPassword: false,
                  onSaved: (String? value) {
                    name != value;
                  },
                  validator: val.nameVal),
              space,
              const Text(
                'Record Amount ',
                style: kSubTextStyle,
              ),
              RoundDoubleTextField(
                  controller: amountController,
                  title: amount,
                  onSaved: (String? value) {
                    amount != value;
                  },
                  validator: val.nameVal),
              const Text(
                'Records Type',
                style: kSubTextStyle,
              ),
              DropdownButtonFormField(
                value: dropdownrectypevalue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownrectypevalue = newValue!;
                  });
                },
                items: recordType.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const Text(
                'Accounts Type',
                style: kSubTextStyle,
              ),
              DropdownButtonFormField(
                value: dropdownaccvalue,
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownaccvalue = newValue!;
                  });
                },
                items: accounts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              space,
              const Text(
                'Record Category',
                style: kSubTextStyle,
              ),
              DropdownButtonFormField(
                value: dropdownreccatvalue,
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownreccatvalue = newValue!;
                  });
                },
                items: record.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              space,
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () async {
                    /*
                    if (_formKey.currentState!.validate()) {
                      //setState(() => loading = true);
                      var name = nameController.value.text;
                      int amount = int.parse(amountController.value.text);
                      var recordtype = dropdownrectypevalue;
                      var accname = dropdownaccvalue;
                      var recordcategory = dropdownreccatvalue;

                      await DatabaseService(widget.uid).updateRecord(
                          name,
                          amount,
                          recordtype,
                          recordcategory,
                          accname,
                          widget.rid);
                    }
                    */

                    Navigator.pushNamed(context, '/finance');
                  },
                  style: kButtonStyle,
                  child: const Text(
                    'Save',
                    style: kButtonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
