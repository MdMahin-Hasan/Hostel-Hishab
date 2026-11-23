import 'package:hostel_hisab/core/base/base_provider.dart';
import 'package:hostel_hisab/features/members/domain/entities/member.dart';
import 'package:hostel_hisab/features/members/domain/usecases/add_member.dart';
import 'package:hostel_hisab/features/members/domain/usecases/get_members.dart';

class MembersProvider extends BaseProvider {
  MembersProvider({required GetMembers getMembers, required AddMember addMember})
      : _getMembers = getMembers,
        _addMember = addMember;

  final GetMembers _getMembers;
  final AddMember _addMember;

  List<Member> _members = [];
  List<Member> get members => _members;

  int _count(DueStatus s) => _members.where((m) => m.status == s).length;
  int get paidCount => _count(DueStatus.paid);
  int get dueCount => _count(DueStatus.due);
  int get advanceCount => _count(DueStatus.advance);

  Future<void> load() => run(() async {
        _members = await _getMembers();
      });

  Future<void> add(String name, String room) => run(() async {
        final m = await _addMember(name: name, room: room);
        _members = [..._members, m];
      });
}
