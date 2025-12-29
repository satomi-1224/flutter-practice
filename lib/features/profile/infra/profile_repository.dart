import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_app/config/env.dart';
import 'package:flutter_app/features/profile/models/user_profile.dart';
import 'package:flutter_app/features/profile/infra/profile_api_client.dart';

part 'profile_repository.g.dart';

abstract class ProfileRepository {
  Future<UserProfile> fetchProfile();
  Future<void> updateProfile(UserProfile profile);
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  if (Env.useMock) {
    return MockProfileRepository();
  } else {
    return ProfileRepositoryImpl(ref.read(profileApiClientProvider));
  }
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiClient _api;
  ProfileRepositoryImpl(this._api);

  @override
  Future<UserProfile> fetchProfile() => _api.fetchProfile();

  @override
  Future<void> updateProfile(UserProfile profile) => _api.updateProfile(profile);
}

class MockProfileRepository implements ProfileRepository {
  UserProfile _profile = const UserProfile(id: 1, name: 'Satomi', email: 'satomi@example.com');

  @override
  Future<UserProfile> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _profile;
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    await Future.delayed(const Duration(seconds: 1));
    _profile = profile;
    print('MOCK: Updated profile to ${profile.name}');
  }
}
