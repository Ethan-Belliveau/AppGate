/// Subscription plan levels.
enum SubPlan { free, pro }

extension SubPlanX on SubPlan {
  String get displayName => switch (this) {
        SubPlan.free => 'Free',
        SubPlan.pro => 'Pro',
      };

  bool get isPro => this == SubPlan.pro;
}

class Subscription {
  final SubPlan plan;
  final DateTime? renewsAt;

  const Subscription({required this.plan, this.renewsAt});

  static const free = Subscription(plan: SubPlan.free);

  static final proMonthly = Subscription(
    plan: SubPlan.pro,
    renewsAt: DateTime(2026, 4, 30),
  );
}
