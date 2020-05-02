import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalexpensesapp/models/transaction.dart';

import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  Map<String, Object> getTransactionValues(int number) {
    final weekDay = DateTime.now().subtract(
      Duration(days: number),
    );

    var totalSum = 0.0;

    for (var i = 0; i < recentTransactions.length; i++) {
      if (recentTransactions[i].date.day == weekDay.day &&
          recentTransactions[i].date.month == weekDay.month &&
          recentTransactions[i].date.year == weekDay.year) {
        totalSum = totalSum + recentTransactions[i].amount;
      }
    }
    Map<String, Object> transactionValues;
    transactionValues = {
      'day': DateFormat.E().format(weekDay).substring(0, 1),
      'amount': totalSum
    };

    return transactionValues;
  }

  List<Map<String, Object>> groupedTransactionValues() {
    List<Map<String, Object>> listOfValues =
        List.generate(7, getTransactionValues);
    return listOfValues.reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues().fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues().map((data) {
            return Flexible(
              fit: FlexFit.tight,
                child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending)
            );
          }).toList(),
        ),
      ),
    );
  }
}
