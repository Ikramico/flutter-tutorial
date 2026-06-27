// lib/features/auth/auth_bloc.dart
// ✅ Compatible with google_sign_in v7.2.0

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../data/app_user.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthGoogleSignInRequested>(_onSignIn);
    on<AuthSignOutRequested>(_onSignOut);

    debugPrint('[AuthBloc] created → firing AuthCheckRequested');
    add(const AuthCheckRequested());
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('[AuthBloc] ▶ AuthCheckRequested');
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInSilently();
      if (user != null) {
        debugPrint('[AuthBloc] ✅ → AuthAuthenticated (${user.email})');
        emit(AuthAuthenticated(user));
      } else {
        debugPrint('[AuthBloc] ℹ️  → AuthUnauthenticated');
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('[AuthBloc] ❌ → AuthUnauthenticated (error: $e)');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignIn(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('[AuthBloc] ▶ AuthGoogleSignInRequested');
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        debugPrint('[AuthBloc] ✅ → AuthAuthenticated (${user.email})');
        emit(AuthAuthenticated(user));
      } else {
        debugPrint('[AuthBloc] ℹ️  → AuthUnauthenticated (cancelled)');
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('[AuthBloc] ❌ → AuthError: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('[AuthBloc] ▶ AuthSignOutRequested');
    await _authRepository.signOut();
    debugPrint('[AuthBloc] → AuthUnauthenticated');
    emit(const AuthUnauthenticated());
  }
}
