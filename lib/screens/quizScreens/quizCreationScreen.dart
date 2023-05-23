import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:elosystem/screens/quizScreens/providerClasses/questionCreationState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import 'minorWidgets/answerList.dart';
import 'minorWidgets/dropDown.dart';
import 'minorWidgets/questionList.dart';

class QuizCreation extends StatefulWidget {
  final String? editUId;

  const QuizCreation({Key? key, this.editUId}) : super(key: key);

  @override
  State<QuizCreation> createState() => _QuizCreationState();
}

class _QuizCreationState extends State<QuizCreation> {
  @override
  void initState() {
    super.initState();
    if (widget.editUId != null) {
      final questionCreationState = Provider.of<QuestionCreationState>(context, listen: false);
      questionCreationState.finishQuestionnaire(context, widget.editUId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<QuestionCreationState>(
            create: (context) => QuestionCreationState(),
          ),
          Provider<AuthService>.value(value: AuthService.instance()),
          // Assuming AuthService is properly implemented
        ],
        child: Scaffold(
            appBar: AppBar(
              // back button
              title: Text(
                widget.editUId != null ? 'Questionnaire list' : 'Home',
              ),
              backgroundColor: hexStringToColor("fdbb2d"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: Container(
                // styling
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      hexStringToColor("fdbb2d"),
                      hexStringToColor("22c1c3"),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: FutureBuilder<String>(
                    // auth service
                    future:
                        Provider.of<AuthService>(context).getCurrentUserName(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return Consumer<QuestionCreationState>(
                            builder: (context, state, _) {
                          return Column(
                              // main body
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                Expanded(
                                  // Textfields and buttons
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 0, 30),
                                        child: Row(
                                          children: [
                                            Flexible(
                                                child: QuizTextFields(
                                                    state.questionController,
                                                    "question name...",
                                                    "Name your question")),
                                            IconButton(
                                                onPressed: () {
                                                  state.questionCreation(context);
                                                },
                                                icon: Icon(Icons.add))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 0, 30),
                                        child: Row(
                                          children: [
                                            Flexible(
                                                // Answer field
                                                child: QuizTextFields(
                                                    state.answerController,
                                                    "write answer here...",
                                                    "Add an answer")),
                                            Container(
                                              // Right or wrong asnwer selector
                                              margin: EdgeInsets.fromLTRB(
                                                  5, 0, 5, 0),
                                              child: DropDownButtonCustom(
                                                state: state,
                                              ),
                                            ),
                                            IconButton(
                                                // add answer to list button
                                                onPressed: () {
                                                    state.addAnswer();
                                                  state.answerController
                                                      .clear();
                                                },
                                                icon: Icon(Icons.add)),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        // finish questionnaire button
                                        onPressed: () async {
                                          state.finishQuestionnaire(
                                              context, widget.editUId!);
                                        },
                                        style: QuizButtonStyle,
                                        child: Text(
                                          "Finish the questionaire",
                                          style: TextStyle(
                                            color: Colors.blue.shade800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: state.questionEditIndex >= 0
                                      ? const Text(
                                          "editing question",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      : null,
                                ),
                                Container(
                                  // List for both the answers and questions
                                  height: 400,
                                  child: DefaultTabController(
                                      length: 2,
                                      child: Column(
                                        children: [
                                          TabBar(tabs: [
                                            Tab(
                                                child: Text(
                                              "Answer list",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            )),
                                            Tab(
                                                child: Text(
                                              "Question list",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ))
                                          ]),
                                          Expanded(
                                            child: TabBarView(children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                ),
                                                child: AnswerList(state: state),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                ),
                                                child: QuestionList(state: state
                                                    ),
                                              ),
                                            ]),
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ]);
                        });
                      }
                    },
                  ),
                )
            )
        )
    );
  }
}

