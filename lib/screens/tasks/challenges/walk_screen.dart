import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../services/health_service.dart';

/// Walk 1 km challenge. Uses HealthKit on iOS; shows a clear setup prompt on web.
class WalkScreen extends StatefulWidget {
  const WalkScreen({super.key});

  @override
  State<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  static const _targetMetres = 1000.0;

  bool _started = false;
  bool _authorized = false;
  bool _completed = false;
  double _metresCovered = 0;
  DateTime? _startTime;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _checkAuthorization();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkAuthorization() async {
    final ok = await HealthService.instance.requestAuthorization();
    if (mounted) setState(() => _authorized = ok);
  }

  Future<void> _start() async {
    setState(() {
      _started = true;
      _startTime = DateTime.now();
      _metresCovered = 0;
    });
    // Poll every 10 seconds for distance updates
    _pollTimer =
        Timer.periodic(const Duration(seconds: 10), (_) => _poll());
  }

  Future<void> _poll() async {
    if (_startTime == null) return;
    final dist =
        await HealthService.instance.distanceMetresSince(_startTime!);
    if (!mounted) return;
    setState(() => _metresCovered = dist ?? _metresCovered);
    if (_metresCovered >= _targetMetres) {
      _pollTimer?.cancel();
      setState(() => _completed = true);
    }
  }

  double get _progress =>
      (_metresCovered / _targetMetres).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const Spacer(),
              if (kIsWeb)
                _buildWebNotice()
              else if (!_authorized)
                _buildAuthPrompt()
              else if (!_started && !_completed)
                _buildReadyState()
              else if (_started && !_completed)
                _buildProgressState()
              else
                _buildCompletedState(context),
              const Spacer(),
              if (!kIsWeb && _authorized && !_started && !_completed)
                FilledButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.directions_walk_rounded, size: 18),
                  label: const Text('Start Walk'),
                ),
              if (!kIsWeb && !_authorized)
                FilledButton(
                  onPressed: _checkAuthorization,
                  child: const Text('Grant Health Access'),
                ),
              if (_completed) _buildUnlockButton(context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textSecondary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Walk 1 km',
                style: Theme.of(context).textTheme.titleLarge),
            const Text('Step away from your screen',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildWebNotice() {
    return _InfoCard(
      icon: Icons.phone_iphone_rounded,
      iconColor: AppColors.info,
      title: 'iPhone required',
      body:
          'This challenge reads steps and distance from Apple Health (HealthKit). '
          'It will work automatically when you run AppGate on your iPhone.',
    );
  }

  Widget _buildAuthPrompt() {
    return _InfoCard(
      icon: Icons.health_and_safety_rounded,
      iconColor: AppColors.primary,
      title: 'Health access needed',
      body:
          'AppGate needs permission to read your walking distance from Apple Health. '
          'Tap below to grant access.',
    );
  }

  Widget _buildReadyState() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.unlocked.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.directions_walk_rounded,
              color: AppColors.unlocked, size: 38),
        ),
        const SizedBox(height: 20),
        const Text(
          'Walk 1 km',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Put your phone in your pocket and walk. '
          'AppGate will track your distance via Apple Health.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textSecondary, fontSize: 14, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildProgressState() {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 8,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.unlocked),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_metresCovered.toStringAsFixed(0)}m',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                  const Text('of 1,000 m',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Keep walking — AppGate is tracking your distance.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textSecondary, fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildCompletedState(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.unlocked.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.unlocked.withValues(alpha: 0.4),
                width: 1.5),
          ),
          child: const Icon(Icons.check_rounded,
              color: AppColors.unlocked, size: 44),
        ),
        const SizedBox(height: 24),
        Text('1 km complete',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          'You walked it off.\nYou\'ve earned an unlock.',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: AppColors.textSecondary, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildUnlockButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        // TODO: call TaskService.completeTask and grant unlock
        Navigator.of(context).popUntil((r) => r.isFirst);
      },
      icon: const Icon(Icons.lock_open_rounded, size: 18),
      label: const Text('Unlock App'),
      style:
          FilledButton.styleFrom(backgroundColor: AppColors.unlocked),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  const _InfoCard(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }
}
