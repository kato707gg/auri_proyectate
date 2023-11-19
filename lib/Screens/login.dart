import 'package:auri_proyectate/Components/my_button.dart';
import 'package:auri_proyectate/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height / 1.7,
            child: Background(),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2.6,
            left: 0,
            right: 0,
            bottom: 0,
            child: Homebody(),
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Fondooo.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class Homebody extends StatefulWidget {
  const Homebody({Key? key}) : super(key: key);

  @override
  _HomebodyState createState() => _HomebodyState();
}

class _HomebodyState extends State<Homebody> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Iniciar sesión',
            style: GoogleFonts.quicksand(
              fontSize: 37,
              fontWeight: FontWeight.w800,
              color: Color.fromARGB(255, 45, 45, 85),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          buildInputField('Nombre de usuario'),
          buildInputField('Contraseña', isPassword: true),
          SizedBox(height: 20),
          buildLoginButton(context),
          buildDividerWithText('O ingresa con:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildSocialLoginButton('assets/google.png'),
              buildSocialLoginButton('assets/facebook.png', size: 32),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInputField(String labelText, {bool isPassword = false}) {
    if (isPassword) {
      return Container(
        margin: EdgeInsets.only(top: 15),
        height: 50,
        child: TextFormField(
          style: TextStyle(
            fontSize: 17,
            color: Color.fromARGB(255, 59, 59, 59),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.7,
                color: Color.fromARGB(255, 219, 219, 219),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            labelStyle: TextStyle(
              color: Color(0xFFB3B3B3),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
                color: Color(0xFFB3B3B3),
              ),
            ),
          ),
          obscureText: !_showPassword,
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 15),
        height: 50,
        child: TextFormField(
          style: TextStyle(
            fontSize: 17,
            color: Color.fromARGB(255, 59, 59, 59),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.7,
                color: Color.fromARGB(255, 219, 219, 219),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            labelStyle: TextStyle(
              color: Color(0xFFB3B3B3),
            ),
          ),
        ),
      );
    }
  }

  Widget buildLoginButton(BuildContext context) {
    return ButtonUtils.buildElevatedButton(
      context: context,
      label: 'Entrar',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      backgroundColor: Color.fromARGB(255, 93, 95, 197),
    );
  }

  Widget buildDividerWithText(String text) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 1.8,
          color: Color(0xFFD9D9D9),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFFA8A8A8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSocialLoginButton(String imagePath, {double size = 30}) {
    return ElevatedButton(
      onPressed: () {
        // Realiza la acción de inicio de sesión
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 229, 229, 229),
        fixedSize: Size(0, 70),
        shape: CircleBorder(side: BorderSide.none),
      ),
      child: Image.asset(
        imagePath,
        width: size,
        height: size,
      ),
    );
  }
}
