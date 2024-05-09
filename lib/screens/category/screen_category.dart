import 'package:flutter/material.dart';
import 'package:personal_money_management/db/category/category_db.dart';
import 'package:personal_money_management/screens/category/expense_category.dart';
import 'package:personal_money_management/screens/category/income_category.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CategoryDB().getCategory();

    return Column(
      children: [
        TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            tabs: const [
              Tab(
                text: 'Income',
              ),
              Tab(
                text: 'Expenses',
              ),
            ]),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: const [IncomeScreen(), ExpenseScreen()],
        ))
      ],
    );
  }
}
