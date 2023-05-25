import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/constants.dart';
import 'package:recovery_app/providers/vehicles.dart';
import 'package:recovery_app/screens/chasis_detail_screen.dart';
import 'package:recovery_app/screens/search_result_screen/search_result.dart';

class VehicleNumberSearch extends StatefulWidget {
  // const Search({super.key});
  final String text;
  const VehicleNumberSearch(
    this.text, {
    super.key,
  });

  @override
  State<VehicleNumberSearch> createState() => _VehicleNumberSearchState();
}

class _VehicleNumberSearchState extends State<VehicleNumberSearch> {
  final _textController = TextEditingController();
  final _stateTextController = TextEditingController();
  final _numberTextController = TextEditingController();
  bool _isLoading = false;
  bool _canSearch = true;

  final _suffixFocusNode = FocusNode();

  // String vehicleNumber = '';
  @override
  void dispose() {
    // TODO: implement dispose
    _stateTextController.dispose();
    _textController.dispose();
    _suffixFocusNode.dispose();
    _numberTextController.dispose();
    super.dispose();
  }

  void _searchVehicles(Vehicles vehicleProvider, String number, String state) {
    vehicleProvider.searchWithVehicleNumber(number, state);
    Navigator.of(context).pushNamed(
        (widget.text == 'Vehicle')
            ? SearchResult.routeName
            : ChasisDetailScreen.routeName,
        arguments: {
          'vehicleNumber': number,
          'state': state,
        });
  }

  Future<void> _getStateList(String text, Vehicles vehicleProvider) async {
    // setState(() {
    //   _isLoading = true;
    // });
    final stateSearchResult =
        await vehicleProvider.getStateVehicleList(_stateTextController.text);
    if (stateSearchResult && context.mounted) {
      FocusScope.of(context).requestFocus(_suffixFocusNode);
    }
    if (!stateSearchResult && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Data for this State is not available. Please Change State.'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          duration: const Duration(seconds: 5),
        ),
      );
    }
    setState(() {
      _canSearch = stateSearchResult;
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
          // Text(
          //   'Search ${widget.text} Number',
          //   style: const TextStyle(
          //     fontWeight: FontWeight.w400,
          //   ),
          //   textAlign: TextAlign.start,
          // ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 4),
              Expanded(
                // fit: FlexFit.tight,
                child: Container(
                  padding: const EdgeInsets.only(
                    right: myDefaultPadding,
                    left: myDefaultPadding,
                    bottom: myDefaultPadding / 2,
                  ),
                  margin: const EdgeInsets.all(8),
                  width: deviceSize.width * 0.40,
                  height: 70,
                  // height: 50,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    color: myBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
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
                            labelText: 'State',
                            counterText: '',
                          ),
                          controller: _stateTextController,
                          maxLength: 2,
                          onChanged: (value) {
                            _stateTextController.value = TextEditingValue(
                              text: value.toUpperCase(),
                              selection: _stateTextController.selection,
                            );
                            // print(_stateTextController.text);
                          },
                          onFieldSubmitted: (value) async {
                            _stateTextController.value = TextEditingValue(
                              text: value.toUpperCase(),
                              selection: _stateTextController.selection,
                            );

                            // update vehicle provider with the state list
                            await _getStateList(
                                _stateTextController.text, vehicleProvider);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(width: 5),
              Expanded(
                // flex: 2,
                // fit: FlexFit.loose,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                    right: myDefaultPadding,
                    left: myDefaultPadding,
                    bottom: 10,
                  ),
                  margin: const EdgeInsets.all(8),
                  width: deviceSize.width * 0.40,
                  height: 70,
                  decoration: BoxDecoration(
                    color: myBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: myBoxShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _numberTextController,
                          // initialValue: vehicleNumber,
                          focusNode: _suffixFocusNode,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          decoration: const InputDecoration(
                            hintText: '1234',
                            labelText: 'Number',
                            counterText: '',
                          ),
                          // onChanged: (value) {
                          //   _numberTextController.value = TextEditingValue(
                          //     text: value.toUpperCase(),
                          //     selection: _numberTextController.selection,
                          //   );
                          // },
                          onFieldSubmitted: (value) async {
                            value = value.toUpperCase();
                            setState(() {
                              _isLoading = true;
                            });
                            await _getStateList(
                                _stateTextController.text, vehicleProvider);
                            setState(() {
                              _isLoading = false;
                            });
                            if (_stateTextController.text.isEmpty) {
                              // show toast that "State Text cannot be empty"
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      "Please Enter STATE Value on Left Field"),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            } else if (_canSearch) {
                              _searchVehicles(vehicleProvider, value,
                                  _stateTextController.text);
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
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
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
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ))
                    : IconButton(
                        onPressed: () async {
                          final value =
                              _numberTextController.text.toUpperCase();
                          setState(() {
                            _isLoading = true;
                          });
                          await _getStateList(
                              _stateTextController.text, vehicleProvider);
                          setState(() {
                            _isLoading = false;
                          });
                          if (_canSearch) {
                            _searchVehicles(vehicleProvider, value,
                                _stateTextController.text);
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
