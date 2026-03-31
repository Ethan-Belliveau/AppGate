import 'package:flutter/foundation.dart';

/// Wraps HealthKit (iOS) / Health Connect (Android) step/distance tracking.
/// On web or unsupported platforms returns stub data so the app stays runnable.
class HealthService {
  static final HealthService _instance = HealthService._();
  HealthService._();
  static HealthService get instance => _instance;

  bool _authorized = false;
  bool get isAuthorized => _authorized;

  /// Request HealthKit permissions. Returns false on web/unsupported.
  Future<bool> requestAuthorization() async {
    if (kIsWeb) return false;
    try {
      // TODO: when running on device, replace with:
      //   final health = Health();
      //   await health.configure();
      //   return await health.requestAuthorization([
      //     HealthDataType.STEPS,
      //     HealthDataType.DISTANCE_WALKING_RUNNING,
      //   ]);
      _authorized = false;
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Returns steps taken since [from]. Returns null if unavailable.
  Future<int?> stepsSince(DateTime from) async {
    if (kIsWeb || !_authorized) return null;
    // TODO: implement via health package on device
    return null;
  }

  /// Returns distance in metres walked/run since [from]. Returns null if unavailable.
  Future<double?> distanceMetresSince(DateTime from) async {
    if (kIsWeb || !_authorized) return null;
    // TODO: implement via health package on device
    return null;
  }
}
