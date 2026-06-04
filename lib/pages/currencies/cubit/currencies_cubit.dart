import 'package:exchange_admin/core/constants/base_cubit.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/currencies/api/currencies_api.dart';
import 'package:exchange_admin/pages/currencies/model/currency_model.dart';
import 'package:flutter/material.dart';

class CurrenciesCubit extends BaseCubit<SigninState<List<CurrencyModel>>> {
  final CurrenciesApi api;

  CurrenciesCubit(this.api) : super(const SigninState.initial());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController symbolController = TextEditingController();
  bool isActiveValue = true;

  List<CurrencyModel> _currencies = [];
  int _nextId = 10;

  static final List<CurrencyModel> _mockCurrencies = [
    CurrencyModel(
      id: '1',
      name: 'دولار أمريكي',
      code: 'USD',
      symbol: '\$',
      isActive: true,
      createdAt: '2026-01-01',
    ),
    CurrencyModel(
      id: '2',
      name: 'ليرة سورية',
      code: 'SYP',
      symbol: 'ل.س',
      isActive: true,
      createdAt: '2026-01-01',
    ),
    CurrencyModel(
      id: '3',
      name: 'يورو',
      code: 'EUR',
      symbol: '€',
      isActive: true,
      createdAt: '2026-01-15',
    ),
    CurrencyModel(
      id: '4',
      name: 'جنيه إسترليني',
      code: 'GBP',
      symbol: '£',
      isActive: true,
      createdAt: '2026-01-15',
    ),
    CurrencyModel(
      id: '5',
      name: 'ليرة تركية',
      code: 'TRY',
      symbol: '₺',
      isActive: true,
      createdAt: '2026-02-01',
    ),
    CurrencyModel(
      id: '6',
      name: 'دينار أردني',
      code: 'JOD',
      symbol: 'د.أ',
      isActive: false,
      createdAt: '2026-02-10',
    ),
  ];

  Future<void> fetchCurrencies() async {
    emit(const SigninState.loading());
    await Future.delayed(const Duration(milliseconds: 600));
    _currencies = List.from(_mockCurrencies);
    emit(SigninState.success(List.from(_currencies)));
  }

  Future<void> addCurrency() async {
    if (!validateForm()) return;

    emit(const SigninState.loading());
    await Future.delayed(const Duration(milliseconds: 500));

    final newCurrency = CurrencyModel(
      id: '${_nextId++}',
      name: nameController.text.trim(),
      code: codeController.text.trim().toUpperCase(),
      symbol: symbolController.text.trim(),
      isActive: isActiveValue,
      createdAt: DateTime.now().toIso8601String().substring(0, 10),
    );

    _currencies = [..._currencies, newCurrency];
    emit(SigninState.success(List.from(_currencies)));
  }

  Future<void> updateCurrency(String id) async {
    if (!validateForm()) return;

    emit(const SigninState.loading());
    await Future.delayed(const Duration(milliseconds: 500));

    _currencies = _currencies.map((c) {
      if (c.id == id) {
        return c.copyWith(
          name: nameController.text.trim(),
          code: codeController.text.trim().toUpperCase(),
          symbol: symbolController.text.trim(),
          isActive: isActiveValue,
        );
      }
      return c;
    }).toList();
    emit(SigninState.success(List.from(_currencies)));
  }

  Future<void> deleteCurrency(String id) async {
    emit(const SigninState.loading());
    await Future.delayed(const Duration(milliseconds: 400));
    _currencies = _currencies.where((c) => c.id != id).toList();
    emit(SigninState.success(List.from(_currencies)));
  }

  void prepareForAdd() {
    nameController.clear();
    codeController.clear();
    symbolController.clear();
    isActiveValue = true;
  }

  void prepareForEdit(CurrencyModel currency) {
    nameController.text = currency.name ?? '';
    codeController.text = currency.code ?? '';
    symbolController.text = currency.symbol ?? '';
    isActiveValue = currency.isActive ?? true;
  }

  @override
  Future<void> close() {
    disposeControllers([nameController, codeController, symbolController]);
    return super.close();
  }
}
