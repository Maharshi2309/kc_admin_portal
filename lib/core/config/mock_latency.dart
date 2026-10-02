import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DEV ONLY: simulated network delay of the mock data sources
/// (`USE_MOCK_API=true`), so loading states are visible. Tests override it
/// with `Duration.zero`.
final mockLatencyProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 400),
);
