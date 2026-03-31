import 'package:flutter/material.dart';
import '../../../app_theme.dart';

/// Guided 4-7-8 breathing challenge. [cycles] rounds earn an unlock.
class BreathingScreen extends StatefulWidget {
  final int cycles;
  const BreathingScreen({super.key, this.cycles = 3});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

enum _Phase { inhale, hold, exhale, done }

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  int get _totalCycles => widget.cycles;
  static const _inhaleSeconds = 4;
  static const _holdSeconds = 7;
  static const _exhaleSeconds = 8;

  late final AnimationController _controller;
  late Animation<double> _scale;

  _Phase _phase = _Phase.inhale;
  int _cycle = 1;
  bool _started = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(_onAnimationStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    setState(() => _started = true);
    _beginPhase(_Phase.inhale);
  }

  void _beginPhase(_Phase phase) {
    setState(() => _phase = phase);

    switch (phase) {
      case _Phase.inhale:
        _scale = Tween<double>(begin: 0.45, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        _controller.duration =
            const Duration(seconds: _inhaleSeconds);
      case _Phase.hold:
        _scale = Tween<double>(begin: 1.0, end: 1.0).animate(_controller);
        _controller.duration = const Duration(seconds: _holdSeconds);
      case _Phase.exhale:
        _scale = Tween<double>(begin: 1.0, end: 0.45).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        _controller.duration = const Duration(seconds: _exhaleSeconds);
      case _Phase.done:
        return;
    }
    _controller
      ..reset()
      ..forward();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;

    switch (_phase) {
      case _Phase.inhale:
        _beginPhase(_Phase.hold);
      case _Phase.hold:
        _beginPhase(_Phase.exhale);
      case _Phase.exhale:
        if (_cycle >= _totalCycles) {
          setState(() {
            _phase = _Phase.done;
            _completed = true;
          });
        } else {
          setState(() => _cycle++);
          _beginPhase(_Phase.inhale);
        }
      case _Phase.done:
        break;
    }
  }

  String get _phaseLabel {
    switch (_phase) {
      case _Phase.inhale:
        return 'Inhale';
      case _Phase.hold:
        return 'Hold';
      case _Phase.exhale:
        return 'Exhale';
      case _Phase.done:
        return 'Complete';
    }
  }

  Color get _phaseColor {
    switch (_phase) {
      case _Phase.inhale:
        return AppColors.primary;
      case _Phase.hold:
        return AppColors.warning;
      case _Phase.exhale:
        return AppColors.info;
      case _Phase.done:
        return AppColors.unlocked;
    }
  }

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
              if (!_completed) _buildBreathingCircle(),
              if (_completed) _buildCompletedState(context),
              const Spacer(),
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
            Text('Breathing Exercise',
                style: Theme.of(context).textTheme.titleLarge),
            Text('4-7-8 technique · ${widget.cycles} cycles',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildBreathingCircle() {
    return Column(
      children: [
        Text(
          'Cycle $_cycle of $_totalCycles',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer static ring
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.border, width: 1),
                ),
              ),
              // Animated fill circle
              if (_started)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    final size = 100.0 + (_scale.value * 130.0);
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _phaseColor.withValues(alpha: 0.15),
                        border: Border.all(
                            color: _phaseColor.withValues(alpha: 0.5),
                            width: 1.5),
                      ),
                    );
                  },
                ),
              // Phase label
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _started ? _phaseLabel : 'Ready',
                    style: TextStyle(
                      color: _started ? _phaseColor : AppColors.textSecondary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (_started) ...[
                    const SizedBox(height: 6),
                    Text(
                      _phaseTip,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        // Cycle dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_totalCycles, (i) {
            final done = i < _cycle - 1 ||
                (_cycle > _totalCycles);
            final active = i == _cycle - 1 && _started;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: done
                    ? AppColors.unlocked
                    : active
                        ? _phaseColor
                        : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  String get _phaseTip {
    switch (_phase) {
      case _Phase.inhale:
        return 'Breathe in through your nose';
      case _Phase.hold:
        return 'Hold gently';
      case _Phase.exhale:
        return 'Out through your mouth';
      case _Phase.done:
        return '';
    }
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
                color: AppColors.unlocked.withValues(alpha: 0.4), width: 1.5),
          ),
          child: const Icon(Icons.check_rounded,
              color: AppColors.unlocked, size: 44),
        ),
        const SizedBox(height: 24),
        Text('Well done',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          '3 cycles complete.\nYou\'ve earned an unlock.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return FilledButton(
      onPressed: _start,
      child: const Text('Begin Breathing'),
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
