


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pub_dev_crawler/theme/app_text_style.dart';

class PackagesPageHeader extends StatelessWidget {
  const PackagesPageHeader({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var textStyle = AppTextStyle(context);
    return Container(
      color: const Color(0xFF1c2834),
      padding: const EdgeInsets.symmetric(vertical: 10,),
      child: Row(children: [
        const SizedBox(width: 35,),
        Image.network('https://pub.dev/static/img/pub-dev-logo-2x.png?hash=umitaheu8hl7gd3mineshk2koqfngugi',
        height: 32,),
        const Spacer(),
        Text('Sign in', style: textStyle.headerText,),
        const SizedBox(width: 25,),
        Row(
          children: [
            Text('Help', style: textStyle.headerText,),
            const SizedBox(width: 1,),
            const Icon(Icons.keyboard_arrow_down_outlined, size: 20, color: Colors.grey,),
          ],
        ),
        const SizedBox(width: 45,),
      ],),
    );
  }

}