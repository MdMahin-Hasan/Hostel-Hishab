abstract class MembersRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchMembers();
  Future<Map<String, dynamic>> addMember(Map<String, dynamic> payload);
}
