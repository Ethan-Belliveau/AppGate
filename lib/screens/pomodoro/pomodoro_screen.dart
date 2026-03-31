import 'dart:async';
import 'package:flutter/material.dart';
import '../../app_theme.dart';

enum _PomodoroPhase { work, shortBreak, longBreak }

enum _PomodoroStatus { idle, running, paused, locked }

/// Pomodoro timer for productivity apps.
/// Runs work intervals then enforces break periods — the app re-locks on break.
class PomodoroScreen extends StatefulWidget {
  /// App name this pomodoro session is for.
  final String appName;

  const PomodoroScreen({super.key, required this.appName});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // ── Configurable ──────────────────────────────────────────────────────────
  int _workMinutes = 25;
  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;
  int _sessionsUntilLongBreak = 4;

  // ── State ─────────────────────────────────────────────────────────────────
  _PomodoroPhase _phase = _PomodoroPhase.work;
  _PomodoroStatus _status = _PomodoroStatus.idle;
  int _completedSessions = 0;
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = _workMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Timer control ─────────────────────────────────────────────────────────

  void _start() {
    setState(() => _status = _PomodoroStatus.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) _onPhaseComplete();
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _status = _PomodoroStatus.paused);
  }

  void _resume() => _start();

  void _reset() {
    _timer?.cancel();
    setState(() {
      _phase = _PomodoroPhase.work;
      _status = _PomodoroStatus.idle;
      _remaining = _workMinutes * 60;
    });
  }

  void _onPhaseComplete() {
    _timer?.cancel();

    if (_phase == _PomodoroPhase.work) {
      final sessions = _completedSessions + 1;
      final isLongBreak = sessions % _sessionsUntilLongBreak == 0;
      setState(() {
        _completedSessions = sessions;
        _phase = isLongBreak
            ? _PomodoroPhase.longBreak
            : _PomodoroPhase.shortBreak;
        _remaining = isLongBreak
            ? _longBreakMinutes * 60
            : _shortBreakMinutes * 60;
        _status = _PomodoroStatus.locked; // enforce break
      });
      _start(); // break timer runs automatically — user can't skip
    } else {
      // Break over — ready for next work session
      setState(() {
        _phase = _PomodoroPhase.work;
        _remaining = _workMinutes * 60;
        _status = _PomodoroStatus.idle;
      });
    }
  }

  void _skipBreak() {
    // Allow skipping break at cost of a warning
    _timer?.cancel();
    setState(() {
      _phase = _PomodoroPhase.work;
      _remaining = _workMinutes * 60;
      _status = _PomodoroStatus.idle;
    });
  }

  // ── Derived state ─────────────────────────────────────────────────────────

  int get _totalForPhase {
    switch (_phase) {
      case _PomodoroPhase.work:
        return _workMinutes * 60;
      case _PomodoroPhase.shortBreak:
        return _shortBreakMinutes * 60;
      case _PomodoroPhase.longBreak:
        return _longBreakMinutes * 60;
    }
  }

  double get _progress =>
      ((_totalForPhase - _remaining) / _totalForPhase).clamp(0.0, 1.0);

  String get _timeLabel {
    final m = _remaining ~/ 60;
    final s = _remaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Color get _phaseColor {
    switch (_phase) {
      case _PomodoroPhase.work:
        return AppColors.primary;
      case _PomodoroPhase.shortBreak:
        return AppColors.unlocked;
      case _PomodoroPhase.longBreak:
        return AppColors.info;
    }
  }

  String get _phaseLabel {
    switch (_phase) {
      case _PomodoroPhase.work:
        return 'Focus';
      case _PomodoroPhase.shortBreak:
        return 'Short break';
      case _PomodoroPhase.longBreak:
        return 'Long break';
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
              _buildTimer(),
              const SizedBox(height: 32),
              _buildSessionDots(),
              const Spacer(),
              if (_status == _PomodoroStatus.locked) _buildBreakLockBanner(),
              _buildControls(),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pomodoro',
                  style: Theme.of(context).textTheme.titleLarge),
              Text(widget.appName,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        IconButton(
          onPressed: _showSettings,
          icon: const Icon(Icons.tune_rounded, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textSecondary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    return Center(
      child: SizedBox(
        width: 240,
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: _status == _PomodoroStatus.idle ? 0 : _progress,
                strokeWidth: 6,
                backgroundColor: AppColors.surfaceVariant,
                valueColor:
                    AlwaysStoppedAnimation<Color>(_phaseColor),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _phaseColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _phaseLabel.toUpperCase(),
                    style: TextStyle(
                      color: _phaseColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _timeLabel,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -2.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_sessionsUntilLongBreak, (i) {
        final done = i < _completedSessions % _sessionsUntilLongBreak;
        final active = i == _completedSessions % _sessionsUntilLongBreak &&
            _phase == _PomodoroPhase.work &&
            _status == _PomodoroStatus.running;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: done
                ? AppColors.primary
                : active
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildBreakLockBanner() {
    final isLong = _phase == _PomodoroPhase.longBreak;
    return GestureDetector(
      onTap: isLong ? null : _skipBreak,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_top_rounded,
                color: AppColors.warning, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isLong
                    ? 'Long break in progress — you\'ve earned this rest.'
                    : 'Break time. Tap to skip (not recommended).',
                style: const TextStyle(
                    color: AppColors.warning, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    if (_status == _PomodoroStatus.locked) {
      // During a break: show countdown, no start button
      return OutlinedButton(
        onPressed: null,
        child: Text('Break ends in $_timeLabel'),
      );
    }

    if (_status == _PomodoroStatus.idle) {
      return FilledButton.icon(
        onPressed: _start,
        icon: const Icon(Icons.play_arrow_rounded, size: 20),
        label: Text('Start ${_workMinutes}m Focus'),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Reset'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: _status == _PomodoroStatus.running ? _pause : _resume,
            icon: Icon(
              _status == _PomodoroStatus.running
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              size: 20,
            ),
            label: Text(
                _status == _PomodoroStatus.running ? 'Pause' : 'Resume'),
          ),
        ),
      ],
    );
  }

  // ── Settings sheet ────────────────────────────────────────────────────────

  void _showSettings() {
    int work = _workMinutes;
    int shortB = _shortBreakMinutes;
    int longB = _longBreakMinutes;
    int sessions = _sessionsUntilLongBreak;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Timer Settings',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),
              _SettingSlider(
                label: 'Focus',
                value: work,
                min: 5,
                max: 60,
                step: 5,
                unit: 'min',
                color: AppColors.primary,
                onChanged: (v) => setSheet(() => work = v),
              ),
              _SettingSlider(
                label: 'Short break',
                value: shortB,
                min: 1,
                max: 15,
                step: 1,
                unit: 'min',
                color: AppColors.unlocked,
                onChanged: (v) => setSheet(() => shortB = v),
              ),
              _SettingSlider(
                label: 'Long break',
                value: longB,
                min: 10,
                max: 30,
                step: 5,
                unit: 'min',
                color: AppColors.info,
                onChanged: (v) => setSheet(() => longB = v),
              ),
              _SettingSlider(
                label: 'Sessions until long break',
                value: sessions,
                min: 2,
                max: 6,
                step: 1,
                unit: '',
                color: AppColors.warning,
                onChanged: (v) => setSheet(() => sessions = v),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _workMinutes = work;
                    _shortBreakMinutes = shortB;
                    _longBreakMinutes = longB;
                    _sessionsUntilLongBreak = sessions;
                  });
                  _reset();
                  Navigator.pop(ctx);
                },
                child: const Text('Apply & Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Setting slider row ────────────────────────────────────────────────────────

class _SettingSlider extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final String unit;
  final Color color;
  final ValueChanged<int> onChanged;

  const _SettingSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.unit,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              Text(
                unit.isEmpty ? '$value' : '$value $unit',
                style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: (max - min) ~/ step,
            activeColor: color,
            inactiveColor: AppColors.surfaceVariant,
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}
