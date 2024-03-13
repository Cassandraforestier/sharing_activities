import 'package:flutter/material.dart';
import 'package:sharing_ativities/src/features/activity/screens/activities_page.dart';
import 'package:sharing_ativities/src/features/authentication/controllers/authentication_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text('Sharing Activities'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image(
                image: AssetImage('assets/logo.png'), height: 200, width: 200),
            TextField(
              controller: _loginController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Login',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                String name = _loginController.text;
                String password = _passwordController.text;

                var result =
                    await AuthenticationController.login(name, password);
                if (result != null && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivitiesPage(),
                    ),
                  );
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Vos identifiants sont incorrects. Veuillez réessayer.'),
                      showCloseIcon: true,
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
