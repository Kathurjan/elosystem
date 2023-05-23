import 'package:elosystem/screens/quizScreens/providerClasses/questionCreationState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownButtonCustom extends StatefulWidget {
  final QuestionCreationState state;

  const DropDownButtonCustom({
    Key? key, required this.state
  }) : super(key: key);

  @override
  _DropDownButtonCustomState createState() => _DropDownButtonCustomState();
}

class _DropDownButtonCustomState extends State<DropDownButtonCustom> {

  @override
  void initState() {
    super.initState();
    widget.state.dropdownValue;
  }


  @override
  Widget build(BuildContext context) {
    List<bool> boolList = <bool>[true, false];

    return DropdownButton(
      items: boolList.map<DropdownMenuItem<bool>>(
        (bool value) {
          return DropdownMenuItem<bool>(
            value: value,
            child: Text(value.toString()),
          );
        },
      ).toList(),
      value: widget.state.dropdownValue,
      onChanged: (newValue) => widget.state.changeDropDown(newValue),
      borderRadius: BorderRadius.circular(2),
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
    );
  }
}
