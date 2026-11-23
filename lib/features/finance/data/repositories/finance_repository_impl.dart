import 'package:hostel_hisab/features/finance/data/datasources/finance_remote_datasource.dart';
import 'package:hostel_hisab/features/finance/data/models/tx_model.dart';
import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';
import 'package:hostel_hisab/features/finance/domain/repositories/finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  const FinanceRepositoryImpl(this._remote);
  final FinanceRemoteDataSource _remote;

  @override
  Future<List<TxItem>> getTransactions() async {
    final list = await _remote.fetchTransactions();
    return list.map(TxModel.fromJson).toList();
  }

  @override
  Future<TxItem> addDeposit({
    required int amount,
    required PaymentMethod method,
    String? trxId,
  }) async {
    final json = await _remote.addDeposit({
      'amount': amount,
      'method': method.name,
      'trxId': trxId,
    });
    return TxModel.fromJson(json);
  }

  @override
  Future<TxItem> approveDeposit(String id) async =>
      TxModel.fromJson(await _remote.approve(id));
}
