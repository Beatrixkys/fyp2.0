import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screens/components/cards.dart';

import '../constant.dart';
import '../services/models/goals.dart';
import 'components/theme_button.dart';

class CongratScreen extends StatefulWidget {
  final BadgesData goals;
  const CongratScreen({Key? key, required this.goals}) : super(key: key);

  @override
  State<CongratScreen> createState() => _CongratScreenState();
}

class _CongratScreenState extends State<CongratScreen> {
  final confettiController = ConfettiController();

  @override
  void initState() {
    super.initState();
    confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          appBar: AppBar(
            actions: const [ChangeThemeButton()],
          ),
          body: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).colorScheme.tertiary,
            child: Center(
                child: Column(
              children: [
                const Spacer(),
                const Text(
                  "You Have Achieved Your Goal!",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Nunito',
                  ),
                ),
                space,
                BadgeCard(goal: widget.goals),
                space,
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/home");
                    },
                    style: kButtonStyle,
                    child: Text(
                      'Go to Home',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            )),
          ),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          shouldLoop: false,
          maxBlastForce: 50,
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 50,
        )
      ],
    );
  }
}
