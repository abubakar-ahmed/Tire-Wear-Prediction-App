import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(TireWearApp());

class TireWearApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TireWearPredictor(),
    );
  }
}

class TireWearPredictor extends StatefulWidget {
  @override
  _TireWearPredictorState createState() => _TireWearPredictorState();
}

class _TireWearPredictorState extends State<TireWearPredictor> {
  // Dropdown values
  String? selectedTireCompound;
  String? selectedTrackSurface;
  String? selectedDrivingStyle;
  String? selectedWeather;

  // Text field controllers
  TextEditingController trackTemperatureController = TextEditingController();
  TextEditingController lapsDrivenController = TextEditingController();
  TextEditingController carWeightController = TextEditingController();

  String? prediction;

  // Function to map inputs to API format
  Map<String, dynamic> encodeInputs() {
    return {
      "tire_compound_hard": selectedTireCompound == "Hard" ? 1 : 0,
      "tire_compound_medium": selectedTireCompound == "Medium" ? 1 : 0,
      "tire_compound_soft": selectedTireCompound == "Soft" ? 1 : 0,
      "tire_compound_wet": selectedTireCompound == "Wet" ? 1 : 0,
      "track_temperature": double.tryParse(trackTemperatureController.text) ?? 0.0,
      "laps_driven": int.tryParse(lapsDrivenController.text) ?? 0,
      "car_weight": int.tryParse(carWeightController.text) ?? 0,
      "track_surface_rough": selectedTrackSurface == "Rough" ? 1 : 0,
      "track_surface_smooth": selectedTrackSurface == "Smooth" ? 1 : 0,
      "driving_style_aggressive": selectedDrivingStyle == "Aggressive" ? 1 : 0,
      "driving_style_balanced": selectedDrivingStyle == "Balanced" ? 1 : 0,
      "driving_style_conservative": selectedDrivingStyle == "Conservative" ? 1 : 0,
      "weather_dry": selectedWeather == "Dry" ? 1 : 0,
      "weather_wet": selectedWeather == "Wet" ? 1 : 0,
    };
  }

  // Function to make API call
  Future<void> getPrediction() async {
    if (selectedTireCompound == null ||
        selectedTrackSurface == null ||
        selectedDrivingStyle == null ||
        selectedWeather == null ||
        trackTemperatureController.text.isEmpty ||
        lapsDrivenController.text.isEmpty ||
        carWeightController.text.isEmpty) {
      setState(() {
        prediction = "Please fill in all the fields.";
      });
      return;
    }

    final url = Uri.parse("https://tire-wear-prediction-app-4.onrender.com/predict"); // Replace with your API URL
    final requestBody = json.encode(encodeInputs());

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          double result = responseData["prediction"][0];
          prediction = "${result.toStringAsFixed(1)}%";
        });
      } else {
        setState(() {
          prediction = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        prediction = "Error: Unable to connect to the server";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Text("Tire Wear Predictor"),
            SizedBox(width: 8),
            Text("🚗"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tire Compound Dropdown
            DropdownButtonFormField<String>(
              value: selectedTireCompound,
              hint: Text("Select Tire Compound"),
              items: ["Soft", "Medium", "Hard", "Wet"]
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => setState(() => selectedTireCompound = value),
              decoration: InputDecoration(labelText: "Tire Compound"),
            ),
            SizedBox(height: 8),
            // Track Temperature Input
            TextField(
              controller: trackTemperatureController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Track Temperature (°C)"),
            ),
            SizedBox(height: 8),
            // Laps Driven Input
            TextField(
              controller: lapsDrivenController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Laps Driven"),
            ),
            SizedBox(height: 8),
            // Car Weight Input
            TextField(
              controller: carWeightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Car Weight (kg)"),
            ),
            SizedBox(height: 8),
            // Track Surface Dropdown
            DropdownButtonFormField<String>(
              value: selectedTrackSurface,
              hint: Text("Select Track Surface"),
              items: ["Smooth", "Rough"]
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => setState(() => selectedTrackSurface = value),
              decoration: InputDecoration(labelText: "Track Surface"),
            ),
            SizedBox(height: 8),
            // Driving Style Dropdown
            DropdownButtonFormField<String>(
              value: selectedDrivingStyle,
              hint: Text("Select Driving Style"),
              items: ["Aggressive", "Balanced", "Conservative"]
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => setState(() => selectedDrivingStyle = value),
              decoration: InputDecoration(labelText: "Driving Style"),
            ),
            SizedBox(height: 8),
            // Weather Dropdown
            DropdownButtonFormField<String>(
              value: selectedWeather,
              hint: Text("Select Weather"),
              items: ["Dry", "Wet"]
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => setState(() => selectedWeather = value),
              decoration: InputDecoration(labelText: "Weather"),
            ),
            SizedBox(height: 16),
            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: getPrediction,
                child: Text("Predict"),
              ),
            ),
            SizedBox(height: 16),
            // Prediction Result
            if (prediction != null)
              Center(
                child: Text(
                  prediction!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
