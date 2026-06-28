// lib/data/models/app_user.dart

import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  String get initials {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }

  @override
  List<Object?> get props => [id, email, displayName, photoUrl];
}
