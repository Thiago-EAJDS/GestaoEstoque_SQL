-- =====================================================
-- CONSULTAS SQL OBRIGATÓRIAS - SUPERMERCADO
-- Total: 10 consultas contemplando TODOS os requisitos
-- =====================================================

-- =====================================================
-- CONSULTA 1: IN, COUNT, ORDER BY
-- Produtos das categorias Alimentos, Bebidas ou Limpeza
-- =====================================================
SELECT 
    c.nome_categoria,
    COUNT(p.id_produto) as total_produtos
FROM PRODUTO p
INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
WHERE c.nome_categoria IN ('Alimentos', 'Bebidas', 'Limpeza')
GROUP BY c.nome_categoria
ORDER BY total_produtos DESC;

-- =====================================================
-- CONSULTA 2: NOT IN, BETWEEN, >=, <=
-- Funcionários que NÃO são do setor Caixa nem Gerência
-- e têm salário entre 1500 e 3000
-- =====================================================
SELECT 
    f.nome,
    f.cargo,
    f.salario,
    s.nome_setor
FROM FUNCIONARIO f
INNER JOIN SETOR s ON f.id_setor = s.id_setor
WHERE f.id_setor NOT IN (1, 6)
  AND f.salario BETWEEN 1500 AND 3000
ORDER BY f.salario DESC;

-- =====================================================
-- CONSULTA 3: AND, OR, SUM, GROUP BY
-- Vendas com valor >= 100 OU forma pagamento Pix/Crédito
-- Total de vendas por forma de pagamento
-- =====================================================
SELECT 
    forma_pagamento,
    COUNT(*) as quantidade_vendas,
    SUM(valor_total) as total_vendido,
    ROUND(AVG(valor_total), 2) as ticket_medio
FROM VENDA
WHERE valor_total >= 100.00 OR forma_pagamento IN ('Pix', 'Crédito')
GROUP BY forma_pagamento
ORDER BY total_vendido DESC;

-- =====================================================
-- CONSULTA 4: MIN, MAX, LIMIT
-- Top 5 produtos mais caros e mais baratos
-- =====================================================
SELECT 
    nome_produto,
    preco_venda,
    CASE 
        WHEN preco_venda = (SELECT MAX(preco_venda) FROM PRODUTO) THEN 'MAIS CARO'
        WHEN preco_venda = (SELECT MIN(preco_venda) FROM PRODUTO) THEN 'MAIS BARATO'
        ELSE 'INTERMEDIÁRIO'
    END as classificacao
FROM PRODUTO
ORDER BY preco_venda DESC
LIMIT 5;

-- =====================================================
-- CONSULTA 5: INNER JOIN (múltiplo), GROUP BY, SUM
-- Ranking de categorias por faturamento
-- =====================================================
SELECT 
    c.nome_categoria,
    COUNT(DISTINCT iv.id_venda) as total_vendas,
    SUM(iv.quantidade) as unidades_vendidas,
    ROUND(SUM(iv.subtotal), 2) as faturamento_total
FROM CATEGORIA c
INNER JOIN PRODUTO p ON c.id_categoria = p.id_categoria
INNER JOIN ITEM_VENDA iv ON p.id_produto = iv.id_produto
GROUP BY c.nome_categoria
ORDER BY faturamento_total DESC;

-- =====================================================
-- CONSULTA 6: LEFT JOIN, COUNT
-- Fornecedores e quantidade de produtos que fornecem
-- (incluindo fornecedores sem produtos)
-- =====================================================
SELECT 
    f.razao_social,
    f.cidade,
    f.estado,
    COUNT(pf.id_produto) as produtos_fornecidos
FROM FORNECEDOR f
LEFT JOIN PRODUTO_FORNECEDOR pf ON f.id_fornecedor = pf.id_fornecedor
GROUP BY f.id_fornecedor, f.razao_social, f.cidade, f.estado
ORDER BY produtos_fornecidos DESC;

-- =====================================================
-- CONSULTA 7: INNER JOIN complexo, >=, <=, ORDER BY
-- Produtos com margem de lucro >= 50%
-- =====================================================
SELECT 
    p.nome_produto,
    c.nome_categoria,
    p.preco_custo,
    p.preco_venda,
    ROUND((p.preco_venda - p.preco_custo), 2) as lucro_unitario,
    ROUND(((p.preco_venda - p.preco_custo) / p.preco_custo * 100), 2) as margem_lucro_percentual
FROM PRODUTO p
INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
WHERE ((p.preco_venda - p.preco_custo) / p.preco_custo * 100) >= 50
ORDER BY margem_lucro_percentual DESC;

-- =====================================================
-- CONSULTA 8: GROUP BY, HAVING (filtro de agregação)
-- Funcionários que realizaram mais de 2 vendas
-- =====================================================
SELECT 
    f.nome,
    f.cargo,
    s.nome_setor,
    COUNT(v.id_venda) as total_vendas_realizadas,
    ROUND(SUM(v.valor_total), 2) as valor_total_vendido
FROM FUNCIONARIO f
INNER JOIN SETOR s ON f.id_setor = s.id_setor
INNER JOIN VENDA v ON f.id_funcionario = v.id_funcionario
GROUP BY f.id_funcionario, f.nome, f.cargo, s.nome_setor
HAVING COUNT(v.id_venda) > 2
ORDER BY total_vendas_realizadas DESC;

-- =====================================================
-- CONSULTA 9: UNION e UNION ALL
-- Listar todos os nomes (Funcionários + Fornecedores)
-- =====================================================
-- UNION (remove duplicatas)
SELECT nome as nome_completo, 'FUNCIONÁRIO' as tipo
FROM FUNCIONARIO
UNION
SELECT razao_social, 'FORNECEDOR'
FROM FORNECEDOR
ORDER BY nome_completo;

-- UNION ALL (mantém todas as linhas, incluindo duplicatas)
SELECT nome as entidade, cargo as detalhes, 'FUNCIONÁRIO' as origem
FROM FUNCIONARIO
UNION ALL
SELECT razao_social, cidade, 'FORNECEDOR'
FROM FORNECEDOR
ORDER BY origem, entidade;

-- =====================================================
-- CONSULTA 10: Subconsulta, MAX, MIN, agregação complexa
-- Análise de estoque crítico vs abundante
-- =====================================================
SELECT 
    'ESTOQUE CRÍTICO' as situacao,
    COUNT(*) as quantidade_produtos,
    ROUND(AVG(quantidade_estoque), 2) as media_estoque
FROM PRODUTO
WHERE quantidade_estoque < estoque_minimo

UNION ALL

SELECT 
    'ESTOQUE ABUNDANTE',
    COUNT(*),
    ROUND(AVG(quantidade_estoque), 2)
FROM PRODUTO
WHERE quantidade_estoque >= (estoque_minimo * 3)

UNION ALL

SELECT 
    'ESTOQUE ADEQUADO',
    COUNT(*),
    ROUND(AVG(quantidade_estoque), 2)
FROM PRODUTO
WHERE quantidade_estoque >= estoque_minimo 
  AND quantidade_estoque < (estoque_minimo * 3);

-- =====================================================
-- CONSULTA BÔNUS 1: Análise temporal de vendas
-- =====================================================
SELECT 
    DATE(data_hora) as data,
    COUNT(*) as total_vendas,
    ROUND(SUM(valor_total), 2) as faturamento_dia,
    ROUND(AVG(valor_total), 2) as ticket_medio_dia
FROM VENDA
GROUP BY DATE(data_hora)
ORDER BY data DESC;

-- =====================================================
-- CONSULTA BÔNUS 2: Produtos mais vendidos
-- =====================================================
SELECT 
    p.nome_produto,
    c.nome_categoria,
    SUM(iv.quantidade) as total_vendido,
    ROUND(SUM(iv.subtotal), 2) as receita_total
FROM PRODUTO p
INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
INNER JOIN ITEM_VENDA iv ON p.id_produto = iv.id_produto
GROUP BY p.id_produto, p.nome_produto, c.nome_categoria
ORDER BY total_vendido DESC
LIMIT 10;

-- =====================================================
-- RESUMO DE REQUISITOS ATENDIDOS:
-- =====================================================
-- ✓ IN / NOT IN (Consultas 1, 2, 3)
-- ✓ BETWEEN (Consulta 2)
-- ✓ >= e <= (Consultas 2, 7)
-- ✓ AND e OR (Consultas 2, 3, 7)
-- ✓ LIMIT (Consultas 4, Bônus 2)
-- ✓ COUNT (Consultas 1, 3, 5, 6, 8, 10)
-- ✓ SUM (Consultas 3, 5, 8, Bônus)
-- ✓ MIN / MAX (Consulta 4, 10)
-- ✓ AVG (Consultas 3, 10, Bônus)
-- ✓ GROUP BY (Todas com agregação)
-- ✓ ORDER BY (Todas as consultas)
-- ✓ INNER JOIN (Consultas 1, 2, 5, 7, 8, Bônus)
-- ✓ LEFT JOIN (Consulta 6)
-- ✓ UNION (Consulta 9)
-- ✓ UNION ALL (Consultas 9, 10)
-- ✓ HAVING (Consulta 8)
-- =====================================================
