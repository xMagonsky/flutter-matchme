import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_match/widgets/location_range_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class UpdateUserFilterForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic> currentData;

  const UpdateUserFilterForm({super.key, required this.onSubmit, required this.currentData});

  @override
  State<UpdateUserFilterForm> createState() => _UpdateUserFilterFormState();
}

class _UpdateUserFilterFormState extends State<UpdateUserFilterForm> {
  final _formKey = GlobalKey<FormState>();
  
  Map<String, dynamic> newData = {
    "searchLocation": GeoPoint(45.468, 9.182),
    "searchRange": 100.0,
    "petPreference": "",
    "rentPriceLimit": double.infinity,
  };

  @override
  void initState() {
    super.initState();

    newData.addAll(widget.currentData);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      widget.onSubmit(newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            decoration: (newData["rentPriceLimit"] == double.infinity)
              ? BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: Colors.black54, width: 1),
              )
              : BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                border: Border(
                  left: BorderSide(color: Colors.black54, width: 1),
                  top: BorderSide(color: Colors.black54, width: 1),
                  right: BorderSide(color: Colors.black54, width: 1)
                )
              ),
            child: SwitchListTile(
              title: const Text('Maximal rent price'),
              value: (newData["rentPriceLimit"] == double.infinity) ? false : true,
              onChanged: (bool value) {
                setState(() {
                  if (value) {
                    newData["rentPriceLimit"] = 0;
                  } else {
                    newData["rentPriceLimit"] = double.infinity;
                  }
                });
              },
            ),
          ),
          
          if ((newData["rentPriceLimit"] != double.infinity))
            TextFormField(
              initialValue: newData["rentPriceLimit"].toStringAsFixed(2),
              decoration: InputDecoration(
                labelText: 'Maximal rent price (monthly)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
                prefixIcon: Icon(Icons.monetization_on_outlined, color: Colors.deepPurple),
              ),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                setState(() => newData["rentPriceLimit"] = double.parse(value!));
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final rent = double.tryParse(value);
                if (rent == null) {
                  return 'Please enter a valid number';
                }
                if (rent < 0) {
                  return 'Value must be 0 or greater';
                }
                
                return null;
              },
            ),
            
          const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: (newData["petPreference"] == "") ? null : newData["petPreference"],
              decoration: InputDecoration(
                labelText: 'Do you have a pet?',
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
              validator: (value) => value == null ? 'Please select if you have a pet' : null,
            ),
            const SizedBox(height: 16),
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
