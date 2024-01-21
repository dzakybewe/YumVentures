import 'package:flutter/material.dart';

Center errorStateMessage() {
  return const Center(
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Please check your internet connection\n',
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),

          ),
          TextSpan(
            text: 'If the problem still occur, kindly contact us',
          ),
        ],
      ),
      textAlign: TextAlign.center,
    ),
  );
}