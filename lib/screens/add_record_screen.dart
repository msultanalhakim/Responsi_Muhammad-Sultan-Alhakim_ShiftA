import 'package:flutter/material.dart';
import 'package:rekam_medis_pasien/services/api_service.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _symptomController = TextEditingController();
  final TextEditingController _severityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Set monochrome background
      appBar: AppBar(
        backgroundColor: Colors.grey[700], // Darker AppBar for contrast
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align title to the start
          children: [
            const Text(
              'Add Patient', 
              style: TextStyle(
                color: Colors.black, // Set title color to black
                fontSize: 20,
                fontWeight: FontWeight.w600, // Set font weight to 600 (semi-bold)
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _patientNameController,
              decoration: InputDecoration(
                labelText: 'Patient Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _symptomController,
              decoration: InputDecoration(
                labelText: 'Symptom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _severityController,
              decoration: InputDecoration(
                labelText: 'Severity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'patient_name': _patientNameController.text,
                  'symptom': _symptomController.text,
                  'severity': _severityController.text,
                };
                await ApiService().createRecord(data);
                Navigator.pop(context); // Go back after creating
              },
              child: const Text('Insert', style: TextStyle(fontFamily: 'Georgia')),
            ),
          ],
        ),
      ),
    );
  }
}
