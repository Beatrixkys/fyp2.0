import 'package:flutter/material.dart';
import 'package:fyp2/screens/components/header.dart';
import 'package:fyp2/services/validator.dart';

import '../constant.dart';
import '../services/lists/acclist.dart';
import '../services/lists/reclist.dart';
import 'components/buttons.dart';
import 'components/cards.dart';
import 'components/drawer.dart';
import 'components/round_components.dart';
import 'components/theme_button.dart';

class FinanceScreen extends StatefulWidget {
  final String uid;

  const FinanceScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
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
                              Navigator.pushNamed(context, "/managefinance");
                            },
                            child: const ButtonCenterText(
                              title: "Manage",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Total Assets: RM 15000',
                      textAlign: TextAlign.start,
                      style: kSubTextStyle,
                    ),
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
                  Row(
                    children: const [
                      ExpenseCard(title: "Income", amount: "5000"),
                      ExpenseCard(title: "Expense", amount: "5000"),
                    ],
                  ),
                  space,
                  const TitleCard(
                      title: "Accounts",
                      route: "/managefinance",
                      button: "Manage"),
                  space,
                  const SizedBox(
                    width: 350,
                    height: 160,
                    child: AccountCardList(),
                  ),
                  space,
                  const TitleCard(
                      title: "Transactions",
                      route: "/managefinance",
                      button: "Manage"),
                  space,
                  /*
                  const SizedBox(
                    width: 400,
                    height: 300,
                    child: RecordList(),
                  ),
                  */
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ManageFinance extends StatefulWidget {
  const ManageFinance({Key? key}) : super(key: key);

  @override
  State<ManageFinance> createState() => _ManageFinanceState();
}

class _ManageFinanceState extends State<ManageFinance> {
  bool accounts = false;

  void toggleView() {
    setState(() {
      accounts = !accounts;
    });
  }

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
              height: MediaQuery.of(context).size.height * 0.24,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Manage Finances',
                    style: kHeadingTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                        width: 120,
                        child: Text(
                          "Change View:",
                          style: kSubTextStyle,
                        ),
                      ),
                      NavigationButton(
                        widget: TextButton(
                          onPressed: () => toggleView(),
                          child: ButtonCenterText(
                            title: accounts ? "Accounts" : "Records ",
                          ),
                        ),
                      ),
                    ],
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
                      SmallButton(title: 'Add', route: '/addfinance'),
                    ],
                  ),
                  space,
                  SizedBox(
                      height: 400,
                      child:
                          accounts ? const AccountList() : const AccountList()/*const RecordList()*/),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class AddFinance extends StatefulWidget {
  const AddFinance({Key? key}) : super(key: key);

  @override
  State<AddFinance> createState() => _AddFinanceState();
}

class _AddFinanceState extends State<AddFinance> {
  String dropdownaccvalue = 'Bank';
  String dropdownreccatvalue = 'Leisure';
  String dropdownrectypevalue = 'Income';

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  bool accountState = false;

  void toggleView() {
    setState(() {
      accountState = !accountState;
    });
  }

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

// Mock Database
    var accounts = ['Bank', 'Cash', 'E-Wallet'];
    var record = ['Leisure', 'Work', 'Transport'];
    var recordType = ['Income', 'Expense'];

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
                height: MediaQuery.of(context).size.height * 0.4,
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Add',
                          style: kHeadingTextStyle,
                        ),
                        Column(
                          children: [
                            const Text('Switch:'),
                            NavigationButton(
                              widget: TextButton(
                                onPressed: () => toggleView(),
                                child: ButtonCenterText(
                                  title: accountState ? "Accounts" : "Records ",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    RoundTextField(
                        controller: nameController,
                        title: "Name",
                        isPassword: false,
                        onSaved: (String? value) {
                          name != value;
                        },
                        validator: val.nameVal),
                    const Spacer(),
                    if (!accountState)
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: [
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
                              items: recordType.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            space,
                          ],
                        ),
                      ),

                    //add minus transaction bar
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    space,
                    RoundDoubleTextField(
                        controller: amountController,
                        title: "Amount",
                        onSaved: (String? value) {
                          amount != value;
                        },
                        validator: val.nameVal),
                    space,
                    if (!accountState)
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            const Text(
                              'Accounts Type',
                              style: kSubTextStyle,
                            ),
                            DropdownButtonFormField(
                              value: dropdownaccvalue,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownaccvalue = newValue!;
                                });
                              },
                              items: accounts.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownreccatvalue = newValue!;
                                });
                              },
                              items: record.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    space,
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async {},
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
              )),
            ],
          ),
        ),
      ),
    );
  }
}
