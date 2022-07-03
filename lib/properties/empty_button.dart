import 'package:flutter/material.dart';

class EmptyButton extends StatelessWidget {
  EmptyButton({required this.onTap, this.buttonColor, this.buttonText});
  @override
  VoidCallback onTap;
  Color? buttonColor;
  String? buttonText;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text(
                buttonText.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
