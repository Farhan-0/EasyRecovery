import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recovery_app/constants.dart';
import 'package:recovery_app/models/vehicle.dart';
import 'package:recovery_app/providers/vehicles.dart';
import 'package:recovery_app/screens/search_result_screen/widgets/vehicle_grid.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});
  static const routeName = '/Search_Result';
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<Vehicle> listOfVehicles = [];
  bool _isGridLoading = false;
  bool _isStateLoading = false;
  bool _isNumberLoading = false;
  bool _canSearch = true;
  final _stateTextController = TextEditingController();
  final _numberTextController = TextEditingController();
  final _suffixFocusNode = FocusNode();
  bool _once = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _suffixFocusNode.dispose();
    _stateTextController.dispose();
    super.dispose();
  }

  Future<void> _getStateList(String text, Vehicles vehicleProvider) async {
    bool stateSearchResult = false;
    if (text.isNotEmpty) {
      stateSearchResult =
          await vehicleProvider.getStateVehicleList(_stateTextController.text);
    }
    if (stateSearchResult && context.mounted) {
      FocusScope.of(context).requestFocus(_suffixFocusNode);
    }
    if (!stateSearchResult && text.isNotEmpty && context.mounted) {
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
      _isGridLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var vehicleNumber = '';
    var state = '';
    vehicleNumber = routeArgs['vehicleNumber'] as String;
    state = routeArgs['state'];
    if (_once) {
      _once = false;
      _stateTextController.text = state;
    }

    // listOfVehicles = Vehicles().searchWithVehicleNumber(vehicleNumber);
    final vehicleProvider = Provider.of<Vehicles>(context);
    listOfVehicles = vehicleProvider.selectedList;

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Result'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // STATE search Container
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: myDefaultPadding),
                    margin: const EdgeInsets.all(8),
                    width: deviceSize.width * 0.40,
                    height: 70,
                    // height: 50,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      color: myBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: myBoxShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextFormField(
                            // initialValue: state,
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
                              // Empty grid
                              vehicleProvider.emptySelectedVehicles;

                              // update vehicle provider with the state list
                              setState(() {
                                _isStateLoading = true;
                              });
                              await _getStateList(
                                  _stateTextController.text, vehicleProvider);

                              setState(() {
                                _isStateLoading = false;
                                listOfVehicles.clear();
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 38,
                          width: 38,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 5, left: 5),
                          decoration: BoxDecoration(
                            color: myPrimaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
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
                          child: _isStateLoading
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
                                    _stateTextController.value =
                                        TextEditingValue(
                                      text: _stateTextController.text
                                          .toUpperCase(),
                                      selection: _stateTextController.selection,
                                    );
                                    // Empty grid
                                    vehicleProvider.emptySelectedVehicles;
                                    // update vehicle provider with the state list
                                    setState(() {
                                      _isStateLoading = true;
                                    });
                                    await _getStateList(
                                        _stateTextController.text,
                                        vehicleProvider);

                                    setState(() {
                                      _isStateLoading = false;
                                      listOfVehicles.clear();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.search_rounded,
                                  ),
                                  color: myBackgroundColor,
                                ),
                        ),
                      ],
                    ),
                  ),

                  // NUMBER Search container

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: myDefaultPadding),
                    margin: const EdgeInsets.all(8),
                    width: deviceSize.width * 0.40,
                    height: 70,
                    decoration: BoxDecoration(
                      color: myBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: myBoxShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextFormField(
                            // controller: _numberTextController,
                            initialValue: vehicleNumber,
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
                              _suffixFocusNode.unfocus();
                              setState(() {
                                _isNumberLoading = true;
                              });
                              // Empty grid
                              vehicleProvider.emptySelectedVehicles;
                              await _getStateList(
                                  _stateTextController.text, vehicleProvider);
                              if (_stateTextController.text.isEmpty) {
                                setState(() {
                                  _isNumberLoading = false;
                                });
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
                                setState(() {
                                  _isGridLoading = true;
                                  _isNumberLoading = true;
                                });
                                listOfVehicles.clear();
                                await vehicleProvider.searchWithVehicleNumber(
                                    value, _stateTextController.text);

                                // listOfVehicles = vehicleProvider.selectedList; //Working
                              }

                              setState(() {
                                _isGridLoading = false;
                                _isNumberLoading = false;
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 38,
                          width: 38,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 5, left: 5),
                          decoration: BoxDecoration(
                            color: myPrimaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
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
                          child: _isNumberLoading
                              ? FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ))
                              : IconButton(
                                  onPressed: () async {},
                                  icon: const Icon(
                                    Icons.search_rounded,
                                  ),
                                  color: myBackgroundColor,
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: myDefaultPadding),
              child: _isGridLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const VehiclesGrid(),
            ),
          ],
        ),
      ),
    );
  }
}
