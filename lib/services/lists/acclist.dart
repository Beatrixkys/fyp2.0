import 'package:flutter/material.dart';
import 'package:fyp2/services/database.dart';
import 'package:fyp2/services/logic.dart';
import 'package:fyp2/services/validator.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../screens/components/cards.dart';
import '../../screens/components/round_components.dart';
import '../models/finance.dart';

class AccountList extends StatefulWidget {
  final String uid;
  const AccountList({Key? key, required this.uid}) : super(key: key);

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<List<AccountsData>>(context);

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        return AccountsTile(account: accounts[index], uid: widget.uid);
      },
    );
  }
}

class AccountsTile extends StatelessWidget {
  const AccountsTile({Key? key, required this.account, required this.uid})
      : super(key: key);

  final AccountsData account;
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
              child: AccountSettingsForm(
                account: account,
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
            backgroundImage: AssetImage('assets/finance.png'),
          ),
          title: Text(
            account.name,
            style: kTitleTextStyle,
          ),
          subtitle: Text('RM ${account.amount}'),
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
                    await DatabaseService(uid).deleteAccount(account.accountid);
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

class AccountSettingsForm extends StatefulWidget {
  const AccountSettingsForm({
    Key? key,
    required this.account,
    required this.uid,
  }) : super(key: key);

  final AccountsData account;
  final String uid;

  @override
  State<AccountSettingsForm> createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  final val = Validator();

  @override
  Widget build(BuildContext context) {
    String name = widget.account.name;
    String amount = widget.account.amount.toString();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Edit Account',
            style: kHeadingTextStyle,
          ),
          space,
          const Text(
            'Account Name',
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
            'Account Amount ',
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
    return StreamBuilder<IncomeExpenseData>(
        stream: DatabaseService(widget.uid).incomeExpense,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var ieData = snapshot.data!;
            return SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  var accamount = 0;
                  var accname = '';
                  if (amountController.text == '') {
                    accamount = widget.account.amount;
                  } else {
                    accamount = int.parse(amountController.text);
                  }

                  if (nameController.text == '') {
                    accname = widget.account.name;
                  } else {
                    accname = nameController.text;
                  }

                  //total old//old
                  var updatedIncome = LogicService().newAmount(
                      ieData.income, widget.account.amount, accamount);

                  await DatabaseService(widget.uid).editAccount(accname,
                      accamount, updatedIncome, widget.account.accountid);

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

class AccountCardList extends StatefulWidget {
  const AccountCardList({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountCardList> createState() => _AccountCardListState();
}

class _AccountCardListState extends State<AccountCardList> {
  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<List<AccountsData>>(context);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        return AccountsCard(
          account: accounts[index],
        );
      },
    );
  }
}
