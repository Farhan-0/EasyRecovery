import 'package:flutter/material.dart';

import '../constants.dart';

class ChasisDetailScreen extends StatelessWidget {
  const ChasisDetailScreen({super.key});
  final String chasisNumber = 'Chasis Number';
  static const routeName = '/ChasisDetailScreen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(chasisNumber),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
        ),
        height: deviceSize.height * 0.35,
        padding: EdgeInsets.symmetric(
            horizontal: myDefaultPadding, vertical: myDefaultPadding / 2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          // color: Colors.amber,
          boxShadow: [
            // bottom right Shadow is darker
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4, 4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
            // top left shadow is lighter
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              // blurRadius: 5,
              // spreadRadius: 1,
            ),
          ],
        ),
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 3),
            padding: EdgeInsets.all(8),
            child: Text(
              'User Name',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Divider(thickness: 2),
          Container(
            child: Column(
              children: [
                Text(
                  'Vehicle Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Make : ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Data Details'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Chassis No. : ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Data Details'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Engine No. : ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Data Details'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Upload Date : ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Data Details'),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "AGENCY'S CONFIRMER(S)",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.message_rounded,
                        color: Colors.purple,
                      ),
                      backgroundColor: Colors.white30,
                    ),
                    CircleAvatar(
                      child: Icon(
                        Icons.message_outlined,
                        color: Colors.purple,
                      ),
                      backgroundColor: Colors.white30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
        // ),
      ),
      //   ],
      // ),
      // ),
    );
  }
}
