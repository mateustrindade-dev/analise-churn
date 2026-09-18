# Análise Histórica e Predição de Churn (Retenção de Clientes)

![Python](https://shields.io)
![PostgreSQL](https://shields.io)
![PowerBI](https://shields.io)
![Scikit-Learn](https://shields.io)

## Visão Geral do Projeto
Este projeto implementa uma solução completa para identificar o perfil de cancelamento de clientes (Churn) de uma empresa de telecomunicações e antecipar o risco de evasão dos clientes atuais.

A solução utiliza **Python** para análise preditiva com Machine Learning, **PostgreSQL** para o armazenamento e modelagem relacional dos dados, e **Power BI** para a entrega de um painel que exibe de forma clara os dados reunidos, de modo a permitir a adequada tomada de decisões por parte dos líderes da empresa.

*   **Dataset Utilizado:** Telco Customer Churn (Fonte: Kaggle)

---

## Arquitetura da Solução e Fluxo de Dados (ETL)

O projeto simula um ambiente de produção, seguindo o fluxo:
1. **Extração e Transformação de Dados (Python):** Limpeza de dados brutos, tratamento de nulos e escala de variáveis numéricas.
2. **Modelagem Preditiva (Sklearn):** Treinamento de um algoritmo de classificação para gerar o score individual de risco de cada cliente.
3. **Carga e Modelagem Relacional (SQL/PostgreSQL):** Divide o arquivo original para um modelo estruturado com chaves primárias e integridade referencial.
4. **Visualização de Dados (Power BI):** Consumo do banco de dados local com relacionamentos otimizados e criação de métricas de negócio via DAX.

---

## Detalhes das Etapas Técnicas

### 1. Engenharia de Dados & Modelagem SQL
Para garantir a otimização do motor colunar do Power BI e simular a escalabilidade de um banco de produção, a tabela desnormalizada original do Kaggle foi dividida em três tabelas no PostgreSQL seguindo as boas práticas de integridade referencial:
*   **`dim_clientes`:** Armazena chaves e dados demográficos dos clientes (gênero, dependentes, parceiro).
*   **`dim_servicos`:** Detalha o portfólio de serviços de tecnologia contratados (internet, suporte técnico, segurança).
*   **`fato_contratos`:** Centraliza o evento comercial, registrando faturamento mensal, tempo de permanência (`tenure`), flag de cancelamento e o **Score de Risco calculado por IA**.

O script DDL com as restrições de chaves está disponível na pasta `/sql`.

### 2. Análise Preditiva & Machine Learning (Python)
*   **Tratamento de Dados:** Detecção de nulos por espaços em branco (`" "`) na coluna `TotalCharges`.
*   **Preparação:** Aplicação de *One-Hot Encoding* automatizado para variáveis categóricas remanescentes e padronização de escala com `StandardScaler` para evitar disparidade de pesos no modelo.
*   **O Algoritmo:** Foi utilizado o **Random Forest Classifier** (`scikit-learn`), dividindo os dados em 80% treino e 20% teste com semente fixa (`random_state=42`) para fins de replicabilidade.
*   **Resultados de Validação:**
    *   **Acurácia Geral:** 80.98%
    *   **Precisão (Classe Churn):** 70% (Garante assertividade nas campanhas, evitando falsos alarmes e desperdício de cupons).
    *   **Recall (Classe Churn):** 50% (Capacidade de capturar o comportamento de evasão).
*   **Geração de Score:** Utilização do método `predict_proba()` para extrair a probabilidade exata (0% a 100%) de cancelamento de cada cliente ativo, injetando essa inteligência na tabela Fato do banco SQL.

O Jupyter Notebook completo com o pipeline está disponível na pasta `/notebooks`.

### 3. Business Intelligence & Storytelling (Power BI)
O relatório foi estruturado em duas visões estratégicas aplicando técnicas de Z-Layout e formatação limpa (*Clean Design*):

*   **Aba 1 - Visão Histórica (O que aconteceu):** Focada em métricas consolidadas através de medidas em linguagem DAX (`Total Clientes`, `Clientes Churn` e `Taxa Churn`). Identificou-se que o risco de cancelamento explode nos primeiros 3 meses de contrato (`tenure`) e está severamente correlacionado a contratos mensais (*Month-to-month*) sem fidelidade.
*   **Aba 2 - Visão de Ação Preditiva (O que vai acontecer):** Criação de métricas de impacto de negócio através da linguagem DAX (ex: `Receita Sob Risco`, que calcula o faturamento ameaçado por clientes ativos com mais de 70% de chance de churn). Exibição de uma tabela operacional ordenada por criticidade financeira e probabilidade, servindo como uma lista de ação direta para a equipe de retenção de clientes.

---

## 📂 Estrutura do Repositório
```text
├── data/
│   ├── WA_Fn-UseC_-Telco-Customer-Churn.csv    
├── notebooks/
│   └── limpeza_e_modelagem_churn.ipynb         
├── sql/
│   ├── criacao_tabelas_ddl.sql                 
├── pbix/
│   └── dashboard_retencao_telco.pbix           
└── README.md                                   
```

---

## 🚀 Como Executar o Projeto Localmente

1. Clone o repositório:
   ```bash
   git clone https://github.com
   ```
2. Instale as dependências do Python:
   ```bash
   py -m pip install pandas numpy scikit-learn sqlalchemy psycopg2-binary
   ```
3. Crie o banco de dados `telco_churn_db` no seu PostgreSQL (via DBeaver/pgAdmin) e execute o arquivo `/sql/criacao_tabelas_ddl.sql`.
4. Execute o Jupyter Notebook `/notebooks/limpeza_e_modelagem_churn.ipynb` inserindo a senha do seu banco de dados local para treinar o modelo e popular as tabelas.
5. Abra o arquivo do Power BI na pasta `/pbix` e atualize as credenciais do conector PostgreSQL para apontar para o seu `localhost`.
