import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_requests_state.freezed.dart';

@freezed
class ExchangeRequestsState with _$ExchangeRequestsState {
  const factory ExchangeRequestsState.initial() = _Initial;
  const factory ExchangeRequestsState.loading() = _Loading;
  const factory ExchangeRequestsState.loaded(
    List<ExchangeRequestModel> requests,
  ) = _Loaded;
  const factory ExchangeRequestsState.updating({
    required List<ExchangeRequestModel> requests,
    required int updatingId,
  }) = _Updating;
  const factory ExchangeRequestsState.updateSuccess(
    List<ExchangeRequestModel> requests,
  ) = _UpdateSuccess;
  const factory ExchangeRequestsState.error(String message) = _Error;
}
