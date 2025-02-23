import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'amazon_s3_repository.g.dart';

@RestApi()
abstract class AmazonS3Repository {
  factory AmazonS3Repository(Dio dio) = _AmazonS3Repository;

  @GET('{path}')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getUserPhotoFromS3(@Path('path') String path);

    @GET('{path}')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDocument(@Path('path') String path);
}
