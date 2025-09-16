import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class BuscaCepPage extends StatefulWidget {
  const BuscaCepPage({super.key});

  @override
  State<BuscaCepPage> createState() => _BuscaCepPageState();
}

class _BuscaCepPageState extends State<BuscaCepPage> {
  String? campo;
  final apiService = InvertextoService();
  
  Widget _buildErrorMessage(String error) {
    final displayError = error.replaceFirst("Exception: ", "");
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Ocorreu um erro:\n$displayError',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: "Digite um CEP",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: apiService.buscaCEP(campo),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      if (campo == null || campo!.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 8.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return _buildErrorMessage(snapshot.error.toString());
                      } else {
                        return exibeResultado(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data == null || snapshot.data.isEmpty) {
      return const SizedBox.shrink();
    }
    String enderecoCompleto = '';
    enderecoCompleto += snapshot.data["street"] ?? "Rua não disponível";
    enderecoCompleto += "\n";
    enderecoCompleto += snapshot.data["neighborhood"] ?? "Bairro não disponível";
    enderecoCompleto += "\n";
    enderecoCompleto += snapshot.data["city"] ?? "Cidade não disponível";
    enderecoCompleto += "\n";
    enderecoCompleto += snapshot.data["state"] ?? "Estado não disponível";
    
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        enderecoCompleto,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        softWrap: true,
      ),
    );
  }
}