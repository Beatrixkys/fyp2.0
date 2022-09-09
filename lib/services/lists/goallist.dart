import 'package:flutter/material.dart';
import 'package:fyp2/services/validator.dart';

import '../../constant.dart';
import '../../screens/components/cards.dart';
import '../../screens/components/round_components.dart';
import '../models/goals.dart';

class GoalList extends StatefulWidget {
  const GoalList({Key? key}) : super(key: key);

  @override
  State<GoalList> createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  @override
  Widget build(BuildContext context) {
    List<GoalsData> goals = [
      GoalsData(
          goalsid: '1',
          progress: 10,
          name: 'Save',
          amountSaved: 50,
          amountToSave: 500,
          grecords: [
            {"amount": 50, "type": "Bank"}
          ]),
    ];

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return GoalsTile(goal: goals[index]);
      },
    );
  }
}

class GoalsTile extends StatelessWidget {
  const GoalsTile({Key? key, required this.goal}) : super(key: key);

  final GoalsData goal;

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
              child: GoalSettingsForm(
                gid: goal.goalsid,
                gtitle: goal.name,
                gamount: goal.amountToSave,
              ),
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircularProgressIndicator(
            value: (goal.progress / 100).toDouble(),
          ),
          title: Text(goal.name),
          subtitle: Text('${goal.amountSaved} of ${goal.amountToSave} saved '),
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

class GoalSettingsForm extends StatefulWidget {
  const GoalSettingsForm({
    Key? key,
    //required this.uid,

    required this.gid,
    required this.gtitle,
    required this.gamount,
    //required this.genddate
  }) : super(key: key);

  //final String uid;
  final String gid;
  final String gtitle;
  final int gamount;
  //final Timestamp genddate;
  @override
  State<GoalSettingsForm> createState() => _GoalSettingsFormState();
}

class _GoalSettingsFormState extends State<GoalSettingsForm> {
//Form
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  final val = Validator();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dropdowntitlevalue = widget.gtitle;
    String amount = (widget.gamount).toString();
    //DateTime? _dateTime = (widget.genddate).toDate();

    //mock database
    List<String> goalTitle = ['Save', 'Reduce'];
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Edit Goal',
                style: kHeadingTextStyle,
              ),
              space,

              const Text(
                'Goal Title',
                style: kSubTextStyle,
              ),
              smallSpace,

              DropdownButtonFormField(
                value: dropdowntitlevalue,
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdowntitlevalue = newValue!;
                  });
                },
                items: goalTitle.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              space,

              //Goal Amount
              RoundDoubleTextField(
                controller: amountController,
                title: "Goal Percentage",
                onSaved: (String? value) {
                  amount != value;
                },
                validator: val.nameVal,
              ),

              space,

              space,

              //save button
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    /*if (_formKey.currentState!.validate()) {
                      int amount = int.parse(amountController.value.text);

                      var target = dropdowntargetvalue;
                      var title = dropdowntitlevalue;
                      Timestamp enddate = Timestamp.fromDate(_dateTime!);

                      DatabaseService(widget.uid).updateGoal(
                        widget.gid,
                        amount,
                        target,
                        title,
                        enddate,
                      );
                    }*/
                    Navigator.pushNamed(context, "/managegoals");
                  },
                  style: kButtonStyle,
                  child: const Text(
                    'Update',
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

class GoalCardList extends StatefulWidget {
  const GoalCardList({Key? key}) : super(key: key);

  @override
  State<GoalCardList> createState() => _GoalCardListState();
}

class _GoalCardListState extends State<GoalCardList> {
  @override
  Widget build(BuildContext context) {
     List<GoalsData> goals = [
      GoalsData(
          goalsid: '1',
          progress: 10,
          name: 'Save',
          amountSaved: 50,
          amountToSave: 500,
          grecords: [
            {"amount": 50, "type": "Bank"}
          ]),
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return GoalCard(goal: goals[index]);
      },
    );
  }
}
