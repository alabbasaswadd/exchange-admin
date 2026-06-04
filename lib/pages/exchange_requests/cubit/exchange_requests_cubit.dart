import 'package:exchange_admin/core/constants/base_cubit.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/exchange_requests/api/exchange_requests_api.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_state.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_admin/pages/exchange_requests/model/update_request_status_model.dart';

class ExchangeRequestsCubit extends BaseCubit<ExchangeRequestsState> {
  final ExchangeRequestsApi _api;

  ExchangeRequestsCubit(this._api)
      : super(const ExchangeRequestsState.initial());

  List<ExchangeRequestModel> _requests = [];
  String? _activeFilter;

  List<ExchangeRequestModel> get cachedRequests =>
      List.unmodifiable(_requests);

  List<ExchangeRequestModel> get filteredRequests => _activeFilter == null
      ? _requests
      : _requests.where((r) => r.status == _activeFilter).toList();

  Future<void> fetchRequests({String? status}) async {
    _activeFilter = status;
    emit(const ExchangeRequestsState.loading());
    final result = await _api.getExchangeRequests(
      page: 1,
      pageSize: 100,
      status: status,
    );
    result.when(
      success: (response) {
        _requests = response.data ?? [];
        emit(ExchangeRequestsState.loaded(_requests));
      },
      failure: (error) =>
          emit(ExchangeRequestsState.error(error.message ?? 'حدث خطأ')),
    );
  }

  Future<void> updateStatus(
    int id,
    String status, {
    String? notes,
  }) async {
    final snapshot = List<ExchangeRequestModel>.from(_requests);

    emit(ExchangeRequestsState.updating(
      requests: snapshot,
      updatingId: id,
    ));

    final result = await _api.updateRequestStatus(
      id,
      UpdateRequestStatusModel(status: status, notes: notes),
    );

    result.when(
      success: (response) {
        _requests = _requests
            .map((r) => r.id == id
                ? (response.data ?? r.copyWith(status: status))
                : r)
            .toList();
        emit(ExchangeRequestsState.updateSuccess(_requests));
        emit(ExchangeRequestsState.loaded(_requests));
      },
      failure: (error) {
        emit(ExchangeRequestsState.loaded(snapshot));
        emit(ExchangeRequestsState.error(
            error.message ?? 'فشل تحديث حالة الطلب'));
      },
    );
  }
}
