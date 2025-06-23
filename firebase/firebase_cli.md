# firebase cli

1. flutter doctor
2. npm install -g firebase-tools (firebase --version) to verify
3. firebase login

====> inside the application
4. flutter pub add firebase_core firebase_auth cloud_firestore
5. dart pub global activate flutterfire_cli
6. echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
7. source ~/.zshrc
8. flutterfire configure

===> in main.dart step 9.
void main() async {
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
