# SQL Advanced Analytics · PostgreSQL

Case de portfólio de **SQL avançado e modelagem dimensional** aplicado a uma empresa fictícia.

## Desafio de negócio
Investigar crescimento comercial, clientes em risco, retenção, concentração de receita e qualidade dos dados.

## Competências demonstradas
- Modelo estrela: fato de pedidos e dimensões de clientes, produtos e datas.
- CTEs e funções de janela: `LAG`, `NTILE`, `DENSE_RANK`, acumulados e rankings.
- Indicadores **MoM, YTD, RFM, coortes de retenção e Pareto/ABC**.
- Chaves estrangeiras, restrições, índices e `EXPLAIN (ANALYZE, BUFFERS)`.
- Testes de consistência com PostgreSQL 16 no GitHub Actions.

## Execução local
Requer PostgreSQL 15+ e `psql`, conectado a um banco no qual você possa criar o schema `analytics`.

```bash
psql -v ON_ERROR_STOP=1 -f sql/01_schema.sql
psql -v ON_ERROR_STOP=1 -f sql/02_seed.sql
psql -v ON_ERROR_STOP=1 -f sql/03_business_kpis.sql
psql -v ON_ERROR_STOP=1 -f sql/04_customer_rfm.sql
psql -v ON_ERROR_STOP=1 -f sql/05_cohort_retention.sql
psql -v ON_ERROR_STOP=1 -f sql/06_product_pareto.sql
psql -v ON_ERROR_STOP=1 -f sql/07_data_quality.sql
psql -v ON_ERROR_STOP=1 -f sql/08_performance.sql
psql -v ON_ERROR_STOP=1 -f tests/assertions.sql
```

## Dados e metodologia
A carga é **100% sintética e determinística**: 120 clientes, 12 produtos e 1.200 pedidos entre 2024 e 2026. Pedidos cancelados não entram na receita reconhecida. A análise RFM utiliza data de referência fixa em 01/01/2027.

**Retenção:** percentual de clientes da coorte que compraram novamente no mês analisado. **RFM:** quintis relativos, não previsão de churn. **Pareto:** classes conforme participação acumulada na receita.

O projeto não precisa de Supabase, banco hospedado nem mensalidade: o PostgreSQL usado no CI é temporário.
