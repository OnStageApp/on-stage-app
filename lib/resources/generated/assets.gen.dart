/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/arrow-forward.svg
  SvgGenImage get arrowForward => const SvgGenImage('assets/icons/arrow-forward.svg');

  /// File path: assets/icons/check_icon.svg
  SvgGenImage get checkIcon => const SvgGenImage('assets/icons/check_icon.svg');

  /// File path: assets/icons/close-icon.svg
  SvgGenImage get closeIcon => const SvgGenImage('assets/icons/close-icon.svg');

  /// File path: assets/icons/filled-notification-bell.svg
  SvgGenImage get filledNotificationBell => const SvgGenImage('assets/icons/filled-notification-bell.svg');

  /// File path: assets/icons/heart-filled.svg
  SvgGenImage get heartFilled => const SvgGenImage('assets/icons/heart-filled.svg');

  /// File path: assets/icons/mixer_horizontal.svg
  SvgGenImage get mixerHorizontal => const SvgGenImage('assets/icons/mixer_horizontal.svg');

  /// File path: assets/icons/music_note.svg
  SvgGenImage get musicNote => const SvgGenImage('assets/icons/music_note.svg');

  /// File path: assets/icons/plus.svg
  SvgGenImage get plus => const SvgGenImage('assets/icons/plus.svg');

  /// File path: assets/icons/search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/search.svg');

  /// File path: assets/icons/search_icon.svg
  SvgGenImage get searchIcon => const SvgGenImage('assets/icons/search_icon.svg');

  /// File path: assets/icons/song_structure.svg
  SvgGenImage get songStructure => const SvgGenImage('assets/icons/song_structure.svg');

  /// File path: assets/icons/user-friends.svg
  SvgGenImage get userFriends => const SvgGenImage('assets/icons/user-friends.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        arrowForward,
        checkIcon,
        closeIcon,
        filledNotificationBell,
        heartFilled,
        mixerHorizontal,
        musicNote,
        plus,
        search,
        searchIcon,
        songStructure,
        userFriends
      ];
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
  AssetGenImage get eventTileBackground => const AssetGenImage('assets/images/event_tile_background.png');

  /// File path: assets/images/ic_launcher.png
  AssetGenImage get icLauncher => const AssetGenImage('assets/images/ic_launcher.png');

  /// File path: assets/images/no_events_image.svg
  SvgGenImage get noEventsImage => const SvgGenImage('assets/images/no_events_image.svg');

  /// File path: assets/images/onstageapp_logo.png
  AssetGenImage get onstageappLogo => const AssetGenImage('assets/images/onstageapp_logo.png');

  /// File path: assets/images/pattern_1.png
  AssetGenImage get pattern1 => const AssetGenImage('assets/images/pattern_1.png');

  /// File path: assets/images/profile1.png
  AssetGenImage get profile1 => const AssetGenImage('assets/images/profile1.png');

  /// File path: assets/images/profile2.png
  AssetGenImage get profile2 => const AssetGenImage('assets/images/profile2.png');

  /// File path: assets/images/profile4.png
  AssetGenImage get profile4 => const AssetGenImage('assets/images/profile4.png');

  /// File path: assets/images/profile5.png
  AssetGenImage get profile5 => const AssetGenImage('assets/images/profile5.png');

  /// List of all assets
  List<dynamic> get values =>
      [band1, band2, band3, eventTileBackground, icLauncher, noEventsImage, onstageappLogo, pattern1, profile1, profile2, profile4, profile5];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

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

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final BytesLoader loader;
    if (_isVecFormat) {
      loader = AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ?? (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
