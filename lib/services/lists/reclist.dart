import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../screens/components/round_components.dart';
import '../database.dart';
import '../models/records.dart';
import '../validator.dart';

class RecordList extends StatefulWidget {
  final String uid;
  const RecordList({Key? key, required this.uid}) : super(key: key);

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  @override
  Widget build(BuildContext context) {
    final records = Provider.of<List<RecordsData>>(context);
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: records.length,
      itemBuilder: (context, index) {
        return RecordsTile(record: records[index], uid: widget.uid);
      },
    );
  }
}

class RecordsTile extends StatelessWidget {
  const RecordsTile(
      {Key? key, required this.record, required this.uid //required this.uid
      })
      : super(key: key);

  final RecordsData record;
  final String uid;

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
                record: record,
                uid: uid,
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
            'RM ${record.amount}',
            style: kTitleTextStyle,
          ),
          subtitle: Text(record.type),
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
                  onPressed: () async {
                    await DatabaseService(uid).deleteRecord(record.recordid);
                  },
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
  const RecordSettingsForm({
    Key? key,
    required this.record,
    required this.uid,
  }) : super(key: key);

  final RecordsData record;
  final String uid;

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
    String type = widget.record.type;
    String amount = widget.record.amount.toString();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Edit Record',
            style: kHeadingTextStyle,
          ),
          space,
          const Text(
            'Record Name',
            style: kSubTextStyle,
          ),
          RoundTextField(
              controller: nameController,
              title: type,
              isPassword: false,
              onSaved: (String? value) {
                type != value;
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
          space,
          saveBtn(),
        ],
      ),
    );
  }

  Widget saveBtn() {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: () async {
          var recamount = 0;
          var recname = '';
          if (amountController.text == '') {
            recamount = widget.record.amount;
          } else {
            recamount = int.parse(amountController.text);
          }

          if (nameController.text == '') {
            recname = widget.record.type;
          } else {
            recname = nameController.text;
          }

          //total old//old

          await DatabaseService(widget.uid)
              .updateRecord(recname, recamount, widget.record.recordid);

          if (!mounted) return;
          Navigator.pop(context);
        },
        style: kButtonStyle,
        child: const Text(
          'Save',
          style: kButtonTextStyle,
        ),
      ),
    );
  }
}
