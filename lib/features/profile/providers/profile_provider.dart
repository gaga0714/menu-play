import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_providers.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/profile_repository.dart';

class ProfileNotifier extends StateNotifier<UserProfile> {
  final ProfileRepository _repo;

  ProfileNotifier(this._repo, UserProfile initial) : super(initial);

  Future<void> updateNickname(String nickname) async {
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(nickname: trimmed);
    await _repo.save(state);
  }

  Future<void> setAvatarPath(String path) async {
    state = state.copyWith(avatarPath: path);
    await _repo.save(state);
  }

  Future<void> clearAvatar() async {
    state = state.copyWith(clearAvatar: true);
    await _repo.save(state);
  }

  Future<void> reset() async {
    state = UserProfile.defaults;
    await _repo.save(state);
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier(
    ref.watch(profileRepositoryProvider),
    ref.watch(initialProfileProvider),
  );
});
