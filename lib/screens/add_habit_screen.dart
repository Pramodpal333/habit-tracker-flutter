import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';
import '../models/habit_priority.dart';
import '../theme/app_typography.dart';
import '../widgets/app_text_field.dart';
import '../widgets/habit_priority_selector.dart';
import '../widgets/primary_button.dart';

/// Screen (rendered as a bottom sheet) for adding a new habit
class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _titleController = TextEditingController();
  HabitPriority _priority = HabitPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      context.read<HabitBloc>().add(AddHabit(title, priority: _priority));
      Navigator.of(context).pop(); // Close the modal
    }
  }

  @override
  Widget build(BuildContext context) {
    // Allows bottom sheet to adjust padding when keyboard appears
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
            'New Habit',
            style: AppTypography.screenTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: _titleController,
            hintText: 'E.g., Read for 30 minutes',
            autofocus: true,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          HabitPrioritySelector(
            value: _priority,
            onChanged: (priority) => setState(() => _priority = priority),
          ),
          const SizedBox(height: 24),
          PrimaryButton(text: 'Save Habit', onPressed: _submit),
        ],
      ),
    );
  }
}
