## **Tire-Wear-Prediction-App**

Welcome to the **Tire Wear Predictor**, a machine learning-powered solution that predicts tire wear percentage based on key driving conditions such as tire compound, track surface, and more. The project leverages a trained regression model served via a FastAPI endpoint and integrates seamlessly with a Flutter-based mobile app for user interaction.

---

##  **Project Features**
- **Machine Learning Model**
- **FastAPI**
- **Flutter App**


---

##  **API Endpoint**
Test the prediction API directly using Postman or any HTTP client.  
**API Base URL**: https://tire-wear-prediction-app-4.onrender.com/predict

Dummy JSON Script to use:

```bash
{
    "tire_compound_hard": 0,
    "tire_compound_medium": 0,
    "tire_compound_soft": 1,
    "tire_compound_wet": 0,
    "track_temperature": 30.2,
    "laps_driven": 56,
    "car_weight": 800,
    "track_surface_rough": 0,
    "track_surface_smooth": 1,
    "driving_style_aggressive": 0,
    "driving_style_balanced": 1,
    "driving_style_conservative": 0,
    "weather_dry": 0,
    "weather_wet": 1
}
```

---

##  **How to Run the Flutter App**
Follow these steps to run the mobile app and test the predictions:

### **2. Set Up Flutter**
Ensure Flutter is installed on your system:
```bash
flutter doctor
```

### **3. Install Dependencies**
```bash
flutter pub get
```

### **4. Run the App**
Connect an emulator or a physical device and launch the app:
```bash
flutter run
```

---

## **YouTube Demo**
https://www.youtube.com/watch?v=4C3J_h8hsE8

---

##**Development Environment**
- **Programming Language**: Python (FastAPI), Dart (Flutter)
- **ML Framework**: Scikit-learn
- **Mobile Framework**: Flutter
- **Hosting**: Render
  
---
