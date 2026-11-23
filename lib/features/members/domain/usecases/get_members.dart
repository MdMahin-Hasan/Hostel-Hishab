import 'package:hostel_hisab/features/members/domain/entities/member.dart';
import 'package:hostel_hisab/features/members/domain/repositories/members_repository.dart';

class GetMembers {
  const GetMembers(this._repo);
  final MembersRepository _repo;

  Future<List<Member>> call() => _repo.getMembers();
}
