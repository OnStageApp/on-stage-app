import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StgLoadingIndicator extends StatelessWidget {
  const StgLoadingIndicator({
    super.key,
    this.size = 24,
  });
  final double size;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CupertinoActivityIndicator(
            radius: size / 2,
          ),
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }
  }
}
