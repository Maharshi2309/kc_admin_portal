// Keeps docs/API_CONTRACT.md, docs/api-examples/ and the contract tests in
// step, so the backend team never reads an example the app doesn't parse.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const String _examples = 'docs/api-examples';

/// Every key in [json], at any depth.
Iterable<String> _keys(Object? json) sync* {
  if (json is Map<String, dynamic>) {
    for (final MapEntry(:key, :value) in json.entries) {
      yield key;
      yield* _keys(value);
    }
  } else if (json is List) {
    for (final item in json) {
      yield* _keys(item);
    }
  }
}

void main() {
  final files =
      Directory(_examples)
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last)
          .where((name) => name.endsWith('.json'))
          .toList()
        ..sort();
  final contract = File('docs/API_CONTRACT.md').readAsStringSync();
  final contractTests = Directory('test/contract')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('_test.dart'))
      .map((f) => f.readAsStringSync())
      .join('\n');

  test('there are examples', () => expect(files, isNotEmpty));

  for (final name in files) {
    test('$name is valid JSON, linked from the contract and tested', () {
      expect(
        () => jsonDecode(File('$_examples/$name').readAsStringSync()),
        returnsNormally,
      );
      expect(
        contract,
        contains('api-examples/$name'),
        reason: 'API_CONTRACT.md should link $name',
      );
      expect(
        contractTests,
        contains("'$name'"),
        reason: 'a contract test should parse $name',
      );
    });
  }

  test('every example the contract links exists', () {
    final linked = RegExp(
      r'api-examples/([\w.-]+\.json)',
    ).allMatches(contract).map((m) => m.group(1)!).toSet();
    expect(linked.difference(files.toSet()), isEmpty);
  });

  group('retired fields stay retired (2026-10-05)', () {
    Map<String, Object?> example(String name) =>
        jsonDecode(File('$_examples/$name').readAsStringSync())
            as Map<String, Object?>;

    test('employees have no email', () {
      for (final name in files.where((n) => n.startsWith('employees.'))) {
        final json = jsonDecode(File('$_examples/$name').readAsStringSync());
        expect(_keys(json), isNot(contains('email')), reason: name);
      }
    });

    test('no designation or department ids', () {
      for (final name in files) {
        final json = jsonDecode(File('$_examples/$name').readAsStringSync());
        expect(
          _keys(json),
          isNot(anyOf(contains('designation'), contains('departmentId'))),
          reason: name,
        );
      }
    });

    test('only Casual and Unpaid leave, with no quotas', () {
      for (final name in files) {
        final text = File('$_examples/$name').readAsStringSync().toLowerCase();
        expect(text, isNot(contains('"sick"')), reason: name);
        expect(text, isNot(contains('"earned"')), reason: name);
        expect(
          _keys(jsonDecode(text)),
          isNot(anyOf(contains('quota'), contains('balancebefore'))),
          reason: name,
        );
      }
    });

    test('the dashboard has no "% of leave used"', () {
      final usage =
          example('dashboard.summary.response.json')['leaveUsage']!
              as Map<String, Object?>;
      expect(usage.keys, isNot(contains('usedPercent')));
      expect(usage.keys, contains('casualRemainingDays'));
    });
  });
}
