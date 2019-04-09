import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:sink/ui/statistics/month_summary.dart';
import 'package:sink/ui/statistics/year_summary.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: SizedBox(
              child: DonutAutoLabelChart.withSampleData(),
              height: 250.0,
            ),
          ),
        ),
        YearExpenses(
          from: DateTime(2018, 5, 0),
          to: DateTime.now(),
        ),
        MonthExpenses(
          from: DateTime.now().subtract(Duration(days: 300)),
          to: DateTime.now(),
        ),
      ],
    );
  }
}

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  factory DonutAutoLabelChart.withSampleData() {
    return DonutAutoLabelChart(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 60, arcRendererDecorators: [charts.ArcLabelDecorator()]));
  }

  static List<charts.Series<Expense, String>> _createSampleData() {
    final data = [
      Expense("Clothes", 100, charts.Color.fromHex(code: "#90afc5")),
      Expense("Food", 75, charts.Color.fromHex(code: "#336b87")),
      Expense("Eating out", 25, charts.Color.fromHex(code: "#2a3132")),
      Expense("Electronics", 15, charts.Color.fromHex(code: "#763626")),
    ];

    return [
      charts.Series<Expense, String>(
        id: 'Sales',
        domainFn: (Expense sales, _) => sales.label,
        measureFn: (Expense sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (Expense row, _) => '${row.label}: ${row.sales}',
        colorFn: (Expense sales, _) => sales.color,
      )
    ];
  }
}

class Expense {
  final String label;
  final int sales;
  final charts.Color color;

  Expense(this.label, this.sales, this.color);
}
