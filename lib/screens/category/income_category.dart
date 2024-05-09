import 'package:flutter/material.dart';
import 'package:personal_money_management/db/category/category_db.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB.instance.incomeList,
        builder: (context, incomelist, child) {
          return ListView.separated(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              itemBuilder: (context, index) {
                final item = incomelist[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(item.name),
                    trailing: IconButton(
                        onPressed: () {
                          CategoryDB.instance.delete(item.id);
                        },
                        icon: const Icon(Icons.delete)),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: incomelist.length);
        });
  }
}
