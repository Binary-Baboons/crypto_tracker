import 'package:crypto_tracker/api/data/coins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesModal extends ConsumerStatefulWidget {
  CategoriesModal(this.selectedCategoryTags, {super.key});

  Set<CategoryTag> selectedCategoryTags;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CategoriesModalState();
  }
}

class _CategoriesModalState extends ConsumerState<CategoriesModal> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: Color.fromARGB(255, 2, 32, 54),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop(widget.selectedCategoryTags);
                    },
                    icon: const Icon(Icons.close)),
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
        itemCount: CategoryTag.values.length,
        itemExtent: 70.0, // Fixed height for each item
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TextButton(
                          onPressed: () =>
                              selectCategoryTag(CategoryTag.values[index]),
                          child:
                              Text(CategoryTag.values[index].getValueWithDash)),
                    ),
                  ),
                  currentCategoryTagMarking(CategoryTag.values[index]),
                ],
              ),
            ),
          );
        },
      ))
    ]);
  }

  void selectCategoryTag(CategoryTag categoryTag) {
    setState(() {
      widget.selectedCategoryTags.add(categoryTag);
    });
  }

  Widget currentCategoryTagMarking(CategoryTag categoryTag) {
    if (widget.selectedCategoryTags.contains(categoryTag)) {
      return Icon(
        Icons.check_circle,
        color: Color.fromARGB(255, 2, 32, 54),
      );
    } else {
      return Text('');
    }
  }
}
