import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_match/widgets/location_range_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UpdateUserDataForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? currentData;

  const UpdateUserDataForm({super.key, required this.onSubmit, this.currentData});

  @override
  State<UpdateUserDataForm> createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<UpdateUserDataForm> {
  final _formKey = GlobalKey<FormState>();


  bool _userTypeError = false;

  bool _mapLoading = false;
  
  Map<String, dynamic> newData = {
    "name": "",
    "surname": "",
    "gender": "",
    "description": "",
    "userType": "",
    "image": "https://magonsky.scay.net/img/no-img.jpg",
    "apartmentImage": "https://magonsky.scay.net/img/no-img.jpg",
    "apartmentDescription": "",
    "apartamentAddress": "",
    "apartamentLocation": GeoPoint(45.468, 9.182),
    "searchLocation": GeoPoint(45.468, 9.182),
    "searchRange": 100.0,
    "petPreference": "",
    "rentPriceLimit": double.infinity,
  };

  @override
  void initState() {
    super.initState();

    if (widget.currentData != null) {
      newData.addAll(widget.currentData!);
    }
  }

  final MapController _mapController = MapController();

  void _submitForm() {
    if (newData["userType"].isEmpty) {
      setState(() {
        _userTypeError = true;
      });
    } else {
      setState(() {
        _userTypeError = false;
      });
    }
    
    if (_formKey.currentState!.validate() && newData["userType"].isNotEmpty && !_mapLoading) {
      _formKey.currentState!.save();
      if (widget.currentData != null) {
        if (newData["userType"] != widget.currentData!["userType"]) {
          newData["accepted"] = [];
          if (newData["petPreference"] == "") {
            newData["petPreference"] = "No";
          }
        }
      }
      widget.onSubmit(newData);
    }
  }

  Timer? _debounce;

  void _onDebounceCompleted(String value) async {
    final url = Uri.parse("https://nominatim.openstreetmap.org/search?format=jsonv2&q=$value");
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    setState(() {
      if (data.length > 0) {
        newData["apartamentLocation"] = GeoPoint(double.parse(data[0]["lat"]), double.parse(data[0]["lon"]));
        _mapController.move(LatLng(double.parse(data[0]["lat"]), double.parse(data[0]["lon"])), 13);
        _mapLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: newData["name"],
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
            onSaved: (value) => newData["name"] = value!,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: newData["surname"],
            decoration: InputDecoration(
              labelText: 'Surname',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.person_outline, color: Colors.deepPurple),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter your surname' : null,
            onSaved: (value) => newData["surname"] = value!,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: newData["age"]?.toString() ?? "",
            decoration: InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.cake, color: Colors.deepPurple),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Please enter your age' : (int.tryParse(value) == null ? 'Please enter a valid number' : null),
            onSaved: (value) => newData["age"] = int.parse(value!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: (newData["gender"] == "") ? null : newData["gender"],
            decoration: InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.transgender, color: Colors.deepPurple),
            ),
            items: ['Male', 'Female', 'Other']
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            onChanged: (value) => setState(() => newData["gender"] = value!),
            validator: (value) => value == null ? 'Please select your gender' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: newData["description"],
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.description, color: Colors.deepPurple),
            ),
            maxLines: 3,
            validator: (value) => value!.isEmpty ? 'Please provide a description' : null,
            onSaved: (value) => newData["description"] = value!,
          ),
          const SizedBox(height: 16),
          const Text(
            'I want to...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () => setState(() => newData["userType"] = 'Seeker'),
                  child: Container(
                    height: 60,
                    width: 130, // This will act as the maximum width
                    decoration: BoxDecoration(
                      color: newData["userType"] == 'Seeker' ? Colors.deepPurple : Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: newData["userType"] == 'Seeker' ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'find\nan apartament',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: newData["userType"] == 'Seeker' ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: GestureDetector(
                  onTap: () => setState(() => newData["userType"] = 'Tenant'),
                  child: Container(
                    height: 60,
                    width: 130, // This will act as the maximum width
                    decoration: BoxDecoration(
                      color: newData["userType"] == 'Tenant' ? Colors.deepPurple : Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: newData["userType"] == 'Tenant' ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'find\na roomate',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: newData["userType"] == 'Tenant' ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_userTypeError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Please select as who would you like to interact with the app!',
                style: TextStyle(
                  color: Colors.red[900],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 16),
          if (newData["userType"].isNotEmpty)
            Column(
              children: [
                if(newData["userType"] == "Tenant")
                  Column(
                    children: [
                      TextFormField(
                        initialValue: newData["apartamentAddress"],
                        decoration: InputDecoration(
                          labelText: 'Apartament address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          ),
                          prefixIcon: Icon(Icons.location_on, color: Colors.deepPurple),
                        ),
                        validator: (value) => value!.isEmpty ? 'This field is required' : null,
                        onSaved: (value) => newData["apartamentAddress"] = value!,
                        onChanged: (value) {
                          setState(() {
                            _mapLoading = true;
                          });
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce = Timer(const Duration(milliseconds: 1000), () {
                            _onDebounceCompleted(value);
                          });
                        },
                      ),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
                        ),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: LatLng(newData["apartamentLocation"].latitude, newData["apartamentLocation"].longitude),
                            initialZoom: 13.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment(0, -0.30),
                                  point: LatLng(newData["apartamentLocation"].latitude, newData["apartamentLocation"].longitude),
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.purple,
                                    size: 40,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 15.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: newData["apartmentDescription"],
                        decoration: InputDecoration(
                          labelText: 'Apartment Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.apartment, color: Colors.deepPurple),
                        ),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty ? 'This field is required' : null,
                        onSaved: (value) => newData["apartmentDescription"] = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: newData["rentPrice"]?.toString() ?? "",
                        decoration: InputDecoration(
                          labelText: 'Rent price (monthly)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.cake, color: Colors.deepPurple),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Please enter the rent price' : (int.tryParse(value) == null ? 'Please enter a valid number' : null),
                        onSaved: (value) => newData["rentPrice"] = int.parse(value!),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: (newData["petPreference"] == "") ? null : newData["petPreference"],
                        decoration: InputDecoration(
                          labelText: 'Do you accept pets?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.pets, color: Colors.deepPurple),
                        ),
                        items: ['Yes', 'No']
                          .map((question) => DropdownMenuItem(
                                value: question,
                                child: Text(question),
                              ))
                          .toList(),
                        onChanged: (value) => setState(() => newData["petPreference"] = value!),
                        validator: (value) => value == null ? 'Please select if you accept pets' : null,
                      ),
                    ],
                  ),

                if (newData["userType"] == 'Seeker')
                  Column(
                    children: [
                      LocationRangeMap(
                        initialLocation: LatLng(newData["searchLocation"].latitude, newData["searchLocation"].longitude),
                        initialRange: newData["searchRange"],
                        onChanged:(value) {
                          setState(() {
                            newData["searchLocation"] = GeoPoint(value.location.latitude, value.location.longitude);
                            newData["searchRange"] = value.range;
                          });
                        },
                      ),
                    ],
                  )
              ],
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              elevation: 8,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}
