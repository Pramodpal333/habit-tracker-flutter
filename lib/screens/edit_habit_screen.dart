import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';
import '../models/habit_priority.dart';
import '../theme/app_typography.dart';
import '../widgets/app_text_field.dart';
import '../widgets/habit_priority_selector.dart';
import '../widgets/primary_button.dart';

/// Bottom sheet for editing a habit from the Habits tab.
class EditHabitScreen extends StatefulWidget {
  final String habitId;
  final String initialTitle;
  final HabitPriority initialPriority;

  const EditHabitScreen({
    super.key,
    required this.habitId,
    required this.initialTitle,
    required this.initialPriority,
  });

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late final TextEditingController _titleController;
  late HabitPriority _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _priority = widget.initialPriority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    context.read<HabitBloc>().add(
          UpdateHabit(
            id: widget.habitId,
            title: title,
            priority: _priority,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: bottomPadding + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Edit Habit',
            style: AppTypography.screenTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: _titleController,
            hintText: 'Habit name',
            autofocus: true,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          HabitPrioritySelector(
            value: _priority,
            onChanged: (priority) => setState(() => _priority = priority),
          ),
          const SizedBox(height: 24),
          PrimaryButton(text: 'Save Changes', onPressed: _submit),
        ],
      ),
    );
  }
}
