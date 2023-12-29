import 'package:crypto_tracker/api/data/coins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimePeriodModal extends ConsumerWidget {
  TimePeriodModal(this.selectedTimePeriod, {super.key});

  TimePeriod selectedTimePeriod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(children: [
        Container(
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Select time period',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    child: IconButton(
                        color: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: TimePeriod.values.length,
          itemExtent: 70.0,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Container(
                child: TextButton(
                    onPressed: () {
                      selectedTimePeriod = TimePeriod.values[index];
                      Navigator.of(context).pop(selectedTimePeriod);
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(TimePeriod.values[index].getTimePeriod),
                          ),
                          Container(
                            child: currentTimePeriodMarking(
                                context, TimePeriod.values[index]),
                          )
                        ],
                      ),
                    )),
              ),
            );
          },
        ))
      ]),
    );
  }

  Widget? currentTimePeriodMarking(
      BuildContext context, TimePeriod currentTimePeriodVar) {
    if (selectedTimePeriod == currentTimePeriodVar) {
      return Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.primary,
      );
    } else {
      return null;
    }
  }
}
