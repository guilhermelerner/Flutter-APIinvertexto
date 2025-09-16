import 'package:apk_invertexto/view/busca_cep_page.dart';
import 'package:apk_invertexto/view/busca_cnpj_page.dart';
import 'package:apk_invertexto/view/por_extenso_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: const Row(
                children: <Widget>[
                  Icon(Icons.edit, color: Colors.white, size: 50.0),
                  SizedBox(width: 30),
                  Text(
                    "Por Extenso",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PorExtensoPage()));
              },
            ),
            const SizedBox(height: 30),
            GestureDetector(
              child: const Row(
                children: <Widget>[
                  Icon(Icons.home, color: Colors.white, size: 50.0),
                  SizedBox(width: 30),
                  Text(
                    "Busca CEP",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BuscaCepPage()));
              },
            ),
            
            const SizedBox(height: 30),
            GestureDetector(
              child: const Row(
                children: <Widget>[
                  Icon(Icons.business, color: Colors.white, size: 50.0),
                  SizedBox(width: 30),
                  Text(
                    "Busca CNPJ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder:(context) => const BuscaCnpjPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}