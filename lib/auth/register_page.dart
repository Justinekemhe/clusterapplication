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

  late WardData _wardData;
  List<Wards> wards = [];

  bool _isHidden = true;

  String? wardId, regionId, districtId;

  late String _name, _phoneNumber, _email, _password;

  @override
  void initState() {
    super.initState();
    getRegions();
  }

  Future<void> getRegions() async {
    String url = AppConfig.REGIONS_URL;
    try {
      var response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 15));
      var data = json.decode(response.body);
      _regionData = RegionData.fromJson(data);
      setState(() {
        regions = _regionData.regions;
      });
    } catch (e) {
      debugPrint("Failed to fetch regions: $e");
    }
  }

  Future<void> getDistrictsByRegion(String regionId) async {
    String url = "${AppConfig.REGIONS_URL}/$regionId";
    try {
      var response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 15));
      var locationJsonData = json.decode(response.body);
      _districtData = DistrictData.fromJson(locationJsonData);
      setState(() {
        districts = _districtData.districts;
      });
    } catch (e) {
      debugPrint("Failed to fetch districts: $e");
    }
  }

  Future<void> getWardsByDistrict(String districtId) async {
    String url = "${AppConfig.WARDS_URL}$districtId";
    try {
      var response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 15));
      var locationJsonData = json.decode(response.body);
      _wardData = WardData.fromJson(locationJsonData);
      setState(() {
        wards = _wardData.wards;
      });
    } catch (e) {
      debugPrint("Failed to fetch wards: $e");
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> registerUser() async {
    String url = AppConfig.REGISTER_URL;
    try {
      print(
          "Sending: $_name, $_email, $_phoneNumber, $_password, wardId: $wardId");

      var response = await http.post(Uri.parse(url), body: {
        'name': _name,
        'email': _email,
        'phone_number': _phoneNumber,
        'password': _password,
        'ward_id': wardId ?? '',
      }).timeout(Duration(seconds: 15));

      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var userData = json.decode(response.body);
        if (userData['success']) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userData['message'],
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userData['message'],
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        throw Exception("Server returned status: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Registration failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      SizedBox(height: 16.0),
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Jina lako linahitajika" : null,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "Jina"),
                        onSaved: (value) => _name = value!,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Namba ya simu inahitajika" : null,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(hintText: "Simu"),
                        onSaved: (value) => _phoneNumber = value!,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Barua pepe inahitajika" : null,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(hintText: "Barua pepe"),
                        onSaved: (value) => _email = value!,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Nywila inahitajika" : null,
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          hintText: "Nywila",
                          suffixIcon: IconButton(
                            icon: Icon(_isHidden
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: _togglePasswordView,
                          ),
                        ),
                        onSaved: (value) => _password = value!,
                      ),
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: regionId,
                        hint: Text("Chagua Mkoa"),
                        items: regions.map((region) {
                          return DropdownMenuItem<String>(
                            value: region.id.toString(),
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
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: districtId,
                        hint: Text("Chagua Wilaya"),
                        items: districts.map((district) {
                          return DropdownMenuItem<String>(
                            value: district.id.toString(),
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
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: wardId,
                        hint: Text("Chagua Kata"),
                        items: wards.map((ward) {
                          return DropdownMenuItem<String>(
                            value: ward.id.toString(),
                            child: Text(ward.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            wardId = value;
                          });
                        },
                      ),
                      SizedBox(height: 24.0),
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
                        child: Text("Jisajili"),
                      ),
                      SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
