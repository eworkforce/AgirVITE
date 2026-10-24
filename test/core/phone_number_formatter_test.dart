import 'package:flutter_test/flutter_test.dart';
import 'package:agir_vite/core/utils/phone_number_formatter.dart';

void main() {
  group('PhoneNumberFormatter', () {
    test('normalizes 10-digit Ivory Coast number with leading 0', () {
      expect(
        PhoneNumberFormatter.normalize('0701020304'),
        equals('+2250701020304'),
      );
      expect(
        PhoneNumberFormatter.normalize('0701020304', includePlus: false),
        equals('2250701020304'),
      );
    });

    test('strips spaces, dashes, periods and parentheses', () {
      expect(
        PhoneNumberFormatter.normalize('07 01-02.03 (04)'),
        equals('+2250701020304'),
      );
      expect(
        PhoneNumberFormatter.normalize('07 01-02.03 (04)', includePlus: false),
        equals('2250701020304'),
      );
    });

    test('handles number already prefixed with +225', () {
      expect(
        PhoneNumberFormatter.normalize('+2250505050505'),
        equals('+2250505050505'),
      );
      expect(
        PhoneNumberFormatter.normalize('+2250505050505', includePlus: false),
        equals('2250505050505'),
      );
    });

    test('handles number prefixed with 225 without plus', () {
      expect(
        PhoneNumberFormatter.normalize('2250102030405'),
        equals('+2250102030405'),
      );
      expect(
        PhoneNumberFormatter.normalize('2250102030405', includePlus: false),
        equals('2250102030405'),
      );
    });

    test('formats multi-recipient numbers for SMS', () {
      final numbers = ['0701020304', '0505050505', '+2250102030405'];
      final smsRecipients = PhoneNumberFormatter.formatForSms(numbers);
      expect(smsRecipients, equals('+2250701020304,+2250505050505,+2250102030405'));
    });

    test('returns empty string on empty input', () {
      expect(PhoneNumberFormatter.normalize(''), equals(''));
      expect(PhoneNumberFormatter.formatForSms([]), equals(''));
    });
  });
}
