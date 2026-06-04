import 'package:exchange_admin/core/components/app_button.dart';
import 'package:exchange_admin/core/components/app_indicator.dart';
import 'package:exchange_admin/core/components/app_snackbar.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/components/app_text_form_field.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/pages/exchange_rates/cubit/exchange_rates_cubit.dart';
import 'package:exchange_admin/pages/exchange_rates/cubit/exchange_rates_state.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final _numFmt = NumberFormat('#,##0', 'en');

class ExchangeRatesScreen extends StatefulWidget {
  const ExchangeRatesScreen({super.key});

  @override
  State<ExchangeRatesScreen> createState() => _ExchangeRatesScreenState();
}

class _ExchangeRatesScreenState extends State<ExchangeRatesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExchangeRatesCubit>().fetchRates();
  }

  void _openEditSheet(ExchangeRateModel rate) {
    final cubit = context.read<ExchangeRatesCubit>();
    cubit.populateEditForm(rate);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _EditRateSheet(rateId: rate.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocConsumer<ExchangeRatesCubit, ExchangeRatesState>(
        listener: (context, state) {
          state.maybeWhen(
            updateSuccess: () {
              Navigator.of(context).pop();
              AppSnackbar.showSuccess(context, 'تم تحديث سعر الصرف بنجاح');
            },
            error: (msg) => AppSnackbar.showError(context, msg),
            orElse: () {},
          );
        },
        builder: (context, state) => state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: AppIndicator()),
          loaded: (rates) => _buildList(rates),
          updating: () =>
              _buildList(context.read<ExchangeRatesCubit>().cachedRates),
          updateSuccess: () =>
              _buildList(context.read<ExchangeRatesCubit>().cachedRates),
          error: (msg) => _buildError(msg),
        ),
      ),
    );
  }

  Widget _buildList(List<ExchangeRateModel> rates) {
    if (rates.isEmpty) return _buildEmpty();
    return RefreshIndicator(
      color: AppColors.kPrimaryColor,
      onRefresh: () => context.read<ExchangeRatesCubit>().fetchRates(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: rates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _RateCard(
          rate: rates[i],
          onEdit: () => _openEditSheet(rates[i]),
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
          Icon(Icons.currency_exchange_rounded, size: 72, color: cs.outline),
          const SizedBox(height: 16),
          AppText('لا توجد أسعار صرف', color: cs.outline, fontSize: 16),
          const SizedBox(height: 20),
          AppButton(
            text: 'تحديث',
            onPressed: () => context.read<ExchangeRatesCubit>().fetchRates(),
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              onPressed: () => context.read<ExchangeRatesCubit>().fetchRates(),
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _RateCard extends StatelessWidget {
  final ExchangeRateModel rate;
  final VoidCallback onEdit;

  const _RateCard({required this.rate, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final buy = rate.buyRate ?? 0;
    final sell = rate.sellRate ?? 0;
    final margin = sell - buy;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.kPrimaryColor, AppColors.kSecondColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${rate.fromCurrency ?? '—'} ⇄ ${rate.toCurrency ?? '—'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Cairo-Bold',
                    ),
                  ),
                ),
                const Spacer(),
                if (rate.isActive == true)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'نشط',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo-Bold',
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded, color: Colors.white),
                  tooltip: 'تعديل',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _RateBox(
                        label: 'سعر الشراء',
                        value: _numFmt.format(buy),
                        icon: Icons.arrow_downward_rounded,
                        accent: Colors.greenAccent)),
                const SizedBox(width: 12),
                Expanded(
                    child: _RateBox(
                        label: 'سعر البيع',
                        value: _numFmt.format(sell),
                        icon: Icons.arrow_upward_rounded,
                        accent: Colors.orangeAccent)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.trending_up_rounded,
                    color: Colors.white70, size: 14),
                const SizedBox(width: 6),
                Text(
                  'الهامش: ${_numFmt.format(margin)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'Cairo-Bold',
                  ),
                ),
                if (rate.updatedAt != null) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time_rounded,
                      color: Colors.white54, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(rate.updatedAt!),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontFamily: 'Cairo-Bold',
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _RateBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const _RateBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontFamily: 'Cairo-Bold',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo-Bold',
            ),
          ),
        ],
      ),
    );
  }
}

// ── Edit Sheet ────────────────────────────────────────────────────────────────

class _EditRateSheet extends StatefulWidget {
  final int rateId;
  const _EditRateSheet({required this.rateId});

  @override
  State<_EditRateSheet> createState() => _EditRateSheetState();
}

class _EditRateSheetState extends State<_EditRateSheet> {
  double _margin = 0;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ExchangeRatesCubit>();
    _recalc(cubit.buyRateController.text, cubit.sellRateController.text);
    cubit.buyRateController.addListener(_onChanged);
    cubit.sellRateController.addListener(_onChanged);
  }

  void _onChanged() {
    final c = context.read<ExchangeRatesCubit>();
    _recalc(c.buyRateController.text, c.sellRateController.text);
  }

  void _recalc(String buy, String sell) {
    final b = double.tryParse(buy) ?? 0;
    final s = double.tryParse(sell) ?? 0;
    setState(() => _margin = s - b);
  }

  @override
  void dispose() {
    final cubit = context.read<ExchangeRatesCubit>();
    cubit.buyRateController.removeListener(_onChanged);
    cubit.sellRateController.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cubit = context.read<ExchangeRatesCubit>();

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
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                    child: const Icon(Icons.edit_rounded,
                        color: AppColors.kPrimaryColor),
                  ),
                  const SizedBox(width: 12),
                  AppText('تعديل سعر الصرف',
                      fontSize: 17, fontWeight: FontWeight.w700),
                ],
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                label: 'سعر الشراء',
                controller: cubit.buyRateController,
                icon: Icons.arrow_downward_rounded,
                prefixIconColor: Colors.green,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'مطلوب';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) {
                    return 'قيمة غير صالحة';
                  }
                  return null;
                },
              ),
              AppTextFormField(
                label: 'سعر البيع',
                controller: cubit.sellRateController,
                icon: Icons.arrow_upward_rounded,
                prefixIconColor: Colors.orange,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'مطلوب';
                  final sell = double.tryParse(v);
                  if (sell == null || sell <= 0) return 'قيمة غير صالحة';
                  final buy =
                      double.tryParse(cubit.buyRateController.text) ?? 0;
                  if (sell <= buy) return 'يجب أن يكون أعلى من سعر الشراء';
                  return null;
                },
              ),
              if (_margin != 0) ...[
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: (_margin > 0 ? Colors.green : cs.error)
                        .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _margin > 0
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 16,
                        color: _margin > 0 ? Colors.green : cs.error,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'الهامش: ${_numFmt.format(_margin.abs())}',
                        style: TextStyle(
                          color: _margin > 0 ? Colors.green : cs.error,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo-Bold',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
                  builder: (_, state) => AppButton(
                    text: 'حفظ التغييرات',
                    onPressed: () => cubit.updateRate(widget.rateId),
                    isLoading: state.maybeWhen(
                        updating: () => true, orElse: () => false),
                    icon: Icons.save_rounded,
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
