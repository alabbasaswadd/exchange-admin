import 'package:exchange_admin/core/constants/base_cubit.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/exchange_requests/api/exchange_requests_api.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';

class ExchangeRequestsCubit
    extends BaseCubit<SigninState<List<ExchangeRequestModel>>> {
  final ExchangeRequestsApi api;

  ExchangeRequestsCubit(this.api) : super(const SigninState.initial());

  List<ExchangeRequestModel> _all = [];
  int? statusFilter;

  Future<void> fetchRequests() async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.getRequests(),
      onSuccess: (data) async {
        _all = data;
        _emitFiltered();
      },
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  void setFilter(int? status) {
    statusFilter = status;
    _emitFiltered();
  }

  void _emitFiltered() {
    final filtered = statusFilter == null
        ? List<ExchangeRequestModel>.from(_all)
        : _all.where((r) => r.status == statusFilter).toList();
    emit(SigninState.success(filtered));
  }

  Future<void> acceptRequest(String id) async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.acceptRequest(id),
      onSuccess: (_) async => fetchRequests(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  Future<void> rejectRequest(String id) async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.rejectRequest(id),
      onSuccess: (_) async => fetchRequests(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  Future<void> suspendRequest(String id) async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.suspendRequest(id),
      onSuccess: (_) async => fetchRequests(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }
}
