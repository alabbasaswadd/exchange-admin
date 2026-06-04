import 'package:exchange_admin/core/components/app_button.dart';
import 'package:exchange_admin/core/components/app_snackbar.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/components/app_text_form_field.dart';
import 'package:exchange_admin/core/components/shimmer_widgets.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/l10n/app_localizations.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/currencies/cubit/currencies_cubit.dart';
import 'package:exchange_admin/pages/currencies/model/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrenciesScreen extends StatefulWidget {
  const CurrenciesScreen({super.key});

  @override
  State<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CurrenciesCubit>().fetchCurrencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocConsumer<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
      listenWhen: (prev, curr) =>
          prev.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          error: (msg) => AppSnackbar.showError(context, msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                _buildSearch(t),
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.kPrimaryColor,
                    onRefresh: () =>
                        context.read<CurrenciesCubit>().fetchCurrencies(),
                    child: state.when(
                      initial: () => const SizedBox(),
                      loading: () => _buildShimmer(),
                      success: (currencies) {
                        final filtered = currencies
                            .where(
                              (c) =>
                                  _searchQuery.isEmpty ||
                                  (c.name ?? '')
                                      .toLowerCase()
                                      .contains(_searchQuery) ||
                                  (c.code ?? '')
                                      .toLowerCase()
                                      .contains(_searchQuery),
                            )
                            .toList();
                        return filtered.isEmpty
                            ? _buildEmpty(t)
                            : _buildList(filtered, t);
                      },
                      error: (msg) => _buildError(msg, t),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: AppButton(
                text: t.add_currency,
                icon: Icons.add_rounded,
                onPressed: () => _showFormSheet(context, null, t),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearch(AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
        decoration: InputDecoration(
          hintText: t.search,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => ShimmerWidget.rectangular(height: 80),
    );
  }

  Widget _buildEmpty(AppLocalizations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.money_off_rounded,
            size: 72,
            color: AppColors.kGreyColor.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          AppText(t.no_currencies, fontSize: 16, color: AppColors.kGreyColor),
        ],
      ),
    );
  }

  Widget _buildError(String message, AppLocalizations t) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.kRedColor.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            AppText(
              message,
              fontSize: 14,
              color: AppColors.kGreyColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: t.retry,
              icon: Icons.refresh_rounded,
              onPressed: () => context.read<CurrenciesCubit>().fetchCurrencies(),
              padding: EdgeInsets.zero,
              height: 44,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<CurrencyModel> currencies, AppLocalizations t) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: currencies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) => _CurrencyCard(
        currency: currencies[index],
        onEdit: () => _showFormSheet(context, currencies[index], t),
        onDelete: () => _confirmDelete(context, currencies[index], t),
      ),
    );
  }

  void _showFormSheet(
    BuildContext context,
    CurrencyModel? currency,
    AppLocalizations t,
  ) {
    final cubit = context.read<CurrenciesCubit>();
    if (currency == null) {
      cubit.prepareForAdd();
    } else {
      cubit.prepareForEdit(currency);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => BlocProvider.value(
        value: cubit,
        child: _CurrencyFormSheet(
          editingId: currency?.id,
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    CurrencyModel currency,
    AppLocalizations t,
  ) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        title: AppText(t.confirm_delete),
        content: AppText(
          '${t.delete_confirm_message} "${currency.name}"؟',
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: AppText(t.cancel, color: AppColors.kGreyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dlgCtx);
              context.read<CurrenciesCubit>().deleteCurrency(currency.id!);
            },
            child: AppText(t.delete, color: AppColors.kRedColor),
          ),
        ],
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  final CurrencyModel currency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CurrencyCard({
    required this.currency,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = currency.isActive ?? true;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: AppText(
              currency.symbol ?? '?',
              fontSize: 18,
              color: AppColors.kPrimaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        currency.name ?? '—',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: (isActive
                                ? AppColors.kSuccessColor
                                : AppColors.kGreyColor)
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        isActive ? 'نشط' : 'غير نشط',
                        fontSize: 11,
                        color: isActive
                            ? AppColors.kSuccessColor
                            : AppColors.kGreyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AppText(
                  '${currency.code ?? '—'} · ${currency.symbol ?? '—'}',
                  fontSize: 12,
                  color: AppColors.kGreyColor,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded, size: 20),
            color: AppColors.kPrimaryColor,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            color: AppColors.kRedColor,
          ),
        ],
      ),
    );
  }
}

class _CurrencyFormSheet extends StatefulWidget {
  final String? editingId;

  const _CurrencyFormSheet({this.editingId});

  @override
  State<_CurrencyFormSheet> createState() => _CurrencyFormSheetState();
}

class _CurrencyFormSheetState extends State<_CurrencyFormSheet> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cubit = context.read<CurrenciesCubit>();
    final isEdit = widget.editingId != null;

    return BlocConsumer<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
      listenWhen: (prev, curr) =>
          prev.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            Navigator.pop(context);
            AppSnackbar.showSuccess(
              context,
              isEdit ? t.currency_updated : t.currency_added,
            );
          },
          error: (msg) => AppSnackbar.showError(context, msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading =
            state.maybeWhen(loading: () => true, orElse: () => false);
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: cubit.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.kGreyColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppText(
                  isEdit ? t.edit_currency : t.add_currency,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  label: t.currency_name,
                  controller: cubit.nameController,
                  icon: Icons.label_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? t.currency_name_required : null,
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  label: t.currency_code,
                  controller: cubit.codeController,
                  icon: Icons.code_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? t.currency_code_required : null,
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  label: t.currency_symbol,
                  controller: cubit.symbolController,
                  icon: Icons.attach_money_rounded,
                  textInputAction: TextInputAction.done,
                  validator: (v) =>
                      (v == null || v.isEmpty)
                          ? t.currency_symbol_required
                          : null,
                ),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (_, setInnerState) => SwitchListTile(
                    value: cubit.isActiveValue,
                    onChanged: (v) {
                      cubit.isActiveValue = v;
                      setInnerState(() {});
                    },
                    title: AppText(t.is_active),
                    activeColor: AppColors.kPrimaryColor,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: t.save,
                    icon: Icons.save_rounded,
                    isLoading: isLoading,
                    onPressed: isEdit
                        ? () => cubit.updateCurrency(widget.editingId!)
                        : () => cubit.addCurrency(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
