import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundTextField extends StatelessWidget {
  final String title;
  final bool isPassword;
  final Function(String?) onSaved;
  final FormFieldValidator validator;
  final TextEditingController controller;

  const RoundTextField(
      {Key? key,
      required this.controller,
      required this.title,
      required this.isPassword,
      required this.onSaved,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 300,
      child: TextFormField(
        obscureText: isPassword ? true : false,
        decoration: InputDecoration(
          hintText: title,
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: title,
        ),
        onSaved: onSaved,
        controller: controller,
        validator: validator,
      ),
    );
  }
}

class RoundDoubleTextField extends StatelessWidget {
  final String title;
  final Function(String?) onSaved;
  final FormFieldValidator validator;
  final TextEditingController controller;

  const RoundDoubleTextField(
      {Key? key,
      required this.controller,
      required this.title,
      required this.onSaved,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      alignment: Alignment.center,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: title,
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: title,
        ),
        onSaved: onSaved,
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }
}
