import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompleteRegistration extends StatefulWidget {
  const CompleteRegistration({super.key});

  @override
  _CompleteRegistrationState createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<CompleteRegistration> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String surname = '';
  String gender = '';
  String description = '';
  String userType = '';
  bool _userTypeError = false;
  String additionalField = '';

  void _submitForm() {
    //_formKey.currentState!.save();

    if (userType.isEmpty) {
      setState(() {
        _userTypeError = true;
      });
    } else {
      setState(() {
        _userTypeError = false;
      });
    }
    
    if (_formKey.currentState!.validate() && !_userTypeError) {
      FirebaseFirestore.instance.collection('offers').add({
        'name': name,
        'surname': surname,
        'gender': gender,
        'description': description,
        'userType': userType,
        if (userType == 'Seeker' || userType == 'Tenant') 'additionalField': additionalField,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Complete!')),
      );

      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Card(
              color: Colors.white.withOpacity(0.9),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      "Complete registration!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
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
                    DropdownButtonFormField<String>(
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
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (userType.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: userType == 'Seeker'
                                ? 'Preferred Location'
                                : 'Property Details',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(
                              userType == 'Seeker' ? Icons.place : Icons.home,
                              color: Colors.deepPurple,
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? 'This field is required' : null,
                          onSaved: (value) => additionalField = value!,
                        ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
