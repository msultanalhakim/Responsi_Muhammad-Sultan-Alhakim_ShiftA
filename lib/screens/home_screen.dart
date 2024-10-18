import 'package:flutter/material.dart';
import 'package:rekam_medis_pasien/screens/edit_record_screen.dart';
import 'package:rekam_medis_pasien/services/api_service.dart';
import 'package:rekam_medis_pasien/screens/sidemenu.dart';
import 'package:rekam_medis_pasien/screens/add_record_screen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? namauser;
  List<dynamic> records = [];
  int currentPage = 0;
  bool isLoading = false;
  static const int recordsPerPage = 4; // Ubah menjadi 4 untuk pagination

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchRecords();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    setState(() {
      namauser = storedUsername;
    });
  }

  Future<void> _fetchRecords() async {
    setState(() {
      isLoading = true; // Set loading state
    });

    try {
      // Fetch records from the API
      final allRecords = await ApiService().getAll();
      // Sort records by creation date (most recent first)
      allRecords.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
      setState(() {
        records = allRecords; // Store all records
        isLoading = false; // Reset loading state
      });
    } catch (error) {
      setState(() {
        isLoading = false; // Reset loading state
      });
      // Handle error (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  List<dynamic> get paginatedRecords {
    // Return a slice of the records list for the current page
    int startIndex = currentPage * recordsPerPage;
    return records.skip(startIndex).take(recordsPerPage).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'List Patient',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Georgia'),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rumah Sakit Kartika Husada',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddRecordScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                      child: const Text('Add Record', style: TextStyle(fontFamily: 'Georgia', color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    if (isLoading) // Show loader while fetching data
                      const Center(child: CircularProgressIndicator())
                    else if (records.isEmpty) // Check if records are empty
                      const Center(child: Text('No records found.', style: TextStyle(color: Colors.white)))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: paginatedRecords.length,
                        itemBuilder: (context, index) {
                          final record = paginatedRecords[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            color: Colors.grey[700],
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(15),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record['patient_name'] ?? 'Unknown Record',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Symptom: ${record['symptom'] ?? 'No Symptoms'}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                  Text(
                                    'Severity: ${record['severity'] ?? 'Unknown Severity'}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showDetail(record);
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.white),
                                    onPressed: () => _updateRecord(record),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white),
                                    onPressed: () => _deleteRecord(record['id']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 10),
                    // Pagination Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentPage > 0) // Show previous button if not on the first page
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentPage--;
                              });
                            },
                            child: const Text('Previous'),
                          ),
                        if ((currentPage + 1) * recordsPerPage < records.length) // Show next button if more records are available
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentPage++;
                              });
                            },
                            child: const Text('Next'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const Sidemenu(),
    );
  }

  void _updateRecord(dynamic record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecordScreen(record: record),
      ),
    );
  }

  void _deleteRecord(int id) async {
    final success = await ApiService().deleteRecord(id);
    if (success) {
      setState(() {
        // Refresh the state after deletion
        records.removeWhere((record) => record['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete record. Check if it exists or try again.')),
      );
    }
  }

  void _showDetail(dynamic record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(record['patient_name'] ?? 'Unknown Record', style: const TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Symptom: ${record['symptom'] ?? 'No Symptoms'}', style: const TextStyle(color: Colors.black)),
              Text('Severity: ${record['severity'] ?? 'Unknown Severity'}', style: const TextStyle(color: Colors.black)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
