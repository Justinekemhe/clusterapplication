import 'dart:convert';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/models/district_data.dart';
import 'package:clusterapplication/models/region_data.dart';
import 'package:clusterapplication/models/ward_data.dart';
import 'package:clusterapplication/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  late RegionData _regionData;
  List<Regions> regions = [];
  late DistrictData _districtData;
  List<Districts> districts = [];
  bool _isHidden = true;

  late WardData _wardData;
  List<Wards> wards = [];

  String? wardId, regionId, districtId;

  late String _name, _phoneNumber, _email, _password;

  Future<void> registerUser() async {
    String url = AppConfig.REGISTER_URL;
    var response = await http.post(Uri.parse(url), body: {
      'name': _name,
      'email': _email,
      'phone_number': _phoneNumber,
      'password': _password,
      'ward_id':
          wardId ?? '', // Provide a default empty string if wardId is null
    });

    var userData = json.decode(response.body);
    if (userData['success']) {
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
        content: Text(
          userData['message'],
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return LoginPage();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
        (Route route) => false,
      );
    } else {
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
        content: Text(
          userData['message'],
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.red),
        ),
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> getRegions() async {
    String url = AppConfig.REGIONS_URL;
    var response = await http.get(Uri.parse(url));

    var data = json.decode(response.body);
    _regionData = RegionData.fromJson(data);
    setState(() {
      regions = _regionData.regions;
    });
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> getDistrictsByRegion(String regionId) async {
    String url = AppConfig.REGIONS_URL + "/" + regionId;
    var response = await http.get(Uri.parse(url));

    print(response.body);

    var locationJsonData = json.decode(response.body);
    _districtData = DistrictData.fromJson(locationJsonData);
    setState(() {
      districts = _districtData.districts;
    });
  }

  Future<void> getWardsByDistrict(String districtId) async {
    String url = AppConfig.WARDS_URL + districtId;
    var response = await http.get(Uri.parse(url));

    var locationJsonData = json.decode(response.body);
    _wardData = WardData.fromJson(locationJsonData);
    setState(() {
      wards = _wardData.wards;
    });
  }

  @override
  void initState() {
    super.initState();
    getRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fungua akaunti"),
      ),
      body: isLoading
          ? LoadingPage()
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Tafadhali ingiza taarifa sahihi",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Jina lako linahotajika";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                hintText: "Jina",
                                hintStyle: TextStyle(fontSize: 18.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  _name = value!;
                                });
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Namba ya simu inahitajika";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                hintText: "Simu",
                                hintStyle: TextStyle(fontSize: 18.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  _phoneNumber = value!;
                                });
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Barua pepe inahitajika";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                hintText: "Barua pepe",
                                hintStyle: TextStyle(fontSize: 18.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  _email = value!;
                                });
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Nywila inahitajika";
                                }
                                return null;
                              },
                              obscureText: _isHidden,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                hintText: "Nywila",
                                hintStyle: TextStyle(fontSize: 18.0),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: _togglePasswordView,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  _password = value!;
                                });
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: regionId,
                                hint: Text("Chagua Mkoa"),
                                items: regions.map((region) {
                                  return DropdownMenuItem<String>(
                                    value: region.id
                                        .toString(), // Convert id to String
                                    child: Text(region.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    regionId = value;
                                    getDistrictsByRegion(value!);
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: districtId,
                                hint: Text("Chagua Wilaya"),
                                items: districts.map((district) {
                                  return DropdownMenuItem<String>(
                                    value: district.id
                                        .toString(), // Convert id to String
                                    child: Text(district.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    districtId = value;
                                    getWardsByDistrict(value!);
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: wardId,
                                hint: Text("Chagua Kata"),
                                items: wards.map((ward) {
                                  return DropdownMenuItem<String>(
                                    value: ward.id
                                        .toString(), // Convert id to String
                                    child: Text(ward.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    wardId = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  registerUser();
                                }
                              },
                              child: Text('Jisajili'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
