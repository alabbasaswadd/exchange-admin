import 'package:exchange_admin/core/components/app_indicator.dart';
import 'package:exchange_admin/core/components/app_snackbar.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_state.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final _numFmt = NumberFormat('#,##0.##', 'en');

const _statusFilters = [
  ('الكل', null),
  ('قيد الانتظار', 'pending'),
  ('مقبول', 'approved'),
  ('مرفوض', 'rejected'),
  ('معلق', 'on_hold'),
  ('مكتمل', 'completed'),
];

class ExchangeRequestsScreen extends StatefulWidget {
  const ExchangeRequestsScreen({super.key});

  @override
  State<ExchangeRequestsScreen> createState() => _ExchangeRequestsScreenState();
}

class _ExchangeRequestsScreenState extends State<ExchangeRequestsScreen> {
  String? _activeStatus;

  @override
  void initState() {
    super.initState();
    context.read<ExchangeRequestsCubit>().fetchRequests();
  }

  void _setFilter(String? status) {
    setState(() => _activeStatus = status);
    context.read<ExchangeRequestsCubit>().fetchRequests(status: status);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: BlocConsumer<ExchangeRequestsCubit, ExchangeRequestsState>(
              listener: (context, state) {
                state.maybeWhen(
                  updateSuccess: (_) =>
                      AppSnackbar.showSuccess(context, 'تم تحديث حالة الطلب'),
                  error: (msg) => AppSnackbar.showError(context, msg),
                  orElse: () {},
                );
              },
              builder: (context, state) => state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const Center(child: AppIndicator()),
                loaded: (requests) => _buildList(requests),
                updating: (requests, __) => _buildList(requests),
                updateSuccess: (requests) => _buildList(requests),
                error: (msg) => _buildError(msg),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _statusFilters.map((f) {
            final isSelected = _activeStatus == f.$2;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FilterChip(
                label: Text(
                  f.$1,
                  style: TextStyle(
                    fontFamily: 'Cairo-Bold',
                    fontSize: 12,
                    color: isSelected
                        ? Colors.white
                        : cs.onSurface.withValues(alpha: 0.7),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => _setFilter(f.$2),
                backgroundColor: cs.surface,
                selectedColor: AppColors.kPrimaryColor,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? AppColors.kPrimaryColor
                      : cs.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildList(List<ExchangeRequestModel> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded,
                size: 72, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            AppText('لا توجد طلبات',
                color: Theme.of(context).colorScheme.outline, fontSize: 16),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: AppColors.kPrimaryColor,
      onRefresh: () =>
          context.read<ExchangeRequestsCubit>().fetchRequests(status: _activeStatus),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: requests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _RequestCard(request: requests[i]),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          AppText(message,
              color: Theme.of(context).colorScheme.outline,
              fontSize: 14,
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context
                .read<ExchangeRequestsCubit>()
                .fetchRequests(status: _activeStatus),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة',
                style: TextStyle(fontFamily: 'Cairo-Bold')),
          ),
        ],
      ),
    );
  }
}

// ── Request Card ──────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final ExchangeRequestModel request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isBuy = request.type == 'buy';
    final isPending = request.status == 'pending';

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isBuy ? AppColors.kPrimaryColor : Colors.orange)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isBuy ? 'شراء' : 'بيع',
                    style: TextStyle(
                      color: isBuy ? AppColors.kPrimaryColor : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: 'Cairo-Bold',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '#${request.requestNumber ?? request.id}',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontFamily: 'Cairo-Bold',
                  ),
                ),
                const Spacer(),
                _StatusChip(status: request.status),
              ],
            ),
            const SizedBox(height: 12),
            // Client info
            Row(
              children: [
                Icon(Icons.person_outline_rounded,
                    size: 16, color: cs.onSurface.withValues(alpha: 0.5)),
                const SizedBox(width: 6),
                Text(
                  request.clientName ?? '—',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo-Bold',
                    fontSize: 14,
                    color: cs.onSurface,
                  ),
                ),
                const Spacer(),
                Icon(Icons.phone_outlined,
                    size: 16, color: cs.onSurface.withValues(alpha: 0.5)),
                const SizedBox(width: 4),
                Text(
                  request.clientPhone ?? '—',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Cairo-Bold',
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Amounts
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.outline.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _AmountCol(
                      label: request.fromCurrencyCode ?? '—',
                      value: _numFmt.format(request.amount ?? 0),
                    ),
                  ),
                  Icon(Icons.compare_arrows_rounded,
                      color: AppColors.kPrimaryColor, size: 22),
                  Expanded(
                    child: _AmountCol(
                      label: request.toCurrencyCode ?? '—',
                      value: _numFmt.format(request.equivalentAmount ?? 0),
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
            ),
            // Rate & date
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'السعر: ${_numFmt.format(request.rate ?? 0)}',
                  style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Cairo-Bold',
                      color: cs.onSurface.withValues(alpha: 0.5)),
                ),
                const Spacer(),
                Text(
                  _formatDate(request.createdAt),
                  style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Cairo-Bold',
                      color: cs.onSurface.withValues(alpha: 0.5)),
                ),
              ],
            ),
            // Action buttons (only for pending)
            if (isPending) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              _ActionButtons(requestId: request.id!),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null) return '—';
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _AmountCol extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _AmountCol({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final align =
        alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'Cairo-Bold',
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo-Bold',
            color: AppColors.kPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final int requestId;

  const _ActionButtons({required this.requestId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExchangeRequestsCubit>();

    return BlocBuilder<ExchangeRequestsCubit, ExchangeRequestsState>(
      builder: (context, state) {
        final isUpdating = state.maybeWhen(
          updating: (_, id) => id == requestId,
          orElse: () => false,
        );

        return Row(
          children: [
            Expanded(
              child: _ActionBtn(
                label: 'قبول',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.kPrimaryColor,
                isLoading: isUpdating,
                onPressed: () =>
                    cubit.updateStatus(requestId, 'approved'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionBtn(
                label: 'تعليق',
                icon: Icons.pause_circle_outline_rounded,
                color: AppColors.kWarningColor,
                isLoading: isUpdating,
                onPressed: () =>
                    cubit.updateStatus(requestId, 'on_hold'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionBtn(
                label: 'رفض',
                icon: Icons.cancel_outlined,
                color: AppColors.kRedColor,
                isLoading: isUpdating,
                onPressed: () =>
                    cubit.updateStatus(requestId, 'rejected'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback onPressed;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: color),
            )
          : Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo-Bold',
          fontSize: 12,
          color: color,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 6),
        minimumSize: const Size(0, 36),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String? status;

  const _StatusChip({this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'pending' => ('قيد الانتظار', AppColors.kWarningColor),
      'approved' => ('مقبول', AppColors.kPrimaryColor),
      'rejected' => ('مرفوض', AppColors.kRedColor),
      'on_hold' => ('معلق', Colors.blue),
      'completed' => ('مكتمل', AppColors.kSecondColor),
      _ => ('غير معروف', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo-Bold',
        ),
      ),
    );
  }
}
