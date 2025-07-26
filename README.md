# Medical Cost Predictor

## Mission & Problem Statement

My mission is to improve access to quality healthcare in Rwanda by leveraging technology-driven solutions. The sector faces critical challenges, including a shortage of doctors and limited resources, leading to long wait times and inefficiencies. Through innovative digital platforms, I aim to bridge gaps between patients, healthcare providers, and services.

## Public API Endpoint

**Swagger UI Documentation:** `https://mlsummative-production.up.railway.app/docs`

**Test the API:**
- Navigate to the Swagger UI link above
- Use the `/predict` endpoint
- Input required parameters: `age` (int), `bmi` (float), `children` (int), `sex` (string), `smoker` (string), `region` (string)
- Execute to receive medical cost predictions

## Video Demo

**YouTube Link:** 

*The video shows how:*
- Model performance comparison (Linear Regression vs Decision Tree vs Random Forest)
- API testing on Swagger UI with data validation
- Flutter mobile app functionality and predictions
- End-to-end system demonstration

## Mobile App Instructions

### Prerequisites
- Flutter SDK installed
- Android device or emulator
- Internet connection

### Setup & Run
1. **Clone the repository:**
   ```bash
   git clone [your-repo-url]
   cd [project-directory]
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Connect device/emulator:**
   ```bash
   flutter devices
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Using the App
1. **Fill in the prediction form:**
   - Age (e.g., 30)
   - BMI (e.g., 22.5)
   - Number of children (e.g., 2)
   - Sex (male/female)
   - Smoking status (yes/no)
   - Region (southeast/southwest/northeast/northwest)

2. **Tap "Predict"** to get medical cost estimation

3. **Navigate** using the menu (top-left) to access the About page


