import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_money_management/model/transactions/transaction_model.dart';

const String transactionDBName = 'transacton-Db';

abstract class TransactionDbFunctions {
  Future<void> insertTransaction(value);
  Future<void> delete(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    return instance;
  }
  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertTransaction(value) async {
    final db = await Hive.openBox<TransactionModel>(transactionDBName);
    db.put(value.id, value);
    await refreshTransactionUi();
  }

  Future<List<TransactionModel>> getTransaction() async {
    final transactiondb =
        await Hive.openBox<TransactionModel>(transactionDBName);
    return transactiondb.values.toList();
  }

  Future<void> refreshTransactionUi() async {
    transactionListNotifier.value.clear();
    final dbList = await getTransaction();
    await Future.forEach(dbList, (element) {
      transactionListNotifier.value.add(element);
    });
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<void> delete(id) async {
    final db = await Hive.openBox<TransactionModel>(transactionDBName);

    try {
      await db.delete(id);
    } catch (e) {
      debugPrint('Exception $e ');
    }

    await refreshTransactionUi();
  }
}
