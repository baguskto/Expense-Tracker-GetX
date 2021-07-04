import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_with_getx/model/transaction.dart';
import 'package:hive_with_getx/widget/transaction_dialog.dart';
import 'package:intl/intl.dart';

import '../boxes.dart';
import 'transactions.dart';

class TransactionPage extends GetView {
//   @override
//   _TransactionPageState createState() => _TransactionPageState();
// }
//
// class _TransactionPageState extends State<TransactionPage> {
  // @override
  // void dispose() {
  //   Hive.close();
  //
  //   super.dispose();
  // }

  final controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Bagus Expense Tracker'),
      centerTitle: true,
    ),
    body:
    ValueListenableBuilder<Box<Transaction>>(
      valueListenable: Boxes.getTransactions().listenable(),
      builder: (context, box, _) {
        final transactions = box.values.toList().cast<Transaction>();

        return buildContent(transactions);
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Get.dialog( TransactionDialog(
        onClickedDone: controller.addTransaction,
      ),)
        //   showDialog(
        // context: context,
        // builder: (context) =>

      ),
    );

  Widget buildContent(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No expenses yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      final netExpense = transactions.fold<double>(
        0,
            (previousValue, transaction) => transaction.isExpense
            ? previousValue - transaction.amount
            : previousValue + transaction.amount,
      );
      final newExpenseString = '\$${netExpense.toStringAsFixed(2)}';
      final color = netExpense > 0 ? Colors.green : Colors.red;

      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Net Expense: $newExpenseString',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = transactions[index];

                return buildTransaction(context, transaction);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildTransaction(
      BuildContext context,
      Transaction transaction,
      ) {
    final color = transaction.isExpense ? Colors.red : Colors.green;
    final date = DateFormat.yMMMd().format(transaction.createdDate);
    final amount = '\$' + transaction.amount.toStringAsFixed(2);

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          transaction.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          buildButtons(context, transaction),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Transaction transaction) => Row(
    children: [
      Expanded(
        child: TextButton.icon(
          label: Text('Edit'),
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TransactionDialog(
                transaction: transaction,
                onClickedDone: (name, amount, isExpense) =>
                    controller.editTransaction(transaction, name, amount, isExpense),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: TextButton.icon(
          label: Text('Delete'),
          icon: Icon(Icons.delete),
          onPressed: () => controller.deleteTransaction(transaction),
        ),
      )
    ],
  );

}
