import 'package:flutter/material.dart';
import 'package:fyp2/services/models/persona.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../constant.dart';
import '../../services/models/finance.dart';
import '../../services/models/goals.dart';

class TitleCard extends StatelessWidget {
  final String title;
  final String route;
  final String button;

  const TitleCard(
      {Key? key,
      required this.title,
      required this.route,
      required this.button})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kTitleTextStyle,
          ),
          const Spacer(),
          TextButton(
            child: Text(
              button,
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, route);
            },
          ),
        ],
      ),
    );
  }
}

class AccountsCard extends StatelessWidget {
  final AccountsData account;

  const AccountsCard({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 130,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: <Widget>[
          Image.asset("assets/bank.png", height: 90),
          Text(
            account.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            ('RM ${account.amount}'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final String title;
  final String amount;

  const ExpenseCard({Key? key, required this.title, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.47,
      height: MediaQuery.of(context).size.height * 0.2,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              title,
              style: kSubTextStyle,
            ),
            const Text("RM", style: kTitleTextStyle),
            Text(
              amount,
              style: kHeadingTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final GoalsData goal;
  //final String uid;

  const GoalCard({
    Key? key,
    required this.goal,
    //required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.3,

        //height: 250,
        //width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: const Color(0xFFE5E5E5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircularPercentIndicator(
                animation: true,
                radius: 65.0,
                percent: (goal.progress / 100).toDouble(),
                lineWidth: 10.0,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white10,
                progressColor: Theme.of(context).colorScheme.tertiary,
                center: Text(
                  '${goal.progress}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
              ),
            ),
            Text(
              goal.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${goal.progress}% of ${goal.target}',
            ),
          ],
        ),
      ),
    );
  }
}

class PersonaCard extends StatelessWidget {
  final PersonaData persona;

  const PersonaCard({
    Key? key,
    required this.persona,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, //update database details
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.32,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              //blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Image.asset(persona.icon, height: 110),
            Text(
              persona.personaname,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
