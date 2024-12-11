import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        context.isDarkMode
            ? 'assets/icons/logo-onstage-white.svg'
            : 'assets/icons/onstage_icon_blue.svg',
        height: 53,
        width: 57,
        fit: BoxFit.fill,
      ),
    );
  }
}
