/// Utility for normalizing and formatting phone numbers.
///
/// Complies with E.164 international standard and Ivory Coast (+225) 10-digit mobile numbers.
class PhoneNumberFormatter {
  /// Default country code for Ivory Coast.
  static const String defaultCountryCode = '225';

  /// Normalizes a phone number to standard format.
  ///
  /// - Strips spaces, hyphens, periods, and parentheses.
  /// - If [includePlus] is true, returns e.g. `+2250701020304`.
  /// - If [includePlus] is false (e.g. for WhatsApp wa.me links), returns `2250701020304`.
  static String normalize(String rawPhone, {bool includePlus = true}) {
    if (rawPhone.trim().isEmpty) return '';

    // Remove all whitespace and common punctuation
    String cleaned = rawPhone.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');

    // Check if it already has a '+'
    bool hasPlus = cleaned.startsWith('+');
    if (hasPlus) {
      cleaned = cleaned.substring(1);
    }

    // Handle Ivory Coast local numbers (10 digits starting with 0, ex: 0701020304)
    if (cleaned.startsWith('0') && cleaned.length == 10) {
      cleaned = '$defaultCountryCode$cleaned';
    } else if (!cleaned.startsWith(defaultCountryCode) && cleaned.length == 10) {
      cleaned = '$defaultCountryCode$cleaned';
    }

    return includePlus ? '+$cleaned' : cleaned;
  }

  /// Formats multiple phone numbers for SMS multi-recipient URI.
  ///
  /// Android and iOS standards accept comma-separated numbers in SMS URI scheme.
  static String formatForSms(List<String> rawPhoneNumbers) {
    return rawPhoneNumbers
        .map((p) => normalize(p, includePlus: true))
        .where((p) => p.isNotEmpty)
        .join(',');
  }
}
