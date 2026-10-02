import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../services/viacep.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final cepController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();

  final ViaCepService viaCepService = ViaCepService();

  bool carregandoCep = false;

  @override
  void dispose() {
    nomeController.dispose();
    cepController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  Future<void> buscarCep() async {
    final cep = cepController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (cep.length != 8) {
      return;
    }

    setState(() {
      carregandoCep = true;
    });

    final dados = await viaCepService.buscarCep(cep);

    if (!mounted) return;

    setState(() {
      carregandoCep = false;
    });

    if (dados == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('CEP não encontrado.'),
          backgroundColor: const Color(0xFFE59AB4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    ruaController.text = dados['logradouro'] ?? '';
    bairroController.text = dados['bairro'] ?? '';
    cidadeController.text = dados['localidade'] ?? '';
    estadoController.text = dados['uf'] ?? '';
  }

  void salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final pessoa = Pessoa(
      nome: nomeController.text,
      cep: cepController.text,
      numero: numeroController.text,
      complemento: complementoController.text,
      rua: ruaController.text,
      bairro: bairroController.text,
      cidade: cidadeController.text,
      estado: estadoController.text,
    );

    Navigator.pop(context, pessoa);
  }

  Widget campoTexto({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    bool somenteLeitura = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: TextFormField(
        controller: controller,
        readOnly: somenteLeitura,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  color: const Color(0xFF6F82C8),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6F82C8),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Novo cadastro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preencha os dados abaixo para criar um novo cadastro.',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF41455A),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Preencha os dados abaixo.',
                style: TextStyle(
                  color: Color(0xFF888894),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Dados pessoais',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F82C8),
                ),
              ),

              const SizedBox(height: 14),

              campoTexto(
                label: 'Nome',
                controller: nomeController,
                icon: Icons.person_outline_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o nome';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),

              const Text(
                'Endereço',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F82C8),
                ),
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: cepController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final cep = value.replaceAll(
                    RegExp(r'[^0-9]'),
                    '',
                  );

                  if (cep.length == 8) {
                    buscarCep();
                  }
                },
                decoration: InputDecoration(
                  labelText: 'CEP',
                  hintText: '00000-000',
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF6F82C8),
                  ),
                  suffixIcon: carregandoCep
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFE59AB4),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Color(0xFFE59AB4),
                          ),
                          onPressed: buscarCep,
                        ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o CEP';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 13),

              campoTexto(
                label: 'Número',
                controller: numeroController,
                icon: Icons.numbers_rounded,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o número';
                  }
                  return null;
                },
              ),

              campoTexto(
                label: 'Complemento',
                controller: complementoController,
                icon: Icons.add_home_work_outlined,
              ),

              campoTexto(
                label: 'Rua',
                controller: ruaController,
                icon: Icons.home_outlined,
                somenteLeitura: true,
              ),

              campoTexto(
                label: 'Bairro',
                controller: bairroController,
                icon: Icons.location_city_outlined,
                somenteLeitura: true,
              ),

              campoTexto(
                label: 'Cidade',
                controller: cidadeController,
                icon: Icons.location_city_outlined,
                somenteLeitura: true,
              ),

              campoTexto(
                label: 'Estado',
                controller: estadoController,
                icon: Icons.map_outlined,
                somenteLeitura: true,
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: salvar,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text(
                    'Salvar cadastro',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}