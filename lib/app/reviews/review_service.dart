// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:in_app_review/in_app_review.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'review_service.g.dart';

// class ReviewService {
// final InAppReview _inAppReview = InAppReview.instance;

// Future<void> requestReview() async {
//   try {
//     if (await _inAppReview.isAvailable()) {
//       await _inAppReview.requestReview();
//     }
//   } catch (e) {
//     // Silent fail - reviews aren't critical
//   }
// }
//
// Future<void> openStoreListing() async {
//   try {
//     await _inAppReview.openStoreListing(
//       appStoreId: dotenv.get('APPLE_APP_ID'),
//     );
//   } catch (e) {
//     // Handle error or provide fallback
//   }
// }
// }
//
// @riverpod
// ReviewService reviewService(Ref ref) {
//   return ReviewService();
// }
