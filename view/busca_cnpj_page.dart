import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class BuscaCnpjPage extends StatefulWidget {
  const BuscaCnpjPage({super.key});

  @override
  State<BuscaCnpjPage> createState() => _BuscaCnpjPageState();
}

class _BuscaCnpjPageState extends State<BuscaCnpjPage> {
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
                labelText: "Digite um CNPJ",
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
                future: apiService.buscaCNPJ(campo),
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
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return _buildErrorMessage(snapshot.error.toString());
                      } else {
                        return _exibeResultado(context, snapshot);
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

  Widget _exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data == null || snapshot.data.isEmpty) {
      return const SizedBox.shrink();
    }
    String dadosEmpresa = '';
    dadosEmpresa += "Razão Social:\n${snapshot.data["razao_social"] ?? "Não disponível"}\n\n";
    dadosEmpresa += "Nome Fantasia:\n${snapshot.data["nome_fantasia"] ?? "Não disponível"}\n\n";
    dadosEmpresa += "Situação: ${snapshot.data["situacao"] ?? "Não disponível"}\n\n";
    dadosEmpresa += "Endereço:\n${snapshot.data["logradouro"]}, ${snapshot.data["numero"]} - ${snapshot.data["bairro"]}, ${snapshot.data["cidade"]} - ${snapshot.data["uf"]}";

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        dadosEmpresa,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        softWrap: true,
      ),
    );
  }
}