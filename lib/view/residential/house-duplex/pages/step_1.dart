// ignore_for_file: library_prefixes, camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable, empty_catches, body_might_complete_normally_nullable, sized_box_for_whitespace, prefer_if_null_operators, unrelated_type_equality_checks, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
import 'package:aashiyan/components/constant.dart';
import 'package:aashiyan/components/forms.dart' as Forms;
import 'package:aashiyan/components/forms.dart';
import 'package:aashiyan/view/residential/house-duplex/providers/page_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../const.dart';
import 'package:http/http.dart' as http;
import '../../../../utils/helpers.dart';
import '../providers/residential_provider.dart';

var duplexPlotValue = TextEditingController();

class Step_1 extends StatefulWidget {
  static const namedRoute = "/intrestedNext";

  @override
  State<Step_1> createState() => _Step_1State();
}

class _Step_1State extends State<Step_1> {
  // late Future<RequirementModel> futureRequirement;
  String nameController = '';
  String lastNameController = "";
  String emailController = "";
  String addressController = "";
  String? diagonal1Controller = '';
  String? diagonal2Controller = '';
  String eastController = "";
  String westController = "";
  String northController = "";
  String southController = "";
  String levelController = "";
  String? widthController = '';
  String? lengthController = '';
  var project_id;
  var projectGroupId;
  var projectTypeId;

  int isRegular = 1;
  int isNotRegular = 0;
  int isNorthOrientaion = 0;
  int plot_orientaion = 0;

  int isWest = 1;
  int isNorth = 1;
  int isSouth = 1;
  int isEast = 1;

  bool? northOriented = false;
  bool? regularPlotValue = false;
  bool? irregularPlotValue = false;
  bool? surveyor = false;
  bool? notReqired = true;
  int notReqiredInt = 0;

  bool eastRoad = false;
  bool westRoad = false;
  bool nortRoad = false;
  bool southRoad = false;
  bool? otherEast = false;
  bool? otherwest = false;
  bool? otherNortn = false;
  bool? otherSouth = false;

  List<String> levels = ["select", "Almost same level", "Up", "Down"];
  String selectedLevel = 'select';
  int selectedLevelInt = 0;

  List<String> items = ["select", "Mr", "Mrs", "Ms", "M/s"];
  String selectedItems = 'select';
  int selectedItemInt = 0;

  List<String> countryItmes = ["India"];
  String country = "India";

  // String selectCity = "select";

  String myState = "Select State";

  int cityId = 0;
  int stateId = 0;

  int plotSize = 0;
  String plotSizeStr = '';
  String selectedState = "";
  // String selectedState = "";

  List cityData = [];
  List stateData = [];

  // Map<String, dynamic> stateData = [];
  // List requirementDataByUserId = [];

  int plotWidth = 0;
  int plotLenght = 0;
  int value = 0;
  String? lengthText, widthText, finalString;
  String calculation = "";

  String totalCalculated() {
    lengthText = lengthController;
    widthText = widthController;
    finalString = duplexPlotValue.text;

    if (lengthText != '' && widthText != '') {
      calculation = (plotLenght * plotWidth).toString();
      duplexPlotValue.value = duplexPlotValue.value.copyWith(
        text: calculation.toString(),
      );
    }

    duplexPlotValue.text = calculation;
    print(duplexPlotValue.text);
    print(calculation);
    return calculation;
  }

  String apiRegularCalcuation() {
    if (printData != null) {
      lengthText = printData["project"]["plot_length"] != null
          ? printData["project"]["plot_length"].toString()
          : "";
      widthText = printData["project"]["plot_width"] != null
          ? printData["project"]["plot_width"].toString()
          : "";
      finalString = duplexPlotValue.text;

      if (lengthText != '' && widthText != '') {
        calculation = (plotLenght * plotWidth).toString();
        duplexPlotValue.value = duplexPlotValue.value.copyWith(
          text: calculation.toString(),
        );
      }
      duplexPlotValue.text = calculation;
      // print(duplexPlotValue.text);
      // print(calculation);
    }

    return calculation;
  }

  String apiIregularCalcuation() {
    diagonal1Text = diagonal1Controller;
    diagonal2Text = diagonal2Controller;
    finalDiagonal = duplexPlotValue.text;

    if (diagonal1Text != '' && diagonal2Text != '') {
      diagonalCalculation = (((diagonal1! * diagonal2!) / 2)).toString();
      duplexPlotValue.value = duplexPlotValue.value.copyWith(
        text: diagonalCalculation.toString(),
      );
    }
    return diagonalCalculation;
  }

  int? diagonal1 = 0;
  int? diagonal2 = 0;
  int? diagonalValue = 0;
  String? diagonal1Text, diagonal2Text, finalDiagonal;
  String diagonalCalculation = "";

  String diagonalCalculations() {
    diagonal1Text = diagonal1Controller;
    diagonal2Text = diagonal2Controller;
    finalDiagonal = duplexPlotValue.text;

    if (diagonal1Text != '' && diagonal2Text != '') {
      diagonalCalculation = (((diagonal1! * diagonal2!) / 2)).toString();
      duplexPlotValue.value = duplexPlotValue.value.copyWith(
        text: diagonalCalculation.toString(),
      );
    }
    return diagonalCalculation;
  }

  void showToast(msg, toastColor, GRAVITY) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 0,
        backgroundColor: toastColor,
        textColor: Colors.white);
  }

  Future<void> getState() async {
    try {
      var client = http.Client();
      var tempStates;
      var response =
          await http.get(Uri.parse("${dotenv.env['APP_URL']}state/$STATE_ID"));
      if (response.statusCode == SUCCESS) {
        Map jsonResponse = jsonDecode(response.body);
        List tempStates = jsonResponse["states"];
        setState(() {
          stateData = tempStates;
        });
      }
    } catch (e) {}
  }

  Future<List?> getCities() async {
    try {
      var client = http.Client();
      var response =
          await http.get(Uri.parse("${dotenv.env['APP_URL']}city/$stateId"));
      if (response.statusCode == SUCCESS) {
        final jsonResponse = jsonDecode(response.body);
        final cityList = jsonResponse['cities'] as List;
        setState(() {
          cityData = cityList;
        });
        return cityList;
      }
    } catch (e) {}
  }

  var printData;
  int? pageId;
  Future<void> getData(id) async {
    try {
      var response = await http.get(
        Uri.parse("${dotenv.env['APP_URL']}edit-project/$id"),
      );
      if (response.statusCode == SUCCESS) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          printData = jsonResponse;
          if (printData != null && printData['project_id'] != null) {
            // print("plotype -----");
            // print(printData["project"]["plot_type"]);
            pageId = printData['project']['id'] != null
                ? int.parse(printData['project']['id'].toString())
                : pageId;
            print(pageId);
            nameController = printData["project"]['first_name'] != null
                ? printData["project"]['first_name'].toString()
                : '';
            lastNameController = printData["project"]["last_name"] != null
                ? printData["project"]["last_name"].toString()
                : "";
            emailController = printData["project"]["email"] != null
                ? printData["project"]["email"].toString()
                : "";
            addressController = printData["project"]["address"] != null
                ? printData["project"]["address"].toString()
                : "";
            selectedState = printData["project"]["state_name"] != null
                ? printData["project"]["state_name"].toString()
                : "";
            lengthController = printData["project"]["plot_length"] != null
                ? printData["project"]["plot_length"].toString()
                : "";
            widthController = printData["project"]["plot_width"] != null
                ? printData["project"]["plot_width"].toString()
                : "";
            plotLenght = printData["project"]["plot_length"] != null
                ? int.parse(printData["project"]["plot_length"])
                : 0;
            plotWidth = printData["project"]["plot_width"] != null
                ? int.parse(printData["project"]["plot_width"])
                : 0;
            diagonal1Controller = printData["project"]["diagonal_1"] != null
                ? printData["project"]["diagonal_1"].toString()
                : '';
            diagonal2Controller = printData["project"]["diagonal_2"] != null
                ? printData["project"]["diagonal_2"].toString()
                : '';
            diagonal1 = printData["project"]["diagonal_1"] != null
                ? int.parse(printData["project"]["diagonal_1"].toString())
                : 0;
            diagonal2 = printData["project"]["diagonal_2"] != null
                ? int.parse(printData["project"]["diagonal_2"].toString())
                : 0;
            eastController = printData["project"]["east_road_width"] != null
                ? printData["project"]["east_road_width"].toString()
                : "";

            westController = printData["project"]["west_road_width"] != null
                ? printData["project"]["west_road_width"].toString()
                : "";
            northController = printData["project"]["north_road_width"] != null
                ? printData["project"]["north_road_width"].toString()
                : "";
            southController = printData["project"]["south_road_width"] != null
                ? printData["project"]["south_road_width"].toString()
                : "";
            levelController = printData["project"]["level_value"] != null
                ? printData["project"]["level_value"].toString()
                : "";

            duplexPlotValue.text = printData["project"]["plot_size"] != null
                ? printData["project"]["plot_size"].toString()
                : "";

            stateId = printData["project"]["state"] != null
                ? printData["project"]["state"]
                : "";
            cityId = printData["project"]["city"] != null
                ? printData["project"]["city"]
                : "";
          }
        });
      }
    } catch (e) {}
  }

  bool isloading = false;

  // updateCheckbox() {
  //   if (isloading) {
  //     if (printData["project"]["east_property"] == 2) {
  //       setState(() {
  //         eastRoad = true;
  //       });
  //     }
  //   }
  // }
  Future<dynamic> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    project_id = prefs.getInt('projectId');
    projectTypeId = prefs.getInt('projectHouseTypeId');
    projectGroupId = prefs.getInt('projectGroupId');
    print(projectTypeId);
    print(' step 1project_id==');
    print(project_id);
    getData(project_id);
    var decJson;
    if (userData != null) {
      decJson = jsonDecode(userData);
    }
    user_id = decJson['data']['id'];
  }

  Future<void> setDimension(dimension) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('dimension', dimenInt);
  }

  String? plotType;

  @override
  void initState() {
    super.initState();

    getUserId();
    final store = Provider.of<PageNavProvider>(context, listen: false);
    var residentProvider =
        Provider.of<ResidentialProvider>(context, listen: false);

    // var group_temp = residentProvider.getProjectGroupData();

    // group_temp.then(
    //   (value) {
    //     projectGroupId = value;
    //   },
    // );

    // var type_temp = residentProvider.getProjectType();
    // type_temp.then(
    //   (value) {
    //     projectTypeId = value;
    //   },
    // );
    getCities();
    getState();
    apiRegularCalcuation();

    duplexPlotValue.addListener(
      () => setState(
        () {
          if (printData != null) {
            plotType = printData["project"]["plot_type"].toString();
            if (plotType == '1') {
              duplexPlotValue
                  .text = (int.parse(printData["project"]["plot_length"]) *
                      int.parse(printData["project"]["plot_width"].toString()))
                  .toString();
            }
            if (plotType == '2') {
              duplexPlotValue
                  .text = ((int.parse(printData["project"]["plot_length"]) *
                          int.parse(
                              printData["project"]["plot_width"].toString())) /
                      2)
                  .toString();
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var provider = Provider.of<PageNavProvider>(context, listen: true);

    if (printData != null) {
      setState(() {
        isloading = true;
      });
    }
    return isloading == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    requirementText("Name"),
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        height: height * 0.04,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: printData != null
                                ? printData['project'] != null
                                    ? Text(printData['project']['prefix'])
                                    : Text(selectedItems)
                                : Text(selectedItems),
                            icon: const Icon(Icons.keyboard_arrow_down_sharp),
                            elevation: 16,
                            items: items
                                .asMap()
                                .entries
                                .map((it) => DropdownMenuItem<String>(
                                      value: it.value,
                                      child: Text(it.value,
                                          style: TextStyle(
                                              fontSize: height * 0.02)),
                                    ))
                                .toList(),
                            onChanged: (it) => setState(
                              () {
                                // if (it == PREFIX_MR) {
                                //   selectedItemInt = MR;
                                // } else if (it == PREFIX_MRS) {
                                //   selectedItemInt = MRS;
                                // } else if (it == PREFIX_MS) {
                                //   selectedItemInt = MS;
                                // } else if (it == PREFIX_M_S) {
                                //   selectedItemInt = M_S;
                                // }
                                // print(items.indexOf(it!));
                                selectedItems = it!;
                                if (printData['project'] != null &&
                                    printData != null) {
                                  printData['project']['prefix'] =
                                      selectedItems;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: SizedBox(
                        height: height * 0.04,
                        width: width * 0.25,
                        child: TextFormField(
                          // controller: nameController,
                          initialValue: printData != null
                              ? printData["project"]['first_name'] != null
                                  ? printData["project"]['first_name']
                                      .toString()
                                  : nameController
                              : nameController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              hintText: "First name",
                              hintStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(8)),
                          onChanged: (value) {
                            nameController = value;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: SizedBox(
                        height: height * 0.04,
                        width: width * 0.19,
                        child: TextFormField(
                          // controller: nameController,
                          initialValue: printData != null
                              ? printData["project"]['last_name'] != null
                                  ? printData["project"]['last_name'].toString()
                                  : lastNameController
                              : lastNameController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              hintText: "last name",
                              hintStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(8)),
                          onChanged: (value) {
                            lastNameController = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    requirementText("Email"),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: SizedBox(
                        height: height * 0.04,
                        width: width * 0.6,
                        child: TextFormField(
                          // controller: nameController,
                          initialValue: printData["project"] != null
                              ? printData["project"]['email'] != null
                                  ? printData["project"]['email'].toString()
                                  : emailController
                              : emailController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(8)
                              //fillColor: Colors.green

                              ),
                          onChanged: (value) {
                            emailController = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    requirementText("Project \nAddress"),
                    SizedBox(
                      width: width * 0.017,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: SizedBox(
                        height: height * 0.06,
                        width: width * 0.6,
                        child: TextFormField(
                          // controller: nameController,
                          initialValue: printData['project'] != null
                              ? printData["project"]['address'] != null
                                  ? printData["project"]['address'].toString()
                                  : addressController
                              : addressController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              hintText: "address",
                              hintStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(8)
                              //fillColor: Colors.green

                              ),
                          onChanged: (value) {
                            addressController = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    requirementText("Country"),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        height: height * 0.04,
                        width: width * 0.6,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: country,
                            elevation: 16,
                            items: countryItmes
                                .map(
                                  (it) => DropdownMenuItem<String>(
                                    value: it,
                                    child: Text(it,
                                        style:
                                            TextStyle(fontSize: height * 0.02)),
                                  ),
                                )
                                .toList(),
                            onChanged: (it) => setState(() => country = it!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    Forms.requirementText("State"),
                    SizedBox(
                      width: width * 0.06,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        height: height * 0.04,
                        width: width * 0.6,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            // value: printData["project"] != null
                            //     ? printData["project"]["state_name"] != null
                            //         ? printData["project"]["state_name"]
                            //         : selectedState
                            //     : selectedState,
                            hint: Text(selectedState),

                            // hint: printData['project'] != null
                            //     ? printData["project"]["state_name"] != null
                            //         ? Text(printData["project"]["state_name"])
                            //         : Text(selectedState)
                            //     : Text(selectedState),
                            elevation: 16,
                            items: stateData.asMap().entries.map((e) {
                              int idx = e.key;
                              String val = e.value['state_name'];
                              return DropdownMenuItem<String>(
                                value: val,
                                onTap: () {
                                  stateId = e.value["id"];
                                  getCities();
                                },
                                child: Text(val),
                              );
                            }).toList(),

                            onChanged: (it) {
                              setState(() {
                                if (printData['project'] != null) {
                                  printData["project"]["state_name"] = null;
                                }
                                selectedState = it.toString();
                                getCities();
                              });
                            },

                            // stateData
                            //     .map(
                            //       (it) => DropdownMenuItem<String>(
                            //         value: it["state_name"] != null &&
                            //                 it["state_name"] != ''
                            //             ? it["state_name"]
                            //             : Text(selectedState),
                            //         child: Text(
                            //           it["state_name"],
                            //           style: TextStyle(
                            //               fontSize: height * 0.02),
                            //         ),
                            //         onTap: () {
                            //           setState(() {
                            //             // stateId = it["id"];
                            //             // print('it["id"]');
                            //             // print(it["id"]);
                            //             getCities();
                            //           });
                            //         },
                            //       ),
                            //     )
                            //     .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    Forms.requirementText("city"),
                    SizedBox(
                      width: width * 0.085,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        height: height * 0.04,
                        width: width * 0.6,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: printData != null
                                ? printData["project"] != null
                                    ? printData["project"]["city_name"] != null
                                        ? Text(
                                            printData["project"]["city_name"])
                                        : Text(myState)
                                    : Text(myState)
                                : Text(myState),
                            elevation: 16,
                            items: cityData
                                .map(
                                  (it) => DropdownMenuItem<String>(
                                    value: it["city_name"],
                                    child: Text(
                                      it["city_name"],
                                      style: TextStyle(fontSize: height * 0.02),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        cityId = it["id"];
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                            onChanged: (newValue) {
                              setState(
                                () {
                                  if (printData['project'] != null) {
                                    printData["project"]["city_name"] =
                                        newValue.toString();
                                  }
                                  myState = newValue.toString();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    const Text(
                      "Property details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.23,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        height: height * 0.04,
                        width: width * 0.2,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: size,
                            elevation: 16,
                            items: sizeitems
                                .map((it) => DropdownMenuItem<String>(
                                      value: it,
                                      child: Text(
                                        it,
                                        style:
                                            TextStyle(fontSize: height * 0.02),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (it) => setState(() => size = it!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: checkColor,
                      checkColor: Colors.white,
                      value: printData != null
                          ? printData['project'] != null
                              // ? printData['project']['plot_type'] != null
                              ? printData['project']['plot_type'] == 1
                                  ? true
                                  : regularPlotValue
                              // : regularPlotValue
                              : regularPlotValue
                          : regularPlotValue,
                      // value: regularPlotValue,
                      onChanged: (val) {
                        setState(() {
                          regularPlotValue = val;
                          irregularPlotValue = false;
                          key:
                          Key(totalCalculated());

                          // if (lengthController != null && widthController != null) {
                          //   duplexPlotValue.text = (int.parse(lengthController!) *
                          //           int.parse(widthController!))
                          //       .toString();

                          //   print(" ======");
                          //   print(duplexPlotValue.text);
                          // }

                          if (printData != null &&
                              printData['project'] != null) {
                            printData['project']['plot_type'] = val;
                          }
                        });
                      },
                    ),
                    SizedBox(
                      width: width * 0.00,
                    ),
                    requirementText("Regular plot"),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Checkbox(
                      activeColor: checkColor,
                      checkColor: Colors.white,
                      value: printData != null
                          ? printData['project'] != null
                              ? printData['project']['plot_type'] == 2
                                  ? true
                                  : irregularPlotValue
                              : irregularPlotValue
                          : irregularPlotValue,
                      onChanged: (val) {
                        setState(
                          () {
                            irregularPlotValue = val;
                            regularPlotValue = false;

                            if (printData != null &&
                                printData['project'] != null) {
                              printData['project']['plot_type'] = val;
                            }
                          },
                        );
                      },
                    ),
                    requirementText("Irregular plot"),
                  ],
                ),
                //  if (regularPlotValue == true) ...[
                Row(
                  children: [
                    requirementText("Length"),
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      child: Container(
                        height: height * 0.04,
                        width: width * 0.15,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Lenght",
                              hintStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(8)),
                          initialValue: printData['project'] != null
                              ? printData['project']['plot_length'] != null
                                  ? printData['project']['plot_length']
                                      .toString()
                                  : lengthController
                              : lengthController,
                          onChanged: (val) {
                            setState(() {
                              if (val != '') {
                                plotType = '';
                                plotLenght = int.parse(val.toString());
                                lengthController = val;
                                totalCalculated();
                                if (printData != null &&
                                    printData['project']['plot_length'] !=
                                        null) {
                                  printData['project']['plot_length'] = val;
                                }
                              } else {
                                plotLenght = 0;
                                duplexPlotValue.text = '0';
                                lengthController = '0';
                              }
                            });
                          },
                          onTap: () {
                            setState(() {
                              // plotLenght = 0;
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    valueContainer(height, width, size, 0.039, 0.05),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    // if (irregularPlotValue == true)
                    if (printData != null
                        ? printData['project'] != null
                            ? printData['project']['plot_type'] == 2
                                ? true
                                : irregularPlotValue == true
                            : irregularPlotValue == true
                        : irregularPlotValue == true) ...[
                      requirementText("Diagona1"),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          height: height * 0.04,
                          width: width * 0.2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Diagonal 1",
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)
                                //fillColor: Colors.green
                                ),
                            initialValue: printData['project'] != null
                                ? printData['project']['diagonal_1'] != null
                                    ? printData['project']['diagonal_1']
                                    : diagonal1Controller
                                : diagonal1Controller,
                            onChanged: (value) {
                              setState(() {
                                if (value != '') {
                                  diagonal1 = int.parse(value.toString());
                                  diagonal1Controller = value;
                                  if (printData != null &&
                                      printData['project']['diagonal_1'] !=
                                          null) {
                                    printData['project']['diagonal_1'] = value;
                                  }
                                  diagonalCalculations();
                                } else {
                                  diagonal1 = 0;
                                  duplexPlotValue.text = '0';
                                  diagonal1Controller = '0';
                                }
                              });
                            },
                            onTap: () {
                              setState(() {
                                diagonalCalculations();
                              });
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    requirementText("Width"),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(5),
                      elevation: 5,
                      child: Container(
                        height: height * 0.04,
                        width: width * 0.15,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "width",
                              hintStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.all(8)
                              //fillColor: Colors.green
                              ),
                          initialValue: printData['project'] != null
                              ? printData['project']['plot_width'] != null
                                  ? printData['project']['plot_width']
                                  : widthController
                              : widthController,
                          onChanged: (val) {
                            setState(() {
                              if (val != '') {
                                plotType = '';
                                plotWidth = int.parse(val.toString());
                                widthController = val;
                                if (printData != null &&
                                    printData['project']['plot_width'] !=
                                        null) {
                                  printData['project']['plot_width'] = val;
                                }
                                totalCalculated();
                              } else {
                                plotWidth = 0;
                                duplexPlotValue.text = '0';
                                widthController = '0';
                              }
                            });
                          },
                          onTap: () {
                            setState(() {
                              // widthController.clear();
                              if (widthController == 0) {
                                plotWidth = 0;
                              }
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    valueContainer(height, width, size, 0.039, 0.05),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    if (printData != null
                        ? printData['project'] != null
                            ? printData['project']['plot_type'] == 2
                                ? true
                                : irregularPlotValue == true
                            : irregularPlotValue == true
                        : irregularPlotValue == true)
                      // if (irregularPlotValue == true)
                      ...[
                      requirementText("Diagona2"),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        elevation: 5,
                        child: Container(
                          height: height * 0.04,
                          width: width * 0.2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Diagonal 2",
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.all(8)
                                // fillColor: Colors.green
                                ),
                            initialValue: printData['project'] != null
                                ? printData['project']['diagonal_2'] != null
                                    ? printData['project']['diagonal_2']
                                    : diagonal2Controller.toString()
                                : diagonal2Controller.toString(),
                            onChanged: (value) {
                              setState(() {
                                if (value != '') {
                                  diagonal2 = int.parse(value.toString());
                                  diagonal2Controller = value;
                                  if (printData != null &&
                                      printData['project']['diagonal_2'] !=
                                          null) {
                                    printData['project']['diagonal_2'] = value;
                                  }
                                  diagonalCalculations();
                                } else {
                                  diagonal2 = 0;
                                  diagonal2Controller = '0';
                                  duplexPlotValue.text = '0';
                                }
                              });
                            },
                            onTap: () {
                              setState(() {});
                            },
                            // onSubmitted: (value) {
                            //   setState(() {
                            //     plotWidth = value;
                            //     plotSize = int.parse(plotWidth);
                            //     plotSize *= int.parse(plotlength);
                            //   });
                            // },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                // ],
                Row(
                  children: [
                    requirementText("Plot size"),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    if (irregularPlotValue == true) ...[
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        elevation: 5,
                        child: Container(
                          height: height * 0.04,
                          width: width * 0.2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)
                                //fillColor: Colors.green
                                ),
                            key: Key(diagonalCalculations()),
                            // initialValue: printData != null
                            //     ? printData['project'] != null
                            //         // ? printData['project']['plot_size'] != null
                            //         ? printData['project']['plot_size']
                            //         // : duplexPlotValue
                            //         : duplexPlotValue.value.text
                            //     : duplexPlotValue.value.text,
                            // initialValue: printData != null
                            //     ? printData['project'] != null
                            //         ? printData['project']['plot_size'] != null
                            //             ? printData['project']['plot_size'].toString()
                            //             : duplexPlotValue.text
                            //         : duplexPlotValue.text
                            //     : duplexPlotValue.text,
                            controller: duplexPlotValue,
                            onChanged: (value) {
                              setState(() {
                                if (plotLenght == 0 || plotWidth == 0) {
                                  value = "0";
                                } else if (lengthController == '' ||
                                    widthController == '') {
                                  value = "0";
                                } else {
                                  duplexPlotValue.value =
                                      duplexPlotValue.value.copyWith(
                                    text: value.toString(),
                                  );
                                  // printData['project']['plot_size'] =
                                  // duplexPlotValue.text;
                                }
                              });
                            },
                            onTap: () {
                              setState(() {
                                duplexPlotValue.clear();
                                duplexPlotValue.value =
                                    duplexPlotValue.value.copyWith(
                                  text: '',
                                );
                              });
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ] else ...[
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        elevation: 5,
                        child: Container(
                          height: height * 0.04,
                          width: width * 0.2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)
                                //fillColor: Colors.green
                                ),
                            key: Key(totalCalculated()),
                            // initialValue: printData != null
                            //     ? printData['project'] != null
                            //         ? printData['project']['plot_size'].toString()
                            //         : duplexPlotValue.value.text
                            //     : duplexPlotValue.value.text,
                            controller: duplexPlotValue,
                            onChanged: (value) {
                              setState(() {
                                duplexPlotValue.value =
                                    duplexPlotValue.value.copyWith(
                                  text: value.toString(),
                                );
                              });
                            },
                            onTap: () {
                              setState(() {
                                duplexPlotValue.clear();
                                duplexPlotValue.value =
                                    duplexPlotValue.value.copyWith(
                                  text: '',
                                );
                              });
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                if (irregularPlotValue == true) ...[
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.white,
                    width: width * 1,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: requirementText(
                              "For irregular plot plot sketch is required"),
                        ),
                        Row(
                          children: [
                            Material(
                              elevation: 2,
                              child: Container(
                                child: Row(
                                  children: const [
                                    Icon(Icons.cloud_upload),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Upload a hand sketch(jpg)"),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.2,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              color: Colors.blue[900],
                              child: const Text(
                                "Preview",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
                Row(
                  children: [
                    Checkbox(
                      activeColor: checkColor,
                      checkColor: Colors.white,
                      value: surveyor,
                      onChanged: (val) {
                        setState(() {
                          surveyor = val;
                        });
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const Text(
                                "You have raised a Alert Dialog Box"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    surveyor = false;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.black,
                                  child: const Text(
                                    "okay",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    requirementText("Appoint as a surveyor"),
                    Checkbox(
                      activeColor: checkColor,
                      checkColor: Colors.white,
                      value: notReqired,
                      onChanged: (val) {
                        setState(() {
                          notReqired = val;
                        });
                      },
                    ),
                    requirementText("Not required"),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: requirementText("Plot values"),
                ),
                Row(
                  children: [
                    requirementText("East"),
                    Checkbox(
                        activeColor: checkColor,
                        checkColor: Colors.white,
                        // value: otherEast,
                        value: printData != null
                            ? printData['project'] != null
                                ? printData["project"]["east_property"] ==
                                        EAST_PROPERTY
                                    ? true
                                    : eastRoad
                                : eastRoad
                            : eastRoad,
                        onChanged: (value) {
                          setState(() {
                            eastRoad = value!;
                            otherEast = false;
                            // if (eastRoad == true) {
                            //   eastRoad = false;
                            // }
                            if (printData != null &&
                                printData['project'] != null) {
                              printData["project"]["east_property"] = eastRoad;
                            }
                          });
                        }),
                    Forms.requirementText("Other property"),
                    // CheckboxListTile(value: value, onChanged: (value)),
                    Checkbox(
                      activeColor: checkColor,
                      checkColor: Colors.white,
                      // value: false,
                      // value: printData != null ? otherEast : otherEast,
                      value: printData['project'] != null
                          ? printData["project"]["east_property"] ==
                                  EAST_OTHER_PROPERTY
                              ? true
                              : otherEast
                          : otherEast,
                      onChanged: (value) {
                        // print?(printData["project"]["east_property"]);
                        setState(() {
                          otherEast = value!;
                          eastRoad = false;
                          if (printData != null &&
                              printData['project'] != null) {
                            printData["project"]["east_property"] = otherEast;
                          }
                          // if (otherEast = true) {
                          //   otherEast = false;
                          // }
                        });
                      },
                    ),
                    requirementText("Road"),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    if (otherEast == true || printData != null
                        ? printData['project'] != null
                            ? printData["project"]["east_property"] ==
                                    EAST_OTHER_PROPERTY
                                ? true
                                : otherEast!
                            : otherEast!
                        : otherEast!) ...[
                      Material(
                        elevation: 5,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: SizedBox(
                          height: height * 0.04,
                          width: width * 0.2,
                          child: TextFormField(
                            // controller: nameController,
                            initialValue: printData['project'] != null
                                ? printData["project"]['east_road_width']
                                : eastController,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                                hintText: "Road width",
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)),
                            onChanged: (value) {
                              eastController = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Forms.valueContainer(height, width, size, 0.039, 0.05)
                    ]
                  ],
                ),
                Row(
                  children: [
                    requirementText("West"),
                    Checkbox(
                      activeColor: checkColor,
                      checkColor: Colors.white,
                      // value: otherwest,
                      value: printData != null
                          ? printData['project'] != null
                              ? printData["project"]["west_property"] ==
                                      WEST_PROPERTY
                                  ? true
                                  : westRoad
                              : westRoad
                          : westRoad,
                      onChanged: (value) {
                        setState(() {
                          westRoad = value!;
                          otherwest = false;
                          if (printData != null &&
                              printData['project'] != null) {
                            printData["project"]["west_property"] = westRoad;
                          }
                          // if (westRoad == true) {
                          //   westRoad = false;
                          // }
                        });
                      },
                    ),
                    requirementText("Other Property"),
                    Checkbox(
                      activeColor: checkColor,
                      checkColor: Colors.white,
                      // value: otherwest,
                      value: printData['project'] != null
                          ? printData["project"]["west_property"] ==
                                  WEST_OTHER_PROPERTY
                              ? true
                              : otherwest
                          : otherwest,
                      onChanged: (value) {
                        setState(() {
                          otherwest = value!;
                          westRoad = false;
                          if (printData != null &&
                              printData['project'] != null) {
                            printData["project"]["west_property"] = otherwest;
                          }
                          // if (otherwest = true) {
                          //   otherwest = false;
                          // }
                        });
                      },
                    ),
                    requirementText("Road"),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    if (otherwest == true || printData != null
                        ? printData['project'] != null
                            ? printData["project"]["west_property"] ==
                                    WEST_OTHER_PROPERTY
                                ? true
                                : otherwest!
                            : otherwest!
                        : otherwest!) ...[
                      // if (printData['project'] != null
                      //     ? printData["project"]["west_road_width"] != null
                      //         ? printData["project"]["west_road_width"]
                      //         : otherwest
                      //     : otherwest == true) ...[
                      Material(
                        elevation: 5,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: SizedBox(
                          height: height * 0.04,
                          width: width * 0.18,
                          child: TextFormField(
                            // controller: nameController,
                            initialValue: printData['project'] != null
                                ? printData["project"]['west_road_width']
                                : westController,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                                hintText: "Road width",
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)
                                //fillColor: Colors.green

                                ),
                            onChanged: (value) {
                              westController = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Forms.valueContainer(height, width, size, 0.039, 0.05)
                    ]
                  ],
                ),
                Row(
                  children: [
                    requirementText("North"),
                    Checkbox(
                        activeColor: checkColor,
                        checkColor: Colors.white,
                        // value: otherNortn,
                        value: printData != null
                            ? printData['project'] != null
                                ? printData["project"]["north_property"] ==
                                        NORTH_PROPERTY
                                    ? true
                                    : nortRoad
                                : nortRoad
                            : nortRoad,
                        onChanged: (value) {
                          setState(() {
                            nortRoad = value!;
                            otherNortn = false;
                            if (printData != null &&
                                printData['project'] != null) {
                              printData["project"]["north_property"] = nortRoad;
                            }
                            // if (nortRoad == true) {
                            //   nortRoad = false;
                            // }
                          });
                        }),
                    requirementText("Other Property"),
                    Checkbox(
                        activeColor: checkColor,
                        checkColor: Colors.white,
                        // value: otherNortn,
                        value: printData['project'] != null
                            ? printData["project"]["north_property"] ==
                                    EAST_OTHER_PROPERTY
                                ? true
                                : otherNortn
                            : otherNortn,
                        // value: printData['project'] != null
                        //     ? printData["project"]["east_property"] == 1
                        //         ? true
                        //         : nortRoad
                        //     : nortRoad,
                        onChanged: (value) {
                          setState(() {
                            otherNortn = value!;
                            nortRoad = false;
                            if (printData != null &&
                                printData['project'] != null) {
                              printData["project"]["north_property"] = nortRoad;
                            }
                            // if (otherNortn = true) {
                            //   otherNortn = false;
                            // }
                          });
                        }),
                    requirementText("Road"),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    if (otherNortn == true || printData != null
                        ? printData['project'] != null
                            ? printData["project"]["north_property"] ==
                                    NORTH_OTHER_PROPERTY
                                ? true
                                : otherNortn!
                            : otherNortn!
                        : otherNortn!) ...[
                      // if (
                      //   printData['project'] != null
                      //     ? printData["project"]["north_road_width"] != null
                      //         ? printData["project"]["north_road_width"]
                      //         : otherNortn == true
                      //     : otherNortn == true) ...[
                      Material(
                        elevation: 5,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: SizedBox(
                          height: height * 0.04,
                          width: width * 0.18,
                          child: TextFormField(
                            // controller: nameController,
                            initialValue: printData['project'] != null
                                ? printData["project"]['north_road_width']
                                : northController,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                                hintText: "Road width",
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)
                                //fillColor: Colors.green
                                ),
                            onChanged: (value) {
                              northController = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Forms.valueContainer(height, width, size, 0.039, 0.05)
                    ]
                  ],
                ),
                Row(
                  children: [
                    requirementText("South"),
                    Checkbox(
                        activeColor: checkColor,
                        checkColor: Colors.white,
                        // value: otherSouth,
                        value: printData != null
                            ? printData['project'] != null
                                ? printData["project"]["south_property"] ==
                                        SOUTH_PROPERTY
                                    ? true
                                    : southRoad
                                : southRoad
                            : southRoad,
                        onChanged: (value) {
                          setState(
                            () {
                              southRoad = value!;
                              otherSouth = false;
                              if (printData != null &&
                                  printData['project'] != null) {
                                printData["project"]["south_property"] =
                                    SOUTH_PROPERTY;
                              }
                              // if (southRoad == true) {
                              //   southRoad = false;
                              // }
                            },
                          );
                        }),
                    Forms.requirementText("Other Property"),
                    Checkbox(
                        activeColor: checkColor,
                        checkColor: Colors.white,
                        // value: otherSouth,
                        value: printData['project'] != null
                            ? printData["project"]["south_property"] ==
                                    SOUTH_OTHER_PROPERTY
                                ? true
                                : otherSouth
                            : otherSouth,
                        onChanged: (value) {
                          setState(() {
                            otherSouth = value!;
                            southRoad = false;
                            if (printData != null &&
                                printData['project'] != null) {
                              printData["project"]["south_property"] =
                                  otherSouth;
                            }
                            // if (otherSouth = true) {
                            //   otherSouth = false;
                            // }
                          });
                        }),
                    requirementText("Road"),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    if (otherSouth == true || printData != null
                        ? printData['project'] != null
                            ? printData["project"]["south_property"] ==
                                    SOUTH_OTHER_PROPERTY
                                ? true
                                : otherSouth!
                            : otherSouth!
                        : otherSouth!) ...[
                      Material(
                        elevation: 5,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: SizedBox(
                          height: height * 0.04,
                          width: width * 0.18,
                          child: TextFormField(
                            // controller: nameController,
                            initialValue: printData['project'] != null
                                ? printData["project"]['south_road_width']
                                : southController,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                                hintText: "Road width",
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)
                                //fillColor: Colors.green

                                ),
                            onChanged: (value) {
                              southController = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Forms.valueContainer(height, width, size, 0.039, 0.05)
                    ]
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.white,
                  width: width * 1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: northOriented,
                              onChanged: (value) {
                                setState(() {
                                  northOriented = value;
                                });
                              }),
                          Align(
                            alignment: Alignment.topLeft,
                            child: requirementText(
                                "For irregular plot sketch is required"),
                          ),
                        ],
                      ),
                      if (northOriented == true) ...[
                        Row(
                          children: [
                            Material(
                              elevation: 2,
                              child: Container(
                                child: Row(
                                  children: const [
                                    Icon(Icons.cloud_upload),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Upload a hand sketch(jpg)"),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.2,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              color: Colors.blue[900],
                              child: const Text(
                                "Preview",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ]
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: requirementText("Plot level from road level"),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: height * 0.04,
                          padding: const EdgeInsets.all(5),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: printData['project'] != null
                                  // ? printData['project']['level'] != null
                                  ? Text(
                                      "${levels[printData['project']['level']]}")
                                  // : Text(selectedLevel)
                                  : Text(selectedLevel),
                              // value: selectedLevel,
                              icon: const Icon(Icons.keyboard_arrow_down_sharp),
                              elevation: 16,
                              items: levels
                                  .map((it) => DropdownMenuItem<String>(
                                        value: it,
                                        child: Text(it,
                                            style: TextStyle(
                                                fontSize: height * 0.02)),
                                      ))
                                  .toList(),
                              onChanged: (it) => setState(() {
                                selectedLevel = it!;
                                if (it == "Up") {
                                  if (printData['project'] != null) {
                                    printData['project']['level'] = 2;
                                  }
                                  selectedLevelInt = 2;
                                } else if (it == "Down") {
                                  if (printData['project'] != null) {
                                    printData['project']['level'] = 3;
                                  }
                                  selectedLevelInt = 3;
                                } else if (it == "Almost same level") {
                                  if (printData['project'] != null) {
                                    printData['project']['level'] = 1;
                                  }
                                  selectedLevelInt = 1;
                                }
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (selectedLevel == "Up") ...[
                      Material(
                        elevation: 5,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: SizedBox(
                          height: height * 0.04,
                          width: width * 0.22,
                          child: TextFormField(
                            // controller: nameController,
                            initialValue: printData['project'] != null
                                ? printData["project"]['level_value_feet']
                                : lengthController,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                                hintText: "Road width",
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)
                                //fillColor: Colors.green

                                ),
                            onChanged: (value) {
                              levelController = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),

                      SizedBox(
                        width: width * 0.01,
                      ),
                      // valueContainer(
                      //   height,
                      //   width,
                      //   size,
                      //   0.039,
                      //   0.05,
                      // ),
                    ]
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                InkWell(
                  onTap: () async {
                    setState(
                      () {
                        if (irregularPlotValue == true) {
                          isRegular = 2;
                          plot_orientaion = 1;
                        }
                        setProjectTypeIdHouse(FLAT_HOUSE);

                        if (size == "m") {
                          dimenInt = 2;
                          setDimension(dimenInt);
                        } else {
                          dimenInt = 1;
                          setDimension(1);
                        }
                        if (regularPlotValue == true) {
                          // isNotRegular = 1;
                          isRegular = 1;
                        }

                        if (isNorthOrientaion == true) {
                          isNorthOrientaion = 1;
                        }

                        if (westRoad == true) {
                          isWest = WEST_PROPERTY;
                        } else if (otherwest == true) {
                          isWest = WEST_OTHER_PROPERTY;
                        }
                        // if (otherwest == true) {
                        //   isWest = "1";
                        // }
                        if (eastRoad == true) {
                          isEast = EAST_PROPERTY;
                        } else if (otherEast == true) {
                          isEast = EAST_OTHER_PROPERTY;
                        }

                        // if (otherEast == true) {
                        //   isEast = EAST_OTHER_PROPERTY;
                        // }
                        if (nortRoad == true) {
                          isNorth = NORTH_PROPERTY;
                        } else if (otherNortn == true) {
                          isNorth = NORTH_OTHER_PROPERTY;
                        }
                        // if (otherNortn == true) {
                        //   isNorth = "1";
                        // }
                        if (southRoad == true) {
                          isSouth = SOUTH_PROPERTY;
                        } else if (otherSouth == true) {
                          isSouth = SOUTH_OTHER_PROPERTY;
                        }
                        // if (otherSouth == true) {
                        //   isSouth = "1";
                        // }
                        if (notReqired == true) {
                          notReqiredInt = 1;
                        }
                      },
                    );
                    // print("upadte is running");
                    // print(project_id);
                    var status;

                    if (pageId != null) {
                      print("upadte is running");
                      print(project_id);
                      provider.requirementUpdate(
                        project_id,
                        user_id,
                        projectGroupId,
                        projectTypeId,
                        selectedItems,
                        nameController,
                        lastNameController,
                        emailController,
                        COUNTRY_ID,
                        stateId,
                        cityId,
                        addressController,
                        isRegular,
                        dimenInt,
                        lengthController!,
                        widthController!,
                        diagonal1Controller!,
                        diagonal2Controller!,
                        duplexPlotValue.text,
                        " ",
                        plot_orientaion,
                        " ",
                        isEast,
                        eastController,
                        isWest,
                        westController,
                        isNorth,
                        northController,
                        isSouth,
                        southController,
                        selectedLevelInt,
                        levelController,
                        notReqiredInt,
                      );
                    } else {
                      provider.requirementPost(
                        user_id,
                        projectGroupId,
                        projectTypeId,
                        selectedItems,
                        nameController,
                        lastNameController,
                        emailController,
                        COUNTRY_ID,
                        stateId,
                        cityId,
                        addressController,
                        isRegular,
                        dimenInt,
                        lengthController!,
                        widthController!,
                        diagonal1Controller!,
                        diagonal2Controller!,
                        duplexPlotValue.text,
                        " ",
                        plot_orientaion,
                        " ",
                        isEast,
                        eastController,
                        isWest,
                        westController,
                        isNorth,
                        northController,
                        isSouth,
                        southController,
                        selectedLevelInt,
                        levelController,
                        notReqiredInt,
                      );
                    }

                    // project_id = provider.project_id;
                    if (status == 200) {
                      showToast('Project Requirement Submitted !',
                          Colors.lightGreen, ToastGravity.TOP);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(4)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Text(
                      "save and continue",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  bool sqCheck(String str) {
    if (str.contains(size)) {
      return true;
    } else {
      return false;
    }
  }
}
