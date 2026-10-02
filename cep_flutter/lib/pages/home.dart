import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pessoa.dart';
import 'cadastro.dart';
import 'splash.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pessoa> pessoas = [];

  @override
  void initState() {
    super.initState();
    carregarPessoas();
  }

  Future<void> carregarPessoas() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getStringList('pessoas') ?? [];

    setState(() {
      pessoas = dados
          .map(
            (item) => Pessoa.fromJson(
              jsonDecode(item),
            ),
          )
          .toList();
    });
  }

  Future<void> salvarPessoas() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = pessoas
        .map(
          (pessoa) => jsonEncode(
            pessoa.toJson(),
          ),
        )
        .toList();

    await prefs.setStringList('pessoas', dados);
  }

  Future<void> abrirCadastro() async {
    final pessoa = await Navigator.push<Pessoa>(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroPage(),
      ),
    );

    if (pessoa != null) {
      setState(() {
        pessoas.add(pessoa);
      });

      await salvarPessoas();
    }
  }

  Future<void> excluirPessoa(int index) async {
    setState(() {
      pessoas.removeAt(index);
    });

    await salvarPessoas();
  }

  void mostrarSplash() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SplashPage(),
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
          'Meus Cadastros',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFFF8F6FB),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 205,
              padding: const EdgeInsets.fromLTRB(22, 45, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF6F82C8),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE59AB4),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.people_alt_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Meus Cadastros',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  const Text(
                    'Cadastro de pessoas',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(
                Icons.home_rounded,
                color: Color(0xFF6F82C8),
              ),
              title: const Text('Início'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.auto_awesome,
                color: Color(0xFFE59AB4),
              ),
              title: const Text('Splash'),
              onTap: () {
                Navigator.pop(context);
                mostrarSplash();
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Divider(),
            ),

            ListTile(
              leading: const Icon(
                Icons.exit_to_app_rounded,
                color: Colors.grey,
              ),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: pessoas.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEBFA),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 55,
                        color: Color(0xFF6F82C8),
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Ainda não tem ninguém aqui',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF41455A),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Clique no + para cadastrar uma pessoa.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF888894),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 90),
              itemCount: pessoas.length,
              itemBuilder: (context, index) {
                final pessoa = pessoas[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCEAF1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Color(0xFFE59AB4),
                            size: 29,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                pessoa.nome,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF41455A),
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                '${pessoa.rua}, ${pessoa.numero}',
                                style: const TextStyle(
                                  color: Color(0xFF777784),
                                ),
                              ),

                              Text(
                                '${pessoa.cidade} - ${pessoa.estado}',
                                style: const TextStyle(
                                  color: Color(0xFF777784),
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            excluirPessoa(index);
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xFFE59AB4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirCadastro,
        backgroundColor: const Color(0xFFE59AB4),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Adicionar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}