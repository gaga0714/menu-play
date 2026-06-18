class UserProfile {
  final String nickname;
  final String? avatarPath;

  const UserProfile({
    required this.nickname,
    this.avatarPath,
  });

  static const UserProfile defaults = UserProfile(nickname: '吃货');

  UserProfile copyWith({String? nickname, String? avatarPath, bool clearAvatar = false}) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      avatarPath: clearAvatar ? null : (avatarPath ?? this.avatarPath),
    );
  }

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'avatarPath': avatarPath,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] as String? ?? defaults.nickname,
      avatarPath: json['avatarPath'] as String?,
    );
  }
}
