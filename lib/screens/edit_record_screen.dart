import 'package:flutter/material.dart';
import 'package:rekam_medis_pasien/services/api_service.dart'; // Import your ApiService here

class EditRecordScreen extends StatefulWidget {
  final dynamic record;

  const EditRecordScreen({super.key, required this.record});

  @override
  _EditRecordScreenState createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController patientNameController;
  late TextEditingController symptomController;
  late TextEditingController severityController;

  @override
  void initState() {
    super.initState();
    patientNameController = TextEditingController(text: widget.record['patient_name']);
    symptomController = TextEditingController(text: widget.record['symptom']);
    severityController = TextEditingController(text: widget.record['severity'].toString());
  }

  @override
  void dispose() {
    patientNameController.dispose();
    symptomController.dispose();
    severityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Set monochrome background
      appBar: AppBar(
        title: const Text('Edit Record', style: TextStyle(fontFamily: 'Georgia', color: Colors.black)),
        backgroundColor: Colors.grey[700], // Darker AppBar for contrast
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text fields to the start
            children: [
              const SizedBox(height: 15),
              TextFormField(
                controller: patientNameController,
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.black), // Border color
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: symptomController,
                decoration: InputDecoration(
                  labelText: 'Symptom',
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.black), // Border color
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a symptom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: severityController,
                decoration: InputDecoration(
                  labelText: 'Severity',
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.black), // Border color
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a severity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await ApiService().updateRecord(widget.record['id'], {
                      'patient_name': patientNameController.text,
                      'symptom': symptomController.text,
                      'severity': severityController.text,
                    });

                    if (success) {
                      Navigator.pop(context); // Go back to the previous screen
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to update record.')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.grey[600], // Button text color
                ),
                child: const Text('Update Record', style: TextStyle(fontFamily: 'Georgia')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
