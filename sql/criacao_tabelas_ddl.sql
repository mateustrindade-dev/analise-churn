CREATE TABLE dim_clientes (
    customer_id VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(10),
    senior_citizen INT,
    partner VARCHAR(5),
    dependents VARCHAR(5)
);

CREATE TABLE dim_servicos (
    customer_id VARCHAR(50) PRIMARY KEY,
    phone_service VARCHAR(5),
    multiple_lines VARCHAR(30),
    internet_service VARCHAR(30),
    online_security VARCHAR(30),
    online_backup VARCHAR(30),
    device_protection VARCHAR(30),
    tech_support VARCHAR(30),
    streaming_tv VARCHAR(30),
    streaming_movies VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES dim_clientes(customer_id)
);

CREATE TABLE fato_contratos (
    customer_id VARCHAR(50) PRIMARY KEY,
    tenure INT,
    contract VARCHAR(30),
    paperless_billing VARCHAR(5),
    payment_method VARCHAR(50),
    monthly_charges NUMERIC(10, 2),
    total_charges NUMERIC(10, 2),
    churn VARCHAR(5),
    churn_probability NUMERIC(3, 2),
    FOREIGN KEY (customer_id) REFERENCES dim_clientes(customer_id)
);
