// lib/features/auth/auth_state.dart

part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// App just launched; checking for a previous session.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// A sign-in or session-check is in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is signed in.
class AuthAuthenticated extends AuthState {
  final AppUser user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

/// No signed-in user; show the Login page.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Sign-in failed with an error message.
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
