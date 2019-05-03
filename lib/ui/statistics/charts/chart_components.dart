import 'package:flutter/material.dart';

class EmptyBreakdown extends StatelessWidget {
  final String periodName;

  EmptyBreakdown({@required this.periodName});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(children: [
        ChartTitle(title: periodName),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Text('$periodName has no entries yet'),
        )
      ]),
    );
  }
}

class ChartTitle extends StatelessWidget {
  final String title;

  ChartTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    );
  }
}

class ChartSubtitle extends StatelessWidget {
  final String subtitle;

  ChartSubtitle({@required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
    );
  }
}
