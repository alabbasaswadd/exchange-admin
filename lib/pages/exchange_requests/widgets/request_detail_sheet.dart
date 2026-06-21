import 'package:exchange_admin/core/components/app_snackbar.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// REQUEST DETAIL BOTTOM SHEET  (shared between HomeScreen & ExchangeRequestsScreen)
// ─────────────────────────────────────────────────────────────────────────────

class RequestDetailSheet extends StatelessWidget {
  final ExchangeRequestModel request;

  const RequestDetailSheet({super.key, required this.request});

  static const _statusConfig = {
    0: (
      color: Color(0xFFF59E0B),
      label: 'معلّق',
      icon: Icons.hourglass_empty_rounded,
    ),
    1: (
      color: AppColors.kSuccessColor,
      label: 'مقبول',
      icon: Icons.check_circle_rounded,
    ),
    2: (
      color: AppColors.kRedColor,
      label: 'مرفوض',
      icon: Icons.cancel_rounded,
    ),
    3: (
      color: AppColors.kGreyColor,
      label: 'موقوف',
      icon: Icons.pause_circle_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cfg =
        _statusConfig[request.status] ??
        (
          color: AppColors.kGreyColor,
          label: '—',
          icon: Icons.help_outline_rounded,
        );
    final cubit = context.read<ExchangeRequestsCubit>();

    return BlocListener<
      ExchangeRequestsCubit,
      SigninState<List<ExchangeRequestModel>>
    >(
      listenWhen: (prev, curr) =>
          prev.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            AppSnackbar.showSuccess(context, 'تم تحديث حالة الطلب بنجاح');
            Navigator.pop(context);
          },
          error: (msg) => AppSnackbar.showError(context, msg),
          orElse: () {},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.kCardDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── handle ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.kGreyColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            // ── status header card ────────────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cfg.color.withValues(alpha: 0.14),
                    cfg.color.withValues(alpha: 0.04),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cfg.color.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cfg.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cfg.icon, color: cfg.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          'تفاصيل الطلب',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        if (request.requestNumber != null)
                          AppText(
                            '#${request.requestNumber}',
                            fontSize: 11,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.w400,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: cfg.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cfg.icon, size: 13, color: cfg.color),
                        const SizedBox(width: 4),
                        AppText(
                          cfg.label,
                          fontSize: 12,
                          color: cfg.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ── scrollable body ───────────────────────────────────────────
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    icon: Icons.person_outline_rounded,
                    label: 'الطالب',
                    value: request.user?.fullName ?? '—',
                  ),
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'التاريخ',
                    value: _fmtDateTime(request.createdAt ?? request.createdOn),
                  ),
                  const SizedBox(height: 14),
                  // ── exchange amounts block ────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.kPrimaryColor.withValues(alpha: 0.09),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // From
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppText(
                                    'المبلغ المُرسَل',
                                    fontSize: 10,
                                    color: AppColors.kGreyColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        _fmt(request.amount),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.kRedColor,
                                      ),
                                      if (request.fromCurrency?.code != null) ...[
                                        const SizedBox(width: 4),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 2),
                                          child: AppText(
                                            request.fromCurrency!.code!,
                                            fontSize: 12,
                                            color: AppColors.kRedColor.withValues(alpha: 0.7),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (request.fromCurrency?.name != null)
                                    AppText(
                                      request.fromCurrency!.name!,
                                      fontSize: 11,
                                      color: AppColors.kGreyColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                ],
                              ),
                            ),
                            // Arrow
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.trending_flat_rounded,
                                color: AppColors.kPrimaryColor,
                                size: 20,
                              ),
                            ),
                            // To
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const AppText(
                                    'المبلغ المُستلَم',
                                    fontSize: 10,
                                    color: AppColors.kGreyColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        _fmt(request.finalAmount),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.kSuccessColor,
                                      ),
                                      if (request.toCurrency?.code != null) ...[
                                        const SizedBox(width: 4),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 2),
                                          child: AppText(
                                            request.toCurrency!.code!,
                                            fontSize: 12,
                                            color: AppColors.kSuccessColor.withValues(alpha: 0.7),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (request.toCurrency?.name != null)
                                    AppText(
                                      request.toCurrency!.name!,
                                      fontSize: 11,
                                      color: AppColors.kGreyColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (request.appliedRate != null ||
                            request.commissionPercent != null) ...[
                          const SizedBox(height: 14),
                          Divider(
                            height: 1,
                            color: AppColors.kGreyColor.withValues(alpha: 0.15),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (request.appliedRate != null)
                                _MiniStat(
                                  label: 'سعر الصرف',
                                  value: _fmtRate(request.appliedRate!),
                                ),
                              if (request.commissionPercent != null)
                                _MiniStat(
                                  label: 'العمولة %',
                                  value: '${_fmt(request.commissionPercent)}%',
                                ),
                              if (request.commissionAmount != null)
                                _MiniStat(
                                  label: 'مبلغ العمولة',
                                  value: '${_fmt(request.commissionAmount)} ${request.fromCurrency?.code ?? ''}',
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (request.notes != null && request.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.notes_rounded,
                      label: 'ملاحظات',
                      value: request.notes!,
                    ),
                  ],
                  // ── action buttons (pending only) ─────────────────────
                  if (request.status == 0) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const AppText(
                          'اتخاذ إجراء',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<
                      ExchangeRequestsCubit,
                      SigninState<List<ExchangeRequestModel>>
                    >(
                      builder: (context, state) {
                        final isLoading = state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                        return Row(
                          children: [
                            Expanded(
                              child: _ActionButton(
                                label: 'قبول',
                                icon: Icons.check_circle_outline_rounded,
                                color: AppColors.kSuccessColor,
                                isLoading: isLoading,
                                onTap: () => _confirmAction(
                                  context,
                                  'قبول',
                                  AppColors.kSuccessColor,
                                  () => cubit.updateRequest(
                                    request.id!,
                                    const ExchangeRequestRequestModel(
                                      newStatus: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ActionButton(
                                label: 'رفض',
                                icon: Icons.cancel_outlined,
                                color: AppColors.kRedColor,
                                isLoading: isLoading,
                                onTap: () => _confirmAction(
                                  context,
                                  'رفض',
                                  AppColors.kRedColor,
                                  () => cubit.updateRequest(
                                    request.id!,
                                    const ExchangeRequestRequestModel(
                                      newStatus: 5,
                                      note: 'ما معي رصيد',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ActionButton(
                                label: 'تعليق',
                                icon: Icons.pause_circle_outline_rounded,
                                color: AppColors.kWarningColor,
                                isLoading: isLoading,
                                onTap: () => _confirmAction(
                                  context,
                                  'تعليق',
                                  AppColors.kWarningColor,
                                  () => cubit.updateRequest(
                                    request.id!,
                                    const ExchangeRequestRequestModel(
                                      newStatus: 0,
                                      note: 'تم تعليق الطلب مؤقتًا',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmAction(
    BuildContext context,
    String actionLabel,
    Color color,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const AppText('تأكيد الإجراء', fontWeight: FontWeight.w700),
        content: AppText('هل تريد $actionLabel هذا الطلب؟', maxLines: 2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: const AppText('إلغاء', color: AppColors.kGreyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dlgCtx);
              onConfirm();
            },
            child: AppText(actionLabel, color: color),
          ),
        ],
      ),
    );
  }

  String _fmt(double? v) {
    if (v == null) return '—';
    final isWhole = v == v.truncateToDouble();
    final raw = isWhole ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
    final parts = raw.split('.');
    final intWithCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return parts.length > 1 ? '$intWithCommas.${parts[1]}' : intWithCommas;
  }

  String _fmtRate(double v) {
    final s = v.toStringAsFixed(4);
    final parts = s.split('.');
    final intWithCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intWithCommas.${parts[1]}';
  }

  String _fmtDateTime(String? d) {
    if (d == null) return '—';
    try {
      final dt = DateTime.parse(d).toLocal();
      final date =
          '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$date  •  $hour:$minute';
    } catch (_) {
      return d;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.kGreyColor),
          const SizedBox(width: 8),
          AppText(
            label,
            fontSize: 12,
            color: AppColors.kGreyColor,
            fontWeight: FontWeight.w400,
          ),
          const Spacer(),
          AppText(
            value,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          label,
          fontSize: 10,
          color: AppColors.kGreyColor,
          fontWeight: FontWeight.w400,
        ),
        AppText(value, fontSize: 13, fontWeight: FontWeight.w700),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  color: color,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: 5),
            AppText(label, fontSize: 13, color: color, fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}
