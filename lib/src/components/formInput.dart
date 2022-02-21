import 'package:flutter/material.dart';

class FormDesignInput extends StatelessWidget {
  FormDesignInput({
    this.hintText,
    this.field,
    this.icon,
    this.obsecureText = false,
    this.fieldController,
  });

  String? hintText;
  TextInputType? field;
  Icon? icon;
  bool? obsecureText;
  TextEditingController? fieldController;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(),
      child: TextFormField(
        controller: fieldController,
        obscureText: obsecureText!,
        validator: (value) {
          if (value!.isEmpty) {
            return "${hintText} is required";
          }
        },
        keyboardType: field,
        decoration: InputDecoration(
          focusColor: Colors.blue,
          hintText: hintText,
          prefixIcon: icon,
        ),
      ),
    );
  }
}
