import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_with_getx/model/transaction.dart';

import '../boxes.dart';

class TransactionController extends GetxController{

  @override
  void onClose() {
    Hive.close();
    super.onClose();
  }


  Future addTransaction(String name, double amount, bool isExpense) async {
    final transaction = Transaction()
      ..name = name
      ..createdDate = DateTime.now()
      ..amount = amount
      ..isExpense = isExpense;

    final box = Boxes.getTransactions();
    box.add(transaction);
    //box.put('mykey', transaction);

    // final mybox = Boxes.getTransactions();
    // final myTransaction = mybox.get('key');
    // mybox.values;
    // mybox.keys;
  }

  void  editTransaction(
      Transaction transaction,
      String name,
      double amount,
      bool isExpense,
      ) {
    transaction.name = name;
    transaction.amount = amount;
    transaction.isExpense = isExpense;

    // final box = Boxes.getTransactions();
    // box.put(transaction.key, transaction);

    transaction.save();
  }

  void deleteTransaction(Transaction transaction) {
    // final box = Boxes.getTransactions();
    // box.delete(transaction.key);

    transaction.delete();
    //setState(() => transactions.remove(transaction));
  }
}