import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/constants.dart';
import 'package:recovery_app/models/vehicle.dart';
import 'package:recovery_app/screens/vehicle_detail_screen/vehicle_detail_screen.dart';

import '../../../providers/vehicles.dart';

class VehiclesGrid extends StatelessWidget {
  // List<Vehicle> listOfVehicles;
  const VehiclesGrid({
    super.key,
  });

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
    final vehicleProvider = Provider.of<Vehicles>(context);
    // final listOfVehicles = Provider.of<Vehicles>(context).selectedList;
    final listOfVehicles = vehicleProvider.selectedVehicleIds;
    return listOfVehicles.isEmpty
        ? Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const Center(
                child: Text(
                  'No Vehicles Found!!',
                  style: TextStyle(
                    shadows: [
                      Shadow(color: myPrimaryColor, offset: Offset(0, -5))
                    ],
                    color: Colors.transparent,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    // color: myPrimaryColor,
                    decorationColor: myPrimaryColor,
                    decoration: TextDecoration.underline,
                    decorationThickness: 3,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Lottie.asset('assets/lottie_files/splash_loading.zip'),
              Lottie.asset(
                  'assets/lottie_files/cute-little-panda-sleeping.json',
                  height: 300,
                  fit: BoxFit.fitHeight)
            ],
          )
        : Column(
            children: [
              Center(
                child: Text(
                  'Vehicles (${listOfVehicles.length})',
                  style: const TextStyle(
                    color: myPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5 / 2,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () async {
                      await vehicleProvider
                          .getselectedVehicle(listOfVehicles[index]);
                      final vehicle = vehicleProvider.selectedvehicle;
                      // _goToVehicleDetailScreen(context, listOfVehicles, index);
                      if (context.mounted) {
                        _goToVehicleDetailScreen(context, vehicle);
                      }
                    },
                    child: Container(
                      height: 10,
                      width: 20,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          // bottom right Shadow is darker
                          BoxShadow(
                            color: Colors.deepPurple,
                            offset: Offset(2, 2),
                            blurRadius: 5,
                            // spreadRadius: 1,
                          ),
                          // top left shadow is lighter
                          // const BoxShadow(
                          //   color: Colors.white,
                          //   offset: Offset(-2, -2),
                          //   // blurRadius: 5,
                          //   // spreadRadius: 1,
                          // ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade800,
                            // Colors.purple.shade400,
                            Colors.purple,
                          ],
                          stops: const [
                            0.1,
                            // 0.4,
                            0.9,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              listOfVehicles[index],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.arrow_right,
                              size: 35,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: listOfVehicles.length,
              ),
            ],
          );
  }
}
