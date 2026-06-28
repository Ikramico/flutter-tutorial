// lib/features/auth/auth_event.dart

part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// Public events — triggered from UI / outside the bloc
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

// Private event — only used internally by AuthBloc to pipe stream updates.
// The leading underscore keeps it out of the public API.
final class _AuthUserChanged extends AuthEvent {
  const _AuthUserChanged(this.user);
  final AppUser? user;

  @override
  List<Object?> get props => [user];
}
