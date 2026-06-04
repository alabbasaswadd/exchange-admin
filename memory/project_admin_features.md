---
name: Admin portal features implementation
description: Full admin portal screens and architecture added for currency exchange app
type: project
---

All 5 admin features implemented (2026-06-05):
- Exchange Rates: fetch + update buy/sell rates (ExchangeRatesCubit)
- Currencies: CRUD operations with search (CurrenciesCubit)
- Exchange Requests: list + accept/reject/suspend with filter chips (ExchangeRequestsCubit)
- Notifications: list + mark as read/mark all read (NotificationsCubit)
- Home: dashboard shell with stats grid, bottom navigation (4 tabs), logout

**Why:** User requested professional admin portal design matching existing auth architecture.
**How to apply:** All cubits extend BaseCubit<SigninState<List<T>>> reusing the existing Freezed generic state. API services use Dio directly (no Retrofit annotations) to avoid code generation. All new strings added to all 3 localization files.

New files added under lib/pages/: home/, exchange_rates/, currencies/, notifications/, exchange_requests/
routes.dart: added /home route with MultiBlocProvider for all 4 cubits
dependency_injection.dart: registered all new services and cubits
api_constans.dart: added all new endpoint constants
shimmer_widgets.dart: added ShimmerWidget.rectangular helper class
