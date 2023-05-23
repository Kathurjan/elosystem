import 'package:elosystem/screens/assignmentScreens/teacher/teachAssignmentProviders/teacherAssignmentProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../reusable_widgets/resuable_widgets.dart';
import '../../../utils/color_utils.dart';
import 'existingAssignment.dart';
import '../../../utils/fire_service/assignment_service.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {


  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherAssignmentProvider>(
      builder: (context, state, _) {
        return Scaffold(
          // this part also handles the return of the scene, which is a build in back button essentially
          appBar: AppBar(
            title: const Text('Assignments'),
            backgroundColor: hexStringToColor("fdbb2d"),
          ),
          body: Container(
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
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        resuableTextFieldNoPassWord(
                          "Name of Assignment",
                          Icons.assignment,
                          state.nameController,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 120,
                          child: resuableTextFieldNoPassWord(
                            "Description",
                            Icons.description,
                            state.descriptionController,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          width: 200,
                          child: resuableTextFieldNoPassWord(
                            "Number of Days",
                            Icons.calendar_today,
                            state.daysController,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            state.createAssign(context);
                          },
                          child: const Text('Create Assignment'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ExistingAssignmentProvider(),
                                  child: ExistingAssignment(),
                                )
                              ),
                            );
                          },
                          child: const Text('View Previous Assignments'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
