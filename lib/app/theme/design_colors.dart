import 'package:flutter/material.dart';

@immutable
class DesignColors extends ThemeExtension<DesignColors> {
  const DesignColors({
    this.cloud10,
    this.cloud20,
    this.cloud30,
    this.cloud40,
    this.cloud80,
    this.link,
    this.indigo,
    this.statusNeutral,
    this.statusErrorRed,
    this.statusErrorRedBg,
    this.statusErrorRed10,
    this.statusSuccessGreen,
    this.universalBlack20,
    this.universalBlack50,
    this.universalBlack60,
    this.universalBlack70,
    this.universalBlack80,
    this.universalBlack100,
    this.essentialsBlack,
    this.universalWhite,
    this.successGreen50,
    this.successDark,
    this.successLight,
    this.greyBackground,
    this.greyscale50,
    this.greyscale100,
    this.greyscale200,
    this.greyscale400,
    this.greyscale500,
    this.greyscale700,
    this.greyscale800,
    this.greyscale900,
    this.orangeLight200,
    this.orangeLight900,
    this.orangeDark900,
    this.blueLight200,
    this.blueLight900,
    this.blueDark900,
    this.purpleLight200,
    this.purpleLight700,
    this.purpleLight900,
    this.purpleDark900,
    this.warningLight,
    this.warningDark,
    this.infoDark,
    this.greenLight200,
    this.greenLight900,
    this.greenDark900,
    this.linkBlue,
    this.errorLight,
    this.errorDark,
    this.essentialsBlack50,
    this.essentialsWhite,
    this.infoLight,
  });
  final Color? cloud10;
  final Color? cloud20;
  final Color? cloud30;
  final Color? cloud40;
  final Color? cloud80;
  final Color? link;
  final Color? indigo;
  final Color? statusNeutral;
  final Color? statusErrorRed;
  final Color? statusErrorRedBg;
  final Color? statusErrorRed10;
  final Color? statusSuccessGreen;
  final Color? universalBlack20;
  final Color? universalBlack50;
  final Color? universalBlack60;
  final Color? universalBlack70;
  final Color? universalBlack80;
  final Color? universalBlack100;
  final Color? essentialsBlack;
  final Color? universalWhite;
  final Color? successGreen50;
  final Color? successDark;
  final Color? successLight;
  final Color? greyBackground;
  final Color? greyscale50;
  final Color? greyscale100;
  final Color? greyscale200;
  final Color? greyscale400;
  final Color? greyscale500;
  final Color? greyscale700;
  final Color? greyscale800;
  final Color? greyscale900;
  final Color? orangeLight200;
  final Color? orangeLight900;
  final Color? orangeDark900;
  final Color? blueLight200;
  final Color? blueLight900;
  final Color? blueDark900;
  final Color? purpleLight200;
  final Color? purpleLight700;
  final Color? purpleLight900;
  final Color? purpleDark900;
  final Color? warningLight;
  final Color? warningDark;
  final Color? infoDark;
  final Color? greenLight200;
  final Color? greenLight900;
  final Color? greenDark900;
  final Color? errorLight;
  final Color? errorDark;
  final Color? linkBlue;
  final Color? essentialsBlack50;
  final Color? essentialsWhite;
  final Color? infoLight;

  @override
  DesignColors copyWith({
    Color? cloud10,
    Color? cloud20,
    Color? cloud30,
    Color? cloud40,
    Color? link,
    Color? indigo,
    Color? statusNeutral,
    Color? statusErrorRed,
    Color? statusErrorRedBg,
    Color? statusErrorRed10,
    Color? statusSuccessGreen,
    Color? universalBlack20,
    Color? universalBlack50,
    Color? universalBlack60,
    Color? universalBlack70,
    Color? universalBlack80,
    Color? universalBlack100,
    Color? essentialsBlack,
    Color? universalWhite,
    Color? successGreen50,
    Color? successLight,
    Color? successDark,
    Color? greyBackground,
    Color? greyscale50,
    Color? greyScale100,
    Color? greyScale200,
    Color? greyscale400,
    Color? greyscale500,
    Color? greyscale700,
    Color? greyscale800,
    Color? orangeLight200,
    Color? orangeLight900,
    Color? orangeDark900,
    Color? blueLight200,
    Color? blueLight900,
    Color? blueDark900,
    Color? purpleLight200,
    Color? purpleLight700,
    Color? purpleLight900,
    Color? purpleDark900,
    Color? warningLight,
    Color? warningDark,
    Color? greenLight200,
    Color? greenLight900,
    Color? greenDark900,
    Color? errorLight,
    Color? errorDark,
    Color? linkBlue,
    Color? infoLight,
    Color? infoDark,
  }) {
    return DesignColors(
      cloud10: cloud10 ?? this.cloud10,
      cloud20: cloud20 ?? this.cloud20,
      cloud30: cloud30 ?? this.cloud30,
      cloud40: cloud40 ?? this.cloud40,
      cloud80: cloud80 ?? cloud80,
      link: link ?? this.link,
      indigo: indigo ?? this.indigo,
      statusNeutral: statusNeutral ?? this.statusNeutral,
      statusErrorRed: statusErrorRed ?? this.statusErrorRed,
      statusErrorRedBg: statusErrorRedBg ?? this.statusErrorRedBg,
      statusErrorRed10: statusErrorRed10 ?? this.statusErrorRed10,
      statusSuccessGreen: statusSuccessGreen ?? this.statusSuccessGreen,
      universalBlack50: universalBlack50 ?? this.universalBlack50,
      universalBlack60: universalBlack60 ?? this.universalBlack60,
      universalBlack70: universalBlack70 ?? this.universalBlack70,
      universalBlack100: universalBlack100 ?? this.universalBlack100,
      essentialsBlack: essentialsBlack ?? this.essentialsBlack,
      universalWhite: universalWhite ?? this.universalWhite,
      successGreen50: successGreen50 ?? this.successGreen50,
      greyBackground: greyBackground ?? this.greyBackground,
      greyscale50: greyscale50 ?? this.greyscale50,
      greyscale100: greyscale100 ?? greyscale100,
      greyscale200: greyscale200 ?? this.greenLight200,
      greyscale400: greyscale400 ?? this.greyscale400,
      greyscale500: greyscale500 ?? this.greyscale500,
      greyscale700: greyscale700 ?? this.greyscale700,
      greyscale800: greyscale800 ?? this.greyscale800,
      orangeLight200: orangeLight200 ?? this.orangeLight200,
      orangeLight900: orangeLight900 ?? this.orangeLight900,
      orangeDark900: orangeDark900 ?? this.orangeDark900,
      blueLight200: blueLight200 ?? this.blueLight200,
      blueLight900: blueLight900 ?? this.blueLight900,
      blueDark900: blueDark900 ?? this.blueDark900,
      purpleLight200: purpleLight200 ?? this.purpleLight200,
      purpleLight700: purpleLight700 ?? this.purpleLight700,
      purpleLight900: purpleLight900 ?? this.purpleLight900,
      purpleDark900: purpleDark900 ?? this.purpleDark900,
      warningLight: warningLight ?? this.warningLight,
      warningDark: warningDark ?? this.warningDark,
      greenLight200: greenLight200 ?? this.greenLight200,
      greenLight900: greenLight900 ?? this.greenLight900,
      greenDark900: greenDark900 ?? this.greenDark900,
      successLight: successLight ?? this.successLight,
      successDark: successDark ?? this.successDark,
      linkBlue: linkBlue ?? this.linkBlue,
      infoLight: infoLight ?? this.infoLight,
      infoDark: infoDark ?? this.infoDark,
    );
  }

  @override
  DesignColors lerp(ThemeExtension<DesignColors>? other, double t) {
    if (other is! DesignColors) {
      return this;
    }

    return DesignColors(
      cloud10: Color.lerp(
        cloud10,
        other.cloud10,
        t,
      ),
      cloud20: Color.lerp(
        cloud20,
        other.cloud20,
        t,
      ),
      cloud30: Color.lerp(
        cloud30,
        other.cloud30,
        t,
      ),
      cloud40: Color.lerp(
        cloud40,
        other.cloud40,
        t,
      ),
      cloud80: Color.lerp(
        cloud80,
        other.cloud80,
        t,
      ),
      link: Color.lerp(
        link,
        other.link,
        t,
      ),
      indigo: Color.lerp(
        indigo,
        other.indigo,
        t,
      ),
      infoDark: Color.lerp(
        infoDark,
        other.infoDark,
        t,
      ),
      statusNeutral: Color.lerp(
        statusNeutral,
        other.statusNeutral,
        t,
      ),
      statusErrorRed: Color.lerp(
        statusErrorRed,
        other.statusErrorRed,
        t,
      ),
      statusErrorRedBg: Color.lerp(
        statusErrorRedBg,
        other.statusErrorRedBg,
        t,
      ),
      statusErrorRed10: Color.lerp(
        statusErrorRed10,
        other.statusErrorRedBg,
        t,
      ),
      statusSuccessGreen: Color.lerp(
        statusSuccessGreen,
        other.statusSuccessGreen,
        t,
      ),
      universalBlack20: Color.lerp(
        universalBlack20,
        other.universalBlack20,
        t,
      ),
      universalBlack50: Color.lerp(
        universalBlack50,
        other.universalBlack50,
        t,
      ),
      universalBlack60: Color.lerp(
        universalBlack60,
        other.universalBlack60,
        t,
      ),
      universalBlack70: Color.lerp(
        universalBlack70,
        other.universalBlack70,
        t,
      ),
      universalBlack80: Color.lerp(
        universalBlack80,
        other.universalBlack80,
        t,
      ),
      universalBlack100: Color.lerp(
        universalBlack100,
        other.universalBlack100,
        t,
      ),
      essentialsBlack: Color.lerp(
        essentialsBlack,
        other.essentialsBlack,
        t,
      ),
      universalWhite: Color.lerp(
        universalWhite,
        other.universalWhite,
        t,
      ),
      successGreen50: Color.lerp(
        successGreen50,
        other.successGreen50,
        t,
      ),
      greyBackground: Color.lerp(
        greyBackground,
        other.greyBackground,
        t,
      ),
      greyscale50: Color.lerp(
        greyscale50,
        other.greyscale50,
        t,
      ),
      greyscale100: Color.lerp(
        greyscale100,
        other.greyscale100,
        t,
      ),
      greyscale200: Color.lerp(
        greyscale200,
        other.greyscale200,
        t,
      ),
      greyscale400: Color.lerp(
        greyscale400,
        other.greyscale400,
        t,
      ),
      greyscale500: Color.lerp(
        greyscale500,
        other.greyscale500,
        t,
      ),
      greyscale700: Color.lerp(
        greyscale700,
        other.greyscale700,
        t,
      ),
      greyscale800: Color.lerp(
        greyscale800,
        other.greyscale800,
        t,
      ),
      orangeLight900: Color.lerp(
        orangeLight900,
        other.orangeLight900,
        t,
      ),
      orangeDark900: Color.lerp(
        orangeDark900,
        other.orangeDark900,
        t,
      ),
      blueLight200: Color.lerp(
        blueLight200,
        other.blueLight200,
        t,
      ),
      blueLight900: Color.lerp(
        blueLight900,
        other.blueLight900,
        t,
      ),
      blueDark900: Color.lerp(
        blueDark900,
        other.blueDark900,
        t,
      ),
      purpleDark900: Color.lerp(
        purpleDark900,
        other.purpleDark900,
        t,
      ),
      purpleLight200: Color.lerp(
        purpleLight200,
        other.purpleLight200,
        t,
      ),
      purpleLight700: Color.lerp(
        purpleLight700,
        other.purpleLight700,
        t,
      ),
      purpleLight900: Color.lerp(
        purpleLight900,
        other.purpleLight900,
        t,
      ),
      warningLight: Color.lerp(
        warningLight,
        other.warningLight,
        t,
      ),
      warningDark: Color.lerp(
        warningDark,
        other.warningDark,
        t,
      ),
      greenLight200: Color.lerp(
        greenLight200,
        other.greenLight200,
        t,
      ),
      greenLight900: Color.lerp(
        greenLight900,
        other.greenLight900,
        t,
      ),
      greenDark900: Color.lerp(
        greenDark900,
        other.greenDark900,
        t,
      ),
      successLight: Color.lerp(
        successLight,
        other.successLight,
        t,
      ),
      successDark: Color.lerp(
        successDark,
        other.successDark,
        t,
      ),
      errorDark: Color.lerp(
        errorDark,
        other.errorDark,
        t,
      ),
      errorLight: Color.lerp(
        errorLight,
        other.errorLight,
        t,
      ),
      linkBlue: Color.lerp(
        linkBlue,
        other.linkBlue,
        t,
      ),
      infoLight: Color.lerp(
        infoLight,
        other.infoLight,
        t,
      ),
    );
  }

  static const light = DesignColors(
    cloud10: Color.fromRGBO(251, 250, 255, 1),
    cloud20: Color.fromRGBO(214, 211, 255, 1),
    cloud30: Color.fromRGBO(191, 188, 232, 1),
    cloud40: Color.fromRGBO(169, 166, 210, 1),
    cloud80: Color.fromRGBO(88, 86, 119, 1),
    link: Color.fromRGBO(123, 97, 255, 1),
    indigo: Color.fromRGBO(116, 12, 249, 1),
    infoDark: Color.fromRGBO(80, 159, 232, 1),
    statusNeutral: Color.fromRGBO(120, 152, 246, 1),
    statusErrorRed: Color.fromRGBO(227, 2, 44, 1),
    statusErrorRedBg: Color.fromRGBO(254, 242, 244, 1),
    statusErrorRed10: Color.fromRGBO(255, 230, 234, 1),
    statusSuccessGreen: Color.fromRGBO(42, 203, 55, 1),
    universalBlack20: Color.fromRGBO(232, 232, 232, 1),
    universalBlack50: Color.fromRGBO(163, 163, 163, 1),
    universalBlack60: Color.fromRGBO(143, 143, 143, 1),
    universalBlack70: Color.fromRGBO(122, 122, 122, 1),
    universalBlack80: Color.fromRGBO(102, 102, 102, 1),
    universalBlack100: Color.fromRGBO(38, 38, 38, 1),
    essentialsBlack: Color.fromRGBO(0, 0, 0, 1),
    universalWhite: Color.fromRGBO(255, 255, 255, 1),
    successGreen50: Color.fromRGBO(12, 135, 22, 1),
    greyBackground: Color.fromRGBO(247, 247, 247, 1),
    greyscale50: Color.fromRGBO(248, 248, 248, 1),
    greyscale100: Color.fromRGBO(243, 243, 243, 1),
    greyscale200: Color.fromRGBO(230, 230, 229, 1),
    greyscale400: Color.fromRGBO(184, 182, 180, 1),
    greyscale500: Color.fromRGBO(143, 141, 138, 1),
    greyscale800: Color.fromRGBO(102, 101, 99, 1),
    orangeLight200: Color.fromRGBO(254, 245, 237, 1),
    greyscale700: Color.fromRGBO(114, 113, 110, 1),
    orangeLight900: Color.fromRGBO(252, 220, 196, 1),
    orangeDark900: Color.fromRGBO(218, 106, 58, 1),
    blueLight200: Color.fromRGBO(236, 249, 245, 1),
    blueLight900: Color.fromRGBO(191, 234, 220, 1),
    blueDark900: Color.fromRGBO(7, 92, 104, 1),
    purpleLight200: Color.fromRGBO(242, 237, 254, 1),
    purpleLight700: Color.fromRGBO(221, 208, 253, 1),
    purpleLight900: Color.fromRGBO(212, 196, 252, 1),
    purpleDark900: Color.fromRGBO(91, 70, 206, 1),
    warningLight: Color.fromRGBO(253, 244, 226, 1),
    warningDark: Color.fromRGBO(222, 153, 78, 1),
    greenLight200: Color.fromRGBO(242, 249, 223, 1),
    greenLight900: Color.fromRGBO(213, 234, 150, 1),
    greenDark900: Color.fromRGBO(83, 161, 64, 1),
    successLight: Color.fromRGBO(227, 245, 237, 1),
    successDark: Color.fromRGBO(85, 163, 124, 1),
    errorLight: Color.fromRGBO(251, 231, 234, 1),
    errorDark: Color.fromRGBO(232, 96, 80, 1),
    linkBlue: Color.fromRGBO(120, 152, 246, 1),
    infoLight: Color.fromRGBO(211, 231, 249, 1),
    essentialsBlack50: Color(0x80000000),
    essentialsWhite: Color(0xFFFFFFFF),
    greyscale900: Color(0xFF595755),
  );

  Color? changeColor(double change) {
    if (change < 0) {
      return errorDark;
    }

    if (change > 0) {
      return successDark;
    }

    return warningDark;
  }
}
