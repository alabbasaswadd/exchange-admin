import 'package:exchange_admin/core/components/app_button.dart';
import 'package:exchange_admin/core/components/app_indicator.dart';
import 'package:exchange_admin/core/components/app_snackbar.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/components/app_text_form_field.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/pages/currencies/cubit/currencies_cubit.dart';
import 'package:exchange_admin/pages/currencies/cubit/currencies_state.dart';
import 'package:exchange_admin/pages/currencies/model/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrenciesScreen extends StatefulWidget {
  const CurrenciesScreen({super.key});

  @override
  State<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CurrenciesCubit>().fetchCurrencies();
  }

  void _openAddSheet() {
    final cubit = context.read<CurrenciesCubit>();
    cubit.codeController.clear();
    cubit.nameController.clear();
    cubit.symbolController.clear();
    cubit.flagController.clear();
    _openSheet(cubit, isEdit: false);
  }

  void _openEditSheet(CurrencyModel currency) {
    final cubit = context.read<CurrenciesCubit>();
    cubit.populateForm(currency);
    _openSheet(cubit, isEdit: true, currency: currency);
  }

  void _openSheet(CurrenciesCubit cubit,
      {required bool isEdit, CurrencyModel? currency}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _CurrencyFormSheet(
          isEdit: isEdit,
          currencyId: currency?.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
      body: BlocConsumer<CurrenciesCubit, CurrenciesState>(
        listener: (context, state) {
          state.maybeWhen(
            saveSuccess: (_) {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(context, 'تمت العملية بنجاح');
            },
            error: (msg) => AppSnackbar.showError(context, msg),
            orElse: () {},
          );
        },
        builder: (context, state) => state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: AppIndicator()),
          loaded: (currencies) => _buildGrid(currencies),
          saving: () =>
              _buildGrid(context.read<CurrenciesCubit>().cachedCurrencies),
          saveSuccess: (currencies) => _buildGrid(currencies),
          error: (msg) => _buildError(msg),
        ),
      ),
    );
  }

  Widget _buildGrid(List<CurrencyModel> currencies) {
    if (currencies.isEmpty) return _buildEmpty();
    return RefreshIndicator(
      color: AppColors.kPrimaryColor,
      onRefresh: () => context.read<CurrenciesCubit>().fetchCurrencies(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: currencies.length,
        itemBuilder: (_, i) => _CurrencyCard(
          currency: currencies[i],
          onEdit: () => _openEditSheet(currencies[i]),
          onToggle: () =>
              context.read<CurrenciesCubit>().toggleActive(currencies[i]),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.paid_outlined, size: 72, color: cs.outline),
          const SizedBox(height: 16),
          AppText('لا توجد عملات', color: cs.outline, fontSize: 16),
          const SizedBox(height: 20),
          AppButton(
            text: 'إضافة عملة',
            onPressed: _openAddSheet,
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 64, color: cs.outline),
          const SizedBox(height: 16),
          AppText(message,
              color: cs.outline, fontSize: 14, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          AppButton(
            text: 'إعادة المحاولة',
            onPressed: () => context.read<CurrenciesCubit>().fetchCurrencies(),
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  final CurrencyModel currency;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const _CurrencyCard({
    required this.currency,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isActive = currency.isActive ?? false;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppColors.kPrimaryColor.withValues(alpha: 0.3)
              : cs.outline,
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    currency.flag ?? '💱',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onToggle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.kPrimaryColor.withValues(alpha: 0.1)
                            : cs.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isActive ? 'نشط' : 'معطل',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo-Bold',
                          color: isActive ? AppColors.kPrimaryColor : cs.outline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                currency.code ?? '—',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo-Bold',
                  color: AppColors.kPrimaryColor,
                ),
              ),
              Text(
                currency.name ?? '—',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Cairo-Bold',
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currency.symbol ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  Icon(Icons.edit_outlined,
                      size: 16, color: cs.onSurface.withValues(alpha: 0.4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Currency Form Sheet ───────────────────────────────────────────────────────

class _CurrencyFormSheet extends StatelessWidget {
  final bool isEdit;
  final int? currencyId;

  const _CurrencyFormSheet({required this.isEdit, this.currencyId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cubit = context.read<CurrenciesCubit>();

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Form(
          key: cubit.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: cs.outline,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      isEdit ? Icons.edit_rounded : Icons.add_rounded,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppText(
                    isEdit ? 'تعديل العملة' : 'إضافة عملة جديدة',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppTextFormField(
                label: 'رمز العملة (مثال: USD)',
                controller: cubit.codeController,
                icon: Icons.code_rounded,
                enabled: !isEdit,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'مطلوب' : null,
              ),
              AppTextFormField(
                label: 'اسم العملة',
                controller: cubit.nameController,
                icon: Icons.label_outline_rounded,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'مطلوب' : null,
              ),
              AppTextFormField(
                label: 'الرمز (مثال: \$)',
                controller: cubit.symbolController,
                icon: Icons.attach_money_rounded,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'مطلوب' : null,
              ),
              AppTextFormField(
                label: 'العلم (إيموجي، اختياري)',
                controller: cubit.flagController,
                icon: Icons.flag_outlined,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<CurrenciesCubit, CurrenciesState>(
                  builder: (_, state) => AppButton(
                    text: isEdit ? 'حفظ التغييرات' : 'إضافة',
                    onPressed: () => isEdit && currencyId != null
                        ? cubit.updateCurrency(currencyId!)
                        : cubit.createCurrency(),
                    isLoading: state.maybeWhen(
                        saving: () => true, orElse: () => false),
                    icon: isEdit ? Icons.save_rounded : Icons.add_rounded,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
