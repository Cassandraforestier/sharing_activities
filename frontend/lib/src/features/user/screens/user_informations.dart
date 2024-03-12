import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/common_widgets/bottom_nav_bar.dart';
import 'package:flutter_application_1/src/features/authentication/screens/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer();
    if (newValue.text.isNotEmpty) {
      newText.write(newValue.text[0]);
      if (newValue.text.length > 1) {
        newText.write(newValue.text[1]);
        if (newValue.text[1] != '/') newText.write('/');
      }
      if (newValue.text.length > 2) {
        newText.write(newValue.text.substring(2, min(4, newValue.text.length)));
      }
      if (newValue.text.length > 4) {
        newText.write(
            '/${newValue.text.substring(4, min(8, newValue.text.length))}');
      }
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  String? url = dotenv.env['BACKEND_URL'];
  late String currentUserLogin = '';
  late String currentUserAddress = '';
  late String currentUserPostalCode = '';
  late String currentUserCity = '';
  late String? currentUserPassword;
  late String? currentUserBirthdayDate;
  late String? currentUserName;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _birthdayDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    Map<String, dynamic> userData = await getData();
    String? username = userData['username'];
    try {
      final response = await http.get(Uri.parse("$url/api/user/$username"));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          currentUserLogin = userData['name'] ?? 'N/A';
          currentUserAddress = userData['address'] ?? 'N/A';
          currentUserPostalCode = userData['postalCode'] ?? 'N/A';
          currentUserCity = userData['city'] ?? 'N/A';
          currentUserPassword = userData['password'];
          currentUserBirthdayDate = userData['birthdayDate'];
          currentUserName = userData['name'];
          _addressController.text = currentUserAddress;
          _postalCodeController.text = currentUserPostalCode;
          _cityController.text = currentUserCity;
          _birthdayDateController.text =
              _formatDate(currentUserBirthdayDate) ?? '';
          _passwordController.text = currentUserPassword ?? '';
          _nameController.text = currentUserName ?? '';
        });
      } else {
        print("Failed to fetch user data. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  // Fonction pour formater la date
  String? _formatDate(String? date) {
    if (date == null) return null;
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  // Fonction pour renvoyer la date au bon format
  String _formatDateForBackend(String date) {
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  Future<void> saveUserData() async {
    try {
      Map<String, dynamic> userData = await getData();
      String? userId = userData['userId'];
      String? username = userData['username'];

      if (userId != null && username != null) {
        final response = await http.put(
          Uri.parse("$url/api/user/$userId"),
          body: {
            'address': _addressController.text,
            'postalCode': _postalCodeController.text,
            'city': _cityController.text,
            'birthdayDate': _formatDateForBackend(_birthdayDateController.text),
            'password': _passwordController.text,
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            currentUserAddress = _addressController.text;
            currentUserPostalCode = _postalCodeController.text;
            currentUserCity = _cityController.text;
            currentUserBirthdayDate = _birthdayDateController.text;
            currentUserPassword = _passwordController.text;
          });
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vos données ont été enregistrées'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Une erreur est survenue, veuillez réessayer plus tard'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        print('Failed to retrieve user ID or username');
      }
    } catch (error) {
      print('Error updating user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        foregroundColor: Colors.white,
        actions: [
          ElevatedButton(
            onPressed: saveUserData,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: Text('Valider'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Informations personnelles',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Login',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 78, 78, 79)),
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 78, 78, 79)),
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _birthdayDateController,
                  decoration: InputDecoration(labelText: 'Anniversaire'),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                    _DateInputFormatter(),
                  ],
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Addresse'),
                ),
                TextFormField(
                  controller: _postalCodeController,
                  decoration: InputDecoration(labelText: 'Code Postal'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'Ville'),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text('Déconnexion'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarManager.build(context, 2),
    );
  }
}
