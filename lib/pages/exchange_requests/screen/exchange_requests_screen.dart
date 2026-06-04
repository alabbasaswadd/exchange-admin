import 'package:exchange_admin/core/components/app_button.dart';
import 'package:exchange_admin/core/components/app_snackbar.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/components/shimmer_widgets.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/l10n/app_localizations.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeRequestsScreen extends StatefulWidget {
  const ExchangeRequestsScreen({super.key});

  @override
  State<ExchangeRequestsScreen> createState() =>
      _ExchangeRequestsScreenState();
}

class _ExchangeRequestsScreenState extends State<ExchangeRequestsScreen> {
  static const _filters = [
    ('all', 'الكل'),
    ('pending', 'معلقة'),
    ('accepted', 'مقبولة'),
    ('rejected', 'مرفوضة'),
    ('suspended', 'موقوفة'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<ExchangeRequestsCubit>().fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocConsumer<ExchangeRequestsCubit,
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
        final cubit = context.read<ExchangeRequestsCubit>();
        return Column(
          children: [
            _buildFilterChips(cubit, t),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.kPrimaryColor,
                onRefresh: () => cubit.fetchRequests(),
                child: state.when(
                  initial: () => const SizedBox(),
                  loading: () => _buildShimmer(),
                  success: (requests) => requests.isEmpty
                      ? _buildEmpty(t)
                      : _buildList(requests, cubit, t),
                  error: (msg) => _buildError(msg, t),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChips(ExchangeRequestsCubit cubit, AppLocalizations t) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final (value, label) = _filters[index];
          final isSelected = cubit.statusFilter == value;
          return FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => cubit.setFilter(value),
            selectedColor: AppColors.kPrimaryColor.withOpacity(0.2),
            checkmarkColor: AppColors.kPrimaryColor,
            labelStyle: TextStyle(
              color: isSelected
                  ? AppColors.kPrimaryColor
                  : AppColors.kGreyColor,
              fontFamily: 'Cairo-Bold',
              fontSize: 13,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => ShimmerWidget.rectangular(height: 130),
    );
  }

  Widget _buildEmpty(AppLocalizations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 72,
            color: AppColors.kGreyColor.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          AppText(t.no_requests, fontSize: 16, color: AppColors.kGreyColor),
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
              onPressed: () =>
                  context.read<ExchangeRequestsCubit>().fetchRequests(),
              padding: EdgeInsets.zero,
              height: 44,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    List<ExchangeRequestModel> requests,
    ExchangeRequestsCubit cubit,
    AppLocalizations t,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _RequestCard(
        request: requests[index],
        onAccept: requests[index].status == 'pending'
            ? () => _confirmAction(
                  context,
                  t.accept,
                  t.request_accepted,
                  AppColors.kSuccessColor,
                  () => cubit.acceptRequest(requests[index].id!),
                  t,
                )
            : null,
        onReject: requests[index].status == 'pending'
            ? () => _confirmAction(
                  context,
                  t.reject,
                  t.request_rejected,
                  AppColors.kRedColor,
                  () => cubit.rejectRequest(requests[index].id!),
                  t,
                )
            : null,
        onSuspend: requests[index].status == 'pending'
            ? () => _confirmAction(
                  context,
                  t.suspend,
                  t.request_suspended,
                  AppColors.kWarningColor,
                  () => cubit.suspendRequest(requests[index].id!),
                  t,
                )
            : null,
      ),
    );
  }

  void _confirmAction(
    BuildContext context,
    String actionLabel,
    String successMsg,
    Color color,
    VoidCallback onConfirm,
    AppLocalizations t,
  ) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        title: AppText(t.confirm_action),
        content: AppText('هل تريد $actionLabel هذا الطلب؟', maxLines: 2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: AppText(t.cancel, color: AppColors.kGreyColor),
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
}

class _RequestCard extends StatelessWidget {
  final ExchangeRequestModel request;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onSuspend;

  const _RequestCard({
    required this.request,
    this.onAccept,
    this.onReject,
    this.onSuspend,
  });

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return AppColors.kSuccessColor;
      case 'rejected':
        return AppColors.kRedColor;
      case 'suspended':
        return AppColors.kWarningColor;
      default:
        return AppColors.kGreyColor;
    }
  }

  String _statusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      case 'suspended':
        return 'موقوف';
      case 'pending':
        return 'معلق';
      default:
        return status ?? '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _statusColor(request.status);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border(
          right: BorderSide(color: statusColor, width: 4),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  request.requesterName ?? '—',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText(
                  _statusLabel(request.status),
                  fontSize: 12,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _InfoChip(
                icon: Icons.phone_outlined,
                label: request.requesterPhone ?? '—',
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.calendar_today_outlined,
                label: request.createdAt ?? '—',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'من: ${request.fromCurrencyCode ?? '—'}',
                      fontSize: 12,
                      color: AppColors.kGreyColor,
                    ),
                    AppText(
                      request.amount?.toStringAsFixed(2) ?? '—',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kPrimaryColor,
                    ),
                  ],
                ),
                const Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.kPrimaryColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      'إلى: ${request.toCurrencyCode ?? '—'}',
                      fontSize: 12,
                      color: AppColors.kGreyColor,
                    ),
                    AppText(
                      request.convertedAmount?.toStringAsFixed(2) ?? '—',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kSuccessColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onAccept != null || onReject != null || onSuspend != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (onAccept != null)
                  Expanded(
                    child: _ActionButton(
                      label: 'قبول',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.kSuccessColor,
                      onTap: onAccept!,
                    ),
                  ),
                if (onAccept != null && onReject != null)
                  const SizedBox(width: 8),
                if (onReject != null)
                  Expanded(
                    child: _ActionButton(
                      label: 'رفض',
                      icon: Icons.cancel_outlined,
                      color: AppColors.kRedColor,
                      onTap: onReject!,
                    ),
                  ),
                if (onSuspend != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      label: 'تعليق',
                      icon: Icons.pause_circle_outline_rounded,
                      color: AppColors.kWarningColor,
                      onTap: onSuspend!,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.kGreyColor),
        const SizedBox(width: 4),
        AppText(label, fontSize: 12, color: AppColors.kGreyColor),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            AppText(label, fontSize: 12, color: color),
          ],
        ),
      ),
    );
  }
}
