import 'package:hostel_hisab/features/members/domain/entities/member.dart';

/// Entity + JSON knowledge. MongoDB documents use "_id".
class MemberModel extends Member {
  const MemberModel({
    required super.id,
    required super.name,
    required super.room,
    super.balance = 0,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        id: json['_id'] as String,
        name: json['name'] as String,
        room: json['room'] as String,
        balance: (json['balance'] as num? ?? 0).toInt(),
      );

  Map<String, dynamic> toJson() =>
      {'_id': id, 'name': name, 'room': room, 'balance': balance};
}
