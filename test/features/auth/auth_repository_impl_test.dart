import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kc_admin_portal/features/auth/data/models/login_response_model.dart';
import 'package:kc_admin_portal/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fake_auth.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late _MockRemote remote;
  late _MockTokenStorage storage;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    storage = _MockTokenStorage();
    repository = AuthRepositoryImpl(remote: remote, tokenStorage: storage);
    when(
      () => storage.writeToken(any(), persist: any(named: 'persist')),
    ).thenAnswer((_) async {});
    when(storage.clear).thenAnswer((_) async {});
  });

  group('signIn', () {
    setUp(() {
      when(
        () => remote.login(email: 'admin@keshav.in', password: 'secret'),
      ).thenAnswer(
        (_) async => LoginResponseModel(accessToken: 'token-1', user: testUser),
      );
    });

    test('keeps the token for next time by default', () async {
      final user = await repository.signIn(
        email: 'admin@keshav.in',
        password: 'secret',
      );
      expect(user, testUser);
      verify(() => storage.writeToken('token-1', persist: true)).called(1);
    });

    test('"Keep me signed in" off keeps it for this session only', () async {
      await repository.signIn(
        email: 'admin@keshav.in',
        password: 'secret',
        keepSignedIn: false,
      );
      verify(() => storage.writeToken('token-1', persist: false)).called(1);
    });

    test('a failed sign-in stores nothing', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: 'wrong',
        ),
      ).thenThrow(const UnauthorizedException('Incorrect email or password.'));

      await expectLater(
        repository.signIn(email: 'admin@keshav.in', password: 'wrong'),
        throwsA(isA<UnauthorizedException>()),
      );
      verifyNever(
        () => storage.writeToken(any(), persist: any(named: 'persist')),
      );
    });
  });

  group('restoreSession', () {
    test('no saved token: signed out, no server call', () async {
      when(storage.readToken).thenAnswer((_) async => null);
      expect(await repository.restoreSession(), isNull);
      verifyNever(remote.me);
    });

    test('a valid saved token restores the user', () async {
      when(storage.readToken).thenAnswer((_) async => 'token-1');
      when(remote.me).thenAnswer((_) async => testUser);
      expect(await repository.restoreSession(), testUser);
    });

    test('a token the server rejects is cleared', () async {
      when(storage.readToken).thenAnswer((_) async => 'expired');
      when(remote.me).thenThrow(const UnauthorizedException());

      expect(await repository.restoreSession(), isNull);
      verify(storage.clear).called(1);
    });

    test('offline keeps the token so the user can retry', () async {
      when(storage.readToken).thenAnswer((_) async => 'token-1');
      when(remote.me).thenThrow(const NetworkException());

      await expectLater(
        repository.restoreSession(),
        throwsA(isA<NetworkException>()),
      );
      verifyNever(storage.clear);
    });
  });

  group('signOut', () {
    test('tells the server and clears the token', () async {
      when(remote.logout).thenAnswer((_) async {});
      await repository.signOut();
      verify(remote.logout).called(1);
      verify(storage.clear).called(1);
    });

    test('still signs out locally when the server is unreachable', () async {
      when(remote.logout).thenThrow(const NetworkException());
      await repository.signOut();
      verify(storage.clear).called(1);
    });
  });

  test('clearSession forgets the token without calling the server', () async {
    await repository.clearSession();
    verify(storage.clear).called(1);
    verifyNever(remote.logout);
  });
}
