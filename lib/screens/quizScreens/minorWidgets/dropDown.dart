import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownButtonCustom extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onChanged;

  const DropDownButtonCustom({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DropDownButtonCustomState createState() => _DropDownButtonCustomState();
}


class _DropDownButtonCustomState extends State<DropDownButtonCustom> {
  bool _dropdownValue = false;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.initialValue;
  }

  void dropdownCallback(bool? selectedValue) {
    if (selectedValue is bool) {
      setState(() {
        _dropdownValue = selectedValue;
      });

      // Invoke the onChanged callback in the parent widget
      widget.onChanged(_dropdownValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<bool> boolList = <bool>[true, false];

    return DropdownButton(
      items: boolList
          .map<DropdownMenuItem<bool>>(
            (bool value) {
          return DropdownMenuItem<bool>(
            value: value,
            child: Text(value.toString()),
          );
        },
      )
          .toList(),
      value: _dropdownValue,
      onChanged: dropdownCallback,
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