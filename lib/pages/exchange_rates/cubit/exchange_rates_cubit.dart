import 'package:exchange_admin/core/constants/base_cubit.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/exchange_rates/api/exchange_rates_api.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_request_model.dart';
import 'package:flutter/material.dart';

class ExchangeRatesCubit
    extends BaseCubit<SigninState<List<ExchangeRateModel>>> {
  final ExchangeRatesApi api;

  ExchangeRatesCubit(this.api) : super(const SigninState.initial());

  final TextEditingController buyRateController = TextEditingController();
  final TextEditingController sellRateController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();

  ExchangeRateModel? _editingRate;

  Future<void> fetchRates() async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.getRates(),
      onSuccess: (data) async => emit(SigninState.success(data)),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  Future<void> updateRate(String id) async {
    if (!validateForm()) return;

    final buyRate = double.tryParse(buyRateController.text.trim());
    final sellRate = double.tryParse(sellRateController.text.trim());
    final commission = int.tryParse(commissionController.text.trim());

    if (buyRate == null || sellRate == null) {
      emit(const SigninState.error('الرجاء إدخال قيم صحيحة'));
      return;
    }

    if (sellRate <= buyRate) {
      emit(const SigninState.error('سعر البيع يجب أن يكون أعلى من سعر الشراء'));
      return;
    }

    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.updateRate(
        id,
        ExchangeRateRequestModel(
          buyRate: buyRate,
          sellRate: sellRate,
          commissionPercent: commission ?? _editingRate?.commissionPercent,
          isActive: _editingRate?.isActive,
        ),
      ),
      onSuccess: (_) async => fetchRates(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  void prepareForEdit(ExchangeRateModel rate) {
    _editingRate = rate;
    buyRateController.text = rate.buyRate?.toString() ?? '';
    sellRateController.text = rate.sellRate?.toString() ?? '';
    commissionController.text = rate.commissionPercent?.toString() ?? '';
  }

  @override
  Future<void> close() {
    disposeControllers([
      buyRateController,
      sellRateController,
      commissionController,
    ]);
    return super.close();
  }
}
