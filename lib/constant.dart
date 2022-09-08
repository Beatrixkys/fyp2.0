import 'package:flutter/material.dart';

///Text styles
const kHeadingTextStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w700,
  fontFamily: 'Nunito',
);

const kTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  fontFamily: 'Nunito',
);

const kSubTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
);

const kButtonTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 20,);

final kButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
  fixedSize: MaterialStateProperty.all(const Size.fromWidth(450)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0),
    ),
  ),
);

const space = SizedBox(height: 20);

const smallSpace = SizedBox(height: 10);
