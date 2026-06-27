// lib/data/repositories/auth_repository.dart
//
// ✅ Correct API for google_sign_in: 7.2.0
//
// What changed in v7 vs v6:
//   OLD (v6): GoogleSignIn(scopes:[...])  → .signIn()  → .signInSilently()
//   NEW (v7): GoogleSignIn.instance       → .initialize() → .authenticate() → .attemptLightweightAuthentication()

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../app_user.dart';

class AuthRepository {
  // ── v7: singleton instance, no constructor ─────────────────────────────────
  final GoogleSignIn _signIn = GoogleSignIn.instance;

  bool _initialized = false;

  // ── Must call this once before any sign-in attempt ────────────────────────
  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    debugPrint('[AuthRepository] initialize() START');
    await _signIn.initialize(
      // serverClientId is your Web Client ID from Google Cloud Console.
      // Required to get an idToken back.
      serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
    );
    _initialized = true;
    debugPrint('[AuthRepository] initialize() DONE');
  }

  /// Called at startup — silent session restore.
  /// Replaces v6's signInSilently().
  Future<AppUser?> signInSilently() async {
    debugPrint('[AuthRepository] signInSilently() START');
    try {
      await _ensureInitialized();

      debugPrint('[AuthRepository] attemptLightweightAuthentication()...');
      // ✅ v7: returns Future<GoogleSignInAccount?> directly
      final account = await _signIn.attemptLightweightAuthentication();

      if (account != null) {
        debugPrint(
          '[AuthRepository] ✅ Silent restore SUCCESS: ${account.email}',
        );
        return _toAppUser(account);
      } else {
        debugPrint('[AuthRepository] ℹ️  No previous session');
        return null;
      }
    } catch (e, stack) {
      debugPrint('[AuthRepository] ❌ signInSilently EXCEPTION: $e');
      debugPrint('$stack');
      return null;
    }
  }

  /// Called when user taps "Continue with Google".
  /// Replaces v6's signIn().
  Future<AppUser?> signInWithGoogle() async {
    debugPrint('[AuthRepository] signInWithGoogle() START');
    try {
      await _ensureInitialized();

      // ── Platform check ───────────────────────────────────────────────────
      // v7: authenticate() only works on Android/iOS/macOS
      // Linux/Windows are NOT supported
      debugPrint(
        '[AuthRepository] supportsAuthenticate(): ${_signIn.supportsAuthenticate()}',
      );

      if (!_signIn.supportsAuthenticate()) {
        debugPrint(
          '[AuthRepository] ❌ Platform does not support authenticate()',
        );
        debugPrint('   → You must run on Android/iOS, not Linux/Windows');
        throw UnsupportedError(
          'Google Sign-In is not supported on this platform (${defaultTargetPlatform.name}).\n'
          'Please run on an Android device or emulator:\n'
          '  flutter run -d <android-device-id>',
        );
      }

      debugPrint('[AuthRepository] Calling authenticate()...');
      // ✅ v7: authenticate() replaces signIn()
      final account = await _signIn.authenticate();

      debugPrint('[AuthRepository] ✅ authenticate() SUCCESS: ${account.email}');
      _logAccount(account);

      // Try fetching tokens to reveal OAuth config issues
      try {
        final auth = await account.authentication;
        // debugPrint('[AuthRepository] accessToken: ${_mask(auth.)}');
        debugPrint('[AuthRepository] idToken    : ${_mask(auth.idToken)}');
        if (auth.idToken == null) {
          debugPrint(
            '[AuthRepository] ⚠️  idToken NULL → check serverClientId / Web client in google_services.json',
          );
        }
      } catch (e) {
        debugPrint('[AuthRepository] ⚠️  Token fetch error: $e');
      }

      return _toAppUser(account);
    } on GoogleSignInException catch (e, stack) {
      debugPrint('[AuthRepository] ❌ GoogleSignInException');
      debugPrint('   code   : ${e.code}');
      debugPrint('   message: ${e.description}');
      _diagnose(e.code.toString());
      debugPrint('$stack');
      rethrow;
    } catch (e, stack) {
      debugPrint('[AuthRepository] ❌ EXCEPTION: ${e.runtimeType}: $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  /// Signs the user out.
  Future<void> signOut() async {
    debugPrint('[AuthRepository] signOut() START');
    try {
      await _ensureInitialized();
      await _signIn.signOut();
      debugPrint('[AuthRepository] ✅ signOut() SUCCESS');
    } catch (e) {
      debugPrint('[AuthRepository] ❌ signOut() EXCEPTION: $e');
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  AppUser _toAppUser(GoogleSignInAccount account) {
    return AppUser(
      id: account.id,
      name: account.displayName ?? 'Unknown',
      email: account.email,
      photoUrl: account.photoUrl,
    );
  }

  void _logAccount(GoogleSignInAccount account) {
    debugPrint('   ┌─ Account ──────────────────────────────');
    debugPrint('   │ id    : ${account.id}');
    debugPrint('   │ email : ${account.email}');
    debugPrint('   │ name  : ${account.displayName}');
    debugPrint('   └────────────────────────────────────────');
  }

  String _mask(String? token) {
    if (token == null) return 'null';
    if (token.length < 12) return '***';
    return '${token.substring(0, 8)}...${token.substring(token.length - 4)}';
  }

  void _diagnose(String code) {
    switch (code) {
      case 'sign_in_failed':
      case '10':
        debugPrint('🔴 DEVELOPER_ERROR — likely causes:');
        debugPrint('   1. SHA-1 not in Google Cloud Console');
        debugPrint('      → cd android && ./gradlew signingReport');
        debugPrint(
          '   2. Package name mismatch (build.gradle vs Cloud Console)',
        );
        debugPrint(
          '   3. google_services.json missing client_type:3 (Web client)',
        );
        break;
      case '12500':
        debugPrint('🔴 OAuth consent screen not published');
        debugPrint('   → Cloud Console → OAuth consent screen → Publish');
        break;
      case '12501':
        debugPrint('ℹ️  User cancelled sign-in');
        break;
      case '7':
        debugPrint('🔴 Network error — check internet / use real device');
        break;
    }
  }
}
