import 'package:flutter/material.dart';
import 'package:quizz/model/question_model.dart';
import '../constraints.dart';
import '../wisgets/question_widget.dart';
import '../wisgets/next_button.dart';
import '../wisgets/option_card.dart';
import 'package:quizz/wisgets/result_box.dart';
import '../model/db_connection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var db = DBconnect();
  // List<Question> extractedData = [
  //   Question(
  //     id: '10',
  //     title: 'Quelle est la capitale de la Tunisie',
  //     options: {'Tunis': true, 'Sfax': false, 'Sousse': false},
  //   ),
  //   Question(
  //     id: '11',
  //     title: 'Quelle est la capitale de la Russia',
  //     options: {'Samara': false, 'Moscow': true, 'Kiev': false},
  //   ),
  // ];

  late Future extractedData;
  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  @override
  void initState() {
    extractedData = getData();
    super.initState();
  }

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;
  void nextQuestion(int questionlength) {
    if (index == questionlength - 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                result: score,
                questionLength: questionlength,
                onPressed: startOver,
              ));
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('veuillez choisir une réponse'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  void checkAnswerAndupdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: extractedData as Future<List<Question>>,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              var extractedData = snapshot.data as List<Question>;
              return Scaffold(
                backgroundColor: background,
                appBar: AppBar(
                  title: const Text('Quizz App'),
                  backgroundColor: background,
                  shadowColor: Colors.transparent,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'Score: $score',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Questionwidget(
                        question: extractedData[index].title,
                        indexAction: index,
                        totalQuestions: extractedData.length,
                      ),
                      const Divider(
                        color: text,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      for (int i = 0;
                          i < extractedData[index].options.length;
                          i++)
                        GestureDetector(
                          onTap: () => checkAnswerAndupdate(
                              extractedData[index].options.values.toList()[i]),
                          child: OptionCard(
                            option:
                                extractedData[index].options.keys.toList()[i],
                            color: isPressed
                                ? extractedData[index]
                                            .options
                                            .values
                                            .toList()[i] ==
                                        true
                                    ? correct
                                    : incorrect
                                : neutral,
                          ),
                        ),
                    ],
                  ),
                ),
                floatingActionButton: GestureDetector(
                  onTap: () => nextQuestion(extractedData.length),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: NextButton(),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(
            child: Text('No data'),
          );
        });
  }
}
