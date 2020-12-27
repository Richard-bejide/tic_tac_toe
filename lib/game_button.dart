import 'package:flutter/material.dart';

class GameButton {
  final int id;
  String text;
  Color bg;
  bool enabled;

  GameButton({@required this.id,
   this.text = "",
   this.bg = Colors.grey,
   this.enabled= true});
}
