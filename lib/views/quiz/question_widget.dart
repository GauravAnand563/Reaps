import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/quiz_bloc/quiz_bloc.dart';
import '../../models/activity_questions/option.dart';
import '../../models/activity_questions/question.dart';
import '../../models/question_responses.dart';
import '../../styles/app_colors.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final QuestionResponse qResponse;
  const QuestionWidget({
    Key? key,
    required this.question,
    required this.qResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildOption({required bool isSelected, required Option option}) {
      return GestureDetector(
        onTap: () {
          BlocProvider.of<QuizBloc>(context)
              .add(MarkOption(question.id, option.key));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary400 : AppColors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                12,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? AppColors.primary200 : AppColors.grey300,
                blurRadius: 20,
                offset: const Offset(4, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.white : AppColors.primary400,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.white : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                option.option,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isSelected ? AppColors.white : null),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.primary600,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ...question.options
              .map(
                (option) => _buildOption(
                    isSelected: option.key == qResponse.selectedOption,
                    option: option),
              )
              .toList(),
          const Spacer(),
        ],
      ),
    );
  }
}
