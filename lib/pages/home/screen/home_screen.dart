import 'dart:math' show min;
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:exchange_admin/core/components/app_alert_dialog.dart';
import 'package:exchange_admin/core/components/app_button.dart';
import 'package:exchange_admin/core/components/app_snackbar.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/components/app_text_form_field.dart';
import 'package:exchange_admin/core/components/custom_appbar.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/core/constants/functions.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/currencies/cubit/currencies_cubit.dart';
import 'package:exchange_admin/pages/currencies/model/currency_model.dart';
import 'package:exchange_admin/pages/exchange_rates/cubit/exchange_rates_cubit.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_admin/pages/exchange_requests/widgets/request_detail_sheet.dart';
import 'package:exchange_admin/pages/notifications/cubit/notifications_cubit.dart';
import 'package:exchange_admin/pages/notifications/model/notification_model.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _pkg = 'com.shmacash.shamcash';

  // Tries Flutter route extras with CLEAR_TASK (forces cold-start so the route
  // extra is actually processed), then falls back to opening the app home.
  Future<void> _openShamCashSend(BuildContext context) async {
    // Common send/transfer route guesses for a Flutter exchange app.
    const routes = [
      '/send',
      '/transfer',
      '/new-order',
      '/create-order',
      '/exchange',
    ];

    for (final route in routes) {
      try {
        await AndroidIntent(
          action: 'android.intent.action.MAIN',
          package: _pkg,
          componentName: '$_pkg.MainActivity',
          arguments: <String, dynamic>{'route': route},
          // CLEAR_TASK + NEW_TASK forces the app to restart so Flutter
          // actually reads the route extra instead of resuming the old state.
          flags: <int>[
            Flag.FLAG_ACTIVITY_NEW_TASK,
            Flag.FLAG_ACTIVITY_CLEAR_TASK,
          ],
        ).launch();
        return;
      } catch (_) {
        continue;
      }
    }

    // Nothing worked — open the app home.
    try {
      await LaunchApp.openApp(androidPackageName: _pkg, openStore: false);
    } catch (_) {
      if (context.mounted) {
        AppSnackbar.showError(context, 'تطبيق شام كاش غير مثبت');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'مرحبا ${UserSession.fullName}',
        centerTitle: false,
        fontColor: Colors.white,
        backgroundColor: isDark
            ? AppColors.kPrimaryColorDarkMode
            : AppColors.kPrimaryColor,
        actions: [
          BlocBuilder<NotificationsCubit, List<NotificationModel>>(
            builder: (context, _) {
              final unread = context.read<NotificationsCubit>().unreadCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),

                    onPressed: () => _openShamCashSend(context),
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 8,
                      right: 6,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.kRedColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: AppText(
                          unread > 9 ? '9+' : '$unread',
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (contextt) => AppAlertDialog(
                  onOk: () {
                    context.read<SigninCubit>().logout();
                    contextt.go('/signin');
                  },
                  onNo: contextt.pop,
                  title: "تسجيل الخروج",
                  content: "هل تريد تسجبل الخروج ؟",
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      backgroundColor: isDark
          ? AppColors.kBackgroundDark
          : const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 48),
            sliver: SliverList(
              delegate: SliverChildListDelegate([const _MainCard()]),
            ),
          ),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// MAIN CARD  (stateful — owns fromCode / toCode)
// ─────────────────────────────────────────────────────────────────────────────

class _MainCard extends StatefulWidget {
  const _MainCard();

  @override
  State<_MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<_MainCard> {
  String _fromCode = '';
  String _toCode = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── gradient top section ────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppColors.kPrimaryColorDarkMode,
                          AppColors.kSecondColorDarkMode,
                        ]
                      : [AppColors.kPrimaryColor, const Color(0xFF047857)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildRateSection(context)],
              ),
            ),
            // ── white bottom section — recent requests ──────────────────
            _buildRecentRequests(context, isDark),
          ],
        ),
      ),
    );
  }

  // ── Greeting ──────────────────────────────────────────────────────────────

  // ── Rate section (header + dropdowns + rate display in one block) ─────────

  Widget _buildRateSection(BuildContext context) {
    return BlocBuilder<
      ExchangeRatesCubit,
      SigninState<List<ExchangeRateModel>>
    >(
      builder: (context, rateState) {
        final isLoading = rateState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final rates = rateState.maybeWhen(
          success: (r) => r,
          orElse: () => <ExchangeRateModel>[],
        );

        // Build code→id map from the currencies already loaded
        final currencies = context.read<CurrenciesCubit>().state.maybeWhen(
          success: (c) => c,
          orElse: () => <CurrencyModel>[],
        );
        final codeToId = {
          for (final c in currencies)
            if (c.code != null && c.id != null) c.code!: c.id!,
        };
        final fromId = codeToId[_fromCode];
        final toId = codeToId[_toCode];

        ExchangeRateModel? rate;
        for (final r in rates) {
          // Primary: match by currency ID (works even when nested objects are null)
          final byId =
              fromId != null &&
              toId != null &&
              r.fromCurrencyId == fromId &&
              r.toCurrencyId == toId;
          // Fallback: match by nested currency code
          final byCode =
              r.fromCurrency?.code == _fromCode &&
              r.toCurrency?.code == _toCode;
          if (byId || byCode) {
            rate = r;
            break;
          }
        }

        final spread = rate != null
            ? (rate.sellRate ?? 0) - (rate.buyRate ?? 0)
            : 0.0;
        final spreadPct =
            rate != null && rate.buyRate != null && rate.buyRate! > 0
            ? (spread / rate.buyRate!) * 100
            : 0.0;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            children: [
              // header
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const AppText(
                    'سعر الصرف الحالي',
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  AppText(
                    '$_fromCode / $_toCode',
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                  ),
                  if (rate != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        final cubit = context.read<ExchangeRatesCubit>();
                        cubit.prepareForEdit(rate!);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: _EditRateSheet(rate: rate!),
                          ),
                        );
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              // dropdown row with embedded rates
              BlocBuilder<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
                builder: (context, currState) {
                  final currencies = currState.maybeWhen(
                    success: (c) => c,
                    orElse: () => <CurrencyModel>[],
                  );
                  if (_fromCode.isEmpty && currencies.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _fromCode = currencies[0].code ?? '';
                          _toCode = currencies.length > 1
                              ? (currencies[1].code ?? '')
                              : _fromCode;
                        });
                      }
                    });
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _CurrencyDropdownButton(
                          currencies: currencies,
                          selectedCode: _fromCode,
                          label: 'من',
                          rateValue: rate?.buyRate,
                          rateLabel: 'شراء',
                          rateColor: const Color(0xFF34D399),
                          rateIcon: Icons.trending_up_rounded,
                          isLoadingRate: isLoading,
                          onTap: () => _showPicker(context, currencies, true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            final tmp = _fromCode;
                            _fromCode = _toCode;
                            _toCode = tmp;
                          }),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.24),
                              ),
                            ),
                            child: const Icon(
                              Icons.swap_horiz_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _CurrencyDropdownButton(
                          currencies: currencies,
                          selectedCode: _toCode,
                          label: 'إلى',
                          rateValue: rate?.sellRate,
                          rateLabel: 'بيع',
                          rateColor: const Color(0xFFFCA5A5),
                          rateIcon: Icons.trending_down_rounded,
                          isLoadingRate: isLoading,
                          onTap: () => _showPicker(context, currencies, false),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // not found
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentRequests(BuildContext context, bool isDark) {
    return Container(
      color: isDark ? AppColors.kCardDark : Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.kSuccessColor, Color(0xFF15803D)],
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: AppText(
                    'آخر طلبات الصرف',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/history'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const AppText(
                    'السجل الكامل',
                    fontSize: 12,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.06),
          ),
          BlocBuilder<
            ExchangeRequestsCubit,
            SigninState<List<ExchangeRequestModel>>
          >(
            builder: (context, state) {
              return state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => _recentShimmer(),
                success: (all) {
                  final recent = all.take(5).toList();
                  if (recent.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: AppText(
                          'لا توجد طلبات صرف',
                          color: AppColors.kGreyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: recent
                        .asMap()
                        .entries
                        .map(
                          (e) => _RequestRow(
                            request: e.value,
                            isLast: e.key == recent.length - 1,
                            onTap: () => _openRequestDetail(context, e.value),
                          ),
                        )
                        .toList(),
                  );
                },
                error: (_) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _recentShimmer() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: List.generate(
          3,
          (i) => Container(
            margin: EdgeInsets.only(bottom: i < 2 ? 10 : 0),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  // ── Detail opener ─────────────────────────────────────────────────────────

  void _openRequestDetail(BuildContext context, ExchangeRequestModel request) {
    final cubit = context.read<ExchangeRequestsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: RequestDetailSheet(request: request),
      ),
    );
  }

  // ── Picker opener ─────────────────────────────────────────────────────────

  void _showPicker(
    BuildContext context,
    List<CurrencyModel> currencies,
    bool isFrom,
  ) {
    final currCubit = context.read<CurrenciesCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: currCubit,
        child: _CurrencyPickerSheet(
          selectedCode: isFrom ? _fromCode : _toCode,
          onSelected: (code) => setState(() {
            if (isFrom) {
              _fromCode = code;
            } else {
              _toCode = code;
            }
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY DROPDOWN BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyDropdownButton extends StatelessWidget {
  final List<CurrencyModel> currencies;
  final String selectedCode;
  final String label;
  final VoidCallback onTap;
  final double? rateValue;
  final String? rateLabel;
  final Color? rateColor;
  final IconData? rateIcon;
  final bool isLoadingRate;

  const _CurrencyDropdownButton({
    required this.currencies,
    required this.selectedCode,
    required this.label,
    required this.onTap,
    this.rateValue,
    this.rateLabel,
    this.rateColor,
    this.rateIcon,
    this.isLoadingRate = false,
  });

  String _fmt(double v) =>
      v < 100 ? v.toStringAsFixed(3) : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    CurrencyModel? sel;
    for (final c in currencies) {
      if (c.code == selectedCode) {
        sel = c;
        break;
      }
    }

    final color = rateColor ?? Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.11),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── top row: direction label + arrow ─────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  label,
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w500,
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // ── currency identity ─────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // symbol badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    sel?.symbol ??
                        (selectedCode.isNotEmpty ? selectedCode[0] : '?'),
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        selectedCode.isEmpty ? '—' : selectedCode,
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      if (sel?.name != null)
                        AppText(
                          sel!.name!,
                          fontSize: 9,
                          color: Colors.white.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w400,
                          maxLines: 1,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // ── rate section ──────────────────────────────────────────────
            if (isLoadingRate) ...[
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
              const SizedBox(height: 10),
              Container(
                height: 12,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 20,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ] else if (rateValue != null) ...[
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(rateIcon, color: color, size: 12),
                  const SizedBox(width: 4),
                  AppText(
                    rateLabel ?? '',
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              AppText(
                _fmt(rateValue!),
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EDIT RATE BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _EditRateSheet extends StatelessWidget {
  final ExchangeRateModel rate;

  const _EditRateSheet({required this.rate});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExchangeRatesCubit>();
    return BlocConsumer<
      ExchangeRatesCubit,
      SigninState<List<ExchangeRateModel>>
    >(
      listenWhen: (p, c) =>
          p.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            AppSnackbar.showSuccess(context, 'تم تحديث سعر الصرف بنجاح');
            Navigator.pop(context);
          },
          error: (msg) => AppSnackbar.showError(context, msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        return _BottomSheet(
          title: 'تعديل سعر الصرف',
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                AppTextFormField(
                  label: 'سعر الشراء',
                  controller: cubit.buyRateController,
                  icon: Icons.trending_up_rounded,
                  prefixIconColor: AppColors.kSuccessColor,
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'سعر البيع',
                  controller: cubit.sellRateController,
                  icon: Icons.trending_down_rounded,
                  prefixIconColor: AppColors.kRedColor,
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'نسبة العمولة %',
                  controller: cubit.commissionController,
                  icon: Icons.percent_rounded,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: 'حفظ التغييرات',
                  onPressed: () => cubit.updateRate(rate.id!),
                  isLoading: isLoading,
                  icon: Icons.save_rounded,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY PICKER BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final String selectedCode;
  final ValueChanged<String> onSelected;

  const _CurrencyPickerSheet({
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          const SizedBox(height: 14),
          const AppText(
            'اختر العملة',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 14),
          _searchField(isDark),
          const SizedBox(height: 12),
          BlocBuilder<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
            builder: (context, state) {
              final all = state.maybeWhen(
                success: (c) => c,
                orElse: () => <CurrencyModel>[],
              );
              final filtered = _query.isEmpty
                  ? all
                  : all
                        .where(
                          (c) =>
                              (c.code?.toLowerCase().contains(_query) ??
                                  false) ||
                              (c.name?.toLowerCase().contains(_query) ??
                                  false) ||
                              (c.symbol?.toLowerCase().contains(_query) ??
                                  false),
                        )
                        .toList();

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: min(filtered.length * 66.0 + 8, 300),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                  itemBuilder: (ctx, i) {
                    final c = filtered[i];
                    return _CurrencyPickerItem(
                      currency: c,
                      isSelected: c.code == widget.selectedCode,
                      onTap: () {
                        widget.onSelected(c.code!);
                        Navigator.pop(context);
                      },
                      onLongPress: () => _openEdit(context, c),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _addButton(context),
        ],
      ),
    );
  }

  Widget _handle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.kGreyColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _searchField(bool isDark) {
    return TextField(
      onChanged: (v) => setState(() => _query = v.toLowerCase().trim()),
      style: const TextStyle(fontFamily: 'Cairo-Bold', fontSize: 13),
      decoration: InputDecoration(
        hintText: 'ابحث عن عملة...',
        hintStyle: const TextStyle(
          fontFamily: 'Cairo-Bold',
          fontSize: 13,
          color: AppColors.kGreyColor,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.kGreyColor,
          size: 20,
        ),
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : const Color(0xFFF0F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _openAdd(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.kPrimaryColor,
          side: BorderSide(
            color: AppColors.kPrimaryColor.withValues(alpha: 0.45),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
        label: const AppText(
          'إضافة عملة جديدة',
          fontSize: 13,
          color: AppColors.kPrimaryColor,
        ),
      ),
    );
  }

  void _openEdit(BuildContext context, CurrencyModel currency) {
    final cubit = context.read<CurrenciesCubit>();
    cubit.prepareForEdit(currency);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _CurrencyFormSheet(isEdit: true, currencyId: currency.id),
      ),
    );
  }

  void _openAdd(BuildContext context) {
    final cubit = context.read<CurrenciesCubit>();
    cubit.prepareForAdd();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _CurrencyFormSheet(isEdit: false),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY PICKER LIST ITEM
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyPickerItem extends StatelessWidget {
  final CurrencyModel currency;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CurrencyPickerItem({
    required this.currency,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currency.isActive ?? false;
    final gradientColors = isActive
        ? [AppColors.kPrimaryColor, const Color(0xFF047857)]
        : [AppColors.kGreyColor, const Color(0xFF94A3B8)];

    return Material(
      color: isSelected
          ? AppColors.kPrimaryColor.withValues(alpha: 0.05)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: AppText(
                  currency.symbol ?? '',
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      currency.code ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText(
                      currency.name ?? '',
                      fontSize: 11,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              if (!isActive)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kGreyColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const AppText(
                    'معطل',
                    fontSize: 9,
                    color: AppColors.kGreyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.kPrimaryColor,
                    size: 20,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.more_vert_rounded,
                    size: 16,
                    color: AppColors.kGreyColor.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY FORM SHEET  (add / edit)
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyFormSheet extends StatefulWidget {
  final bool isEdit;
  final String? currencyId;

  const _CurrencyFormSheet({required this.isEdit, this.currencyId});

  @override
  State<_CurrencyFormSheet> createState() => _CurrencyFormSheetState();
}

class _CurrencyFormSheetState extends State<_CurrencyFormSheet> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CurrenciesCubit>();
    return BlocConsumer<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
      listenWhen: (p, c) =>
          p.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            AppSnackbar.showSuccess(
              context,
              widget.isEdit ? 'تم تحديث العملة' : 'تمت إضافة العملة',
            );
            Navigator.pop(context);
          },
          error: (msg) => AppSnackbar.showError(context, msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        return _BottomSheet(
          title: widget.isEdit ? 'تعديل العملة' : 'إضافة عملة جديدة',
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                AppTextFormField(
                  label: 'اسم العملة',
                  controller: cubit.nameController,
                  icon: Icons.label_outline_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'رمز العملة (مثال: USD)',
                  controller: cubit.codeController,
                  icon: Icons.code_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'الرمز (مثال: \$)',
                  controller: cubit.symbolController,
                  icon: Icons.attach_money_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 6, 5, 4),
                  child: Row(
                    children: [
                      const AppText('حالة العملة', fontSize: 14),
                      const Spacer(),
                      StatefulBuilder(
                        builder: (_, set) => Switch.adaptive(
                          value: cubit.isActiveValue,
                          activeColor: AppColors.kPrimaryColor,
                          onChanged: (v) => set(() => cubit.isActiveValue = v),
                        ),
                      ),
                      AppText(
                        cubit.isActiveValue ? 'نشطة' : 'معطلة',
                        fontSize: 12,
                        color: cubit.isActiveValue
                            ? AppColors.kSuccessColor
                            : AppColors.kGreyColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: widget.isEdit ? 'حفظ التعديلات' : 'إضافة العملة',
                  onPressed: () => widget.isEdit
                      ? cubit.updateCurrency(widget.currencyId!)
                      : cubit.addCurrency(),
                  isLoading: isLoading,
                  icon: widget.isEdit ? Icons.save_rounded : Icons.add_rounded,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RequestRow extends StatelessWidget {
  final ExchangeRequestModel request;
  final bool isLast;
  final VoidCallback? onTap;

  const _RequestRow({required this.request, required this.isLast, this.onTap});

  static const _statusConfig = {
    0: (
      icon: Icons.hourglass_empty_rounded,
      color: Color(0xFFF59E0B),
      label: 'معلّق',
    ),
    1: (
      icon: Icons.check_rounded,
      color: AppColors.kSuccessColor,
      label: 'مقبول',
    ),
    2: (icon: Icons.close_rounded, color: AppColors.kRedColor, label: 'مرفوض'),
    3: (icon: Icons.pause_rounded, color: AppColors.kGreyColor, label: 'موقوف'),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cfg =
        _statusConfig[request.status] ??
        (
          icon: Icons.help_outline_rounded,
          color: AppColors.kGreyColor,
          label: '—',
        );

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              child: Row(
                children: [
                  // ── status icon ───────────────────────────────────────
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cfg.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cfg.icon, color: cfg.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // ── text content ──────────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppText(
                                request.user?.fullName ?? '—',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: cfg.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: AppText(
                                cfg.label,
                                fontSize: 10,
                                color: cfg.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            AppText(
                              '${_fmt(request.amount)} ${request.fromCurrency?.code ?? ''}',
                              fontSize: 11,
                              color: AppColors.kRedColor,
                              fontWeight: FontWeight.w600,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 10,
                                color: AppColors.kGreyColor,
                              ),
                            ),
                            AppText(
                              '${_fmt(request.finalAmount)} ${request.toCurrency?.code ?? ''}',
                              fontSize: 11,
                              color: AppColors.kSuccessColor,
                              fontWeight: FontWeight.w600,
                            ),
                            const Spacer(),
                            AppText(
                              _fmtDate(request.createdAt ?? request.createdOn),
                              fontSize: 10,
                              color: AppColors.kGreyColor.withValues(
                                alpha: 0.6,
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  // ── chevron ───────────────────────────────────────────
                  Icon(
                    Icons.chevron_left_rounded,
                    size: 18,
                    color: AppColors.kGreyColor.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 70,
            endIndent: 16,
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
      ],
    );
  }

  String _fmt(double? v) {
    if (v == null) return '—';
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}م';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}ك';
    return v.toStringAsFixed(0);
  }

  String _fmtDate(String? d) {
    if (d == null) return '';
    try {
      final dt = DateTime.parse(d);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return d;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED BOTTOM SHEET CONTAINER
// ─────────────────────────────────────────────────────────────────────────────

class _BottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _BottomSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.kGreyColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          AppText(title, fontSize: 16, fontWeight: FontWeight.w700),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
