class Questionaire {
  List<QuestionDTO> questions = [];

  Questionaire(this.questions);
}

class QuestionDTO {
  List<AnswerObj> answers = [];
  String questionText = "";

  QuestionDTO(this.answers, this.questionText);
}

class AnswerObj{
  int Score = 0;
  String txt = "";


  AnswerObj(this.Score, this.txt);
}



class fakeObject {
  late Questionaire questionaire;

  fakeObject(){
    var _question1 = QuestionDTO([
      AnswerObj(2, "txt")
    ], "Test1");
    this.questionaire = Questionaire([_question1]);
  }
}