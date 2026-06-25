// lib/features/auth/auth_event.dart

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Fired once at startup to attempt a silent session restore.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Fired when the user taps "Continue with Google".
class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

/// Fired when the user taps "Sign Out".
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
