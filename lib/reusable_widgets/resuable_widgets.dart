import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

TextField resuableTextField(String text, IconData icon, bool isPassword,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withAlpha(200)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white60,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withAlpha(200)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      fillColor: Colors.white.withAlpha(50),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.solid),
      ),
    ),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

Container signInButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed))
            return Colors.white.withAlpha(200);
          return Colors.blue;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: const BorderSide(color: Colors.yellow),
          ),
        ),
      ),
      child: Text(isLogin ? "Login" : "Sign Up",
          style: const TextStyle(
              color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 16)),
    ),
  );
}

TextField resuableTextFieldNoPassWord(
    String text, IconData icon, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: false,
    enableSuggestions: true,
    autocorrect: true,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withAlpha(200)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white60,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withAlpha(200)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      fillColor: Colors.white.withAlpha(50),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.solid),
      ),
    ),
    keyboardType: TextInputType.emailAddress,
  );
}

Container signOutButton(String text, BuildContext context, Function onTap) {
  return Container(
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text("$text"),
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 15),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed))
            return Colors.white.withAlpha(200);
          return Colors.blue; // Use the component's default.
        }),
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        minimumSize: MaterialStateProperty.all(const Size(50, 15)),
      ),
    ),
  );
}

RoutingButton(String text, BuildContext context, Function onTap) {
  return ElevatedButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 23),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        minimumSize: MaterialStateProperty.all(const Size(200, 20)),
      ),
      onPressed: () {
        onTap();
      },
      child: Text("$text"));
}

ReturnButton(String text, BuildContext context, Function onTap) {
  return ElevatedButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 15),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        minimumSize: MaterialStateProperty.all(const Size(50, 15)),
      ),
      onPressed: () {
        onTap();
      },
      child: Text("$text"));
}

QuizTextFields(TextEditingController controller, String hintText, String labelText){
  return TextField(
    controller: controller,
    style: TextStyle(
      color: Colors.black.withAlpha(200),
    ),
    enabled: true,
    decoration: InputDecoration(
      prefixIcon: const Icon(
        Icons.help_outline,
        color: Colors.black,
      ),
      labelText: labelText,
      labelStyle: TextStyle(
          fontWeight: FontWeight.bold),
      hintText: hintText,
      filled: true,
      floatingLabelBehavior:
      FloatingLabelBehavior.always,
      fillColor:
      Colors.white.withAlpha(50),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(30.0),
        borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.solid),
      ),
    ),
  );
}

final ButtonStyle QuizeButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty
        .resolveWith<Color>(
          (Set<MaterialState> states) {
        if (states
            .contains(MaterialState.disabled)) {
          return Colors.grey; // Disabled color
        }
        return Colors.orange; // Default color
      },
    ),
    textStyle:
    MaterialStateProperty.all<TextStyle>(
      TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold),
    ),
    shape: MaterialStateProperty.all<
        OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    padding: MaterialStateProperty.all<
        EdgeInsetsGeometry>(
      EdgeInsets.symmetric(
          vertical: 12, horizontal: 24),
    ),
  );