

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextStyle {

  final BuildContext context;

  AppTextStyle(this.context);

  TextStyle get headerText {
    return const TextStyle(fontSize: 14, color: Colors.white);
  }

  TextStyle get searchBarText {
    return TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9));
  }

  TextStyle get darkBoldText {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4a4a4a));
  }

  TextStyle get sortType {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF1967d2));
  }

  TextStyle get countText {
    return const TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xFF4a4a4a));
  }

  TextStyle get packageNormalText {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF4a4a4a));
  }

  TextStyle get packTitle {
    return const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF0175c2));
  }

  TextStyle get score {
    return const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color(0xFF0175c2));
  }

  TextStyle get percent {
    return const TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xFF0175c2));
  }
}