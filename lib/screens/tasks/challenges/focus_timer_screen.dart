import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app_theme.dart';

/// 5-minute focus timer. User must keep the screen open the entire time.
class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen>
    with WidgetsBindingObserver {
  static const _totalSeconds = 5 * 60;

  Timer? _timer;
  int _remaining = _totalSeconds;
  bool _started = false;
  bool _completed = false;
  bool _interrupted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the user backgrounds the app while the timer is running, fail them.
    if (_started && !_completed &&
        state == AppLifecycleState.paused) {
      _fail();
    }
  }

  void _start() {
    setState(() {
      _started = true;
      _interrupted = false;
      _remaining = _totalSeconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) {
        _timer?.cancel();
        setState(() => _completed = true);
      }
    });
  }

  void _fail() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() {
      _started = false;
      _interrupted = true;
      _remaining = _totalSeconds;
    });
  }

  String get _timeLabel {
    final m = _remaining ~/ 60;
    final s = _remaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progress =>
      (_totalSeconds - _remaining) / _totalSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildHeader(context),
              const Spacer(),
              if (!_completed) _buildTimer(),
              if (_completed) _buildCompletedState(context),
              const Spacer(),
              if (_interrupted) _buildInterruptedBanner(),
              if (!_started && !_completed) _buildStartButton(),
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
            Text('5-Minute Focus',
                style: Theme.of(context).textTheme.titleLarge),
            const Text('Stay on screen until the timer ends',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildTimer() {
    return Column(
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: _started ? _progress : 0,
                  strokeWidth: 6,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _timeLabel,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -2,
                    ),
                  ),
                  Text(
                    _started ? 'remaining' : 'minutes',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Put your phone down.\nCome back when it\'s done.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textSecondary, fontSize: 15, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildInterruptedBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blocked.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.blocked.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_rounded, color: AppColors.blocked, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'You left the app — timer reset. Try again.',
              style:
                  TextStyle(color: AppColors.blocked, fontSize: 13),
            ),
          ),
        ],
      ),
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
        Text('Focus complete',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          '5 minutes held.\nYou\'ve earned an unlock.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return FilledButton(
      onPressed: _start,
      child: const Text('Start Timer'),
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
      style: FilledButton.styleFrom(backgroundColor: AppColors.unlocked),
    );
  }
}
