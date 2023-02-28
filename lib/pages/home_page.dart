import 'package:cep_app/models/endereco_model.dart';
import 'package:flutter/material.dart';
import '../repositories/cep_repository.dart';
import '../repositories/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  bool loading = false;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar CEP',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(238, 108, 27, 223),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 20,
          left: 12,
          right: 12,
          bottom: 15,
        ),
        child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: cepEC,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(235, 197, 164, 243),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    labelText: "CEP",
                    labelStyle: const TextStyle(
                      fontFamily: 'Arial',
                      color: Color.fromARGB(255, 105, 105, 105),
                      fontSize: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CEP Obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final valid = formKey.currentState?.validate() ?? false;
                      if (valid) {
                        try {
                          setState(() {
                            loading = true;
                          });
                          final endereco =
                              await cepRepository.getCep(cepEC.text);
                          setState(() {
                            loading = false;
                            enderecoModel = endereco;
                          });
                        } catch (e) {
                          setState(() {
                            loading = false;
                            enderecoModel = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Erro ao buscar Endereço')));
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(238, 108, 27, 223),
                      ),
                    ),
                    child:
                        const Text('Buscar', style: TextStyle(fontSize: 18))),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                    visible: loading, child: const CircularProgressIndicator()),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: enderecoModel != null,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.2,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(238, 108, 27, 223),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      children: <Widget>[
                        Visibility(
                          visible: enderecoModel != null,
                          child: Text(
                            '${enderecoModel?.logradouro} ${enderecoModel?.bairro} ${enderecoModel?.cep} ${enderecoModel?.localidade} ${enderecoModel?.uf}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
