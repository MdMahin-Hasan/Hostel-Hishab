import 'package:flutter/foundation.dart';
import 'package:hostel_hisab/core/errors/app_exception.dart';

enum ViewState { idle, loading, success, error }

/// Every feature provider extends this, so loading/error handling is
/// written ONCE instead of in every provider.
abstract class BaseProvider extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _error;
  bool _disposed = false;

  ViewState get state => _state;
  String? get error => _error;
  bool get isLoading => _state == ViewState.loading;

  /// Wraps an async job: loading -> success / error, notifying the UI.
  Future<void> run(Future<void> Function() job) async {
    _state = ViewState.loading;
    _error = null;
    notifyListeners();
    try {
      await job();
      _state = ViewState.success;
    } catch (e) {
      _error = e is AppException
          ? e.message
          : 'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।';
      _state = ViewState.error;
    }
    notifyListeners();
  }

  // Avoids "notifyListeners after dispose" crashes if a request finishes late.
  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
