import 'package:flutter/material.dart';

Widget textFormField(
    TextEditingController textEditingController,
    String label,
    String hint,
    IconData iconData,
    String initalValue,
    TextInputType textInputType) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) return hint;
      },
      controller: textEditingController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData),
        hintText: hint,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: textInputType,
    ),
  );
}
