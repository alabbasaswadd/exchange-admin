import 'package:exchange_admin/core/constants/base_cubit.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/exchange_rates/api/exchange_rates_api.dart';
import 'package:exchange_admin/pages/exchange_rates/cubit/exchange_rates_state.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:exchange_admin/pages/exchange_rates/model/update_rate_request_model.dart';
import 'package:flutter/material.dart';

class ExchangeRatesCubit extends BaseCubit<ExchangeRatesState> {
  final ExchangeRatesApi _api;

  ExchangeRatesCubit(this._api) : super(const ExchangeRatesState.initial());

  final TextEditingController buyRateController = TextEditingController();
  final TextEditingController sellRateController = TextEditingController();

  List<ExchangeRateModel> _rates = [];
  List<ExchangeRateModel> get cachedRates => List.unmodifiable(_rates);

  Future<void> fetchRates() async {
    emit(const ExchangeRatesState.loading());
    final result = await _api.getExchangeRates();
    result.when(
      success: (response) {
        _rates = response.data ?? [];
        emit(ExchangeRatesState.loaded(_rates));
      },
      failure: (error) =>
          emit(ExchangeRatesState.error(error.message ?? 'حدث خطأ')),
    );
  }

  Future<void> updateRate(int id) async {
    if (!validateForm()) return;

    final buy = double.tryParse(buyRateController.text.trim());
    final sell = double.tryParse(sellRateController.text.trim());
    if (buy == null || buy <= 0 || sell == null || sell <= 0 || sell <= buy) {
      return;
    }

    await executeApi(
      request: () => _api.updateExchangeRate(
        id,
        UpdateRateRequestModel(buyRate: buy, sellRate: sell),
      ),
      onLoading: () => emit(const ExchangeRatesState.updating()),
      onSuccess: (response) async {
        if (response.data != null) {
          _rates = _rates.map((r) => r.id == id ? response.data! : r).toList();
        } else {
          _rates = _rates
              .map((r) => r.id == id
                  ? r.copyWith(
                      buyRate: buy,
                      sellRate: sell,
                      updatedAt: DateTime.now().toIso8601String(),
                    )
                  : r)
              .toList();
        }
        emit(const ExchangeRatesState.updateSuccess());
        emit(ExchangeRatesState.loaded(_rates));
      },
      onError: (msg) {
        emit(ExchangeRatesState.loaded(_rates));
        emit(ExchangeRatesState.error(msg));
      },
    );
  }

  void populateEditForm(ExchangeRateModel rate) {
    buyRateController.text = rate.buyRate?.toStringAsFixed(0) ?? '';
    sellRateController.text = rate.sellRate?.toStringAsFixed(0) ?? '';
  }

  @override
  Future<void> close() {
    disposeControllers([buyRateController, sellRateController]);
    return super.close();
  }
}
