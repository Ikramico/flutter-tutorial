// lib/features/auth/auth_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../data/app_user.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late final StreamSubscription<AppUser?> _authSub;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<_AuthUserChanged>(_onUserChanged); // internal — handles stream events
    on<AuthGoogleSignInRequested>(_onSignIn);
    on<AuthSignOutRequested>(_onSignOut);

    // Subscribe once. Every sign-in / sign-out (including the silent restore
    // triggered by initialize → attemptLightweightAuthentication) will push
    // an _AuthUserChanged event, keeping state in sync automatically.
    _authSub = _authRepository.authStateChanges.listen(
      (user) => add(_AuthUserChanged(user)),
      onError: (_) => add(const _AuthUserChanged(null)),
    );

    debugPrint('[AuthBloc] created → firing AuthCheckRequested');
    add(const AuthCheckRequested());
  }

  // ── Event handlers ────────────────────────────────────────────────────────

  void _onCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) {
    debugPrint('[AuthBloc] ▶ AuthCheckRequested');
    // Just show a spinner. The silent sign-in was already triggered by
    // AuthRepository.initialize() → attemptLightweightAuthentication().
    // Its result arrives via _authSub → _AuthUserChanged below.
    emit(const AuthLoading());
  }

  void _onUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      debugPrint('[AuthBloc] ✅ → AuthAuthenticated (${event.user!.email})');
      emit(AuthAuthenticated(event.user!));
    } else {
      debugPrint('[AuthBloc] ℹ️  → AuthUnauthenticated');
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
      // authenticate() result arrives via the stream → _onUserChanged.
      // We still await to catch thrown exceptions (e.g. user cancels).
      await _authRepository.signInWithGoogle();
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
    // signOut() pushes null onto authStateChanges → _onUserChanged emits
    // AuthUnauthenticated, so no manual emit needed here.
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }
}
