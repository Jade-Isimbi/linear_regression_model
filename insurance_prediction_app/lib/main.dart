import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/prediction_screen.dart';
import 'screens/history_screen.dart';
import 'providers/prediction_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PredictionProvider(),
      child: MaterialApp(
        title: 'Insurance Prediction App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        routes: {
          '/prediction': (context) => PredictionScreen(),
          '/history': (context) => HistoryScreen(),
        },
      ),
    );
  }
}