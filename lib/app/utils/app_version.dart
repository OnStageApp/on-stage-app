import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  static Future<String> getVersionNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  static Future<String> getFullVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }
}

class VersionDisplay extends StatelessWidget {
  const VersionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: AppVersion.getFullVersion(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            'Version ${snapshot.data}',
            style: context.textTheme.labelSmall!
                .copyWith(color: context.colorScheme.outline),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
