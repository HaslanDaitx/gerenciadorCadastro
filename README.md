## 🛠️ Tecnologias Utilizadas

- **Linguagem:** Dart
- **Framework:** Flutter (Suporte a Windows)
- **Banco de Dados:** SQLite
- **Pacotes:**
  - `sqflite` / `sqflite_common_ffi` (Gerenciamento do banco)
  - `path` (Gerenciamento de diretórios)

## 📂 Estrutura do Projeto

- `lib/database/`: Configuração do banco, criação de tabelas e Triggers.
- `lib/models/`: Modelo de dados (`Cadastro`).
- `lib/screens/`: Interface gráfica do usuário.
- `database.sql`: Script SQL completo com a criação das tabelas e triggers.
- `Executavel/`: Pasta contendo a versão compilada (`.exe`) pronta para uso.

## 🚀 Como Rodar o Projeto

Via Executável (Sem instalar Flutter)
1. Acesse a pasta `Executavel` (ou `Release`) na raiz deste repositório.
2. Execute o arquivo `agenda_app.exe`.
3. O banco de dados será criado automaticamente na primeira execução.
