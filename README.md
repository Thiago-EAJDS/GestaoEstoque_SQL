# Gestão de Estoque — Supermercado (SQLite)

Modelo de banco de dados e consultas SQL de um sistema de gestão de estoque de supermercado.

## Estrutura

| Pasta | Conteúdo |
|---|---|
| `01_DOCUMENTACAO/` | Minimundo e relatório do projeto (PDF) |
| `02_MODELAGEM/` | Modelo entidade-relacionamento (`mer.brM3`, `mer.png`) e diagrama do supermercado |
| `03_SCRIPTS_SQL/` | Criação das tabelas, dados de exemplo, consultas e álgebra relacional |
| `04_BANCO/` | Banco SQLite de exemplo (`supermercado.db`) |
| `05_APRESENTACAO/` | Anotações da apresentação |

## Scripts

- `create_tables.sql`: apaga e recria as 12 tabelas, com chaves estrangeiras e índices.
- `insert_data.sql`: insere os dados de exemplo.
- `consultas_obrigatorias.sql`: 10 consultas obrigatórias e 2 bônus, cobrindo JOIN, agregações, UNION, HAVING e subconsultas.
- `algebra_relacional.txt`: as consultas escritas em álgebra relacional.

## Como recriar o banco

Com o CLI do SQLite:

```bash
sqlite3 teste.db < 03_SCRIPTS_SQL/create_tables.sql
sqlite3 teste.db < 03_SCRIPTS_SQL/insert_data.sql
sqlite3 teste.db < 03_SCRIPTS_SQL/consultas_obrigatorias.sql
```

Use um arquivo novo, como `teste.db`. O `create_tables.sql` apaga as tabelas existentes, então rodá-lo sobre `04_BANCO/supermercado.db` substitui os dados desse arquivo.
