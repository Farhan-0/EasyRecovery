import 'package:flutter/material.dart';
import 'package:recovery_app/constants.dart';
import 'package:recovery_app/widgets/chassis_search.dart';

import '../../../providers/role.dart';
import 'grid_card.dart';
import '../../../widgets/vehicle_number_search.dart';

class AdminBody extends StatelessWidget {
  final Role roleProvider;
  const AdminBody({
    super.key,
    required this.roleProvider,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          //Name container
          Container(
            height: deviceSize.height * 0.2,
            child: Stack(children: [
              Container(
                height: deviceSize.height * 0.2 - 27,
                padding: const EdgeInsets.all(myDefaultPadding),
                decoration: const BoxDecoration(
                  color: myPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Hi ${roleProvider.name}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              // Positioned(child: Container(height:,),),
            ]),
          ),

          // Searching elements
          Container(
            // height: deviceSize.height * 0.25,
            margin: const EdgeInsets.only(
              left: myDefaultPadding,
              right: myDefaultPadding,
              bottom: myDefaultPadding,
            ),
            decoration: const BoxDecoration(),
            child: Column(
              children: [
                VehicleNumberSearch('Vehicle'),
                const SizedBox(height: 20),
                const ChassisSearch(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: deviceSize.height * 0.6,
            padding: const EdgeInsets.symmetric(horizontal: myDefaultPadding),
            child: GridView.builder(
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: 2 / 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (_, index) => const GridItem(),
            ),
          ),
        ],
      ),
    );
  }
}
