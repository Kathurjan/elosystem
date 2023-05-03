class Questionaire {
  List<Question> questions = [];

  Questionaire(this.questions);
}

class Question {
  List<AnswerObj> answers = [];
  String questionText = "";

  Question(this.answers, this.questionText);
}

class AnswerObj{
  int Score = 0;
  String txt = "";


  AnswerObj(this.Score, this.txt);
}



class fakeObject {
  late Questionaire questionaire;

  fakeObject(){
    var _question1 = Question([
      AnswerObj(2, "txt")
    ], "Test1");
    this.questionaire = Questionaire([_question1]);
  }
}