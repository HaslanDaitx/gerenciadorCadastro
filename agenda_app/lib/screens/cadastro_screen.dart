import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/cadastro.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _descricaoController = TextEditingController();
  final _codigoController = TextEditingController();
  
  final db = DatabaseHelper.instance;
  List<Cadastro> _cadastros = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await db.listarCadastros();
    setState(() => _cadastros = lista);
  }

  Future<void> _inserir() async {
    final int codigo = int.tryParse(_codigoController.text) ?? 0;
    
    final cadastro = Cadastro(
      codigo: codigo,
      descricao: _descricaoController.text,
    );

    await db.inserirCadastro(cadastro);
    
    _limpar();
    _carregar();
  }

  Future<void> _atualizar() async {
    final cadastro = Cadastro(
      codigo: int.tryParse(_codigoController.text) ?? 0,
      descricao: _descricaoController.text,
    );
    await db.atualizarCadastro(cadastro);
    _limpar();
    _carregar();
  }

  Future<void> _excluir(int codigo) async {
    await db.excluirCadastro(codigo);
    _carregar();
  }

  void _limpar() {
    _descricaoController.clear();
    _codigoController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Cadastros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
            tooltip: 'Atualizar Lista',
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Novo Registro",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _descricaoController,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                            hintText: 'Digite o nome do item',
                            prefixIcon: Icon(Icons.description_outlined),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _codigoController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Código',
                            hintText: 'Ex: 10',
                            prefixIcon: Icon(Icons.numbers),
                            border: OutlineInputBorder(),
                            isDense: true,
                            helperText: "O código deve ser único e maior que zero.",
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _inserir,
                                icon: const Icon(Icons.add),
                                label: const Text('INSERIR'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  backgroundColor: Colors.indigo,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _atualizar,
                                icon: const Icon(Icons.save_as),
                                label: const Text('ATUALIZAR'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Itens Cadastrados",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),

                Expanded(
                  child: _cadastros.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox, size: 60, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("Nenhum cadastro encontrado", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _cadastros.length,
                          itemBuilder: (context, index) {
                            final item = _cadastros[index];
                            return Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                title: Text(
                                  item.descricao,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'ID #${item.codigo}',
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  tooltip: 'Excluir registro',
                                  onPressed: () => _excluir(item.codigo),
                                ),
                                onTap: () {
                                  _descricaoController.text = item.descricao;
                                  _codigoController.text = item.codigo.toString();
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}