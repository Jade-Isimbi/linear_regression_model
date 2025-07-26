import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Cost Predictor',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white24),
          ),
          labelStyle: TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white38),
        ),
      ),
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();
  String sex = 'male';
  String smoker = 'no';
  String region = 'southeast';

  String result = '';
  bool isLoading = false;
  bool isSuccess = false;
  bool isError = false;

  Future<void> predict() async {
    setState(() {
      isLoading = true;
      isSuccess = false;
      isError = false;
      result = '';
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse('https://mlsummative-production.up.railway.app/predict');
    final body = jsonEncode({
      "age": int.parse(ageController.text),
      "bmi": double.parse(bmiController.text),
      "children": int.parse(childrenController.text),
      "sex": sex,
      "smoker": smoker,
      "region": region,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          isSuccess = true;
          result = "Predicted cost: \$${data['prediction'][0].toStringAsFixed(2)}";
        });
      } else {
        setState(() {
          isError = true;
          result = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
        result = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  InputDecoration customDecoration({
    required String label,
    String? hint,
    bool enabled = true,
    bool success = false,
    bool error = false,
    IconData? icon,
    String? helperText,
  }) {
    Color borderColor = Colors.white24;
    if (success) borderColor = Colors.green;
    if (error) borderColor = Colors.redAccent;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      enabled: enabled,
      filled: true,
      fillColor: enabled ? Colors.black : Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey, width: 2),
      ),
      suffixIcon: success
          ? Icon(Icons.check_circle, color: Colors.green)
          : error
              ? Icon(Icons.error, color: Colors.redAccent)
              : icon != null
                  ? Icon(icon, color: Colors.white38)
                  : null,
      helperText: helperText,
      helperStyle: TextStyle(
        color: success
            ? Colors.green
            : error
                ? Colors.redAccent
                : Colors.white38,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medical Cost Predictor')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Predict'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: customDecoration(
                  label: 'Age',
                  hint: 'e.g. 30',
                  success: isSuccess,
                  error: isError,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter age' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: bmiController,
                keyboardType: TextInputType.number,
                decoration: customDecoration(
                  label: 'BMI',
                  hint: 'e.g. 22.5',
                  success: isSuccess,
                  error: isError,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter BMI' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: childrenController,
                keyboardType: TextInputType.number,
                decoration: customDecoration(
                  label: 'Children',
                  hint: 'e.g. 2',
                  success: isSuccess,
                  error: isError,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter number of children' : null,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: sex,
                decoration: customDecoration(label: 'Sex'),
                dropdownColor: Colors.black,
                items: ['male', 'female']
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => sex = val!),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: smoker,
                decoration: customDecoration(label: 'Smoker'),
                dropdownColor: Colors.black,
                items: ['yes', 'no']
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => smoker = val!),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: region,
                decoration: customDecoration(label: 'Region'),
                dropdownColor: Colors.black,
                items: [
                  'southeast',
                  'southwest',
                  'northeast',
                  'northwest'
                ]
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => region = val!),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : predict,
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Predict'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
              if (result.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? Colors.green.withOpacity(0.1)
                        : isError
                            ? Colors.red.withOpacity(0.1)
                            : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    result,
                    style: TextStyle(
                      fontSize: 18,
                      color: isSuccess
                          ? Colors.green
                          : isError
                              ? Colors.redAccent
                              : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 80, color: Colors.blueAccent),
            SizedBox(height: 24),
            Text(
              'Medical Cost Predictor',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'This app predicts your medical costs using a machine learning model hosted on FastAPI.\n\n'
                'Enter your details on the Predict page and tap Predict to see your estimated medical cost.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}