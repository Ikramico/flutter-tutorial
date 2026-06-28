  
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../app_user.dart';

class AuthRepository {
  AuthRepository();

  // v7: singleton — no constructor arguments, no scopes at construction time
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final _userController = StreamController<AppUser?>.broadcast();
  StreamSubscription<GoogleSignInAuthenticationEvent>? _eventSub;

  // ── Auth State Stream ─────────────────────────────────────────────────────

  /// Emits an [AppUser] on successful sign-in, `null` on sign-out / error.
  /// Subscribe in your AuthBloc instead of calling signInSilently().
  Stream<AppUser?> get authStateChanges => _userController.stream;

  // ── Initialization ────────────────────────────────────────────────────────

  /// Call **once** before any other method — e.g. in main() or your DI setup.
  ///
  /// [serverClientId] is your Web Client ID from Google Cloud Console
  /// (needed for ID tokens / backend verification).
  Future<void> initialize({String? serverClientId}) async {
    await _googleSignIn.initialize(serverClientId: serverClientId);

    _eventSub = _googleSignIn.authenticationEvents.listen(
      _onAuthEvent,
      onError: (Object error) {
        debugPrint('[AuthRepository] authenticationEvents error: $error');
        _userController.add(null);
      },
    );

    // Non-blocking silent sign-in attempt (replaces signInSilently).
    // Result arrives via authenticationEvents → authStateChanges.
    _googleSignIn.attemptLightweightAuthentication();
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Interactive Google Sign-In (Credential Manager / account picker sheet).
  ///
  /// The result is also pushed onto [authStateChanges] so your BLoC stream
  /// listener will fire too.
  Future<AppUser?> signInWithGoogle() async {
    if (!_googleSignIn.supportsAuthenticate()) {
      debugPrint(
        '[AuthRepository] authenticate() not supported on this platform.',
      );
      return null;
    }

    // Bridge the next stream event into a Future so existing BLoC event
    // handlers can still await a result without restructuring.
    final completer = Completer<AppUser?>();
    late final StreamSubscription<AppUser?> sub;
    sub = authStateChanges.listen((user) {
      if (!completer.isCompleted) {
        completer.complete(user);
        sub.cancel();
      }
    });

    try {
      await _googleSignIn.authenticate();
    } catch (e) {
      sub.cancel();
      if (!completer.isCompleted) completer.completeError(e);
      debugPrint('[AuthRepository] signInWithGoogle error: $e');
      rethrow;
    }

    return completer.future;
  }

  /// Sign out from Google.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _userController.add(null);
    } catch (e) {
      debugPrint('[AuthRepository] signOut error: $e');
    }
  }

  /// Release resources when the repository is no longer needed.
  void dispose() {
    _eventSub?.cancel();
    _userController.close();
  }

  // ── Internals ─────────────────────────────────────────────────────────────

  void _onAuthEvent(GoogleSignInAuthenticationEvent event) {
    // Use Dart 3 exhaustive switch — compiler will warn if new event types
    // are added to the library in a future version.
    final AppUser? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => _toUser(event.user),
      GoogleSignInAuthenticationEventSignOut() => null,
    };
    _userController.add(user);
  }

  // GoogleSignInAccount is still the user type in v7 (unchanged from v6)
  AppUser _toUser(GoogleSignInAccount account) {
    return AppUser(
      id: account.id,
      email: account.email,
      displayName: account.displayName ?? account.email,
      photoUrl: account.photoUrl,
    );
  }
}
