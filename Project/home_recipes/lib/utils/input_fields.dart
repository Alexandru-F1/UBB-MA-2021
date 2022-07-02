import 'package:flutter/material.dart';
import 'package:home_recipes/utils/utils.dart';

class InputFields {
  static Widget inputField(
    String name,
    String hintName,
    TextInputType textInputType,
    TextEditingController myController,
    String initialText,
  ) {
    if (myController.text == "") {
      myController.text = initialText;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          name,
          style: const TextStyle(color: Colors.black, fontSize: 15),
        ),
        const SizedBox(
          height: 3,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Utilitys.greyGreen,
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              const BoxShadow(color: Colors.black12, blurRadius: 6.0, offset: Offset(0, 2)),
            ],
          ),
          height: 40.0,
          child: TextField(
            controller: myController,
            keyboardType: textInputType,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: -6, left: 15),
              hintText: hintName,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
