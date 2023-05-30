import 'package:flutter/material.dart';
import 'package:recovery_app/constants.dart';
import 'package:recovery_app/helpers/custom_icons.dart';

class GridItem extends StatelessWidget {
  final int index;
  static const List<IconData> _gridIcons = [
    Icons.pending_actions_rounded,
    CustomIcons.inYard,
    CustomIcons.release,
    CustomIcons.inHold,
  ];
  static const List<String> _gridCardName = [
    'Pending',
    'In Yard',
    'Release',
    'In Hold',
  ];
  static const List<int> _gridCardNumber = [
    29285,
    5,
    0,
    0,
  ];
  GridItem(
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      // height: 20,
      // width: 30,
      decoration: BoxDecoration(
        color: myBackgroundColor,
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 4,
            // spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(5, 5),
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(height: deviceSize.height * 0.02),
          Icon(
            _gridIcons[index],
            size: deviceSize.height * 0.07,
          ),
          SizedBox(height: deviceSize.height * 0.02),
          Text(
            _gridCardName[index],
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
          ),
          // SizedBox(height: deviceSize.height * 0.02),
          const Divider(thickness: 2),
          // SizedBox(height: deviceSize.height * 0.02),
          Flexible(
            child: Text(
              _gridCardNumber[index].toString(),
              style: TextStyle(color: myPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
