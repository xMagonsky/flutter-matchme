import 'package:flutter/material.dart';

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
  
  Map<String, dynamic> newData = {
    "name": "",
    "surname": "",
    "age": "",
    "gender": "",
    "description": "",
    "userType": "",
    "apartmentDescription": "",
    "location": "",
    "locationRange": "",
    "petPreference": "",
  };

  @override
  void initState() {
    super.initState();

    if (widget.currentData != null) {
      newData = widget.currentData!;
    }
  }

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
    
    if (_formKey.currentState!.validate() && newData["userType"].isNotEmpty) {
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
            initialValue: newData["age"].toString(),
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
            'Are you a:',
            style: TextStyle(
              fontSize: 16,
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
                        'Seeker',
                        style: TextStyle(
                          fontSize: 16,
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
                        'Tenant',
                        style: TextStyle(
                          fontSize: 16,
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
                TextFormField(
                  initialValue: newData["location"],
                  decoration: InputDecoration(
                    labelText: newData["userType"] == 'Seeker' ? 'Search location' : 'Apartament location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.location_on, color: Colors.deepPurple),
                  ),
                  validator: (value) => value!.isEmpty ? 'This field is required' : null,
                  onSaved: (value) => newData["location"] = value!,
                ),
                const SizedBox(height: 16),
                if(newData["userType"] == "Tenant")
                  Column(
                    children: [
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
                    ],
                  ),
                if (newData["userType"] == 'Seeker')
                  TextFormField(
                    initialValue: newData["locationRange"],
                    decoration: InputDecoration(
                      labelText: 'Preferred Location Range',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.map, color: Colors.deepPurple),
                    ),
                    validator: (value) => value!.isEmpty ? 'This field is required' : null,
                    onSaved: (value) => newData["locationRange"] = value!,
                  ),
                if (newData["userType"] == 'Seeker')
                  const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: (newData["petPreference"] == "") ? null : newData["petPreference"],
                  decoration: InputDecoration(
                    labelText: newData["userType"] == 'Seeker' ? 'Do you have a pet?' : 'Do you accept pets?',
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
                  validator: (value) => value == null ? 'Please select your gender' : null,
                ),
                const SizedBox(height: 16),
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
