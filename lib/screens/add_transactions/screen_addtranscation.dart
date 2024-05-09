import 'package:flutter/material.dart';
import 'package:personal_money_management/db/category/category_db.dart';
import 'package:personal_money_management/db/transactions/tansaction_db.dart';
import 'package:personal_money_management/model/categorymodel/category_model.dart';
import 'package:personal_money_management/model/transactions/transaction_model.dart';

class AddTransactions extends StatefulWidget {
  static const routename = 'Add-Transaction';

  const AddTransactions({super.key});

  @override
  State<AddTransactions> createState() => _AddTransactionsState();
}

class _AddTransactionsState extends State<AddTransactions> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  CategoryType? _selectedCategoryType;
  Categorymodel? _selectedCategoryModel;
  DateTime? _selectedDateTime;
  String? _IDcategory;

  @override
  void initState() {
    dispalyUi();
    _selectedCategoryType = CategoryType.income;

    super.initState();
  }

  void dispalyUi() async {
    await CategoryDB.instance.refreshUi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //purpose
                form('purpose', _purposeController),

                const SizedBox(
                  height: 10,
                ),

                //Amount
                form('Amount', _amountController),
                const SizedBox(
                  height: 10,
                ),

                //Date
                TextButton.icon(
                  onPressed: () async {
                    final _selectedDateTemp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now());
                    if (_selectedDateTemp == null) {
                      return;
                    } else {
                      setState(() {
                        _selectedDateTime = _selectedDateTemp;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_selectedDateTime == null
                      ? 'Select date'
                      : _selectedDateTime.toString().substring(0, 10)),
                ),

                //  CategoryType
                Row(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: CategoryType.income,
                          groupValue: _selectedCategoryType,
                          onChanged: (value) {
                            setState(() {
                              _IDcategory = null;
                              _selectedCategoryType = value;
                            });
                          },
                        ),
                        const Text('income'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: CategoryType.expense,
                          groupValue: _selectedCategoryType,
                          onChanged: (value) {
                            setState(() {
                              _IDcategory = null;
                              _selectedCategoryType = value;
                            });
                          },
                        ),
                        const Text('expense'),
                      ],
                    ),
                  ],
                ),
                DropdownButton<String>(
                  onTap: () {},
                  hint: const Text('Select Category'),
                  value: _IDcategory,
                  items: (_selectedCategoryType == CategoryType.income
                          ? CategoryDB.instance.incomeList
                          : CategoryDB.instance.expenseList)
                      .value
                      .map((e) {
                    return DropdownMenuItem(
                      onTap: () {
                        _selectedCategoryModel = e;
                      },
                      value: e.id,
                      child: Text(e.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _IDcategory = value;
                    });
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        addTransaction(
                            _purposeController.text,
                            _amountController.text,
                            _selectedDateTime,
                            _selectedCategoryType,
                            _selectedCategoryModel);
                      }
                    },
                    child: const Text('Submit'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form(String name, TextEditingController controller) {
    return TextFormField(
      validator: (value) {
        if (name == 'Amount'
            ? value == null || value.isEmpty || double.tryParse(value) == null
            : value == null || value.isEmpty) {
          return 'enter a $name';
        } else {
          return null;
        }
      },
      keyboardType:
          name == 'Amount' ? TextInputType.number : TextInputType.text,
      controller: controller,
      decoration: InputDecoration(hintText: name),
    );
  }

  void addTransaction(String purpose, String price, DateTime? date,
      CategoryType? type, Categorymodel? categorymodel) {
    if (date == null) {
      toast('Select a date');
      return;
    } else if (type == null) {
      toast('Select a Category type');
      return;
    } else if (categorymodel == null) {
      toast('Select a Category');
      return;
    } else {
      final model = TransactionModel(
          purpose: purpose,
          amount: double.parse(price),
          date: date,
          type: type,
          category: categorymodel);

      TransactionDB.instance.insertTransaction(model);
      Navigator.pop(context);
    }
  }

  void toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 3,
        width: MediaQuery.of(context).size.width * 0.9,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          style: const TextStyle(color: Colors.red),
        )));
  }
}
