import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/onstage_icon_blue.svg',
        height: 53,
        width: 57,
        fit: BoxFit.fill,
      ),
    );
  }
}
