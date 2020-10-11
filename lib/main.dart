import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizBrain quizBrain = QuizBrain();

  List<Icon> scorekeeper = [];

  void addScore(IconData icon, MaterialColor colorValue) {
    scorekeeper.add(Icon(
      icon,
      color: colorValue,
    ));
  }

  void updateScore(bool userAnswer) {
    quizBrain.checkAnswer(userAnswer)
        ? addScore(Icons.check, Colors.green)
        : addScore(Icons.close, Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  checkAndUpdateScoreElseThrowAlert(true);
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                  checkAndUpdateScoreElseThrowAlert(false);
                });
              },
            ),
          ),
        ),
        Row(
          children: scorekeeper,
        )
      ],
    );
  }

  void checkAndUpdateScoreElseThrowAlert(bool user_answer) {
    updateScore(user_answer);
    if (quizBrain.questionsStillRemaining()) {
      quizBrain.incrementQuestionNumber();
    } else {
      produceAlert();
      resetEverything();
    }
  }

  void produceAlert() {
    AlertStyle alertStyle = getAlertStyle();
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.info,
      title: "Finished!",
      desc: "Quiz has ended.",
      buttons: [
        DialogButton(
          child: Text(
            "Start again.",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  AlertStyle getAlertStyle() {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromBottom,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      descTextAlign: TextAlign.start,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
      alertAlignment: Alignment.center,
    );
    return alertStyle;
  }

  void resetEverything() {
    quizBrain.resetQuestionNumber();
    scorekeeper.clear();
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
