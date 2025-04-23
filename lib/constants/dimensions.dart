import 'package:flutter/material.dart';

double scaleHeight(double inputHeight, BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  return (inputHeight / 812.0) * screenHeight; // 812 is default iPhone 11 screen height
}

double scaleWidth(double inputWidth, BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  return (inputWidth / 375.0) * screenWidth; // 375 is default iPhone 11 screen width
}
