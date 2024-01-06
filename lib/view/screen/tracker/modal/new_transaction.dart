
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:crypto_tracker/service/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/transaction.dart';

class NewTransactionModal extends ConsumerStatefulWidget {
  const NewTransactionModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewTransactionModalState();
  }
}

class _NewTransactionModalState extends ConsumerState<NewTransactionModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedCoinUuid = 'Bitcoin';
  TransactionType selectedTransactionType = TransactionType.values[0];
  final dateTimeController = TextEditingController();
  final amountController = TextEditingController();
  final priceController = TextEditingController();

  late TransactionService transactionService;

  @override
  void initState() {
    super.initState();
    transactionService = ref.read(transactionServiceProvider);
  }

  // TODO: In the future user will be able to search and select from the coins coming from api
  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Select Coin'),
                  value: 'Bitcoin',
                  items: <String>['Bitcoin', 'Ethereum', 'Litecoin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? uuid) {
                    selectedCoinUuid = uuid!;
                  },
                ),
                TextFormField(
                  controller: dateTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Date and Time',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      dateTimeController.text = pickedDate.toIso8601String();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a date";
                    }

                    if (DateTime.parse(value).isAfter(DateTime.now())) {
                      return "Please enter a date in the past";
                    }

                    return null;
                  },
                ),
                DropdownButtonFormField<TransactionType>(
                  decoration: const InputDecoration(labelText: 'Transaction Type'),
                  value: TransactionType.values[0],
                  items: TransactionType.values.map<DropdownMenuItem<TransactionType>>((TransactionType type) {
                    return DropdownMenuItem<TransactionType>(
                      value: type,
                      child: Text(type.getValueOnly),
                    );
                  }).toList(),
                  onChanged: (TransactionType? type) {
                    selectedTransactionType = type!;
                  },
                ),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the amount";
                    }

                    var parsed = double.tryParse(value);
                    if (parsed == null) {
                      "Please enter a valid amount";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Total spent'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the total spent price";
                    }

                    var parsed = double.tryParse(value);
                    if (parsed == null) {
                      "Please enter a valid total spent price";
                    }

                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        transactionService.addTransaction(Transaction(DateTime.parse(dateTimeController.text), selectedCoinUuid, selectedTransactionType, double.parse(amountController.text), double.parse(priceController.text)));
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Submit', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    dateTimeController.dispose();
    amountController.dispose();
    priceController.dispose();
  }
}