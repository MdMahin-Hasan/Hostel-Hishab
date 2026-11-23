enum DueStatus { paid, due, advance }

class Member {
  const Member({
    required this.id,
    required this.name,
    required this.room,
    this.balance = 0,
  });

  final String id;
  final String name;
  final String room;

  /// Money is stored as whole taka (int), never double -> no rounding bugs.
  /// negative = member owes money, positive = paid in advance.
  final int balance;

  DueStatus get status => balance < 0
      ? DueStatus.due
      : balance > 0
          ? DueStatus.advance
          : DueStatus.paid;
}
