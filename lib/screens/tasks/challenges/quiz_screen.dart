import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class _Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  const _Question(this.question, this.options, this.correctIndex);
}

const _questions = [
  _Question(
    'What is the main reason you picked up your phone right now?',
    ['Boredom', 'Habit', 'I needed something specific', 'Anxiety'],
    2,
  ),
  _Question(
    'How do you feel when you can\'t check your phone for 30 minutes?',
    ['Fine — I don\'t notice', 'A little uneasy', 'Anxious', 'Relieved'],
    0,
  ),
  _Question(
    'Which of these is a healthy way to take a break from screens?',
    ['Switch to another device', 'Go for a short walk', 'Watch shorter videos', 'Check email instead'],
    1,
  ),
];

/// Mindfulness quiz — answer all 3 correctly to earn an unlock.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _current = 0;
  final List<int?> _selected = List.filled(_questions.length, null);
  bool _revealed = false;
  bool _completed = false;
  bool _failed = false;

  void _select(int option) {
    if (_revealed) return;
    setState(() => _selected[_current] = option);
  }

  void _confirm() {
    if (_selected[_current] == null) return;
    setState(() => _revealed = true);
  }

  void _next() {
    final correct = _selected[_current] == _questions[_current].correctIndex;
    if (!correct) {
      setState(() => _failed = true);
      return;
    }
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _revealed = false;
      });
    } else {
      setState(() => _completed = true);
    }
  }

  void _restart() {
    setState(() {
      _current = 0;
      for (int i = 0; i < _selected.length; i++) {
        _selected[i] = null;
      }
      _revealed = false;
      _failed = false;
      _completed = false;
    });
  }

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
              const SizedBox(height: 28),
              if (!_completed && !_failed) ...[
                _buildProgressBar(),
                const SizedBox(height: 28),
                _buildQuestion(),
                const Spacer(),
                _buildActionButton(),
              ],
              if (_failed) ...[
                const Spacer(),
                _buildFailState(context),
                const Spacer(),
                FilledButton(
                  onPressed: _restart,
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.surfaceVariant),
                  child: const Text('Try Again'),
                ),
              ],
              if (_completed) ...[
                const Spacer(),
                _buildCompletedState(context),
                const Spacer(),
                _buildUnlockButton(context),
              ],
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
            Text('Mindfulness Quiz',
                style: Theme.of(context).textTheme.titleLarge),
            Text('${_questions.length} questions · all correct to pass',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(_questions.length, (i) {
        Color color;
        if (i < _current) {
          color = AppColors.unlocked;
        } else if (i == _current) {
          color = AppColors.primary;
        } else {
          color = AppColors.surfaceVariant;
        }
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i < _questions.length - 1 ? 4 : 0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_current];
    final chosen = _selected[_current];
    final correct = _revealed ? q.correctIndex : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${_current + 1}',
          style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: 10),
        Text(
          q.question,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.4,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(q.options.length, (i) {
          final isChosen = chosen == i;
          final isCorrect = correct == i;
          final isWrong = _revealed && isChosen && !isCorrect;

          Color borderColor = AppColors.border;
          Color bgColor = AppColors.surface;
          Color textColor = AppColors.textPrimary;

          if (isCorrect && _revealed) {
            borderColor = AppColors.unlocked;
            bgColor = AppColors.unlocked.withValues(alpha: 0.08);
            textColor = AppColors.unlocked;
          } else if (isWrong) {
            borderColor = AppColors.blocked;
            bgColor = AppColors.blocked.withValues(alpha: 0.08);
            textColor = AppColors.blocked;
          } else if (isChosen && !_revealed) {
            borderColor = AppColors.primary;
            bgColor = AppColors.primary.withValues(alpha: 0.08);
          }

          return GestureDetector(
            onTap: () => _select(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      q.options[i],
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: isChosen
                              ? FontWeight.w500
                              : FontWeight.w400),
                    ),
                  ),
                  if (_revealed && isCorrect)
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.unlocked, size: 18),
                  if (isWrong)
                    const Icon(Icons.cancel_rounded,
                        color: AppColors.blocked, size: 18),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActionButton() {
    if (!_revealed) {
      return FilledButton(
        onPressed: _selected[_current] != null ? _confirm : null,
        child: const Text('Confirm Answer'),
      );
    }
    final isLast = _current == _questions.length - 1;
    return FilledButton(
      onPressed: _next,
      child: Text(isLast ? 'Finish' : 'Next Question'),
    );
  }

  Widget _buildFailState(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.blocked.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close_rounded,
              color: AppColors.blocked, size: 38),
        ),
        const SizedBox(height: 20),
        Text('Incorrect',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          'That wasn\'t the right answer.\nReflect and try again.',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: AppColors.textSecondary, height: 1.6),
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
        Text('All correct',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          'Quiz passed.\nYou\'ve earned an unlock.',
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
      style: FilledButton.styleFrom(backgroundColor: AppColors.unlocked),
    );
  }
}
