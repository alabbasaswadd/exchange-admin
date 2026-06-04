import 'package:exchange_admin/core/constants/base_cubit.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_admin/pages/exchange_requests/api/exchange_requests_api.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';

class ExchangeRequestsCubit
    extends BaseCubit<SigninState<List<ExchangeRequestModel>>> {
  final ExchangeRequestsApi api;

  ExchangeRequestsCubit(this.api) : super(const SigninState.initial());

  List<ExchangeRequestModel> _requests = [];
  String _statusFilter = 'all';

  String get statusFilter => _statusFilter;

  List<ExchangeRequestModel> get filteredRequests {
    if (_statusFilter == 'all') return _requests;
    return _requests
        .where((r) => r.status?.toLowerCase() == _statusFilter)
        .toList();
  }

  static final List<ExchangeRequestModel> _mockRequests = [
    ExchangeRequestModel(
      id: '1',
      requesterName: 'أحمد محمد السيد',
      requesterPhone: '0912345678',
      fromCurrencyCode: 'USD',
      toCurrencyCode: 'SYP',
      amount: 500.0,
      exchangeRate: 12800.0,
      convertedAmount: 6400000.0,
      status: 'pending',
      createdAt: '2026-06-04T09:15:00',
      notes: 'تحويل عاجل',
    ),
    ExchangeRequestModel(
      id: '2',
      requesterName: 'فاطمة علي حسن',
      requesterPhone: '0923456789',
      fromCurrencyCode: 'EUR',
      toCurrencyCode: 'SYP',
      amount: 200.0,
      exchangeRate: 13900.0,
      convertedAmount: 2780000.0,
      status: 'accepted',
      createdAt: '2026-06-04T08:30:00',
      notes: null,
    ),
    ExchangeRequestModel(
      id: '3',
      requesterName: 'محمود خالد عمر',
      requesterPhone: '0934567890',
      fromCurrencyCode: 'SYP',
      toCurrencyCode: 'USD',
      amount: 5000000.0,
      exchangeRate: 0.000078,
      convertedAmount: 390.0,
      status: 'pending',
      createdAt: '2026-06-04T10:00:00',
      notes: 'للسفر',
    ),
    ExchangeRequestModel(
      id: '4',
      requesterName: 'سارة يوسف النور',
      requesterPhone: '0945678901',
      fromCurrencyCode: 'GBP',
      toCurrencyCode: 'SYP',
      amount: 150.0,
      exchangeRate: 16100.0,
      convertedAmount: 2415000.0,
      status: 'rejected',
      createdAt: '2026-06-03T15:45:00',
      notes: 'وثائق غير مكتملة',
    ),
    ExchangeRequestModel(
      id: '5',
      requesterName: 'عمر عبدالله الحسن',
      requesterPhone: '0956789012',
      fromCurrencyCode: 'USD',
      toCurrencyCode: 'SYP',
      amount: 1000.0,
      exchangeRate: 12800.0,
      convertedAmount: 12800000.0,
      status: 'accepted',
      createdAt: '2026-06-03T12:20:00',
      notes: null,
    ),
    ExchangeRequestModel(
      id: '6',
      requesterName: 'نور الدين مصطفى',
      requesterPhone: '0967890123',
      fromCurrencyCode: 'TRY',
      toCurrencyCode: 'SYP',
      amount: 10000.0,
      exchangeRate: 370.0,
      convertedAmount: 3700000.0,
      status: 'suspended',
      createdAt: '2026-06-03T11:00:00',
      notes: 'قيد المراجعة',
    ),
    ExchangeRequestModel(
      id: '7',
      requesterName: 'ليلى إبراهيم زيد',
      requesterPhone: '0978901234',
      fromCurrencyCode: 'USD',
      toCurrencyCode: 'SYP',
      amount: 750.0,
      exchangeRate: 12800.0,
      convertedAmount: 9600000.0,
      status: 'pending',
      createdAt: '2026-06-04T11:30:00',
      notes: null,
    ),
    ExchangeRequestModel(
      id: '8',
      requesterName: 'حسن رضا الأمين',
      requesterPhone: '0989012345',
      fromCurrencyCode: 'JOD',
      toCurrencyCode: 'SYP',
      amount: 300.0,
      exchangeRate: 18000.0,
      convertedAmount: 5400000.0,
      status: 'accepted',
      createdAt: '2026-06-02T14:00:00',
      notes: null,
    ),
  ];

  Future<void> fetchRequests() async {
    emit(const SigninState.loading());
    await Future.delayed(const Duration(milliseconds: 800));
    _requests = List.from(_mockRequests);
    emit(SigninState.success(filteredRequests));
  }

  void setFilter(String status) {
    _statusFilter = status;
    emit(SigninState.success(filteredRequests));
  }

  Future<void> acceptRequest(String id) => _updateStatus(id, 'accepted');
  Future<void> rejectRequest(String id) => _updateStatus(id, 'rejected');
  Future<void> suspendRequest(String id) => _updateStatus(id, 'suspended');

  Future<void> _updateStatus(String id, String newStatus) async {
    emit(const SigninState.loading());
    await Future.delayed(const Duration(milliseconds: 500));
    _requests = _requests.map((r) {
      return r.id == id ? r.copyWith(status: newStatus) : r;
    }).toList();
    emit(SigninState.success(filteredRequests));
  }
}
