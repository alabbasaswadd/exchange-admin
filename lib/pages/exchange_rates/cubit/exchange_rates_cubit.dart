import 'package:exchange_admin/core/constants/base_cubit.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/exchange_rates/api/exchange_rates_api.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:flutter/material.dart';

class ExchangeRatesCubit
    extends BaseCubit<SigninState<List<ExchangeRateModel>>> {
  final ExchangeRatesApi api;

  ExchangeRatesCubit(this.api) : super(const SigninState.initial());

  final TextEditingController buyRateController = TextEditingController();
  final TextEditingController sellRateController = TextEditingController();

  List<ExchangeRateModel> _rates = [];

  static final List<ExchangeRateModel> _mockRates = [
    ExchangeRateModel(
      id: '1',
      fromCurrencyId: 'c1',
      toCurrencyId: 'c2',
      fromCurrencyName: 'دولار أمريكي',
      toCurrencyName: 'ليرة سورية',
      fromCurrencyCode: 'USD',
      toCurrencyCode: 'SYP',
      buyRate: 12800.0,
      sellRate: 13000.0,
      updatedAt: '2026-06-04T10:30:00',
    ),
    ExchangeRateModel(
      id: '2',
      fromCurrencyId: 'c3',
      toCurrencyId: 'c2',
      fromCurrencyName: 'يورو',
      toCurrencyName: 'ليرة سورية',
      fromCurrencyCode: 'EUR',
      toCurrencyCode: 'SYP',
      buyRate: 13900.0,
      sellRate: 14200.0,
      updatedAt: '2026-06-04T10:30:00',
    ),
    ExchangeRateModel(
      id: '3',
      fromCurrencyId: 'c4',
      toCurrencyId: 'c2',
      fromCurrencyName: 'جنيه إسترليني',
      toCurrencyName: 'ليرة سورية',
      fromCurrencyCode: 'GBP',
      toCurrencyCode: 'SYP',
      buyRate: 16100.0,
      sellRate: 16500.0,
      updatedAt: '2026-06-03T14:00:00',
    ),
    ExchangeRateModel(
      id: '4',
      fromCurrencyId: 'c5',
      toCurrencyId: 'c2',
      fromCurrencyName: 'ليرة تركية',
      toCurrencyName: 'ليرة سورية',
      fromCurrencyCode: 'TRY',
      toCurrencyCode: 'SYP',
      buyRate: 370.0,
      sellRate: 385.0,
      updatedAt: '2026-06-04T08:15:00',
    ),
    ExchangeRateModel(
      id: '5',
      fromCurrencyId: 'c6',
      toCurrencyId: 'c2',
      fromCurrencyName: 'دينار أردني',
      toCurrencyName: 'ليرة سورية',
      fromCurrencyCode: 'JOD',
      toCurrencyCode: 'SYP',
      buyRate: 18000.0,
      sellRate: 18400.0,
      updatedAt: '2026-06-04T09:00:00',
    ),
  ];

  Future<void> fetchRates() async {
    emit(const SigninState.loading());
    await Future.delayed(const Duration(milliseconds: 700));
    _rates = List.from(_mockRates);
    emit(SigninState.success(List.from(_rates)));
  }

  Future<void> updateRate(String id) async {
    if (!validateForm()) return;

    final buyRate = double.tryParse(buyRateController.text.trim());
    final sellRate = double.tryParse(sellRateController.text.trim());

    if (buyRate == null || sellRate == null) {
      emit(const SigninState.error('الرجاء إدخال قيم صحيحة'));
      emit(SigninState.success(List.from(_rates)));
      return;
    }

    if (sellRate <= buyRate) {
      emit(const SigninState.error('سعر البيع يجب أن يكون أعلى من سعر الشراء'));
      emit(SigninState.success(List.from(_rates)));
      return;
    }

    emit(const SigninState.loading());
    await Future.delayed(const Duration(milliseconds: 500));
    _rates = _rates.map((rate) {
      if (rate.id == id) {
        return rate.copyWith(buyRate: buyRate, sellRate: sellRate);
      }
      return rate;
    }).toList();
    emit(SigninState.success(List.from(_rates)));
  }

  void prepareForEdit(ExchangeRateModel rate) {
    buyRateController.text = rate.buyRate?.toString() ?? '';
    sellRateController.text = rate.sellRate?.toString() ?? '';
  }

  @override
  Future<void> close() {
    disposeControllers([buyRateController, sellRateController]);
    return super.close();
  }
}
