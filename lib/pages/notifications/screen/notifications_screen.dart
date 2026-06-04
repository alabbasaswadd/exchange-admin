// import 'package:exchange_admin/core/components/app_button.dart';
// import 'package:exchange_admin/core/components/app_snackbar.dart';
// import 'package:exchange_admin/core/components/app_text.dart';
// import 'package:exchange_admin/core/components/shimmer_widgets.dart';
// import 'package:exchange_admin/core/constants/colors.dart';
// import 'package:exchange_admin/l10n/app_localizations.dart';
// import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
// import 'package:exchange_admin/pages/notifications/cubit/notifications_cubit.dart';
// import 'package:exchange_admin/pages/notifications/model/notification_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<NotificationsCubit>().fetchNotifications();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     return Scaffold(
//       appBar: AppBar(
//         title: AppText(t.notifications),
//         centerTitle: true,
//         actions: [
//           BlocBuilder<NotificationsCubit, SigninState<List<NotificationModel>>>(
//             builder: (context, state) {
//               final cubit = context.read<NotificationsCubit>();
//               final hasUnread = cubit.unreadCount > 0;
//               if (!hasUnread) return const SizedBox();
//               return TextButton.icon(
//                 onPressed: () => cubit.markAllAsRead(),
//                 icon: const Icon(
//                   Icons.done_all_rounded,
//                   size: 18,
//                   color: AppColors.kPrimaryColor,
//                 ),
//                 label: AppText(
//                   t.mark_all_read,
//                   fontSize: 12,
//                   color: AppColors.kPrimaryColor,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: BlocConsumer<NotificationsCubit,
//           SigninState<List<NotificationModel>>>(
//         listenWhen: (prev, curr) =>
//             prev.maybeWhen(loading: () => true, orElse: () => false),
//         listener: (context, state) {
//           state.maybeWhen(
//             error: (msg) => AppSnackbar.showError(context, msg),
//             orElse: () {},
//           );
//         },
//         builder: (context, state) {
//           return RefreshIndicator(
//             color: AppColors.kPrimaryColor,
//             onRefresh: () =>
//                 context.read<NotificationsCubit>().fetchNotifications(),
//             child: state.when(
//               initial: () => const SizedBox(),
//               loading: () => _buildShimmer(),
//               success: (notifications) => notifications.isEmpty
//                   ? _buildEmpty(t)
//                   : _buildList(notifications, t),
//               error: (msg) => _buildError(msg, t),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildShimmer() {
//     return ListView.separated(
//       padding: const EdgeInsets.all(16),
//       itemCount: 6,
//       separatorBuilder: (_, __) => const SizedBox(height: 10),
//       itemBuilder: (_, __) => ShimmerWidget.rectangular(height: 80),
//     );
//   }

//   Widget _buildEmpty(AppLocalizations t) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.notifications_none_rounded,
//             size: 72,
//             color: AppColors.kGreyColor.withOpacity(0.4),
//           ),
//           const SizedBox(height: 16),
//           AppText(
//             t.no_notifications,
//             fontSize: 16,
//             color: AppColors.kGreyColor,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildError(String message, AppLocalizations t) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline_rounded,
//               size: 64,
//               color: AppColors.kRedColor.withOpacity(0.6),
//             ),
//             const SizedBox(height: 16),
//             AppText(
//               message,
//               fontSize: 14,
//               color: AppColors.kGreyColor,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             AppButton(
//               text: t.retry,
//               icon: Icons.refresh_rounded,
//               onPressed: () =>
//                   context.read<NotificationsCubit>().fetchNotifications(),
//               padding: EdgeInsets.zero,
//               height: 44,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildList(List<NotificationModel> notifications, AppLocalizations t) {
//     return ListView.separated(
//       padding: const EdgeInsets.all(16),
//       itemCount: notifications.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 10),
//       itemBuilder: (_, index) => _NotificationCard(
//         notification: notifications[index],
//         onTap: () {
//           if (notifications[index].isRead != true) {
//             context
//                 .read<NotificationsCubit>()
//                 .markAsRead(notifications[index].id!);
//           }
//         },
//       ),
//     );
//   }
// }

// class _NotificationCard extends StatelessWidget {
//   final NotificationModel notification;
//   final VoidCallback onTap;

//   const _NotificationCard({required this.notification, required this.onTap});

//   Color _typeColor(String? type) {
//     switch (type?.toLowerCase()) {
//       case 'success':
//         return AppColors.kSuccessColor;
//       case 'warning':
//         return AppColors.kWarningColor;
//       case 'error':
//         return AppColors.kRedColor;
//       default:
//         return const Color(0xFF3B82F6);
//     }
//   }

//   IconData _typeIcon(String? type) {
//     switch (type?.toLowerCase()) {
//       case 'success':
//         return Icons.check_circle_outline_rounded;
//       case 'warning':
//         return Icons.warning_amber_outlined;
//       case 'error':
//         return Icons.error_outline_rounded;
//       default:
//         return Icons.info_outline_rounded;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final isRead = notification.isRead ?? false;
//     final typeColor = _typeColor(notification.type);
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(14),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           color: isRead
//               ? (isDark ? AppColors.kCardDark : Colors.white)
//               : typeColor.withOpacity(0.06),
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             if (!isDark)
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.06),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//           ],
//           border: Border.all(
//             color: isRead ? Colors.transparent : typeColor.withOpacity(0.3),
//             width: 1,
//           ),
//         ),
//         padding: const EdgeInsets.all(14),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: typeColor.withOpacity(0.15),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(_typeIcon(notification.type), color: typeColor, size: 20),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: AppText(
//                           notification.title ?? '—',
//                           fontSize: 14,
//                           fontWeight:
//                               isRead ? FontWeight.w400 : FontWeight.w700,
//                         ),
//                       ),
//                       if (!isRead)
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             color: typeColor,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                     ],
//                   ),
//                   if (notification.body != null) ...[
//                     const SizedBox(height: 4),
//                     AppText(
//                       notification.body!,
//                       fontSize: 13,
//                       color: AppColors.kGreyColor,
//                       maxLines: 2,
//                     ),
//                   ],
//                   if (notification.createdAt != null) ...[
//                     const SizedBox(height: 6),
//                     AppText(
//                       notification.createdAt!,
//                       fontSize: 11,
//                       color: AppColors.kGreyColor,
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
