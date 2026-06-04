import 'package:exchange_admin/core/constants/colors.dart';
import 'package:exchange_admin/pages/currencies/cubit/currencies_cubit.dart';
import 'package:exchange_admin/pages/currencies/screen/currencies_screen.dart';
import 'package:exchange_admin/pages/exchange_rates/cubit/exchange_rates_cubit.dart';
import 'package:exchange_admin/pages/exchange_rates/screen/exchange_rates_screen.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_admin/pages/exchange_requests/screen/exchange_requests_screen.dart';
import 'package:exchange_admin/pages/notifications/cubit/notifications_cubit.dart';
import 'package:exchange_admin/pages/notifications/cubit/notifications_state.dart';
import 'package:exchange_admin/pages/notifications/screen/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  static const _titles = [
    'أسعار الصرف',
    'العملات',
    'طلبات الصرف',
    'الإشعارات',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            fontFamily: 'Cairo-Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          _NotificationBadge(
            isActive: _currentIndex == 3,
            onTap: () => setState(() => _currentIndex = 3),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _onRefresh,
            tooltip: 'تحديث',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ExchangeRatesScreen(),
          CurrenciesScreen(),
          ExchangeRequestsScreen(),
          NotificationsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.kPrimaryColor.withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.currency_exchange_outlined),
            selectedIcon: Icon(Icons.currency_exchange_rounded,
                color: AppColors.kPrimaryColor),
            label: 'الأسعار',
          ),
          const NavigationDestination(
            icon: Icon(Icons.paid_outlined),
            selectedIcon:
                Icon(Icons.paid_rounded, color: AppColors.kPrimaryColor),
            label: 'العملات',
          ),
          const NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz_rounded,
                color: AppColors.kPrimaryColor),
            label: 'الطلبات',
          ),
          NavigationDestination(
            icon: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final count = state.maybeWhen(
                  loaded: (n) => n.where((e) => e.isRead == false).length,
                  orElse: () => 0,
                );
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count',
                      style: const TextStyle(fontSize: 10)),
                  child: const Icon(Icons.notifications_outlined),
                );
              },
            ),
            selectedIcon: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final count = state.maybeWhen(
                  loaded: (n) => n.where((e) => e.isRead == false).length,
                  orElse: () => 0,
                );
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count',
                      style: const TextStyle(fontSize: 10)),
                  child: const Icon(Icons.notifications_rounded,
                      color: AppColors.kPrimaryColor),
                );
              },
            ),
            label: 'الإشعارات',
          ),
        ],
      ),
    );
  }

  void _onRefresh() {
    switch (_currentIndex) {
      case 0:
        context.read<ExchangeRatesCubit>().fetchRates();
      case 1:
        context.read<CurrenciesCubit>().fetchCurrencies();
      case 2:
        context.read<ExchangeRequestsCubit>().fetchRequests();
      case 3:
        context.read<NotificationsCubit>().fetchNotifications();
    }
  }
}

class _NotificationBadge extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _NotificationBadge({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final count = state.maybeWhen(
          loaded: (n) => n.where((e) => e.isRead == false).length,
          orElse: () => 0,
        );
        if (count == 0) return const SizedBox.shrink();
        return IconButton(
          onPressed: onTap,
          tooltip: 'الإشعارات',
          icon: Badge(
            label: Text(
              count > 99 ? '99+' : '$count',
              style: const TextStyle(fontSize: 10),
            ),
            child: const Icon(Icons.notifications_outlined),
          ),
        );
      },
    );
  }
}
