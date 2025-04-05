# 📱 Mevian – A Modern Social Media App

Mevian is a luxurious and minimal social media app developed using **Flutter** and **Firebase**. It offers a visually appealing, Instagram-inspired interface with seamless user interactions including posting, liking, and commenting on images.

![Mevian Logo]((https://sdmntprwestus.oaiusercontent.com/files/00000000-b4d8-5230-a6c8-dfa4299e7ec1/raw?se=2025-04-05T06%3A45%3A48Z&sp=r&sv=2024-08-04&sr=b&scid=659f7be6-5c45-578a-b5d2-e1eb4825c05c&skoid=aa8389fc-fad7-4f8c-9921-3c583664d512&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-04-04T09%3A06%3A47Z&ske=2025-04-05T09%3A06%3A47Z&sks=b&skv=2024-08-04&sig=dcr7q6fGqJihuiAdcX%2BBnTR740W8qFQWUpMh/dK2cPo%3D))

---

## 🚀 Features

- 🔐 **Authentication** with Firebase
- 📸 **Post creation** with images and captions
- ❤️ **Like & comment** on posts
- 💬 Real-time **comment threads**
- 🢑 **User profiles**
- 🎨 Clean and modern UI inspired by Instagram
- 🌙 Support for **dark mode** and themed components

---

## 🛠️ Tech Stack

- **Flutter** (Frontend Framework)
- **Dart** (Programming Language)
- **Firebase**:
  - Firestore (Database)
  - Firebase Auth (User Authentication)
  - Firebase Storage (Image Upload)

---

## 📦 Folder Structure

```
lib/
├── models/           # User and Post model classes
├── providers/        # State management using Provider
├── screens/          # Auth and Feed screens
├── utils/            # Colors, constants, and global variables
├── widgets/          # Reusable UI components like PostCard
└── main.dart         # App entry point
```

---

## 🔧 Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/mevian.git
   cd mevian
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your Firebase project
   - Replace the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Enable Email/Password Authentication and Firestore

4. **Run the app**
   ```bash
   flutter run
   ```
--

## 🤝 Contributing

Feel free to fork the repo and submit a pull request. Contributions are welcome!

---

## 📃 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## 💡 Inspiration

Mevian draws design inspiration from Instagram, but strives to provide a unique and elegant social experience tailored for minimalism lovers.
