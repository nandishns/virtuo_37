import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:virtuo/helpers/commonWidgets.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestion = 0;
  List<String> _questions = [
    'What does DNA stand for?',
    'What is the shape of DNA?',
    'What are the four bases of DNA?',
    'What is the function of DNA?'
  ];
  List<List<String>> _options = [
    [
      'A. Deoxyribonucleic acid',
      'B. Ribonucleic acid',
      'C. Adenosine triphosphate',
      'D. Carbon dioxide'
    ],
    ['A. Helix', 'B. Square', 'C. Triangle', 'D. Circle'],
    [
      'A. Adenine, Cytosine, Guanine, Uracil',
      'B. Adenine, Cytosine, Guanine, Thymine',
      'C. Adenine, Cytosine, Guanine, Ribose',
      'D. Adenine, Cytosine, Guanine, Deoxyribose'
    ],
    [
      'A. To store genetic information',
      'B. To break down food',
      'C. To produce energy',
      'D. To transport oxygen'
    ]
  ];
  List<String> _answers = ['A', 'A', 'B', 'A'];

  int _score = 0;

  void _nextQuestion(String choice) {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        if (_answers[_currentQuestion] == choice) {
          _score++;
        }
        _currentQuestion++;
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            final height = MediaQuery.of(context).size.height;
            return AlertDialog(
              title: Center(
                child: Text(
                  'Quiz complete',
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600, fontSize: height / 38),
                ),
              ),
              content: Text(
                'Your score is ${_score + 1}/${_questions.length}',
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600, fontSize: height / 62),
              ),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/lotties/streak.json",
                            height: height * 0.09),
                        Text("+1", style: GoogleFonts.ubuntu(fontSize: 30))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: customCancelButtonStyle(context),
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _currentQuestion = 0;
                            _score = 0;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("DNA Quiz", context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _questions[_currentQuestion],
              style: GoogleFonts.openSans(
                  fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Column(
              children: _options[_currentQuestion].map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: customAgreeButtonStyle(context),
                    child: Text(
                      option,
                      style: GoogleFonts.openSans(color: Colors.black),
                    ),
                    onPressed: () => _nextQuestion(option.split('. ')[0]),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
