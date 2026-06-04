import 'package:exchange_admin/core/components/app_snackbar.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const _filters = [
    ('all', 'الكل'),
    ('pending', 'معلق'),
    ('accepted', 'مقبول'),
    ('rejected', 'مرفوض'),
    ('suspended', 'موقوف'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<ExchangeRequestsCubit>();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.kBackgroundDark : AppColors.kBackgroundLight,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.kPrimaryColorDarkMode : AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
        title: const AppText(
          'سجل طلبات الصرف',
          color: Colors.white,
          fontSize: 17,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterBar(cubit),
          Expanded(
            child: BlocConsumer<ExchangeRequestsCubit,
                SigninState<List<ExchangeRequestModel>>>(
              listenWhen: (prev, curr) =>
                  prev.maybeWhen(loading: () => true, orElse: () => false),
              listener: (context, state) {
                state.maybeWhen(
                  error: (msg) => AppSnackbar.showError(context, msg),
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  success: (requests) => _buildList(context, requests),
                  error: (msg) => _buildError(msg),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ExchangeRequestsCubit cubit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.kCardDark : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: BlocBuilder<ExchangeRequestsCubit,
          SigninState<List<ExchangeRequestModel>>>(
        builder: (context, state) {
          final selected = cubit.statusFilter;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((f) {
                final isSelected = f.$1 == selected;
                final count = state.maybeWhen(
                  success: (list) => f.$1 == 'all'
                      ? list.length
                      : list
                          .where((r) =>
                              r.status?.toLowerCase() == f.$1)
                          .length,
                  orElse: () => 0,
                );
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => cubit.setFilter(f.$1)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _filterColor(f.$1)
                            : _filterColor(f.$1).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            f.$2,
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : _filterColor(f.$1),
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : _filterColor(f.$1).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: AppText(
                              '$count',
                              fontSize: 10,
                              color: isSelected
                                  ? Colors.white
                                  : _filterColor(f.$1),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Color _filterColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.kWarningColor;
      case 'accepted':
        return AppColors.kSuccessColor;
      case 'rejected':
        return AppColors.kRedColor;
      case 'suspended':
        return AppColors.kGreyColor;
      default:
        return AppColors.kPrimaryColor;
    }
  }

  Widget _buildList(
      BuildContext context, List<ExchangeRequestModel> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded,
                size: 64,
                color: AppColors.kGreyColor.withValues(alpha: 0.35)),
            const SizedBox(height: 16),
            const AppText(
              'لا توجد طلبات',
              fontSize: 16,
              color: AppColors.kGreyColor,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _HistoryRequestCard(request: requests[i]),
    );
  }

  Widget _buildError(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: AppColors.kRedColor),
            const SizedBox(height: 12),
            AppText(msg,
                fontSize: 14,
                color: AppColors.kGreyColor,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w400),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _HistoryRequestCard extends StatelessWidget {
  final ExchangeRequestModel request;

  const _HistoryRequestCard({required this.request});

  Color get _statusColor {
    switch (request.status?.toLowerCase()) {
      case 'accepted':
        return AppColors.kSuccessColor;
      case 'rejected':
        return AppColors.kRedColor;
      case 'suspended':
        return AppColors.kGreyColor;
      default:
        return AppColors.kWarningColor;
    }
  }

  String get _statusLabel {
    switch (request.status?.toLowerCase()) {
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      case 'suspended':
        return 'موقوف';
      default:
        return 'معلق';
    }
  }

  IconData get _statusIcon {
    switch (request.status?.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'suspended':
        return Icons.pause_circle_filled_rounded;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPending = request.status?.toLowerCase() == 'pending';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          right: BorderSide(color: _statusColor, width: 3),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.kPrimaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            request.requesterName ?? '—',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          AppText(
                            request.requesterPhone ?? '',
                            fontSize: 11,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_statusIcon,
                                  color: _statusColor, size: 12),
                              const SizedBox(width: 4),
                              AppText(
                                _statusLabel,
                                fontSize: 11,
                                color: _statusColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          _formatDate(request.createdAt),
                          fontSize: 10,
                          color:
                              AppColors.kGreyColor.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Exchange flow
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : AppColors.kBackgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ExchangeFlow(
                          fromCode: request.fromCurrencyCode ?? '—',
                          fromAmount: _formatAmount(request.amount),
                          toCode: request.toCurrencyCode ?? '—',
                          toAmount:
                              _formatAmount(request.convertedAmount),
                        ),
                      ),
                    ],
                  ),
                ),
                if (request.exchangeRate != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.swap_horiz_rounded,
                          size: 13, color: AppColors.kGreyColor),
                      const SizedBox(width: 4),
                      AppText(
                        'سعر الصرف المطبق: ',
                        fontSize: 11,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                      AppText(
                        request.exchangeRate!.toStringAsFixed(2),
                        fontSize: 12,
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ],
                if (request.notes != null && request.notes!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.kWarningColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.kWarningColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notes_rounded,
                            size: 13, color: AppColors.kWarningColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppText(
                            request.notes!,
                            fontSize: 11,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.w400,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isPending)
            _PendingActionsBar(request: request),
        ],
      ),
    );
  }

  String _formatAmount(double? amount) {
    if (amount == null) return '—';
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}م';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}ك';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    try {
      final d = DateTime.parse(date);
      final months = [
        '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return '${d.day} ${months[d.month]} ${d.year}  '
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
  }
}

class _ExchangeFlow extends StatelessWidget {
  final String fromCode;
  final String fromAmount;
  final String toCode;
  final String toAmount;

  const _ExchangeFlow({
    required this.fromCode,
    required this.fromAmount,
    required this.toCode,
    required this.toAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _CurrencyAmount(code: fromCode, amount: fromAmount, isFrom: true),
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.kPrimaryColor, AppColors.kSecondColor],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(height: 2),
            const AppText(
              'تحويل',
              fontSize: 9,
              color: AppColors.kGreyColor,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        _CurrencyAmount(code: toCode, amount: toAmount, isFrom: false),
      ],
    );
  }
}

class _CurrencyAmount extends StatelessWidget {
  final String code;
  final String amount;
  final bool isFrom;

  const _CurrencyAmount({
    required this.code,
    required this.amount,
    required this.isFrom,
  });

  @override
  Widget build(BuildContext context) {
    final color = isFrom ? AppColors.kRedColor : AppColors.kSuccessColor;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AppText(code, fontSize: 13, color: color,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        AppText(amount, fontSize: 16, fontWeight: FontWeight.w700),
      ],
    );
  }
}

class _PendingActionsBar extends StatelessWidget {
  final ExchangeRequestModel request;

  const _PendingActionsBar({required this.request});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExchangeRequestsCubit>();
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x12000000))),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          _ActionChip(
            label: 'قبول',
            icon: Icons.check_rounded,
            color: AppColors.kSuccessColor,
            onTap: () => _confirm(context, 'قبول الطلب',
                () => cubit.acceptRequest(request.id!)),
          ),
          const _VerticalDivider(),
          _ActionChip(
            label: 'رفض',
            icon: Icons.close_rounded,
            color: AppColors.kRedColor,
            onTap: () => _confirm(context, 'رفض الطلب',
                () => cubit.rejectRequest(request.id!)),
          ),
          const _VerticalDivider(),
          _ActionChip(
            label: 'تعليق',
            icon: Icons.pause_rounded,
            color: AppColors.kGreyColor,
            onTap: () => _confirm(context, 'تعليق الطلب',
                () => cubit.suspendRequest(request.id!)),
          ),
        ],
      ),
    );
  }

  void _confirm(
      BuildContext context, String title, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText(title),
        content: AppText('هل أنت متأكد من تنفيذ هذا الإجراء؟',
            maxLines: 2, fontWeight: FontWeight.w400),
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
            child: const AppText('تأكيد', color: AppColors.kPrimaryColor),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: 5),
              AppText(label, fontSize: 12, color: color,
                  fontWeight: FontWeight.w700),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: const Color(0x12000000));
  }
}
