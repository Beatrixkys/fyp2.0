import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp2/screens/components/header.dart';
import 'package:fyp2/services/logic.dart';
import 'package:fyp2/services/models/records.dart';
import 'package:fyp2/services/validator.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../services/database.dart';
import '../services/lists/acclist.dart';
import '../services/lists/reclist.dart';
import '../services/models/finance.dart';
import '../services/models/goals.dart';
import 'components/buttons.dart';
import 'components/cards.dart';
import 'components/drawer.dart';
import 'components/round_components.dart';
import 'components/theme_button.dart';
import 'congrats_screen.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    final User? user = auth.currentUser;
    final uid = user!.uid;

    return MultiProvider(
        providers: [
          StreamProvider<List<AccountsData>>.value(
              value: DatabaseService(uid).accounts, initialData: const []),
          StreamProvider<IncomeExpenseData>.value(
            value: DatabaseService(uid).incomeExpense,
            initialData: IncomeExpenseData(expense: 0, income: 0),
          ),
          StreamProvider<List<RecordsData>>.value(
              value: DatabaseService(uid).records, initialData: const []),
        ],
        builder: (context, snapshot) {
          return Scaffold(
            drawer: const NavDrawer(),
            appBar: AppBar(
              elevation: 0.0,
              actions: const [ChangeThemeButton()],
            ),
            body: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  MyHeader(
                      height: MediaQuery.of(context).size.height * 0.24,
                      color: Theme.of(context).colorScheme.primary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Finances',
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
                                                ManageFinance(uid: uid)));
                                  },
                                  child: const ButtonCenterText(
                                    title: "Manage",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AssetCard(uid: uid),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        space,
                        const TitleCard(
                          title: "Overview of the Month",
                          route: "/goals",
                          button: "See More",
                        ),
                        IECards(uid: uid),
                        space,
                        const TitleCard(
                            title: "Accounts", route: "/finance", button: ""),
                        space,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 160,
                          child: const AccountCardList(),
                        ),
                        space,
                        const TitleCard(
                            title: "Records", route: "/finance", button: ""),
                        space,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 300,
                          child: RecordList(
                            uid: uid,
                          ),
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

class ManageFinance extends StatefulWidget {
  final String uid;
  const ManageFinance({Key? key, required this.uid}) : super(key: key);

  @override
  State<ManageFinance> createState() => _ManageFinanceState();
}

class _ManageFinanceState extends State<ManageFinance> {
  void _popUp() {
    showDialog(
        context: context,
        builder: (context) {
          return AddAccount(uid: widget.uid);
        });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<List<AccountsData>>.value(
              value: DatabaseService(widget.uid).accounts,
              initialData: const []),
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
                    height: MediaQuery.of(context).size.height * 0.24,
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      children: const [
                        Spacer(),
                        Text(
                          'Manage Accounts',
                          style: kHeadingTextStyle,
                        ),
                        Spacer(),
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
                            height: 400,
                            child: AccountList(
                                uid: widget.uid) /*const RecordList()*/),
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

class AddAccount extends StatefulWidget {
  final String uid;
  const AddAccount({Key? key, required this.uid}) : super(key: key);

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  bool accountState = false;
  final val = Validator();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = "";
    String amount = "";

    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Add Account',
                style: kHeadingTextStyle,
              ),
              space,
              RoundTextField(
                  controller: nameController,
                  title: "Name",
                  isPassword: false,
                  onSaved: (String? value) {
                    name != value;
                  },
                  validator: val.nameVal),

              space,
              RoundDoubleTextField(
                  controller: amountController,
                  title: "Amount",
                  onSaved: (String? value) {
                    amount != value;
                  },
                  validator: val.nameVal),
              space,
              //send values into the widget
              _saveBtn(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveBtn() {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: () async {
          var name = nameController.value.text;
          int amount = int.parse(amountController.value.text);
          await DatabaseService(widget.uid).saveAccount(name, amount);

          if (!mounted) return;
          Navigator.pop(context);
        },
        style: kButtonStyle,
        child: Text(
          'Save',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
      ),
    );
  }
}

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({Key? key}) : super(key: key);

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
//initial values

  String name = "";
  String accid = "";

  String goal = "";
  String goalid = "";
  int goalamountToSave = 0;
  int goalamountSaved = 0;
  String _amount = "0";

  bool goalRecState = false;

  void toggleView() {
    setState(() {
      goalRecState = !goalRecState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user!.uid;

    return MultiProvider(
        providers: [
          StreamProvider<List<AccountsData>>.value(
              value: DatabaseService(uid).accounts, initialData: const []),
          StreamProvider<List<GoalsData>>.value(
            value: DatabaseService(uid).goals,
            initialData: const [],
          ),
        ],
        builder: (context, snapshot) {
          return Container(
            color: Theme.of(context).colorScheme.primary,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  //insert dropdown
                  Row(children: [
                    const Spacer(),
                    _accBtn(uid),
                    if (goalRecState) _goalBtn(uid),
                    const Spacer()
                  ]),

                  space,
                  const Text(
                    "Add Record",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "RM $_amount",
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  space,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.4,
                      children: setKeyboard(),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: goalRecState
                          ? _goalRecordButtons(uid)
                          : _ieRecordButtons(uid)),
                  const Spacer()
                ],
              ),
            ),
          );
        });
  }

  Widget _accDialog(uid) {
    Stream<List<AccountsData>> accounts = DatabaseService(uid).accounts;

    return StreamBuilder<List<AccountsData>>(
        stream: accounts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var accountData = snapshot.data!;

            return Dialog(
              child: Column(
                children: [
                  const Spacer(),
                  const Text('Choose Account:', style: kHeadingTextStyle),
                  space,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20.0),
                      itemCount: accountData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context, accountData[index]);
                              },
                              style: kButtonStyle,
                              child: Text(
                                accountData[index].name,
                                style: kTitleTextStyle,
                              )),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _goalDialog(uid) {
    Stream<List<GoalsData>> goals = DatabaseService(uid).goals;

    return StreamBuilder<List<GoalsData>>(
        stream: goals,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var goalData = snapshot.data!;

            return Dialog(
              child: Column(
                children: [
                  const Spacer(),
                  const Text('Choose Goal:', style: kHeadingTextStyle),
                  space,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20.0),
                      itemCount: goalData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context, goalData[index]);
                              },
                              style: kButtonStyle,
                              child: Text(
                                goalData[index].name,
                                style: kTitleTextStyle,
                              )),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  //Selection Buttons

  Widget _accBtn(uid) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () async {
          var accval = await showDialog(
              context: context,
              builder: (context) {
                return _accDialog(uid);
              });

          setState(() {
            name = accval.name;
            accid = accval.accountid;
          });

          print(name);
        },
        child: Text(
          name == "" ? 'Choose Account' : 'Acc: $name',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ),
      ),
    );
  }

  Widget _goalBtn(uid) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () async {
          GoalsData goalval = await showDialog(
              context: context,
              builder: (context) {
                return _goalDialog(uid);
              });

          setState(() {
            goal = goalval.name;
            goalid = goalval.goalsid;
            goalamountToSave = goalval.amountToSave;
            goalamountSaved = goalval.amountSaved;
          });

          print(goalid);
        },
        style: kButtonStyle,
        child: Text(
          goal == "" ? 'Choose Goal' : 'Goal: $goal',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ),
      ),
    );
  }

//Record Buttons
  Widget _ieRecordButtons(uid) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: () {
            int amount = int.parse(_amount);
            //TODO! Income Records Adding Function

            DatabaseService(uid).addARecord(amount, accid, name);
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        FloatingActionButton(
          onPressed: () async {
            //TODO! Expense Records Adding Function
            int amount = int.parse(_amount);
            await DatabaseService(uid).subtractARecord(amount, accid, name);
          },
          child: const Icon(Icons.remove),
        ),
        FloatingActionButton(
          onPressed: () => toggleView(),
          child: const Icon(Icons.gps_fixed),
        ),
      ],
    );
  }

  Widget _goalRecordButtons(uid) {
    List<BadgesData> goals = [
      BadgesData(
          goalsid: '1',
          amountToSave: 0,
          amountSaved: 0,
          name: "GOAL",
          progress: 0),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: () => toggleView(),
          child: const Icon(Icons.attach_money),
        ),
        StreamBuilder<TotalGoalsData>(
            stream: DatabaseService(uid).totalGoalsData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var totalGoalData = snapshot.data!;
                return FloatingActionButton(
                  onPressed: () async {
                    int amount = int.parse(_amount);
                    int newAmount = goalamountSaved + amount;

                    int newProgress = (LogicService()
                            .goalProgress(newAmount, goalamountToSave))
                        .toInt();

                    int newTotalProgress = (LogicService().goalProgress(
                            newAmount, totalGoalData.totalAmountToSave))
                        .toInt();

                    if (newProgress == 100) {
                      //TODO! Delete from Goals, add to Badges, push goal to new Page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CongratScreen(goals: goals[0])));
                    } else {
                      await DatabaseService(uid).addGRecord(
                        amount,
                        name,
                        goalid,
                        accid,
                        goal,
                        newProgress,
                        newTotalProgress,
                      );
                    }
                  },
                  child: const Icon(Icons.add),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ],
    );
  }

//Calculator Buttons
  Widget _numberBtn(String number) {
    return TextButton(
      child: Text(
        number,
        style: const TextStyle(fontSize: 40, color: Colors.white),
      ),
      onPressed: () {
        setState(() {
          if (_amount == "0") {
            _amount = number;
          } else if (_amount.length == 15) {
            _amount = _amount;
            HapticFeedback.heavyImpact();
          } else {
            _amount += number;
          }
        });
      },
    );
  }

  Widget _deleteBtn() {
    return TextButton(
      child: const Text(
        "<",
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
      onPressed: () {
        setState(() {
          if (_amount.length <= 1) {
            _amount = "0";
          } else {
            _amount = _amount.substring(0, _amount.length - 1);
          }
        });
      },
    );
  }

  setKeyboard() {
    List<Widget> keyboard = [];

    // numbers 1-9
    List.generate(9, (index) {
      keyboard.add(_numberBtn("${index + 1}"));
    });

    keyboard.add(_numberBtn("."));
    keyboard.add(_numberBtn("0"));
    keyboard.add(_deleteBtn());

    return keyboard;
  }
}
