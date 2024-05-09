import 'package:flutter/material.dart';
import 'package:personal_money_management/db/category/category_db.dart';
import 'package:personal_money_management/model/categorymodel/category_model.dart';
import 'package:personal_money_management/screens/add_transactions/screen_addtranscation.dart';
import 'package:personal_money_management/screens/category/category_add_popup.dart';
import 'package:personal_money_management/screens/category/screen_category.dart';
import 'package:personal_money_management/screens/home/widgets/wigdet_bottomnavigation.dart';
import 'package:personal_money_management/screens/transaction/screen_transaction.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  static ValueNotifier<int> selectedIndex = ValueNotifier(0);
  final List _pages = [const ScreenTransaction(), const ScreenCategory()];

  get name => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Money Manager',
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndex,
          builder: (context, value, child) => _pages[value],
        ),
      ),
      bottomNavigationBar: const Widget_BottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (HomePage.selectedIndex.value == 0) {
            Navigator.pushNamed(context, AddTransactions.routename);
          } else {
            showMyDialog(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
