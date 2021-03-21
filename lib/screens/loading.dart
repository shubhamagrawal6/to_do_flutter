import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(8),
          height: 100,
          width: 200,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 4,
              ),
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 15.0,
                ),
              ]),
          child: const Center(
              child: Material(
            type: MaterialType.transparency,
            child: Text(
              "Loading: \nPlease Wait",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ))),
    );
  }
}
