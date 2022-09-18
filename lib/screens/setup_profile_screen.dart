import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/services/lists/personalist.dart';
import 'package:fyp2/services/validator.dart';

import '../constant.dart';
import '../services/database.dart';
import 'components/header.dart';
import 'components/loading.dart';
import 'components/round_components.dart';

class SetUpProfileAndAccountsScreen extends StatefulWidget {
  const SetUpProfileAndAccountsScreen({Key? key}) : super(key: key);

  @override
  State<SetUpProfileAndAccountsScreen> createState() =>
      _SetUpProfileAndAccountsScreenState();
}

class _SetUpProfileAndAccountsScreenState
    extends State<SetUpProfileAndAccountsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //push data into firebase here

//Form
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  bool loading = false;

  final val = Validator();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    //visuals
    double width = MediaQuery.of(context).size.width;

    String name = "";
    String amount = "";

    return loading
        ? const Loading()
        : Scaffold(
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    MyHeader(
                      height: MediaQuery.of(context).size.height * 0.1,
                      color: Theme.of(context).colorScheme.secondary,
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            'Set Up and Profile and Accounts',
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
                          const Text(
                            'Choose Persona',
                            style: kTitleTextStyle,
                          ),
                          space,
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: width,
                            child: PersonaCardList(
                              uid: uid,
                              newUser: true,
                            ),
                          ),
                          space,
                          SizedBox(
                            width: 300,
                            child: Row(
                              children: [
                                const Spacer(),
                                const Text(
                                  'Add Accounts',
                                  style: kTitleTextStyle,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => loading = true);
                                        var name = nameController.value.text;
                                        int amount = int.parse(
                                            amountController.value.text);

                                        await DatabaseService(uid)
                                            .saveAccount(name, amount);

                                        //TODO! call pop up to show feedback

                                        nameController.clear();
                                        amountController.clear();
                                      }
                                    },
                                    icon: const Icon(Icons.add_circle_outline)),
                                const Spacer(),
                              ],
                            ),
                          ),
                          space,
                          RoundTextField(
                              controller: nameController,
                              isPassword: false,
                              title: "Accounts Name",
                              onSaved: (String? value) {
                                name != value;
                              },
                              validator: val.nameVal),
                          space,
                          RoundDoubleTextField(
                              controller: amountController,
                              title: "Accounts Amount",
                              onSaved: (String? value) {
                                amount != value;
                              },
                              validator: val.amountVal),
                          space,
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  var name = nameController.value.text;
                                  int amount =
                                      int.parse(amountController.value.text);

                                  await DatabaseService(uid)
                                      .saveAccount(name, amount);
                                }
                                if (!mounted) return;
                                Navigator.pushNamed(context, '/home');
                              },
                              style: kButtonStyle,
                              child: const Text(
                                'Next',
                                style: kButtonTextStyle,
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
