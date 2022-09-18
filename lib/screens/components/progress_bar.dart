import 'package:flutter/material.dart';
import 'package:fyp2/constant.dart';
import 'package:fyp2/services/models/user.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final Stream<MyUserData> myUserData;

  const ProgressBar({
    Key? key,
    required this.myUserData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyUserData>(
        stream: myUserData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data;
            var value = userData!.progress;
            return LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.95,
              lineHeight: MediaQuery.of(context).size.height * 0.05,
              percent:
                  value / 100, //calculate and pass in passed on goal progress
              center: Text("$value %", style: kSubTextStyle),
              backgroundColor: Theme.of(context).primaryColor,
              progressColor: Theme.of(context).colorScheme.primary,
              barRadius: const Radius.circular(40),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
