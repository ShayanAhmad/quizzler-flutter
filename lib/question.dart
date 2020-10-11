class Question {
  String _question;
  bool _answer;

  Question(String q, bool a) {
    _question = q;
    _answer = a;
  }

  bool get getAnswer => _answer;

  String get getQuestion => _question;
}
