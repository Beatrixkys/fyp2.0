import 'package:flutter/material.dart';
import 'package:fyp2/screens/components/cards.dart';
import 'package:fyp2/services/models/persona.dart';

class PersonaCardList extends StatefulWidget {
  const PersonaCardList({Key? key}) : super(key: key);

  @override
  State<PersonaCardList> createState() => _PersonaCardListState();
}

class _PersonaCardListState extends State<PersonaCardList> {
  @override
  Widget build(BuildContext context) {
    List<PersonaData> personas = [
      PersonaData(
          icon: "assets/owl.png",
          personaname: "Owl",
          personaDescription: "Consistency driven"),
      PersonaData(
          icon: "assets/eagle.png",
          personaname: "Eagle",
          personaDescription: "Amount Based"),
      PersonaData(
          icon: "assets/pigeon.png",
          personaname: "Pigeon",
          personaDescription: "Percentage Based"),
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: personas.length,
      itemBuilder: (context, index) {
        return PersonaCard(persona: personas[index]);
      },
    );
  }
}
