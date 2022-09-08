import 'package:flutter/material.dart';
import 'package:fyp2/constant.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final String progress;
  final double percent;

  const ProgressBar({
    Key? key,
    required this.percent,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: MediaQuery.of(context).size.width * 0.95,
      lineHeight: MediaQuery.of(context).size.height * 0.05,
      percent: percent, //calculate and pass in passed on goal progress
      center: Text(progress, style: kSubTextStyle),
      backgroundColor: Theme.of(context).primaryColor,
      progressColor: Theme.of(context).colorScheme.primary,
      barRadius: const Radius.circular(40),
    );
  }
}
