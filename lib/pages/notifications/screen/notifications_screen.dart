import 'package:exchange_admin/core/components/app_indicator.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/pages/notifications/cubit/notifications_cubit.dart';
import 'package:exchange_admin/pages/notifications/cubit/notifications_state.dart';
import 'package:exchange_admin/pages/notifications/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().fetchNotifications();
  }

  List<NotificationModel> _applyFilter(List<NotificationModel> list) =>
      switch (_filter) {
        'unread' => list.where((n) => n.isRead == false).toList(),
        'read' => list.where((n) => n.isRead == true).toList(),
        _ => list,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) => state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: AppIndicator()),
          loaded: (notifications) => Column(
            children: [
              _FilterBar(
                selected: _filter,
                unreadCount:
                    notifications.where((n) => n.isRead == false).length,
                onChanged: (v) => setState(() => _filter = v),
                onMarkAll: () =>
                    context.read<NotificationsCubit>().markAllAsRead(),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.kPrimaryColor,
                  onRefresh: () =>
                      context.read<NotificationsCubit>().fetchNotifications(),
                  child: _applyFilter(notifications).isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.notifications_none_rounded,
                                        size: 72, color: cs.outline),
                                    const SizedBox(height: 16),
                                    AppText('لا توجد إشعارات',
                                        color: cs.outline, fontSize: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: _applyFilter(notifications).length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final item = _applyFilter(notifications)[i];
                            return _NotificationTile(
                              notification: item,
                              onTap: () => context
                                  .read<NotificationsCubit>()
                                  .markAsRead(item.id),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          error: (msg) => Center(
            child: AppText(msg,
                color: Theme.of(context).colorScheme.outline, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

// ── Filter Bar ────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final String selected;
  final int unreadCount;
  final ValueChanged<String> onChanged;
  final VoidCallback onMarkAll;

  const _FilterBar({
    required this.selected,
    required this.unreadCount,
    required this.onChanged,
    required this.onMarkAll,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Row(
        children: [
          _FilterChip(label: 'الكل', value: 'all', selected: selected, onTap: onChanged),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'غير مقروءة',
            value: 'unread',
            selected: selected,
            onTap: onChanged,
            badge: unreadCount > 0 ? unreadCount : null,
          ),
          const SizedBox(width: 8),
          _FilterChip(label: 'مقروءة', value: 'read', selected: selected, onTap: onChanged),
          const Spacer(),
          if (unreadCount > 0)
            TextButton(
              onPressed: onMarkAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'قراءة الكل',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Cairo-Bold',
                  color: AppColors.kPrimaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;
  final int? badge;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor
              : AppColors.kPrimaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : AppColors.kPrimaryColor,
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Cairo-Bold',
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.3)
                      : AppColors.kPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Notification Tile ─────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  Color _typeColor(BuildContext context) => switch (notification.type) {
        'request' => AppColors.kPrimaryColor,
        'approved' => AppColors.kSuccessColor,
        'rejected' => AppColors.kRedColor,
        'rate_update' => AppColors.kWarningColor,
        _ => Theme.of(context).colorScheme.outline,
      };

  IconData _typeIcon() => switch (notification.type) {
        'request' => Icons.swap_horiz_rounded,
        'approved' => Icons.check_circle_outline_rounded,
        'rejected' => Icons.cancel_outlined,
        'rate_update' => Icons.trending_up_rounded,
        _ => Icons.info_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isUnread = notification.isRead == false;
    final color = _typeColor(context);

    return InkWell(
      onTap: isUnread ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.kPrimaryColor.withValues(alpha: 0.04)
              : cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnread
                ? AppColors.kPrimaryColor.withValues(alpha: 0.2)
                : cs.outline.withValues(alpha: 0.3),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_typeIcon(), color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title ?? '',
                          style: TextStyle(
                            fontWeight: isUnread
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: 'Cairo-Bold',
                            color: cs.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Cairo-Bold',
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Cairo-Bold',
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'الآن';
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      return 'منذ ${diff.inDays} يوم';
    } catch (_) {
      return iso;
    }
  }
}
