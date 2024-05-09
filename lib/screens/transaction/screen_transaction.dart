import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_money_management/db/transactions/tansaction_db.dart';
import 'package:personal_money_management/model/categorymodel/category_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshTransactionUi();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (context, value, _) {
        return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final transactionDb = value[index];
              String formatedDate =
                  DateFormat('dd MMM').format(transactionDb.date);
              return Slidable(
                startActionPane: ActionPane(motion: BehindMotion(), children: [
                  SlidableAction(
                    backgroundColor: Color.fromARGB(255, 243, 96, 86),
                    onPressed: (context) async {
                      await TransactionDB.instance.delete(transactionDb.id!);
                    },
                    icon: Icons.delete,
                    label: 'delete',
                    borderRadius: BorderRadius.circular(6),
                  ),
                ]),
                child: Card(
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: transactionDb.type == CategoryType.income
                          ? Colors.green[300]
                          : Colors.red[300],
                      radius: 35,
                      child: Text(
                        " ${formatedDate.split(' ')[0]}\n${formatedDate.split(' ')[1]}",
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    title: Text(transactionDb.amount.toString()),
                    subtitle: Text(transactionDb.purpose),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemCount: value.length);
      },
    );
  }
}
