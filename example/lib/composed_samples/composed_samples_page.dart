import 'package:flutter/material.dart';

import 'samples/composed_stack_sample1.dart';

class ComposedSamplesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 26.0, top: 40),
              child: Text(
                'Composed Chart (Using Stack)',
                style: TextStyle(
                  color: const Color(
                    0xff333333,
                  ),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: AspectRatio(
              aspectRatio: 2,
              child: Card(
                elevation: 14,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0, top: 18.0),
                  child: ComposedStackSample1(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}