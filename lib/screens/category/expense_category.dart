import 'package:flutter/material.dart';
import 'package:personal_money_management/db/category/category_db.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB.instance.expenseList,
      builder: (context, expenselist, child) {
        return ListView.separated(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            itemBuilder: (context, index) {
              final item = expenselist[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      CategoryDB.instance.delete(item.id);
                    },
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: expenselist.length);
      },
    );
  }
}
