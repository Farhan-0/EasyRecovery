import 'package:flutter/material.dart';
import 'package:recovery_app/constants.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key});

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
            Icons.pending_actions_rounded,
            size: deviceSize.height * 0.07,
          ),
          SizedBox(height: deviceSize.height * 0.02),
          Text(
            'Pending',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
          ),
          // SizedBox(height: deviceSize.height * 0.02),
          const Divider(thickness: 2),
          // SizedBox(height: deviceSize.height * 0.02),
          const Flexible(
            child: Text(
              'Count',
              style: TextStyle(color: myPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
