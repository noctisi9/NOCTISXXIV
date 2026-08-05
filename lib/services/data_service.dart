import '../models/market_models.dart';

/// Every widget in the dashboard reads through this interface — never
/// directly from a data source. This is the single swap point.
///
/// Current real implementation: Mt5DataService (mt5_data_service.dart).
/// MockDataService has been removed — once real data existed, faking
/// numbers for cards that already have a real source stopped being
/// useful. Cards for engines that don't exist yet (Market Average,
/// Session Behavior, News, Signal) get an explicit honest neutral
/// state from Mt5DataService itself, not randomly generated numbers.
abstract class DataService {
  /// Emits a new snapshot whenever underlying data changes.
  Stream<DashboardSnapshot> watchDashboard();

  /// One-off fetch, useful for manual refresh.
  Future<DashboardSnapshot> fetchDashboard();
}
