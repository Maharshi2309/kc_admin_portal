import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage secureStorage;
  late TokenStorage storage;

  setUp(() {
    secureStorage = _MockSecureStorage();
    storage = TokenStorage(secureStorage);
  });

  test('reads once, then serves the cached token', () async {
    when(
      () => secureStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => 'abc');

    expect(await storage.readToken(), 'abc');
    expect(await storage.readToken(), 'abc');
    verify(() => secureStorage.read(key: any(named: 'key'))).called(1);
  });

  test('a storage failure means "no saved session", not a crash', () async {
    when(
      () => secureStorage.read(key: any(named: 'key')),
    ).thenThrow(Exception('storage unavailable'));

    expect(await storage.readToken(), isNull);
  });

  test('a token that cannot be persisted still works in memory', () async {
    when(
      () => secureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenThrow(Exception('storage unavailable'));

    await storage.writeToken('xyz');
    expect(await storage.readToken(), 'xyz');
  });

  test('without "keep signed in" the token lives in memory only', () async {
    when(
      () => secureStorage.delete(key: any(named: 'key')),
    ).thenAnswer((_) async {});

    await storage.writeToken('session-only', persist: false);

    expect(await storage.readToken(), 'session-only');
    verify(() => secureStorage.delete(key: any(named: 'key'))).called(1);
    verifyNever(
      () => secureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    );
  });
}
