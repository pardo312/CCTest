import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  final String id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final String? bio;
  final bool sellerEnabled;
  final bool sellerVerified;
  final double creditBalance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    this.username,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.bio,
    this.sellerEnabled = false,
    this.sellerVerified = false,
    this.creditBalance = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? id,
    String? username,
    String? fullName,
    String? email,
    String? avatarUrl,
    String? bio,
    bool? sellerEnabled,
    bool? sellerVerified,
    double? creditBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      sellerEnabled: sellerEnabled ?? this.sellerEnabled,
      sellerVerified: sellerVerified ?? this.sellerVerified,
      creditBalance: creditBalance ?? this.creditBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        fullName,
        email,
        avatarUrl,
        bio,
        sellerEnabled,
        sellerVerified,
        creditBalance,
        createdAt,
        updatedAt,
      ];
}