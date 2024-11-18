import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/network_permission_notifier.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/shared/data/enums/error_type.dart';
import 'package:on_stage_app/app/shared/data/error_model/permission_error_model.dart';
import 'package:on_stage_app/logger.dart';

class PermissionInterceptor extends Interceptor {
  PermissionInterceptor(this.ref);

  final Ref ref;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null && err.response?.data != null) {
      try {
        final errorData = err.response!.data as Map<String, dynamic>;

        if (errorData['errorName'] == ErrorType.PERMISSION_DENIED.name) {
          final errorResponse = PermissionErrorResponse.fromJson(errorData);
          ref.read(networkPermissionProvider.notifier).permissionDenied(
                errorResponse.param ?? PermissionType.none,
              );
        }
      } catch (e) {
        logger.e('Failed to parse permission denied error: $e');
      }
    }

    return handler.next(err);
  }
}
