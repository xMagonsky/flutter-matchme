import 'package:flutter/material.dart';

class UpdateUserDataForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const UpdateUserDataForm({super.key, required this.onSubmit});

  @override
  State<UpdateUserDataForm> createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<UpdateUserDataForm> {
  final _formKey = GlobalKey<FormState>();
  // Provide default values
  String name = 'John';
  String surname = 'Doe';
  String gender = 'Male';
  int age = 25;
  String description = 'Short description about yourself...';
  String userType = 'Seeker';

  String apartmentDescription = 'A cozy apartment...';
  String location = 'New York';
  String locationRange = '10 km';
  String petPreference = 'Yes';

  bool _userTypeError = false;

  void _submitForm() {
    if (userType.isEmpty) {
      setState(() {
        _userTypeError = true;
      });
    } else {
      setState(() {
        _userTypeError = false;
      });
    }
    
    if (_formKey.currentState!.validate() && userType.isNotEmpty) {
      _formKey.currentState!.save();
      widget.onSubmit(<String, dynamic>{
        "name": name,
        "surname": surname,
        "age": age,
        "gender": gender,
        "description": description,
        "userType": userType,
        "apartmentDescription": apartmentDescription,
        "location": location,
        "locationRange": locationRange,
        "petPreference": petPreference,
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: name,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
            onSaved: (value) => name = value!,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: surname,
            decoration: InputDecoration(
              labelText: 'Surname',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.person_outline, color: Colors.deepPurple),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter your surname' : null,
            onSaved: (value) => surname = value!,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: age.toString(),
            decoration: InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.cake, color: Colors.deepPurple),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Please enter your age' : (int.tryParse(value) == null ? 'Please enter a valid number' : null),
            onSaved: (value) => age = int.parse(value!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: gender,
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
            onChanged: (value) => setState(() => gender = value!),
            validator: (value) => value == null ? 'Please select your gender' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: description,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.description, color: Colors.deepPurple),
            ),
            maxLines: 3,
            validator: (value) => value!.isEmpty ? 'Please provide a description' : null,
            onSaved: (value) => description = value!,
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
                  onTap: () => setState(() => userType = 'Seeker'),
                  child: Container(
                    height: 60,
                    width: 130, // This will act as the maximum width
                    decoration: BoxDecoration(
                      color: userType == 'Seeker' ? Colors.deepPurple : Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: userType == 'Seeker' ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Seeker',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: userType == 'Seeker' ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: GestureDetector(
                  onTap: () => setState(() => userType = 'Tenant'),
                  child: Container(
                    height: 60,
                    width: 130, // This will act as the maximum width
                    decoration: BoxDecoration(
                      color: userType == 'Tenant' ? Colors.deepPurple : Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: userType == 'Tenant' ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Tenant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: userType == 'Tenant' ? Colors.white : Colors.black,
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
          if (userType.isNotEmpty)
            Column(
              children: [
                if(userType == "Tenant")
                  Column(
                    children: [
                      TextFormField(
                        initialValue: apartmentDescription,
                        decoration: InputDecoration(
                          labelText: 'Apartment Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.apartment, color: Colors.deepPurple),
                        ),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty ? 'This field is required' : null,
                        onSaved: (value) => apartmentDescription = value!,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                TextFormField(
                  initialValue: location,
                  decoration: InputDecoration(
                    labelText: userType == 'Seeker' ? 'Search location' : 'Apartament location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.location_on, color: Colors.deepPurple),
                  ),
                  validator: (value) => value!.isEmpty ? 'This field is required' : null,
                  onSaved: (value) => location = value!,
                ),
                const SizedBox(height: 16),
                if (userType == 'Seeker')
                  TextFormField(
                    initialValue: locationRange,
                    decoration: InputDecoration(
                      labelText: 'Preferred Location Range',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.map, color: Colors.deepPurple),
                    ),
                    validator: (value) => value!.isEmpty ? 'This field is required' : null,
                    onSaved: (value) => locationRange = value!,
                  ),
                if (userType == 'Seeker')
                  const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: petPreference,
                  decoration: InputDecoration(
                    labelText: userType == 'Seeker' ? 'Do you have a pet?' : 'Do you accept pets?',
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
                  onChanged: (value) => setState(() => petPreference = value!),
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
              'Submit',
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
