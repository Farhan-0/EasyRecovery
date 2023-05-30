import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/providers/auth.dart';

class NameDropDownButton extends StatefulWidget {
  final String title;
  const NameDropDownButton({super.key, required this.title});

  @override
  State<NameDropDownButton> createState() => _NameDropDownButtonState();
}

class _NameDropDownButtonState extends State<NameDropDownButton> {
  bool _once = true;
  List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'B_Item4',
  ];

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  // @override
  // void initState() async {
  //   // TODO: implement initState
  //   // final authProvider = Provider.of<Auth>(context);
  //   // authProvider.fetchNameOfUsers();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    if (_once) {
      _once = false;
      final authProvider = Provider.of<Auth>(context);
      await authProvider.fetchNameOfUsers();
      setState(() {
        items = authProvider.getUserNames;
      });
      // print(items);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    // await authProvider.fetchNameOfUsers();
    // items = authProvider.getUserNames;
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          'Select ${widget.title}',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) async {
          setState(() {
            selectedValue = value as String;
          });
          authProvider.setUserNameToBeDeleted(selectedValue as String);
          await authProvider.fetchEmailOfUsers();
        },
        buttonStyleData: const ButtonStyleData(
          height: 40,
          width: 200,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: textEditingController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: textEditingController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Search for an item...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return (item.value.toString().contains(searchValue));
          },
        ),
        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            textEditingController.clear();
          }
        },
      ),
    );
  }
}
