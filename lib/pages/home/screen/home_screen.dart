import 'package:exchange_admin/core/components/app_button.dart';
import 'package:exchange_admin/core/components/app_snackbar.dart';
import 'package:exchange_admin/core/components/app_text.dart';
import 'package:exchange_admin/core/components/app_text_form_field.dart';
import 'package:exchange_admin/core/constants/cached/cached_helper.dart';
import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/currencies/cubit/currencies_cubit.dart';
import 'package:exchange_admin/pages/currencies/model/currency_model.dart';
import 'package:exchange_admin/pages/exchange_rates/cubit/exchange_rates_cubit.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_admin/pages/notifications/cubit/notifications_cubit.dart';
import 'package:exchange_admin/pages/notifications/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.kBackgroundDark
          : AppColors.kBackgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _NotificationsSection(),
                const SizedBox(height: 8),
                const _StatsSection(),
                const SizedBox(height: 8),
                const _ExchangeRatesSection(),
                const SizedBox(height: 8),
                const _CurrenciesSection(),
                const SizedBox(height: 8),
                const _ExchangeRequestsSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      stretch: true,
      backgroundColor:
          isDark ? AppColors.kPrimaryColorDarkMode : AppColors.kPrimaryColor,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppColors.kPrimaryColorDarkMode,
                      AppColors.kSecondColorDarkMode,
                    ]
                  : [AppColors.kPrimaryColor, AppColors.kSecondColor],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        'مرحباً، المدير',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      AppText(
                        'لوحة التحكم الرئيسية',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  const Spacer(),
                  BlocBuilder<NotificationsCubit, List<NotificationModel>>(
                    builder: (context, notifications) {
                      final unread = context
                          .read<NotificationsCubit>()
                          .unreadCount;
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                          if (unread > 0)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: AppColors.kRedColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
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
                  _LogoutButton(),
                ],
              ),
            ),
          ),
        ),
        title: AppText(
          'لوحة التحكم',
          color: Colors.white,
          fontSize: 16,
        ),
        centerTitle: true,
        titlePadding:
            const EdgeInsets.only(bottom: 12, left: 56, right: 56),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
      onSelected: (value) {
        if (value == 'logout') _confirmLogout(context);
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded,
                  color: AppColors.kRedColor, size: 20),
              const SizedBox(width: 8),
              AppText('تسجيل الخروج', color: AppColors.kRedColor),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText('تسجيل الخروج'),
        content: AppText('هل أنت متأكد أنك تريد تسجيل الخروج؟',
            maxLines: 2, fontWeight: FontWeight.w400),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: AppText('إلغاء', color: AppColors.kGreyColor),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dlgCtx);
              await CacheHelper.remove('token');
              if (context.mounted) context.go('/signin');
            },
            child: AppText('خروج', color: AppColors.kRedColor),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          AppText(title, fontSize: 16, fontWeight: FontWeight.w700),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NOTIFICATIONS SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, List<NotificationModel>>(
      builder: (context, notifications) {
        if (notifications.isEmpty) return const SizedBox.shrink();
        final cubit = context.read<NotificationsCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _SectionHeader(
              title: 'الإشعارات',
              icon: Icons.notifications_rounded,
              iconColor: const Color(0xFF3B82F6),
              trailing: cubit.unreadCount > 0
                  ? TextButton(
                      onPressed: cubit.markAllAsRead,
                      child: AppText(
                        'تحديد الكل كمقروء',
                        fontSize: 12,
                        color: AppColors.kPrimaryColor,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) => _NotificationCard(
                  notification: notifications[i],
                  onTap: () => cubit.markAsRead(notifications[i].id!),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  Color get _color {
    switch (notification.type?.toLowerCase()) {
      case 'success':
        return AppColors.kSuccessColor;
      case 'warning':
        return AppColors.kWarningColor;
      case 'error':
        return AppColors.kRedColor;
      default:
        return const Color(0xFF3B82F6);
    }
  }

  IconData get _icon {
    switch (notification.type?.toLowerCase()) {
      case 'success':
        return Icons.check_circle_outline_rounded;
      case 'warning':
        return Icons.warning_amber_outlined;
      case 'error':
        return Icons.error_outline_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRead = notification.isRead ?? false;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isRead
              ? (isDark ? AppColors.kCardDark : Colors.white)
              : _color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isRead ? Colors.transparent : _color.withOpacity(0.3),
            width: 1.2,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_icon, color: _color, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: AppText(
                    notification.title ?? '',
                    fontSize: 12,
                    fontWeight:
                        isRead ? FontWeight.w400 : FontWeight.w700,
                    maxLines: 1,
                  ),
                ),
                if (!isRead)
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _color,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: AppText(
                notification.body ?? '',
                fontSize: 11,
                color: AppColors.kGreyColor,
                fontWeight: FontWeight.w400,
                maxLines: 2,
              ),
            ),
            AppText(
              notification.createdAt ?? '',
              fontSize: 10,
              color: AppColors.kGreyColor.withOpacity(0.7),
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATS SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppText('نظرة عامة', fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<ExchangeRatesCubit,
                    SigninState<List<ExchangeRateModel>>>(
                  builder: (context, state) {
                    final count = state.maybeWhen(
                      success: (list) => list.length,
                      orElse: () => 0,
                    );
                    return _StatCard(
                      label: 'أسعار الصرف',
                      value: '$count',
                      icon: Icons.currency_exchange_rounded,
                      color: AppColors.kPrimaryColor,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BlocBuilder<CurrenciesCubit,
                    SigninState<List<CurrencyModel>>>(
                  builder: (context, state) {
                    final count = state.maybeWhen(
                      success: (list) => list.length,
                      orElse: () => 0,
                    );
                    return _StatCard(
                      label: 'العملات',
                      value: '$count',
                      icon: Icons.account_balance_wallet_rounded,
                      color: const Color(0xFF3B82F6),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<ExchangeRequestsCubit,
                    SigninState<List<ExchangeRequestModel>>>(
                  builder: (context, state) {
                    final pending = state.maybeWhen(
                      success: (list) =>
                          list.where((r) => r.status == 'pending').length,
                      orElse: () => 0,
                    );
                    return _StatCard(
                      label: 'طلبات معلقة',
                      value: '$pending',
                      icon: Icons.pending_actions_rounded,
                      color: AppColors.kWarningColor,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BlocBuilder<ExchangeRequestsCubit,
                    SigninState<List<ExchangeRequestModel>>>(
                  builder: (context, state) {
                    final accepted = state.maybeWhen(
                      success: (list) =>
                          list.where((r) => r.status == 'accepted').length,
                      orElse: () => 0,
                    );
                    return _StatCard(
                      label: 'طلبات مقبولة',
                      value: '$accepted',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.kSuccessColor,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(value, fontSize: 24, fontWeight: FontWeight.w700),
              AppText(label, fontSize: 11, color: AppColors.kGreyColor,
                  fontWeight: FontWeight.w400),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXCHANGE RATES SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _ExchangeRatesSection extends StatelessWidget {
  const _ExchangeRatesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _SectionHeader(
          title: 'أسعار الصرف',
          icon: Icons.currency_exchange_rounded,
          iconColor: AppColors.kPrimaryColor,
        ),
        const SizedBox(height: 12),
        BlocConsumer<ExchangeRatesCubit, SigninState<List<ExchangeRateModel>>>(
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
              loading: () => _buildShimmer(),
              success: (rates) => _buildRatesList(context, rates),
              error: (msg) => _buildError(msg, context),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          3,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 72,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String msg, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.kRedColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.kRedColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: AppText(msg, fontSize: 13, color: AppColors.kRedColor,
                  fontWeight: FontWeight.w400),
            ),
            TextButton(
              onPressed: () =>
                  context.read<ExchangeRatesCubit>().fetchRates(),
              child: AppText('إعادة', fontSize: 12,
                  color: AppColors.kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatesList(
      BuildContext context, List<ExchangeRateModel> rates) {
    if (rates.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AppText('لا توجد أسعار صرف', color: AppColors.kGreyColor,
            textAlign: TextAlign.center),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: rates
            .map((rate) => _RateCard(rate: rate))
            .toList(),
      ),
    );
  }
}

class _RateCard extends StatelessWidget {
  final ExchangeRateModel rate;

  const _RateCard({required this.rate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.kPrimaryColor,
                  AppColors.kSecondColor,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AppText(
              '${rate.fromCurrencyCode ?? '—'} → ${rate.toCurrencyCode ?? '—'}',
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _RateBadge(
                      label: 'شراء',
                      value: rate.buyRate?.toStringAsFixed(0) ?? '—',
                      color: AppColors.kSuccessColor,
                    ),
                    const SizedBox(width: 8),
                    _RateBadge(
                      label: 'بيع',
                      value: rate.sellRate?.toStringAsFixed(0) ?? '—',
                      color: AppColors.kRedColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showEditSheet(context, rate),
            icon: Icon(
              Icons.edit_outlined,
              color: AppColors.kPrimaryColor,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.kPrimaryColor.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context, ExchangeRateModel rate) {
    final cubit = context.read<ExchangeRatesCubit>();
    cubit.prepareForEdit(rate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _EditRateSheet(rate: rate),
      ),
    );
  }
}

class _RateBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _RateBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(label, fontSize: 10, color: color, fontWeight: FontWeight.w400),
          const SizedBox(width: 4),
          AppText(value, fontSize: 12, color: color, fontWeight: FontWeight.w700),
        ],
      ),
    );
  }
}

class _EditRateSheet extends StatelessWidget {
  final ExchangeRateModel rate;

  const _EditRateSheet({required this.rate});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExchangeRatesCubit>();
    return BlocConsumer<ExchangeRatesCubit, SigninState<List<ExchangeRateModel>>>(
      listenWhen: (prev, curr) =>
          prev.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            Navigator.pop(context);
            AppSnackbar.showSuccess(context, 'تم تحديث السعر بنجاح');
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
        return _BottomSheetContainer(
          title:
              'تعديل: ${rate.fromCurrencyCode} → ${rate.toCurrencyCode}',
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
                  validator: (v) =>
                      v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'سعر البيع',
                  controller: cubit.sellRateController,
                  icon: Icons.trending_down_rounded,
                  prefixIconColor: AppColors.kRedColor,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 8),
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
// CURRENCIES SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _CurrenciesSection extends StatelessWidget {
  const _CurrenciesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _SectionHeader(
          title: 'العملات',
          icon: Icons.account_balance_wallet_rounded,
          iconColor: const Color(0xFF3B82F6),
          trailing: IconButton(
            onPressed: () => _showAddSheet(context),
            icon: const Icon(Icons.add_rounded, color: Color(0xFF3B82F6)),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        BlocConsumer<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
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
              loading: () => _buildShimmer(),
              success: (currencies) => _buildGrid(context, currencies),
              error: (msg) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppText(msg, color: AppColors.kRedColor),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddSheet(BuildContext context) {
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

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
        children: List.generate(
          6,
          (_) => Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<CurrencyModel> currencies) {
    if (currencies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AppText('لا توجد عملات', color: AppColors.kGreyColor,
            textAlign: TextAlign.center),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
        children:
            currencies.map((c) => _CurrencyCard(currency: c)).toList(),
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  final CurrencyModel currency;

  const _CurrencyCard({required this.currency});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = currency.isActive ?? false;
    final activeColor =
        isActive ? AppColors.kSuccessColor : AppColors.kGreyColor;

    return GestureDetector(
      onLongPress: () => _showOptions(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.kCardDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? AppColors.kSuccessColor.withOpacity(0.2)
                : Colors.transparent,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: activeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AppText(
                currency.symbol ?? '',
                fontSize: 16,
                color: activeColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            AppText(
              currency.code ?? '',
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: activeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: AppText(
                isActive ? 'نشط' : 'معطل',
                fontSize: 9,
                color: activeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    final cubit = context.read<CurrenciesCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: cubit,
        child: _CurrencyOptionsSheet(currency: currency),
      ),
    );
  }
}

class _CurrencyOptionsSheet extends StatelessWidget {
  final CurrencyModel currency;

  const _CurrencyOptionsSheet({required this.currency});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CurrenciesCubit>();
    return _BottomSheetContainer(
      title: currency.name ?? '',
      child: Column(
        children: [
          _OptionTile(
            icon: Icons.edit_outlined,
            label: 'تعديل العملة',
            color: AppColors.kPrimaryColor,
            onTap: () {
              Navigator.pop(context);
              cubit.prepareForEdit(currency);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: _CurrencyFormSheet(
                    isEdit: true,
                    currencyId: currency.id,
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _OptionTile(
            icon: Icons.delete_outline_rounded,
            label: 'حذف العملة',
            color: AppColors.kRedColor,
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(context, cubit);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, CurrenciesCubit cubit) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText('حذف العملة'),
        content: AppText(
          'هل أنت متأكد من حذف ${currency.name}؟',
          maxLines: 2,
          fontWeight: FontWeight.w400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: AppText('إلغاء', color: AppColors.kGreyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dlgCtx);
              cubit.deleteCurrency(currency.id!);
            },
            child: AppText('حذف', color: AppColors.kRedColor),
          ),
        ],
      ),
    );
  }
}

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
      listenWhen: (prev, curr) =>
          prev.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            Navigator.pop(context);
            AppSnackbar.showSuccess(
              context,
              widget.isEdit ? 'تم تحديث العملة' : 'تمت إضافة العملة',
            );
          },
          error: (msg) => AppSnackbar.showError(context, msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading =
            state.maybeWhen(loading: () => true, orElse: () => false);
        return _BottomSheetContainer(
          title: widget.isEdit ? 'تعديل العملة' : 'إضافة عملة جديدة',
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                AppTextFormField(
                  label: 'اسم العملة',
                  controller: cubit.nameController,
                  icon: Icons.label_outline_rounded,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'رمز العملة (مثال: USD)',
                  controller: cubit.codeController,
                  icon: Icons.code_rounded,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'الرمز (مثال: \$)',
                  controller: cubit.symbolController,
                  icon: Icons.attach_money_rounded,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 4),
                  child: Row(
                    children: [
                      AppText('نشط', fontSize: 14),
                      const Spacer(),
                      StatefulBuilder(
                        builder: (context, setSwitchState) {
                          return Switch.adaptive(
                            value: cubit.isActiveValue,
                            activeColor: AppColors.kPrimaryColor,
                            onChanged: (v) => setSwitchState(
                              () => cubit.isActiveValue = v,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: widget.isEdit ? 'حفظ التعديلات' : 'إضافة',
                  onPressed: () => widget.isEdit
                      ? cubit.updateCurrency(widget.currencyId!)
                      : cubit.addCurrency(),
                  isLoading: isLoading,
                  icon: widget.isEdit
                      ? Icons.save_rounded
                      : Icons.add_rounded,
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
// EXCHANGE REQUESTS SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _ExchangeRequestsSection extends StatefulWidget {
  const _ExchangeRequestsSection();

  @override
  State<_ExchangeRequestsSection> createState() =>
      _ExchangeRequestsSectionState();
}

class _ExchangeRequestsSectionState extends State<_ExchangeRequestsSection> {
  static const _filters = [
    ('all', 'الكل'),
    ('pending', 'معلق'),
    ('accepted', 'مقبول'),
    ('rejected', 'مرفوض'),
    ('suspended', 'موقوف'),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExchangeRequestsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _SectionHeader(
          title: 'سجل طلبات الصرف',
          icon: Icons.receipt_long_rounded,
          iconColor: AppColors.kWarningColor,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: BlocBuilder<ExchangeRequestsCubit,
              SigninState<List<ExchangeRequestModel>>>(
            builder: (context, state) {
              final selected = cubit.statusFilter;
              return ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: _filters.map((f) {
                  final isSelected = f.$1 == selected;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => cubit.setFilter(f.$1)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.kPrimaryColor
                              : AppColors.kPrimaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AppText(
                          f.$2,
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white
                              : AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        BlocConsumer<ExchangeRequestsCubit,
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
              loading: () => _buildShimmer(),
              success: (requests) => _buildList(context, requests),
              error: (msg) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppText(msg, color: AppColors.kRedColor),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          4,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, List<ExchangeRequestModel> requests) {
    if (requests.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_rounded,
                  size: 52, color: AppColors.kGreyColor.withOpacity(0.4)),
              const SizedBox(height: 12),
              AppText('لا توجد طلبات',
                  color: AppColors.kGreyColor, fontSize: 14),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: requests.map((r) => _RequestCard(request: r)).toList(),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final ExchangeRequestModel request;

  const _RequestCard({required this.request});

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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            request.requesterName ?? '—',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            request.requesterPhone ?? '',
                            fontSize: 11,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.1),
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
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoChip(
                          label: 'من',
                          value: request.fromCurrencyCode ?? '—',
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 14, color: AppColors.kGreyColor),
                      Expanded(
                        child: _InfoChip(
                          label: 'إلى',
                          value: request.toCurrencyCode ?? '—',
                          align: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: _InfoChip(
                          label: 'المبلغ',
                          value: _formatAmount(request.amount),
                          align: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                if (request.convertedAmount != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      AppText(
                        'المبلغ المحوّل: ',
                        fontSize: 11,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                      AppText(
                        _formatAmount(request.convertedAmount),
                        fontSize: 12,
                        color: AppColors.kSuccessColor,
                        fontWeight: FontWeight.w700,
                      ),
                      AppText(
                        ' ${request.toCurrencyCode ?? ''}',
                        fontSize: 11,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                      const Spacer(),
                      AppText(
                        _formatDate(request.createdAt),
                        fontSize: 10,
                        color: AppColors.kGreyColor.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
                if (request.notes != null && request.notes!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.notes_rounded,
                          size: 12, color: AppColors.kGreyColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: AppText(
                          request.notes!,
                          fontSize: 11,
                          color: AppColors.kGreyColor,
                          fontWeight: FontWeight.w400,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isPending) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'قبول',
                      icon: Icons.check_rounded,
                      color: AppColors.kSuccessColor,
                      onTap: () => _confirmAction(
                        context,
                        'قبول الطلب',
                        'هل تريد قبول هذا الطلب؟',
                        () => context
                            .read<ExchangeRequestsCubit>()
                            .acceptRequest(request.id!),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _ActionButton(
                      label: 'رفض',
                      icon: Icons.close_rounded,
                      color: AppColors.kRedColor,
                      onTap: () => _confirmAction(
                        context,
                        'رفض الطلب',
                        'هل تريد رفض هذا الطلب؟',
                        () => context
                            .read<ExchangeRequestsCubit>()
                            .rejectRequest(request.id!),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _ActionButton(
                      label: 'تعليق',
                      icon: Icons.pause_rounded,
                      color: AppColors.kGreyColor,
                      onTap: () => _confirmAction(
                        context,
                        'تعليق الطلب',
                        'هل تريد تعليق هذا الطلب؟',
                        () => context
                            .read<ExchangeRequestsCubit>()
                            .suspendRequest(request.id!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmAction(BuildContext context, String title, String content,
      VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText(title),
        content: AppText(content, maxLines: 2, fontWeight: FontWeight.w400),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: AppText('إلغاء', color: AppColors.kGreyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dlgCtx);
              onConfirm();
            },
            child: AppText('تأكيد', color: AppColors.kPrimaryColor),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double? amount) {
    if (amount == null) return '—';
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}م';
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
      return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final TextAlign align;

  const _InfoChip({
    required this.label,
    required this.value,
    this.align = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align == TextAlign.end
          ? CrossAxisAlignment.end
          : align == TextAlign.center
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 9, color: AppColors.kGreyColor,
            fontWeight: FontWeight.w400, textAlign: align),
        AppText(value, fontSize: 13, fontWeight: FontWeight.w700,
            textAlign: align),
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
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            AppText(label, fontSize: 11, color: color,
                fontWeight: FontWeight.w700),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED BOTTOM SHEET CONTAINER
// ─────────────────────────────────────────────────────────────────────────────

class _BottomSheetContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _BottomSheetContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
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
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.kGreyColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          AppText(title, fontSize: 16, fontWeight: FontWeight.w700),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: AppText(label, fontSize: 14, color: color),
      onTap: onTap,
    );
  }
}
