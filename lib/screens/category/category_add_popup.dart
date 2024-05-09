import 'package:flutter/material.dart';
import 'package:personal_money_management/db/category/category_db.dart';
import 'package:personal_money_management/model/categorymodel/category_model.dart';

ValueNotifier selectedradiotype = ValueNotifier(CategoryType.income);
TextEditingController _controller = TextEditingController();
Future<void> showMyDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Category Name',
                  fillColor: Colors.white,
                  filled: true),
            ),
          ),
          const Row(
            children: [
              RadioButtonCategory(type: CategoryType.income, tittle: "income"),
              RadioButtonCategory(
                  type: CategoryType.expense, tittle: "expense"),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                String name = _controller.text;
                if (name.isEmpty || selectedradiotype.value == null) {
                  return;
                } else {
                  final model = Categorymodel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      type: selectedradiotype.value);
                  CategoryDB.instance.insertCategory(model);
                  _controller.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add')),
        ],
      );
    },
  );
}

class RadioButtonCategory extends StatelessWidget {
  final CategoryType type;
  final String tittle;
  const RadioButtonCategory(
      {super.key, required this.type, required this.tittle});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedradiotype,
      builder: (context, value, _) {
        return Row(
          children: [
            Radio(
              value: type,
              groupValue: value,
              onChanged: (value) {
                selectedradiotype.value = value;
              },
            ),
            Text(tittle),
          ],
        );
      },
    );
  }
}
