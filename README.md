# 📱 Mevian – A Modern Social Media App

Mevian is a luxurious and minimal social media app developed using **Flutter** and **Firebase**. It offers a visually appealing, Instagram-inspired interface with seamless user interactions including posting, liking, and commenting on images.


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
