/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/user-friends.svg
  String get userFriends => 'assets/icons/user-friends.svg';

  /// List of all assets
  List<String> get values => [userFriends];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/band1.png
  AssetGenImage get band1 => const AssetGenImage('assets/images/band1.png');

  /// File path: assets/images/band2.png
  AssetGenImage get band2 => const AssetGenImage('assets/images/band2.png');

  /// File path: assets/images/band3.png
  AssetGenImage get band3 => const AssetGenImage('assets/images/band3.png');

  /// File path: assets/images/event_tile_background.png
  AssetGenImage get eventTileBackground =>
      const AssetGenImage('assets/images/event_tile_background.png');

  /// File path: assets/images/ic_launcher.png
  AssetGenImage get icLauncher =>
      const AssetGenImage('assets/images/ic_launcher.png');

  /// File path: assets/images/onstageapp_logo.png
  AssetGenImage get onstageappLogo =>
      const AssetGenImage('assets/images/onstageapp_logo.png');

  /// File path: assets/images/pattern_1.png
  AssetGenImage get pattern1 =>
      const AssetGenImage('assets/images/pattern_1.png');

  /// File path: assets/images/profile1.png
  AssetGenImage get profile1 =>
      const AssetGenImage('assets/images/profile1.png');

  /// File path: assets/images/profile2.png
  AssetGenImage get profile2 =>
      const AssetGenImage('assets/images/profile2.png');

  /// File path: assets/images/profile4.png
  AssetGenImage get profile4 =>
      const AssetGenImage('assets/images/profile4.png');

  /// File path: assets/images/profile5.png
  AssetGenImage get profile5 =>
      const AssetGenImage('assets/images/profile5.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        band1,
        band2,
        band3,
        eventTileBackground,
        icLauncher,
        onstageappLogo,
        pattern1,
        profile1,
        profile2,
        profile4,
        profile5
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
