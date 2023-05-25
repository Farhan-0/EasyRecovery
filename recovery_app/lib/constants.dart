import 'package:flutter/material.dart';

const myPrimaryColor = Colors.purple;
const mySecondaryColor = Colors.blue;
const myTextColor = Color(0xFF3C4046);
// const myBackgroundColor = Color.fromARGB(232, 255, 255, 255);
final myBackgroundColor = Colors.grey[200];
// final myBackgroundColor = Colors.white70;
const double myDefaultPadding = 16.0;
final myGrey = Colors.grey.shade400;
final List<BoxShadow> myBoxShadow = [
  // bottom right Shadow is darker
  BoxShadow(
    color: Colors.grey.shade400,
    offset: const Offset(5, 5),
    blurRadius: 4,
    spreadRadius: 1,
  ),
  // top left shadow is lighter
  const BoxShadow(
    color: Colors.white,
    offset: Offset(-5, -5),
    blurRadius: 4,
    spreadRadius: 1,
  )
];
