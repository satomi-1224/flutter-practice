import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_app/features/profile/models/user_profile.dart';
import 'package:flutter_app/features/profile/infra/profile_repository.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserProfile> build() {
    return ref.read(profileRepositoryProvider).fetchProfile();
  }

  Future<void> updateProfile({required String name, required String email}) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    state = const AsyncValue.loading();
    try {
      final newProfile = currentProfile.copyWith(name: name, email: email);
      await ref.read(profileRepositoryProvider).updateProfile(newProfile);
      
      // 更新後の値をセット
      state = AsyncValue.data(newProfile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
