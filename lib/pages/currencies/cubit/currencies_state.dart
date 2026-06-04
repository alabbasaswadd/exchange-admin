import 'package:exchange_admin/pages/currencies/model/currency_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'currencies_state.freezed.dart';

@freezed
class CurrenciesState with _$CurrenciesState {
  const factory CurrenciesState.initial() = _Initial;
  const factory CurrenciesState.loading() = _Loading;
  const factory CurrenciesState.loaded(List<CurrencyModel> currencies) =
      _Loaded;
  const factory CurrenciesState.saving() = _Saving;
  const factory CurrenciesState.saveSuccess(List<CurrencyModel> currencies) =
      _SaveSuccess;
  const factory CurrenciesState.error(String message) = _Error;
}
