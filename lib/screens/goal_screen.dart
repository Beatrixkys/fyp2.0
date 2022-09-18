import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/services/validator.dart';
import 'package:provider/provider.dart';
import '../constant.dart';
import '../services/database.dart';
import '../services/lists/goallist.dart';
import '../services/logic.dart';
import '../services/models/goals.dart';
import '../services/models/user.dart';
import 'components/buttons.dart';
import 'components/cards.dart';
import 'components/drawer.dart';
import 'components/header.dart';
import 'components/progress_bar.dart';
import 'components/round_components.dart';
import 'components/theme_button.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final controller = ScrollController();

    final User? user = auth.currentUser;
    final uid = user!.uid;

    Stream<MyUserData> myUserData = DatabaseService(uid).user;

    return MultiProvider(
        providers: [
          StreamProvider<List<GoalsData>>.value(
              value: DatabaseService(uid).goals, initialData: const []),
          StreamProvider<List<BadgesData>>.value(
              value: DatabaseService(uid).badges, initialData: const []),
          StreamProvider<MyUserData>.value(
            value: DatabaseService(uid).user,
            initialData:
                MyUserData(uid: uid, name: '', email: 'email', progress: 0),
          ),
        ],
        builder: (context, snapshot) {
          return Scaffold(
            drawer: const NavDrawer(),
            appBar: AppBar(
              elevation: 0,
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ManageGoal(uid: uid)));
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
                        ProgressBar(myUserData: myUserData),
                        space,
                        const TitleCard(
                          title: "Overview of Goals",
                          route: "/goals",
                          button: "See More",
                        ),
                        space,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: const GoalCardList(),
                        ),
                        space,
                        const TitleCard(
                          title: "Goals Achieved",
                          route: "/goals",
                          button: "See More",
                        ),
                        space,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: const BadgeCardList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class ManageGoal extends StatefulWidget {
  final String uid;
  const ManageGoal({Key? key, required this.uid}) : super(key: key);

  @override
  State<ManageGoal> createState() => _ManageGoalState();
}

class _ManageGoalState extends State<ManageGoal> {
  void _popUp() {
    showDialog(
        context: context,
        builder: (context) {
          return AddGoal(uid: widget.uid);
        });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<List<GoalsData>>.value(
              value: DatabaseService(widget.uid).goals, initialData: const []),
        ],
        builder: (context, snapshot) {
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
                          children: [
                            const Text('Existing Data',
                                style: kHeadingTextStyle),
                            const Spacer(),
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                onPressed: () => _popUp(),
                                child: Center(
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        space,
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.69,
                            child: GoalList(
                              uid: widget.uid,
                            )),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          );
        });
  }
}

class AddGoal extends StatefulWidget {
  final String uid;
  const AddGoal({Key? key, required this.uid}) : super(key: key);

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  double currentsliderval = 0;
  String dropdowngoalnamevalue = 'Car';
  double monthlysavings = 0;
//Form
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  final val = Validator();

  bool suggestedState = true;

  void toggleView() {
    setState(() {
      suggestedState = !suggestedState;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //form intialisaion
    String amount = "0";
    String name = "";

    return Dialog(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Spacer(),
            const Text(
              'Add Goals',
              style: kHeadingTextStyle,
            ),
            space,
            Row(
              children: [
                const Spacer(),
                const Text(
                  'Switch:',
                  style: kTitleTextStyle,
                ),
                const Spacer(),
                _toggleBtn(),
                const Spacer(),
              ],
            ),
            space,
            const Divider(
              thickness: 2.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    space,
                    const Text(
                      'Goal Name',
                      style: kSubTextStyle,
                    ),
                    space,

                    suggestedState
                        ? _dropDownFormField(name)
                        : _formTextField(name),

                    space,

                    //Goal Amount
                    RoundDoubleTextField(
                      controller: amountController,
                      title: "Goal Amount To Save",
                      onSaved: (String? value) {
                        amount != value;
                      },
                      validator: val.amountVal,
                    ),

                    space,

                    if (amountController.text != "") _goalPrediction(),
                    //save button
                    _saveBtn(widget.uid),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _goalPrediction() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).colorScheme.tertiary,
      child: Column(
        children: [
          Text(
            "Save  $monthlysavings Monthly",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              fontFamily: 'Nunito',
            ),
          ),
          Text(
            "To Achieve ${amountController.text} In:",
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'Nunito',
            ),
          ),
          space,
          Text(
            " $currentsliderval Months",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nunito',
            ),
          ),
          Slider(
              value: currentsliderval,
              max: 180,
              divisions: 60,
              label: currentsliderval.round().toString(),
              onChanged: (double value) {
                setState(() {
                  currentsliderval = value;
                  monthlysavings = LogicService()
                      .goalToSave(amountController.text, currentsliderval);
                });
              }),
        ],
      ),
    );
  }

  Widget _toggleBtn() {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () => toggleView(),
        child: Center(
          child: Text(
            suggestedState ? "Suggested" : " Custom ",
            style: kButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _formTextField(String name) {
    return RoundTextField(
        controller: nameController,
        title: "Name",
        isPassword: false,
        onSaved: (String? value) {
          name != value;
        },
        validator: val.nameVal);
  }

  Widget _dropDownFormField(String name) {
    var accounts = ['Car', 'Vacation', 'House', 'Wedding'];

    return DropdownButtonFormField(
      value: dropdowngoalnamevalue,
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      onChanged: (String? newValue) {
        setState(() {
          dropdowngoalnamevalue = newValue!;
        });
      },
      items: accounts.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _saveBtn(String uid) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            int amount = int.parse(amountController.value.text);

            var name = suggestedState
                ? dropdowngoalnamevalue
                : nameController.value.text;

            int amountSaved = 0;
            int progress = 0;

            await DatabaseService(uid)
                .saveGoal(amount, name, amountSaved, progress);

            if (!mounted) return;
            Navigator.pop(context);
          }
        },
        style: kButtonStyle,
        child: Text(
          "Save",
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
      ),
    );
  }

  //Widget for Real Time
}
