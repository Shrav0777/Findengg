# FindEngg 🎓

### Smart Engineering College Discovery App built with Flutter & Firebase

FindEngg is a modern Flutter-based application designed to help students explore engineering colleges with detailed information, brochures, fee structures, campus galleries, and more — all in one place.

The app combines Firebase integration, dynamic data fetching, web scraping, and a clean UI/UX experience to create a smart college discovery platform for aspiring engineering students.

---

## ✨ Features

### 🏫 College Discovery

* Browse engineering colleges
* Detailed college information pages
* College descriptions, contact details, websites, and locations

### 🔥 Firebase Integration

* Firebase Firestore database integration
* Real-time data fetching
* Structured college data management

### 📄 Brochure Viewer

* View college brochures directly inside the app
* In-app PDF viewer support
* Google Drive direct-download PDF integration

### 💰 Fee Structure System

* Dynamic fee structure scraping
* Store and display fee data from online sources

### 🖼️ Campus Gallery

* Dynamically fetch campus images from:

  * Official college websites
  * Collegedunia
  * Google sources (fallback)
* No need to manually upload images to Firestore

### 📱 Modern Gallery Experience

* Fullscreen swipeable image viewer
* Zoom in/out support
* Download & share image functionality
* Instagram-style image navigation

### 🎨 Modern UI/UX

* Clean and responsive Flutter UI
* Smooth animations and transitions
* Minimal and student-friendly design

---

## 🛠️ Tech Stack

### Frontend

* Flutter
* Dart

### Backend & Database

* Firebase Firestore
* Firebase Authentication (optional/future-ready)

### APIs & Data Sources

* Collegedunia scraping
* Official college websites
* Google image sources

### Packages Used

Some major Flutter packages used in the project:

```yaml
cloud_firestore
firebase_core
http
cached_network_image
photo_view
syncfusion_flutter_pdfviewer
url_launcher
share_plus
```

---

## 📂 Project Structure

```bash
lib/
│
├── screens/
│   ├── home/
│   ├── college_details/
│   ├── gallery/
│   └── brochure/
│
├── widgets/
│
├── services/
│   ├── firebase_services/
│   ├── scraping_services/
│   └── api_services/
│
├── models/
│
├── utils/
│
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have:

* Flutter SDK installed
* Android Studio / VS Code
* Firebase project configured

---

### Installation

#### 1️⃣ Clone the repository

```bash
git clone https://github.com/your-username/findengg.git
```

#### 2️⃣ Navigate to the project folder

```bash
cd findengg
```

#### 3️⃣ Install dependencies

```bash
flutter pub get
```

#### 4️⃣ Run the app

```bash
flutter run
```

---


## 🌟 Future Improvements

* AI-powered college recommendations
* College comparison system
* Cutoff predictor
* Student reviews & ratings
* Bookmark/Favorites feature
* Dark mode support
* Advanced search & filters

---


