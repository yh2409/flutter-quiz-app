// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors_in_immutables, unused_import, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(MyApp());

class Question {
  String questionText;
  List<String> options;
  int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizProvider with ChangeNotifier {
  List<Question> _questions = [
    Question(
      questionText: 'What is the capital of France?',
      options: ['Berlin', 'Paris', 'London', 'Madrid'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'Which planet is known as the Red Planet?',
      options: ['Earth', 'Mars', 'Venus', 'Jupiter'],
      correctAnswerIndex: 1,
    ),
    // Add more questions as needed
  ];

  List<Question> get questions => _questions;

  int _currentQuestionIndex = 0;

  int get currentQuestionIndex => _currentQuestionIndex;

  bool _quizCompleted = false;

  bool get quizCompleted => _quizCompleted;

  void answerQuestion(int selectedOptionIndex) {
    if (_currentQuestionIndex < _questions.length - 1) {
      // Move to the next question
      _currentQuestionIndex++;
    } else {
      // Quiz completed
      _quizCompleted = true;
    }
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _quizCompleted = false;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizProvider(),
      child: MaterialApp(
        title: 'Quiz App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: Colors.amber),
        ),
        home: QuizScreen(),
      ),
    );
  }
}

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: QuizWidget(),
      ),
    );
  }
}

class QuizWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {
      final quizProvider = Provider.of<QuizProvider>(context);

      if (quizProvider.quizCompleted) {
        return QuizResultWidget();
      }

      final currentQuestion =
          quizProvider.questions[quizProvider.currentQuestionIndex];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            currentQuestion.questionText,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 24),
          ...currentQuestion.options.asMap().entries.map(
            (entry) {
              final optionIndex = entry.key;
              final optionText = entry.value;

              return QuizOptionButton(
                onPressed: () {
                  quizProvider.answerQuestion(optionIndex);
                },
                text: optionText,
              );
            },
          ),
        ],
      );
    } catch (error) {
      return Center(
        child: Text(
          'An error occurred: $error',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }
}

class QuizOptionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  QuizOptionButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary,
          onPrimary: Colors.white,
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class QuizResultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {
      final quizProvider = Provider.of<QuizProvider>(context);

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200, // Set a fixed height for the FlareActor
              child: FlareActor(
                'assets/quiz_completed.flr', // Add your own Flare asset
                animation: 'success',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Quiz Completed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                quizProvider.resetQuiz();
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Start Again'),
            ),
          ],
        ),
      );
    } catch (error) {
      return Center(
        child: Text(
          'An error occurred: $error',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }
}

@override
Widget build(BuildContext context) {
  try {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlareActor(
            'assets/quiz_completed.flr', // Add your own Flare asset
            animation: 'success',
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16),
          Text(
            'Quiz Completed!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              quizProvider.resetQuiz();
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Start Again'),
          ),
        ],
      ),
    );
  } catch (error) {
    return Center(
      child: Text(
        'An error occurred: $error',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
