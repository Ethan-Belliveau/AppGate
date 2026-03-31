import 'package:flutter/material.dart';
import '../../../app_theme.dart';

/// Gratitude journal challenge. User writes 3 entries (min 4 words each).
class GratitudeScreen extends StatefulWidget {
  const GratitudeScreen({super.key});

  @override
  State<GratitudeScreen> createState() => _GratitudeScreenState();
}

class _GratitudeScreenState extends State<GratitudeScreen> {
  final _controllers = List.generate(3, (_) => TextEditingController());
  final _focusNodes = List.generate(3, (_) => FocusNode());
  bool _submitted = false;

  static const _minWords = 4;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  int _wordCount(String text) =>
      text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

  bool _entryValid(int i) => _wordCount(_controllers[i].text) >= _minWords;

  bool get _allValid => _controllers.every((c) {
        return _wordCount(c.text) >= _minWords;
      });

  void _submit() {
    setState(() => _submitted = true);
    if (!_allValid) return;
    // Valid — show completion state (handled via _submitted + _allValid)
  }

  @override
  Widget build(BuildContext context) {
    final completed = _submitted && _allValid;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                if (!completed) ...[
                  _buildIntro(context),
                  const SizedBox(height: 28),
                  ...List.generate(3, (i) => _buildEntryField(i)),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
                ] else ...[
                  _buildCompletedState(context),
                ],
              ],
            ),
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
            Text('Gratitude Journal',
                style: Theme.of(context).textTheme.titleLarge),
            const Text('3 entries · min 4 words each',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.edit_note_rounded,
                color: AppColors.warning, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Name three things you\'re grateful for right now. Be specific.',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryField(int index) {
    final labels = [
      'First, I\'m grateful for…',
      'Second, I appreciate…',
      'Third, something good today…',
    ];

    final isValid = _entryValid(index);
    final showError = _submitted && !isValid;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}.',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: _controllers[index],
            builder: (_, __) {
              return TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                onChanged: (_) => setState(() {}),
                maxLines: 3,
                minLines: 2,
                textInputAction: index < 2
                    ? TextInputAction.next
                    : TextInputAction.done,
                onSubmitted: (_) {
                  if (index < 2) {
                    FocusScope.of(context)
                        .requestFocus(_focusNodes[index + 1]);
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                },
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 15, height: 1.5),
                decoration: InputDecoration(
                  hintText: labels[index],
                  hintStyle: const TextStyle(
                      color: AppColors.textMuted, fontSize: 14),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.all(14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: showError
                          ? AppColors.blocked
                          : isValid
                              ? AppColors.unlocked.withValues(alpha: 0.6)
                              : AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 1.5),
                  ),
                  suffixIcon: isValid
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.unlocked, size: 18)
                      : null,
                  errorText: showError
                      ? 'Write at least $_minWords words'
                      : null,
                  errorStyle: const TextStyle(
                      color: AppColors.blocked, fontSize: 11),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedState(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
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
          child: const Icon(Icons.favorite_rounded,
              color: AppColors.unlocked, size: 40),
        ),
        const SizedBox(height: 24),
        Text('Gratitude logged',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          'Three things noted.\nYou\'ve earned an unlock.',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: AppColors.textSecondary, height: 1.6),
        ),
        const SizedBox(height: 40),
        FilledButton.icon(
          onPressed: () {
            // TODO: call TaskService.completeTask and grant unlock
            Navigator.of(context).popUntil((r) => r.isFirst);
          },
          icon: const Icon(Icons.lock_open_rounded, size: 18),
          label: const Text('Unlock App'),
          style:
              FilledButton.styleFrom(backgroundColor: AppColors.unlocked),
        ),
      ],
    );
  }
}
