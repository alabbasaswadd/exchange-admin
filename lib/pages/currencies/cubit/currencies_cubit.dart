import 'package:exchange_admin/core/constants/base_cubit.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/currencies/api/currencies_api.dart';
import 'package:exchange_admin/pages/currencies/cubit/currencies_state.dart';
import 'package:exchange_admin/pages/currencies/model/currency_model.dart';
import 'package:exchange_admin/pages/currencies/model/currency_request_model.dart';
import 'package:flutter/material.dart';

class CurrenciesCubit extends BaseCubit<CurrenciesState> {
  final CurrenciesApi _api;

  CurrenciesCubit(this._api) : super(const CurrenciesState.initial());

  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController symbolController = TextEditingController();
  final TextEditingController flagController = TextEditingController();

  List<CurrencyModel> _currencies = [];
  List<CurrencyModel> get cachedCurrencies => List.unmodifiable(_currencies);

  Future<void> fetchCurrencies() async {
    emit(const CurrenciesState.loading());
    final result = await _api.getCurrencies();
    result.when(
      success: (response) {
        _currencies = response.data ?? [];
        emit(CurrenciesState.loaded(_currencies));
      },
      failure: (error) =>
          emit(CurrenciesState.error(error.message ?? 'حدث خطأ')),
    );
  }

  Future<void> createCurrency() async {
    if (!validateForm()) return;

    await executeApi(
      request: () => _api.createCurrency(
        CreateCurrencyRequestModel(
          code: codeController.text.trim().toUpperCase(),
          name: nameController.text.trim(),
          symbol: symbolController.text.trim(),
          flag: flagController.text.trim().isEmpty
              ? null
              : flagController.text.trim(),
        ),
      ),
      onLoading: () => emit(const CurrenciesState.saving()),
      onSuccess: (response) async {
        if (response.data != null) {
          _currencies = [..._currencies, response.data!];
        }
        emit(CurrenciesState.saveSuccess(_currencies));
        emit(CurrenciesState.loaded(_currencies));
        _clearForm();
      },
      onError: (msg) {
        emit(CurrenciesState.loaded(_currencies));
        emit(CurrenciesState.error(msg));
      },
    );
  }

  Future<void> updateCurrency(int id) async {
    if (!validateForm()) return;

    await executeApi(
      request: () => _api.updateCurrency(
        id,
        UpdateCurrencyRequestModel(
          name: nameController.text.trim(),
          symbol: symbolController.text.trim(),
          flag: flagController.text.trim().isEmpty
              ? null
              : flagController.text.trim(),
        ),
      ),
      onLoading: () => emit(const CurrenciesState.saving()),
      onSuccess: (response) async {
        if (response.data != null) {
          _currencies =
              _currencies.map((c) => c.id == id ? response.data! : c).toList();
        }
        emit(CurrenciesState.saveSuccess(_currencies));
        emit(CurrenciesState.loaded(_currencies));
        _clearForm();
      },
      onError: (msg) {
        emit(CurrenciesState.loaded(_currencies));
        emit(CurrenciesState.error(msg));
      },
    );
  }

  Future<void> toggleActive(CurrencyModel currency) async {
    final result = await _api.updateCurrency(
      currency.id!,
      UpdateCurrencyRequestModel(isActive: !(currency.isActive ?? false)),
    );
    result.when(
      success: (response) {
        _currencies = _currencies
            .map((c) => c.id == currency.id
                ? (response.data ?? c.copyWith(isActive: !(currency.isActive ?? false)))
                : c)
            .toList();
        emit(CurrenciesState.loaded(_currencies));
      },
      failure: (error) =>
          emit(CurrenciesState.error(error.message ?? 'فشل تحديث العملة')),
    );
  }

  void populateForm(CurrencyModel currency) {
    codeController.text = currency.code ?? '';
    nameController.text = currency.name ?? '';
    symbolController.text = currency.symbol ?? '';
    flagController.text = currency.flag ?? '';
  }

  void _clearForm() {
    codeController.clear();
    nameController.clear();
    symbolController.clear();
    flagController.clear();
  }

  @override
  Future<void> close() {
    disposeControllers([
      codeController,
      nameController,
      symbolController,
      flagController,
    ]);
    return super.close();
  }
}
