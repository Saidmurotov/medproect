import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:medproect/core/constants/diet_tables.dart';

void main() {
  final cyrillic = RegExp(r'[\u0400-\u04FF]');

  test('Uzbek localization strings do not contain Cyrillic text', () {
    final arb =
        jsonDecode(File('lib/l10n/app_uz.arb').readAsStringSync())
            as Map<String, dynamic>;

    final cyrillicEntries = arb.entries.where((entry) {
      return !entry.key.startsWith('@') &&
          entry.value is String &&
          cyrillic.hasMatch(entry.value as String);
    }).toList();

    expect(cyrillicEntries, isEmpty);
  });

  test('disease options stay in Latin Uzbek', () {
    final cyrillicOptions = DietConstants.diseaseOptions
        .where((option) => cyrillic.hasMatch(option))
        .toList();

    expect(cyrillicOptions, isEmpty);
  });

  test('legacy Cyrillic disease names are normalized to Latin Uzbek', () {
    const legacyGastrit =
        '\u0421\u0443\u0440\u0443\u043d\u043a\u0430\u043b\u0438 '
        '\u0433\u0430\u0441\u0442\u0440\u0438\u0442';

    expect(
      DietConstants.normalizeDiseaseName(legacyGastrit),
      'Surunkali gastrit',
    );
  });
}
