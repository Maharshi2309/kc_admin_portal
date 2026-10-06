import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores the session token in the platform's secure storage
/// (Keychain on iOS, Keystore-backed storage on Android, encrypted browser
/// storage on web). The token is cached in memory after the first read so
/// requests do not hit storage every time.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: on web, browser storage is
/// readable by scripts on the same origin. If the backend can issue an
/// httpOnly cookie instead, prefer that for web.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'keshav_admin.access_token';

  String? _cachedToken;
  bool _loaded = false;

  /// Whether the current token is also saved for the next start ("Keep me
  /// signed in"), so a replacement token is kept the same way.
  bool _persisted = false;

  /// A storage failure is treated as "no saved session" so it can never
  /// block signing in.
  Future<String?> readToken() async {
    if (!_loaded) {
      try {
        _cachedToken = await _storage.read(key: _accessTokenKey);
        _persisted = _cachedToken != null;
      } on Object catch (error) {
        debugPrint('TokenStorage: read failed ($error)');
        _cachedToken = null;
      }
      _loaded = true;
    }
    return _cachedToken;
  }

  /// Keeps the token for this session. With [persist] ("Keep me signed in")
  /// it is also saved for the next start; without it any saved token is
  /// removed. If saving fails, the session still works until the app closes.
  Future<void> writeToken(String token, {bool persist = true}) async {
    _cachedToken = token;
    _loaded = true;
    _persisted = persist;
    try {
      if (persist) {
        await _storage.write(key: _accessTokenKey, value: token);
      } else {
        await _storage.delete(key: _accessTokenKey);
      }
    } on Object catch (error) {
      debugPrint(
        'TokenStorage: ${persist ? 'write' : 'delete'} failed ($error)',
      );
    }
  }

  /// A new token for the same session (e.g. after switching organization),
  /// saved for the next start only if the current one was.
  Future<void> replaceToken(String token) =>
      writeToken(token, persist: _persisted);

  Future<void> clear() async {
    _cachedToken = null;
    _loaded = true;
    try {
      await _storage.delete(key: _accessTokenKey);
    } on Object catch (error) {
      debugPrint('TokenStorage: delete failed ($error)');
    }
  }
}

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(const FlutterSecureStorage()),
);
