/// Bangla digits, taka amounts (lakh grouping) and dates.
class Fmt {
  static const _digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  static const _months = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  /// 123 -> ১২৩
  static String bn(Object value) => value.toString().split('').map((c) {
        final d = int.tryParse(c);
        return d == null ? c : _digits[d];
      }).join();

  /// ১২৫০ -> 1250 (people may type Bangla digits)
  static String en(String s) => s.split('').map((c) {
        final i = _digits.indexOf(c);
        return i == -1 ? c : '$i';
      }).join();

  /// Parses Bangla or English digits. Returns null when invalid.
  static int? parseInt(String? s) => int.tryParse(en((s ?? '').trim()));

  /// 1248000 -> 12,48,000 (Bangladesh style grouping)
  static String group(int n) {
    final negative = n < 0;
    final s = n.abs().toString();
    if (s.length <= 3) return negative ? '-$s' : s;
    final last = s.substring(s.length - 3);
    var rest = s.substring(0, s.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    final out = '${parts.join(',')},$last';
    return negative ? '-$out' : out;
  }

  /// 12480 -> ৳ ১২,৪৮০
  static String taka(int n) => '৳ ${bn(group(n))}';

  /// 2026-10-28 -> ২৮ অক্টোবর
  static String date(DateTime d) => '${bn(d.day)} ${_months[d.month - 1]}';
}
