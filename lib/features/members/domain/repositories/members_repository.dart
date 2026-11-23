import 'package:hostel_hisab/features/members/domain/entities/member.dart';

abstract class MembersRepository {
  Future<List<Member>> getMembers();
  Future<Member> addMember({required String name, required String room});
}
