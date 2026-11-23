import 'package:hostel_hisab/core/errors/app_exception.dart';
import 'package:hostel_hisab/features/members/domain/entities/member.dart';
import 'package:hostel_hisab/features/members/domain/repositories/members_repository.dart';

class AddMember {
  const AddMember(this._repo);
  final MembersRepository _repo;

  /// Business rule lives here, not in the widget.
  Future<Member> call({required String name, required String room}) {
    if (name.trim().isEmpty) throw const AppException('নাম লিখুন');
    return _repo.addMember(name: name.trim(), room: room.trim());
  }
}
