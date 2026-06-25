
import 'package:google_sign_in/google_sign_in.dart';
import '../app_user.dart';

class AuthRepository {
  // Scopes: profile info + email are the defaults; request only what you need.
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// Returns the signed-in [AppUser], or null if the user cancelled.
  /// Throws on network / configuration errors.
  Future<AppUser?> signInWithGoogle() async {
    // Trigger the Google sign-in flow.
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // User cancelled the picker.
    if (googleUser == null) return null;

    // Build our domain user from the Google account info.
    return AppUser(
      id: googleUser.id,
      name: googleUser.displayName ?? 'User',
      email: googleUser.email,
      photoUrl: googleUser.photoUrl,
    );
  }

  /// Silently restores a previous sign-in session on app restart.
  /// Returns null if no previous session exists.
  Future<AppUser?> signInSilently() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn
        .signInSilently();
    if (googleUser == null) return null;

    return AppUser(
      id: googleUser.id,
      name: googleUser.displayName ?? 'User',
      email: googleUser.email,
      photoUrl: googleUser.photoUrl,
    );
  }

  /// Signs the user out and clears the cached account.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  /// Returns true if a user is currently signed in.
  bool get isSignedIn => _googleSignIn.currentUser != null;

  /// Returns the current signed-in account, or null.
  AppUser? get currentUser {
    final account = _googleSignIn.currentUser;
    if (account == null) return null;
    return AppUser(
      id: account.id,
      name: account.displayName ?? 'User',
      email: account.email,
      photoUrl: account.photoUrl,
    );
  }
}
