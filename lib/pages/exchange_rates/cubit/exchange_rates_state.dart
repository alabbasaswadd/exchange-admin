import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rates_state.freezed.dart';

@freezed
class ExchangeRatesState with _$ExchangeRatesState {
  const factory ExchangeRatesState.initial() = _Initial;
  const factory ExchangeRatesState.loading() = _Loading;
  const factory ExchangeRatesState.loaded(List<ExchangeRateModel> rates) =
      _Loaded;
  const factory ExchangeRatesState.updating() = _Updating;
  const factory ExchangeRatesState.updateSuccess() = _UpdateSuccess;
  const factory ExchangeRatesState.error(String message) = _Error;
}
