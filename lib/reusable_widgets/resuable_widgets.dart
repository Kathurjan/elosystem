import 'package:flutter/material.dart';

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
          return Colors.blue; // Use the component's default.
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

RoutingButton(String text, BuildContext context, Function onTap) {
  return ElevatedButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 23),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),

        minimumSize: MaterialStateProperty.all(const Size(200, 20)),
      ),
      onPressed: () {},
      child: Text("$text"));
}
