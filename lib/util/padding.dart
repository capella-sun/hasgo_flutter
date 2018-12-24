import 'package:flutter/material.dart';

/// Applies default Form Padding
/// `EdgeInsets.all(16.0)`
Widget formPad({@required Widget child}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: child,
  );
}