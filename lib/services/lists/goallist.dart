import 'package:flutter/material.dart';
import 'package:fyp2/services/validator.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../screens/components/cards.dart';
import '../../screens/components/round_components.dart';
import '../database.dart';
import '../logic.dart';
import '../models/goals.dart';

class GoalList extends StatefulWidget {
  final String uid;
  const GoalList({Key? key, required this.uid}) : super(key: key);

  @override
  State<GoalList> createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<List<GoalsData>>(context);

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return GoalsTile(goal: goals[index], uid: widget.uid);
      },
    );
  }
}

class GoalsTile extends StatelessWidget {
  const GoalsTile({Key? key, required this.goal, required this.uid})
      : super(key: key);

  final GoalsData goal;
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
              child: GoalSettingsForm(
                goal: goal,
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
                  onPressed: () async {
                    await DatabaseService(uid).deleteGoal(goal.goalsid);
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

class GoalSettingsForm extends StatefulWidget {
  const GoalSettingsForm({
    Key? key,
    required this.uid,
    required this.goal,
    //required this.genddate
  }) : super(key: key);

  final GoalsData goal;
  final String uid;
  //final Timestamp genddate;
  @override
  State<GoalSettingsForm> createState() => _GoalSettingsFormState();
}

class _GoalSettingsFormState extends State<GoalSettingsForm> {
//Form
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  final amountSavedController = TextEditingController();

  final val = Validator();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    amountSavedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.goal.name;
    String amount = (widget.goal.amountToSave).toString();
    String amountSaved = (widget.goal.amountSaved).toString();
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
                'Name',
                style: kSubTextStyle,
              ),
              smallSpace,
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
                'Amount To Save',
                style: kSubTextStyle,
              ),
              smallSpace,
              //Goal Amount
              RoundDoubleTextField(
                controller: amountController,
                title: amount,
                onSaved: (String? value) {
                  amount != value;
                },
                validator: val.nameVal,
              ),

              space,
              const Text(
                'Amount Saved',
                style: kSubTextStyle,
              ),
              smallSpace,
              RoundDoubleTextField(
                controller: amountSavedController,
                title: amountSaved,
                onSaved: (String? value) {
                  amountSaved != value;
                },
                validator: val.nameVal,
              ),
              space,
              //save button
              saveBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget saveBtn() {
    return StreamBuilder<TotalGoalsData>(
        stream: DatabaseService(widget.uid).totalGoalsData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var totalGoalData = snapshot.data!;
            return SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  var goalamountToSave = 0;
                  var goalamountSaved = 0;
                  var goalname = '';

                  if (amountController.text == '') {
                    goalamountToSave = widget.goal.amountToSave;
                  } else {
                    goalamountToSave = int.parse(amountController.text);
                  }

                  if (amountSavedController.text == '') {
                    goalamountSaved = widget.goal.amountToSave;
                  } else {
                    goalamountSaved = int.parse(amountSavedController.text);
                  }

                  if (nameController.text == '') {
                    goalname = widget.goal.name;
                  } else {
                    goalname = nameController.text;
                  }

                  //total old//old
                  var updatedTATS = LogicService().newAmount(
                      totalGoalData.totalAmountToSave,
                      widget.goal.amountToSave,
                      goalamountToSave);

                  var updatedTAS = LogicService().newAmount(
                      totalGoalData.totalAmountSaved,
                      widget.goal.amountSaved,
                      goalamountSaved);

                  var updatedProgress = LogicService()
                      .goalProgress(goalamountSaved, goalamountToSave)
                      .toInt();

                  var updatedTotalProgress = LogicService()
                      .goalProgress(updatedTAS, updatedTATS)
                      .toInt();

                  await DatabaseService(widget.uid).updateGoal(
                      widget.goal.goalsid,
                      goalamountToSave,
                      goalamountSaved,
                      goalname,
                      updatedProgress,
                      updatedTATS,
                      updatedTAS,
                      updatedTotalProgress);

                  if (!mounted) return;
                  Navigator.pushNamed(context, '/finance');
                },
                style: kButtonStyle,
                child: const Text(
                  'Save',
                  style: kButtonTextStyle,
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
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
    final goals = Provider.of<List<GoalsData>>(context);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return GoalCard(goal: goals[index]);
      },
    );
  }
}

class BadgeCardList extends StatefulWidget {
  const BadgeCardList({Key? key}) : super(key: key);

  @override
  State<BadgeCardList> createState() => _BadgeCardListState();
}

class _BadgeCardListState extends State<BadgeCardList> {
  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<List<BadgesData>>(context);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return BadgeCard(goal: goals[index]);
      },
    );
  }
}
