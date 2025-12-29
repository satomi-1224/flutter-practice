import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_app/features/profile/models/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/infra/api/api_client.dart';

part 'profile_api_client.g.dart';

@RestApi()
abstract class ProfileApiClient {
  factory ProfileApiClient(Dio dio, {String baseUrl}) = _ProfileApiClient;

  @GET('/profile')
  Future<UserProfile> fetchProfile();

  @PUT('/profile')
  Future<UserProfile> updateProfile(@Body() UserProfile profile);
}

@Riverpod(keepAlive: true)
ProfileApiClient profileApiClient(Ref ref) {
  return ProfileApiClient(ref.read(dioProvider));
}
