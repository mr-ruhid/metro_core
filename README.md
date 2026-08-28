<div align="center">
  <img src="https://raw.githubusercontent.com/ruhidjavadoff/metro-core/main/assets/logo.png" alt="Metro Core Logo" width="250"/>
  <h1>📱 Metro Core OS</h1>
  <p><b>A modern, cross-platform operating system interface built with Flutter, designed to run on Linux-based devices.</b></p>

<a href="https://github.com/ruhidjavadoff/metro-core">View Source Code</a> •
<a href="#%EF%B8%8F-how-to-build-linux--wsl">Installation Guide</a>

<br><br>

  <p>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"></a>
    <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"></a>
    <a href="https://isocpp.org/"><img src="https://img.shields.io/badge/C++-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white" alt="C++"></a>
    <a href="https://www.linux.org/"><img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux"></a>
    <a href="https://cmake.org/"><img src="https://img.shields.io/badge/CMake-064F8C?style=for-the-badge&logo=cmake&logoColor=white" alt="CMake"></a>
  </p>
</div>

<br>

## 📜 About the Project

**Metro Core** aims to provide a sleek, Windows Phone-inspired UI with deep system integration. It bridges the gap between a beautiful modern frontend and low-level hardware control using **Dart FFI (Foreign Function Interface)** and **C++ native libraries**.

---

## ✨ Key Features

| Feature | Description |
|:---|:---|
| 🎨 **Modern UI** | A dark-themed, responsive, tile-based design built from the ground up in Flutter. |
| 🔌 **Deep Integration** | Uses `dart:ffi` to directly communicate with native Linux C++ libraries for hardware management. |
| 🛡️ **Device Encryption** | Full management for Linux LUKS / dm-crypt directly from the UI settings. |
| 📊 **System Monitoring** | Real-time tracking of Battery, Storage, CPU, RAM, Network, and Time. |
| 🚗 **Driving Mode** | Automotive integration infrastructure (Android Auto-like) using WebSockets. |
| 📺 **Wireless Display** | WFD support for seamless screen mirroring and discovery. |
| 🌐 **Multi-language Ready** | Built-in `i18n` support. All UI strings are stored as keys for easy localization. |
| 📱 **Overflow Prevention** | Adaptive screens using `SafeArea` and flexible layouts to prevent bottom overflow errors. |

---

## 🛠️ Tech Stack

| Category | Technology |
|:---|:---|
| **Frontend** | Flutter (Dart) |
| **Backend / Native** | C++ (Compiled to `.so` shared libraries) |
| **Integration** | `dart:ffi` for calling C++ functions directly from Dart |
| **State Management** | Native Flutter State (StatefulWidgets) |
| **Build System** | CMake for C++ libraries |

---

## 🧠 Native Libraries (C++)

The system relies on several C++ shared libraries located in `/usr/local/lib/`. These libraries are dynamically called via `dart:ffi`.

| Library Name | Purpose |
|:---|:---|
| `libbattery_manager.so` | Battery level, charging status, AI protection, and bypass features. |
| `libstorage_manager.so` | Storage capacity, used/free space, and low storage warnings. |
| `libnotification_manager.so` | Notification settings (lock screen, banners, alarms, apps). |
| `libphone_manager.so` | Phone number, caller ID, silence unknown, ask reason. |
| `libwfd_manager.so` | Wireless Display (WFD) discovery and streaming protocols. |
| `libbrightness_manager.so` | Screen brightness control and adjustment. |
| `libabout_manager.so` | System info (kernel version, CPU, RAM). |
| `libsecurity.so` | Device encryption (LUKS) status, enable/disable functionality. |

> **Note:** These libraries are built using CMake and copied to the system paths. The `SystemFFI` class in `lib/ffi/system_ffi.dart` handles loading them safely.

---

## 🔌 FFI Integration (Mock vs Real)

The `SystemFFI` class (`lib/ffi/system_ffi.dart`) utilizes a smart `USE_MOCK` flag system for seamless development:

*   🟢 **`USE_MOCK = true` (Default):** All hardware data is simulated. Perfect for UI development, UI/UX testing, and debugging on non-Linux machines without needing real hardware.
*   🔴 **`USE_MOCK = false`:** The application attempts to load the real `.so` C++ libraries and fetch actual live system data.

---

## 🛡️ Device Encryption & 🚗 Driving Mode

*   **Encryption (`DeviceEncryptionService`):** Provides a UI for managing disk encryption (Linux LUKS). It connects to the `libsecurity.so` native library to check current encryption status, and allows users to enable or disable encryption (requires a PIN).
*   **Driving Mode:** The project includes infrastructure for an Android Auto-like experience. The phone (Linux device) gathers data (music, GPS, notifications) via a C++ service (`phone_bridge.cpp`). The external display runs a Flutter UI (`driving_mode_page.dart`) that connects via WebSocket to the phone and renders the data.

---

## 📂 Project Structure

```text
metro_core/
├── lib/
│   ├── apps/
│   │   └── settings/
│   │       ├── system/
│   │       │   ├── about_page.dart
│   │       │   ├── battery_saver.dart
│   │       │   ├── charge.dart
│   │       │   ├── device_encryption_page.dart
│   │       │   ├── display.dart
│   │       │   ├── notifications.dart
│   │       │   ├── phone.dart
│   │       │   ├── storage.dart
│   │       │   └── wireless_display.dart
│   │       ├── setting_search.dart
│   │       └── settings.dart
│   ├── core/
│   │   └── settings_links.dart
│   ├── ffi/
│   │   └── system_ffi.dart
│   ├── screens/
│   │   └── home/
│   │       └── home.dart
│   └── main.dart
├── linux/
│   └── (Native shared libraries are copied here)
├── pubspec.yaml
└── README.md
🛠️ How to Build (Linux / WSL)
1. Install Dependencies
Install the required packages for building the C++ libraries:

Bash
sudo apt update
sudo apt install cmake make g++ nlohmann-json3-dev -y
2. Build the Native Libraries
Navigate to each native service directory (e.g., ~/system/services/battery) and compile:

Bash
mkdir -p build && cd build
cmake ..
make
sudo cp lib*.so /usr/local/lib/
3. Run the Flutter App
Once libraries are built and placed correctly, run the application:

Bash
flutter pub get
flutter run -d linux
📄 License & Contributing
License: © 2026 Metro Core. All rights reserved.

Contributing: Contributions are highly welcome! Feel free to open issues or pull requests to improve the system architecture, add new hardware integrations, or fix bugs.

<div align="center">
  <h2>🌟 Support & Donate</h2>
  <p>If you appreciate the time and effort put into building this OS interface, consider supporting the development. Your motivation keeps this project alive!</p>

  <br>

  <!-- Main Badges -->
  <a href="https://kofe.al/@ruhidjavadoff">
    <img src="https://kofe.al/assets/images/kofeal-logo.svg" height="40" alt="Support on Kofe.al" style="background-color: white; padding: 5px; border-radius: 5px;">
  </a>
  &nbsp;&nbsp;
  <a href="https://www.paypal.com/paypalme/ruhidjavadoff">
    <img src="https://img.shields.io/badge/Donate%20via-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white" alt="Donate via PayPal" height="40">
  </a>
  
  <br><br>

  <!-- Additional Links in a clean list format -->
  <p align="center">
    ☕ <b>Kofe.al:</b> <a href="https://kofe.al/@ruhidjavadoff">@ruhidjavadoff</a> <br>
    🍵 <b>Çayvoy:</b> <a href="https://cayvoy.com/donate/ruhid4715">ruhid4715</a> <br>
    💳 <b>PayPal:</b> <code>ruhidjavadoff@gmail.com</code> <br>
    🪙 <b>Crypto (USDT - BNB Smart Chain):</b> <br>
    <code>0x9a4AD41762D6B07B8C266b312Cf0dBe31FAd890c</code>
  </p>
</div>