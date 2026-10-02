import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Broadcasts "the server rejected our session" (a 401 on an authenticated
/// request). The network layer emits; the auth controller listens and signs
/// the user out.
///
/// It exists so the API client does not depend on the auth feature (which
/// itself depends on the API client).
class SessionEvents {
  final _expired = StreamController<String?>.broadcast();

  /// The server's reason, e.g. "Your role has been deactivated.", when it
  /// gave one.
  Stream<String?> get onExpired => _expired.stream;

  void notifyExpired([String? reason]) {
    if (!_expired.isClosed) _expired.add(reason);
  }

  final _forbidden = StreamController<void>.broadcast();

  /// A 403: the role's permissions may have changed since sign-in, so the
  /// signed-in user is reloaded.
  Stream<void> get onForbidden => _forbidden.stream;

  void notifyForbidden() {
    if (!_forbidden.isClosed) _forbidden.add(null);
  }

  Future<void> dispose() async {
    await _expired.close();
    await _forbidden.close();
  }
}

final sessionEventsProvider = Provider<SessionEvents>((ref) {
  final events = SessionEvents();
  ref.onDispose(events.dispose);
  return events;
});
