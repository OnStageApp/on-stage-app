import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePhotoViewer extends StatelessWidget {
  const ProfilePhotoViewer({
    required this.name,
    this.imageBytes,
    super.key,
  });

  final String name;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // Centered photo
          Center(
            child: Hero(
              tag: 'profile-photo-$name',
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: imageBytes != null
                      ? DecorationImage(
                          image: MemoryImage(imageBytes!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: imageBytes == null
                    ? Center(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      )
                    : null,
              ),
            ),
          ),

          // Close button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String name,
    Uint8List? imageBytes,
  }) async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    await Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return ProfilePhotoViewer(
            imageBytes: imageBytes,
            name: name,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );

    if (context.mounted) {
      SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      );
    }
  }
}
