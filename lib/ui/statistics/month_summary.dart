import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';
import 'package:sink/ui/statistics/charts/breakdown_chart.dart';
import 'package:sink/ui/statistics/charts/chart_components.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';

class MonthExpenses extends StatelessWidget {
  final DateTime from;
  final DateTime to;

  MonthExpenses({@required this.to})
      : this.from = new DateTime(to.year, to.month, 1, 0, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        return Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 0.0),
          child: Card(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreRepository.snapshotBetween(from, to),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return PaddedCircularProgressIndicator();
                }

                List<Entry> entries = snapshot.data.documents
                    .where((ds) => ds['type'] != EntryType.INCOME.index)
                    .map((ds) => Entry.fromSnapshot(ds))
                    .toList();

                var label = monthsName(to);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: entries.isEmpty
                      ? EmptyBreakdown(periodName: label)
                      : SortedBreakdown(
                          month: label,
                          data: toBars(entries, vm.toCategory),
                          ascending: false,
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

@immutable
class _ViewModel {
  final Function(String) toCategory;

  _ViewModel({@required this.toCategory});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(toCategory: (id) => getCategory(store.state, id));
  }
}

List<ChartEntry> toBars(List<Entry> entries, Function(String) toCategory) {
  var categories = Map<Category, double>();
  entries.forEach(
    (entry) => categories.update(
        toCategory(entry.categoryId), (value) => value + entry.amount,
        ifAbsent: () => entry.amount),
  );

  return categories.entries
      .map((entry) => ChartEntry(
            label: entry.key.name,
            amount: entry.value,
            color: entry.key.color,
          ))
      .toList();
}
