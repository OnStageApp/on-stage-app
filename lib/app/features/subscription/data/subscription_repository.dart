import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/subscription/domain/subscription.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'subscription_repository.g.dart';

@RestApi()
abstract class SubscriptionRepository {
  factory SubscriptionRepository(Dio dio) = _SubscriptionRepository;

  @POST(API.intentSecret)
  Future<String> getIntentUserSecret();

  @GET(API.currentSubscription)
  Future<Subscription> getCurrentSubscription();

  @PUT(API.currentSubscription)
  Future<Subscription> updateSubscription(@Body() Subscription subscription);
}
