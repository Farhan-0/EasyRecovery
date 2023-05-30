import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recovery_app/constants.dart';
import 'package:recovery_app/screens/vehicle_detail_screen/widgets/my_selectable_text.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VehicleDetailScreen extends StatelessWidget {
  VehicleDetailScreen({super.key});
  static const routeName = '/VehicleDetailScreen';

  final String vehicleNumber = 'Vehicle Number';

  final _selectableTextFocusNode = FocusNode();

  final screenshotController = ScreenshotController();

  Future _saveAndShare(Uint8List bytes, String vehicleNumber) async {
    final timeStamp = DateTime.now();
    final time = DateFormat('yyyy-mm-dd_kk:mm:ss').format(timeStamp);
    // print(time);
    final name = 'Screenshot_$vehicleNumber.jpg';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/$name');
    image.writeAsBytesSync(bytes);

    await Share.shareFiles([image.path]);
  }

  void _removeSelection() {
    // Clear the selection by setting the focus to an empty focus node
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String?, dynamic>;
    // print(routeArgs);
    return Scaffold(
      backgroundColor: myBackgroundColor,
      appBar: AppBar(
        title: Text(routeArgs['vehicleNumber'] as String),
      ),
      body: GestureDetector(
        onTap: _removeSelection,
        child: Screenshot(
          controller: screenshotController,
          child: SingleChildScrollView(
            child: Container(
              // alignment: Alignment.center,
              constraints: BoxConstraints(
                minHeight: 400,
                maxHeight: deviceSize.height * 2,
                maxWidth: 500,
              ),
              margin: const EdgeInsets.only(
                top: 20,
                left: 15,
                right: 15,
              ),
              // height: deviceSize.height * 0.45,
              // width: deviceSize.width * 0.6,
              padding: const EdgeInsets.symmetric(
                  horizontal: myDefaultPadding, vertical: myDefaultPadding / 2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: myBackgroundColor,
                boxShadow: myBoxShadow,
              ),
              // child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          routeArgs['userName'] as String,
                          style: Theme.of(context).textTheme.titleLarge,
                          // style: GoogleFonts.cambay(),
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 2),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Vehicle Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),

                      // style: GoogleFonts.cambay(),
                    ),
                  ),
                  // make
                  vehicleDetailItem(
                      deviceSize, 'MAKE : ', routeArgs['make'] as String),
                  const SizedBox(height: 10),
                  // Vehicle Number
                  vehicleDetailItem(deviceSize, 'VEHICLE No : ',
                      routeArgs['vehicleNumber'] as String),
                  const SizedBox(height: 10),
                  // chassis number
                  vehicleDetailItem(deviceSize, 'CHASSIS No :',
                      routeArgs['chassisNumber'] as String),
                  const SizedBox(height: 10),
                  // engine number
                  vehicleDetailItem(deviceSize, 'ENGINE No :',
                      routeArgs['engineNumber'] as String),
                  const SizedBox(height: 10),
                  // agr(loan) number
                  if (routeArgs['role'] != 'Agent')
                    vehicleDetailItem(
                        deviceSize, 'AGR NO :', routeArgs['agrNO'] as String),
                  if (routeArgs['role'] != 'Agent') const SizedBox(height: 10),
                  // Branch name
                  vehicleDetailItem(
                      deviceSize, 'BR NAME :', routeArgs['brName'] as String),
                  const SizedBox(height: 10),
                  // bom buck
                  if (routeArgs['role'] != 'Agent')
                    vehicleDetailItem(deviceSize, 'BOM BUCK :',
                        routeArgs['bomBuck'].toString()),
                  if (routeArgs['role'] != 'Agent') const SizedBox(height: 10),
                  // emi os
                  if (routeArgs['role'] != 'Agent')
                    vehicleDetailItem(
                        deviceSize, 'EMI OS :', routeArgs['emiOs'].toString()),
                  if (routeArgs['role'] != 'Agent') const SizedBox(height: 10),
                  // Total due
                  if (routeArgs['role'] != 'Agent')
                    vehicleDetailItem(deviceSize, 'TOTAL DUE :',
                        routeArgs['total'].toString()),
                  if (routeArgs['role'] != 'Agent') const SizedBox(height: 10),
                  // company
                  vehicleDetailItem(
                      deviceSize, 'COMPANY :', routeArgs['company'].toString()),
                  const SizedBox(height: 10),
                  // vehicleDetailItem(
                  //     deviceSize, 'BR NAME :', routeArgs['brName'] as String),
                  // SizedBox(height: 10),
                  const Divider(
                    thickness: 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "AGENCY'S CONFIRMER(S)",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: myPrimaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.purple,
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                height: 50,
                                width: 50,
                              ),
                              IconButton(
                                onPressed: () async {
                                  try {
                                    final image =
                                        await screenshotController.capture();

                                    if (image == null) {
                                      return;
                                    }
                                    await _saveAndShare(image,
                                        routeArgs['vehicleNumber'] as String);
                                  } catch (error) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title:
                                            const Text('An Error Occured :('),
                                        content: const Text(
                                            'Error occured while capturing screenshot.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Okay',
                                              style: TextStyle(
                                                  color: Colors.purple),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.message_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: myPrimaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.purple,
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                height: 50,
                                width: 50,
                              ),
                              Center(
                                child: IconButton(
                                  onPressed: () async {
                                    try {
                                      final image =
                                          await screenshotController.capture();

                                      if (image == null) {
                                        return;
                                      }
                                      await _saveAndShare(image,
                                          routeArgs['vehicleNumber'] as String);
                                    } catch (error) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title:
                                              const Text('An Error Occured :('),
                                          content: const Text(
                                              'Error occured while capturing screenshot.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Okay',
                                                style: TextStyle(
                                                    color: Colors.purple),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.whatsapp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ],
              ),
              //
            ),
          ),
        ),
      ),
    );
  }

  Row vehicleDetailItem(
      Size deviceSize, String dataheading, String dataDetails) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            dataheading,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // Spacer(),
        // SizedBox(width: 2),
        Expanded(
          flex: 1,

          child: Container(
            // margin: EdgeInsets.only(left: 8),
            // width: 100,
            padding: const EdgeInsets.all(myDefaultPadding / 2),
            decoration: BoxDecoration(
              color: myBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-5, -5),
                  blurRadius: 3,
                ),
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: const Offset(5, 5),
                  blurRadius: 3,
                ),
              ],
            ),
            constraints: BoxConstraints(maxWidth: deviceSize.width * 0.45),
            // child: FittedBox(
            child: SelectableText(
              focusNode: _selectableTextFocusNode,
              dataDetails,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            // child: MySelectableText(dataDetails: dataDetails),
            // ),
          ),
          //   ],
          // ),
        ),
      ],
    );
  }
}
