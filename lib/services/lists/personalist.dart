import 'package:flutter/material.dart';
import 'package:fyp2/screens/components/cards.dart';
import 'package:fyp2/services/models/persona.dart';

class PersonaCardList extends StatefulWidget {
  final String uid;
  final bool newUser;
  const PersonaCardList({Key? key, required this.uid, required this.newUser}) : super(key: key);

  @override
  State<PersonaCardList> createState() => _PersonaCardListState();
}

class _PersonaCardListState extends State<PersonaCardList> {
  @override
  Widget build(BuildContext context) {
    List<PersonaData> personas = [
      PersonaData(
          icon: "assets/owl.png",
          pname: "Owl",
          pdescription: "Consistency driven"),
      PersonaData(
          icon: "assets/eagle.png",
          pname: "Eagle",
          pdescription: "Amount Based"),
      PersonaData(
          icon: "assets/pigeon.png",
          pname: "Pigeon",
          pdescription: "Percentage Based"),
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: personas.length,
      itemBuilder: (context, index) {
        return PersonaCard(persona: personas[index], uid: widget.uid, newUser: widget.newUser,);
      },
    );
  }
}
