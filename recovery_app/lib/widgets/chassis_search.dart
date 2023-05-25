import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/vehicle.dart';
import '../providers/vehicles.dart';
import '../screens/vehicle_detail_screen/vehicle_detail_screen.dart';

class ChassisSearch extends StatefulWidget {
  const ChassisSearch({super.key});

  @override
  State<ChassisSearch> createState() => _ChassisSearchState();
}

class _ChassisSearchState extends State<ChassisSearch> {
  final _chassisTextController = TextEditingController();
  bool _isLoading = false;

  void _goToVehicleDetailScreen(BuildContext context, Vehicle vehicle) {
    // print(listOfVehicles.map((e) => print(e.agrNo)));
    Navigator.of(context).pushNamed(VehicleDetailScreen.routeName, arguments: {
      'userName': vehicle.userName,
      'vehicleNumber': vehicle.vehicleNumber,
      'make': vehicle.asset,
      'chassisNumber': vehicle.chassisNumber,
      'engineNumber': vehicle.engineNumber,
      'agrNO': vehicle.agrNo,
      'bomBuck': vehicle.bomBuck,
      'brName': vehicle.brName,
      'emiOs': vehicle.emiOs,
      'total': vehicle.total,
      'company': vehicle.company,
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final vehicleProvider = Provider.of<Vehicles>(context);
    return Container(
      // height: 100,
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: myBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: myBoxShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 4),
              Expanded(
                // fit: FlexFit.tight,
                child: Container(
                  padding: const EdgeInsets.only(
                    right: myDefaultPadding * 2,
                    left: myDefaultPadding * 2,
                    bottom: myDefaultPadding,
                  ),
                  margin: const EdgeInsets.all(8),
                  width: deviceSize.width * 0.40,
                  height: 70,
                  // height: 50,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    color: myBackgroundColor,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: myBoxShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: TextFormField(
                          // initialValue: 'CG',
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'Chassis Number',
                          ),
                          controller: _chassisTextController,
                          onChanged: (value) {
                            _chassisTextController.value = TextEditingValue(
                              text: value.toUpperCase(),
                              selection: _chassisTextController.selection,
                            );
                          },
                          onFieldSubmitted: (value) async {
                            setState(() {
                              _isLoading = true;
                            });
                            _chassisTextController.value = TextEditingValue(
                              text: value.toUpperCase(),
                              selection: _chassisTextController.selection,
                            );
                            final vehicleId =
                                await vehicleProvider.searchWithChassisNumber(
                                    _chassisTextController.text);
                            if (vehicleId == 'NOT_FOUND') {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text('Chassis No. NOT available.'),
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                duration: const Duration(seconds: 5),
                              ));
                            } else {
                              await vehicleProvider
                                  .getselectedVehicle(vehicleId);
                              final vehicle = vehicleProvider.selectedvehicle;
                              // _goToVehicleDetailScreen(context, listOfVehicles, index);
                              setState(() {
                                _isLoading = false;
                              });
                              _chassisTextController.clear();
                              _goToVehicleDetailScreen(context, vehicle);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                width: 45,
                margin: const EdgeInsets.only(right: 5, left: 5),
                decoration: BoxDecoration(
                  color: myPrimaryColor,
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    // bottom right Shadow is darker
                    BoxShadow(
                      color: Colors.purple.shade400,
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                      // spreadRadius: 1,
                    ),
                  ],
                ),
                child: _isLoading
                    ? FittedBox(
                        // fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          _chassisTextController.value = TextEditingValue(
                            text: _chassisTextController.text.toUpperCase(),
                            selection: _chassisTextController.selection,
                          );
                          final vehicleId =
                              await vehicleProvider.searchWithChassisNumber(
                                  _chassisTextController.text);
                          if (vehicleId == 'NOT_FOUND') {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Chassis No. NOT available.'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              duration: const Duration(seconds: 5),
                            ));
                          } else {
                            await vehicleProvider.getselectedVehicle(vehicleId);
                            final vehicle = vehicleProvider.selectedvehicle;
                            // _goToVehicleDetailScreen(context, listOfVehicles, index);
                            setState(() {
                              _isLoading = false;
                            });
                            _chassisTextController.clear();
                            _goToVehicleDetailScreen(context, vehicle);
                          }
                        },
                        icon: const Icon(
                          Icons.search_rounded,
                        ),
                        color: myBackgroundColor,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
