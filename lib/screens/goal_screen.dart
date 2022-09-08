import 'package:flutter/material.dart';
import 'package:fyp2/services/validator.dart';
import 'package:intl/intl.dart';
import '../constant.dart';
import '../services/lists/goallist.dart';
import 'components/buttons.dart';
import 'components/cards.dart';
import 'components/drawer.dart';
import 'components/header.dart';
import 'components/progress_bar.dart';
import 'components/round_components.dart';
import 'components/theme_button.dart';

class GoalScreen extends StatelessWidget {
  final String uid;
  const GoalScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        actions: const [ChangeThemeButton()],
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            MyHeader(
                height: MediaQuery.of(context).size.height * 0.2,
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Goals',
                          textAlign: TextAlign.start,
                          style: kHeadingTextStyle,
                        ),
                        const Spacer(),
                        NavigationButton(
                          widget: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/managegoals");
                            },
                            child: const ButtonCenterText(
                              title: "Manage",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  space,
                  const ProgressBar(percent: 0.8, progress: "80%"),
                  space,
                  const TitleCard(
                    title: "Overview of Goals",
                    route: "/goals",
                    button: "See More",
                  ),
                  space,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const GoalCardList(),
                  ),
                  space,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ManageGoal extends StatefulWidget {
  const ManageGoal({Key? key}) : super(key: key);

  @override
  State<ManageGoal> createState() => _ManageGoalState();
}

class _ManageGoalState extends State<ManageGoal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: const [ChangeThemeButton()],
      ),
      body: SafeArea(
        child: Column(
          children: [
            MyHeader(
              height: MediaQuery.of(context).size.height * 0.15,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    'Manage Goals',
                    style: kHeadingTextStyle,
                  ),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('Existing Data', style: kHeadingTextStyle),
                      Spacer(),
                      SmallButton(title: 'Add', route: '/addgoal'),
                    ],
                  ),
                  space,
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.69,
                      child: const GoalList()),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class AddGoal extends StatefulWidget {
  const AddGoal({Key? key}) : super(key: key);

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  String dropdowntitlevalue = 'Save';
  String dropdowntargetvalue = 'Income';
//Form
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  final val = Validator();

  DateTime? _dateTime;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String amount = "0";

    //mock database
    List<String> goalTitle = ['Save', 'Reduce'];
    List<String> goalTarget = ['Income', 'Expense'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: const [ChangeThemeButton()],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyHeader(
                height: MediaQuery.of(context).size.height * 0.2,
                color: Theme.of(context).colorScheme.primary,
                child: const Center(
                  child: Text(
                    'Add Goals',
                    style: kHeadingTextStyle,
                  ),
                ),
              ),
              Expanded(
                  child: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      space,
                      const Text(
                        'Goal Title',
                        style: kSubTextStyle,
                      ),
                      space,

                      //Use Provider to display list from DB 

                      DropdownButtonFormField(
                        value: dropdowntitlevalue,
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdowntitlevalue = newValue!;
                          });
                        },
                        items: goalTitle
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                      space,
                      const Text(
                        'Goal Target',
                        style: kSubTextStyle,
                      ),

                      DropdownButtonFormField(
                        value: dropdowntargetvalue,
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdowntargetvalue = newValue!;
                          });
                        },
                        items: goalTarget
                            .map<DropdownMenuItem<String>>((String value) {
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

                      //TIME
                      const Text(
                        'Choose End Date ',
                        style: kSubTextStyle,
                      ),

                      TextButton.icon(
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2222));

                          if (newDate == null) return;

                          setState(() => _dateTime = newDate);
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_dateTime == null
                            ? 'Choose A Date'
                            : DateFormat('dd/MM/yyyy')
                                .format(_dateTime!)
                                .toString()),
                      ),

                      space,

                      //save button
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: kButtonStyle,
                          child: Text(
                            'Save',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
