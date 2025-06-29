import 'package:flutter/material.dart';
Widget btnCal({
  required String text,
  required Function() event,
  Color c=Colors.black
})
=> MaterialButton(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  onPressed: event,
  color: c,
  child: Text(text,
    style: const TextStyle(fontSize: 30,color: Colors.white,fontFamily: 'font1',fontStyle: FontStyle.italic),
  ),
);
