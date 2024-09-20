import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_repository.dart';
import 'package:on_stage_app/app/features/team/application/team_state.dart';
import 'package:on_stage_app/app/shared/data/dio_s3_client/dio_s3_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'amazon_s3_notifier.g.dart';

@riverpod
class AmazonS3Notifier extends _$AmazonS3Notifier {
  late final AmazonS3Repository _s3Repository;

  @override
  void build() {
    final dioS3 = ref.read(dioS3Provider);

    _s3Repository = AmazonS3Repository(dioS3);
  }

  Future<Uint8List?> getPhotoFromAWS(String preSignedUrl) async {
    try {
      final photoBytes = await _s3Repository.getUserPhotoFromS3(preSignedUrl);

      if (photoBytes.isNotEmpty) {
        final photo = Uint8List.fromList(photoBytes);
        return photo;
      } else {
        logger.e('Failed to fetch image. Status code: 500');
        return null;
      }
    } catch (e) {
      logger.e('Error fetching image: $e');
      return null;
    }
  }
}
