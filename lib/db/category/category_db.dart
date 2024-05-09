import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_money_management/model/categorymodel/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String categoryDBName = 'Category_database';

abstract class CategoryDbFunctions {
  Future<List<Categorymodel>> getCategory();
  Future<void> insertCategory(Categorymodel value);
  Future<void> delete(String id);
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<Categorymodel>> incomeList = ValueNotifier([]);
  ValueNotifier<List<Categorymodel>> expenseList = ValueNotifier([]);

  @override
  Future<void> insertCategory(Categorymodel value) async {
    final categorDb = await Hive.openBox<Categorymodel>(categoryDBName);
    await categorDb.put(value.id, value);
    await refreshUi();
  }

  @override
  Future<List<Categorymodel>> getCategory() async {
    final categoryDb = await Hive.openBox<Categorymodel>(categoryDBName);
    return categoryDb.values.toList();
  }

  Future<void> refreshUi() async {
    incomeList.value.clear();
    expenseList.value.clear();
    final categoryDb = await getCategory();
    await Future.forEach(categoryDb, (element) {
      if (element.type == CategoryType.income) {
        incomeList.value.add(element);
      } else {
        expenseList.value.add(element);
      }
    });
    incomeList.notifyListeners();
    expenseList.notifyListeners();
  }

  @override
  Future<void> delete(String id) async {
    final db = await Hive.openBox<Categorymodel>(categoryDBName);
    await db.delete(id);
    refreshUi();
  }
}
