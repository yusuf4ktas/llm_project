import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      child: Center(
        child: SpinKitWaveSpinner(
            color: Colors.lightBlue.shade100,
          size: 50,
        ),
      ),
    );
  }
}
