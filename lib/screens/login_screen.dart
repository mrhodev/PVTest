// filepath: /Users/mrho/labs/PVTest/lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: user == null
            ? FilledButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Iniciar sesión con Google'),
                onPressed: () async {
                  final user = await signInWithGoogle();
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bienvenido, ${user.displayName ?? user.email}'),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesión'),
                    onPressed: () async {
                      await signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
      ),
    );
  }
}