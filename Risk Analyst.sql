create database credit_risk_raw;

set global local_infile  =1;

CREATE TABLE credit_risk_raw (
    person_age INT,
    person_income INT,
    person_home_ownership VARCHAR(50),
    person_emp_length DOUBLE, -- Menggunakan DOUBLE jika ada desimal atau nilai kosong
    loan_intent VARCHAR(100),
    loan_grade VARCHAR(10),
    loan_amnt INT,
    loan_int_rate DOUBLE,     -- Suku bunga biasanya desimal
    loan_status INT,          -- 0 atau 1
    loan_percent_income DOUBLE,
    cb_person_default_on_file VARCHAR(10),
    cb_person_cred_hist_length INT
);

LOAD DATA LOCAL INFILE 'C:/Users/Hadess/Downloads/Latihan Excel & Bank Soal/CSV/Risk Analyst/loan/loan.csv'
INTO TABLE credit_risk_raw
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select count(*) from credit_risk_raw;
select * from credit_risk_raw limit 10;

select
	count(case when person_income is null then 1 end) as null_pendapatan,
    count(case when loan_int_rate is null then 1 end) as null_suku_bunga,
    count(case when person_emp_length is null then 1 end) as null_masa_kerja,
    count(*) as total_baris_masuk
from credit_risk_raw;

select * from credit_risk_raw
where person_age > 100
	or person_emp_length > person_age;
    
drop table credit_risk_raw;

CREATE TABLE credit_risk_raw (
    id INT, -- Menampung baris angka jutaan di awal CSV
    person_age INT,
    person_income INT,
    person_home_ownership VARCHAR(50),
    person_emp_length DOUBLE,
    loan_intent VARCHAR(100),
    loan_grade VARCHAR(10),
    loan_amnt INT,
    loan_int_rate DOUBLE,
    loan_status INT,
    loan_percent_income DOUBLE,
    cb_person_default_on_file VARCHAR(10),
    cb_person_cred_hist_length INT
);

LOAD DATA LOCAL INFILE 'C:/Users/Hadess/Downloads/Latihan Excel & Bank Soal/CSV/Risk Analyst/loan/loan.csv'
INTO TABLE credit_risk_raw
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

DROP TABLE IF EXISTS credit_risk_raw;

CREATE TABLE credit_risk_raw (
    id INT,
    member_id VARCHAR(50),
    loan_amnt INT,
    funded_amnt INT,
    funded_amnt_inv DOUBLE,
    term VARCHAR(20),
    int_rate VARCHAR(20),       -- Sementara VARCHAR karena ada simbol '%' di CSV aslinya
    installment DOUBLE,
    grade VARCHAR(10),
    sub_grade VARCHAR(10),
    emp_title VARCHAR(255),
    emp_length VARCHAR(50),     -- VARCHAR karena berisi teks seperti '< 1 year' atau '10+ years'
    home_ownership VARCHAR(50),
    annual_inc DOUBLE,
    verification_status VARCHAR(50),
    issue_d VARCHAR(50),        -- VARCHAR untuk dijinakkan ke format DATE nanti
    loan_status VARCHAR(50),    -- Berisi teks 'Fully Paid', 'Charged Off', atau 'Default'
    pymnt_plan VARCHAR(10),
    url TEXT,
    `desc` TEXT,
    purpose VARCHAR(100),
    title VARCHAR(255),
    zip_code VARCHAR(20),
    addr_state VARCHAR(10),
    dti DOUBLE,                 -- Debt-to-Income Ratio
    delinq_2yrs INT,
    earliest_cr_line VARCHAR(50),
    inq_last_6mths INT,
    mths_since_last_delinq VARCHAR(50),
    mths_since_last_record VARCHAR(50),
    open_acc INT,
    pub_rec INT,
    revol_bal INT,
    revol_util VARCHAR(20),
    total_acc INT,
    initial_list_status VARCHAR(10),
    out_prncp DOUBLE,
    out_prncp_inv DOUBLE,
    total_pymnt DOUBLE,
    total_pymnt_inv DOUBLE,
    total_rec_prncp DOUBLE,
    total_rec_int DOUBLE,
    total_rec_late_fee DOUBLE,
    recoveries DOUBLE,
    collection_recovery_fee DOUBLE,
    last_pymnt_d VARCHAR(50),
    last_pymnt_amnt DOUBLE,
    next_pymnt_d VARCHAR(50),
    last_credit_pull_d VARCHAR(50),
    collections_12_mths_ex_med INT,
    mths_since_last_major_derog VARCHAR(50),
    policy_code INT,
    application_type VARCHAR(50),
    -- Sisa kolom di bawah ini kita tampung sebagai TEXT/VARCHAR agar proses LOAD aman
    annual_inc_joint VARCHAR(50), dti_joint VARCHAR(50), verification_status_joint VARCHAR(50),
    acc_now_delinq VARCHAR(50), tot_coll_amt VARCHAR(50), tot_cur_bal VARCHAR(50), open_acc_6m VARCHAR(50),
    open_il_6m VARCHAR(50), open_il_12m VARCHAR(50), open_il_24m VARCHAR(50), mths_since_rcnt_il VARCHAR(50),
    total_bal_il VARCHAR(50), il_util VARCHAR(50), open_rv_12m VARCHAR(50), open_rv_24m VARCHAR(50),
    max_bal_bc VARCHAR(50), all_util VARCHAR(50), total_rev_hi_lim VARCHAR(50), inq_fi VARCHAR(50),
    total_cu_tl VARCHAR(50), inq_last_12m VARCHAR(50)
);

LOAD DATA LOCAL INFILE 'C:/Users/Hadess/Downloads/Latihan Excel & Bank Soal/CSV/Risk Analyst/loan/loan.csv'
INTO TABLE credit_risk_raw
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE OR REPLACE VIEW clean_credit_risk AS
SELECT 
    id,
    loan_amnt,
    funded_amnt,
    -- Mengonversi tenor teks "36 months" menjadi angka murni 36
    CAST(REPLACE(term, ' months', '') AS UNSIGNED) AS loan_term_months,
    -- Mengonversi suku bunga menjadi tipe data desimal yang presisi
    CAST(int_rate AS DECIMAL(5,2)) AS interest_rate,
    installment,
    grade,
    sub_grade,
    home_ownership,
    annual_inc AS annual_income,
    verification_status,
    purpose,
    addr_state AS customer_state,
    dti AS debt_to_income,
    delinq_2yrs,
    
    -- Pembuatan Fitur Utama Manajemen Risiko (Target Variable)
    CASE 
        WHEN loan_status IN ('Charged Off', 'Default', 'Does not meet the credit policy. Status:Charged Off') THEN 1
        ELSE 0 
    END AS is_default,
    
    -- Mempertahankan status teks asli untuk kebutuhan label visualisasi jika diperlukan
    loan_status AS loan_status_desc
FROM credit_risk_raw
-- Memastikan kita hanya menarik data yang memiliki angka pendapatan valid dan masuk akal
WHERE annual_inc IS NOT NULL 
  AND annual_inc > 0;
  
  SELECT is_default, loan_status_desc, COUNT(*) AS total_nasabah
FROM clean_credit_risk
GROUP BY is_default, loan_status_desc;

