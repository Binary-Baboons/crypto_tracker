import 'package:crypto_tracker/api/data/coins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimePeriodModal extends ConsumerWidget {
  TimePeriodModal(this.selectedTimePeriod, {super.key});

  TimePeriod selectedTimePeriod;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Container(
        color: Color.fromARGB(255, 2, 32, 54),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    'Select time period',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                )
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: TextButton(
                        onPressed: () {
                          selectedTimePeriod = TimePeriod.values[index];
                          Navigator.of(context).pop(selectedTimePeriod);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                    TimePeriod.values[index].getTimePeriod),
                              ),
                              Container(
                                child: currentTimePeriodMarking(
                                    TimePeriod.values[index]),
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          );
        },
      ))
    ]);
  }

  Widget currentTimePeriodMarking(TimePeriod currentTimePeriodVar) {
    if (selectedTimePeriod == currentTimePeriodVar) {
      return Icon(
        Icons.check_circle,
        color: Color.fromARGB(255, 2, 32, 54),
      );
    } else {
      return Text('');
    }
  }
}
