import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class PorExtensoPage extends StatefulWidget {
  const PorExtensoPage({super.key});

  @override
  State<PorExtensoPage> createState() => _PorExtensoPageState();
}

class _PorExtensoPageState extends State<PorExtensoPage> {
  String? campo;
  final apiService = InvertextoService();
  String _moedaSelecionada = 'real';
  
  final _controller = TextEditingController();

  final Map<String, String> _opcoesMoeda = {
    'real': 'Real (R\$)',
    'dollar': 'Dólar (US\$)',
    'euro': 'Euro (€)',
  };

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
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Digite um numero",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _moedaSelecionada,
              dropdownColor: Colors.grey[850],
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: const InputDecoration(
                labelText: 'Converter para',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
              ),
              items: _opcoesMoeda.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(_opcoesMoeda[key]!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _moedaSelecionada = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                "Converter",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  campo = _controller.text;
                });
              },
            ),

            Expanded(
              child: FutureBuilder(
                future: apiService.convertePorExtenso(campo, _moedaSelecionada),
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
      return Container();
    }
    final texto = snapshot.data!["text"] ?? '';
    if (texto == "Digite um número acima.") return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }
}