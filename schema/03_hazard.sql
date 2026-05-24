CREATE TABLE IF NOT EXISTS p_code (
    p_code_id TEXT PRIMARY KEY,        -- e.g. P264
    p_code TEXT,
    phrase TEXT NOT NULL,             -- full standardized text
    category TEXT,                    -- prevention / response / storage / disposal
    notes TEXT
);

CREATE TABLE IF NOT EXISTS pcode_group (
    group_id TEXT PRIMARY KEY,
    group_name TEXT,
    description TEXT
);


CREATE TABLE IF NOT EXISTS hazard_code (
    hazard_id TEXT PRIMARY KEY,
    h_code TEXT,
    hazard_statements TEXT
);

CREATE TABLE IF NOT EXISTS hazard_classification (
    classification_id TEXT PRIMARY KEY,
    hazard_id TEXT,
    hazard_class TEXT,
    category TEXT,
    signal_word TEXT,

    FOREIGN KEY (hazard_id)
        REFERENCES hazard_code(hazard_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);