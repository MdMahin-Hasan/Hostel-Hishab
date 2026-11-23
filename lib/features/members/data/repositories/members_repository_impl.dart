import 'package:hostel_hisab/features/members/data/datasources/members_remote_datasource.dart';
import 'package:hostel_hisab/features/members/data/models/member_model.dart';
import 'package:hostel_hisab/features/members/domain/entities/member.dart';
import 'package:hostel_hisab/features/members/domain/repositories/members_repository.dart';

class MembersRepositoryImpl implements MembersRepository {
  const MembersRepositoryImpl(this._remote);
  final MembersRemoteDataSource _remote;

  @override
  Future<List<Member>> getMembers() async {
    final list = await _remote.fetchMembers();
    return list.map(MemberModel.fromJson).toList(); // JSON -> entity
  }

  @override
  Future<Member> addMember({required String name, required String room}) async {
    final json = await _remote.addMember({'name': name, 'room': room});
    return MemberModel.fromJson(json);
  }
}
