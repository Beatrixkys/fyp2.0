import 'package:flutter/material.dart';
import 'package:fyp2/services/validator.dart';

import '../../constant.dart';
import '../../screens/components/cards.dart';
import '../../screens/components/round_components.dart';
import '../models/finance.dart';

class AccountList extends StatefulWidget {
  const AccountList({Key? key}) : super(key: key);

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    List<AccountsData> accounts = [
      AccountsData(name: "Bank", amount: 50, accountid: '1', arecords: [
        {'amount': 50, 'type': "income"}
      ]),
      AccountsData(name: "Cash", amount: 50, accountid: '2', arecords: [
        {'amount': 50, 'type': "income"}
      ]),
    ];

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        return AccountsTile(account: accounts[index]);
      },
    );
  }
}

class AccountsTile extends StatelessWidget {
  const AccountsTile({Key? key, required this.account}) : super(key: key);

  final AccountsData account;

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
                aid: account.accountid,
                aname: account.name,
                aamount: account.amount,
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

class AccountSettingsForm extends StatefulWidget {
  const AccountSettingsForm(
      {Key? key, required this.aid, required this.aname, required this.aamount})
      : super(key: key);

  final String aid;
  final String aname;
  final int aamount;

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
    String name = widget.aname;
    String amount = widget.aamount.toString();
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
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () async {
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
    );
  }
}

class AccountCardList extends StatefulWidget {
  const AccountCardList({Key? key}) : super(key: key);

  @override
  State<AccountCardList> createState() => _AccountCardListState();
}

class _AccountCardListState extends State<AccountCardList> {
  @override
  Widget build(BuildContext context) {
    List<AccountsData> accounts = [
      AccountsData(name: "Bank", amount: 50, accountid: '1', arecords: [
        {'amount': 50, 'type': "income"}
      ]),
      AccountsData(name: "Cash", amount: 50, accountid: '2', arecords: [
        {'amount': 50, 'type': "income"}
      ]),
    ];
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
