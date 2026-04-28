CREATE TABLE p_code (
    pcode_id TEXT PRIMARY KEY,        -- e.g. P264
    phrase TEXT NOT NULL,             -- full standardized text
    category TEXT,                    -- prevention / response / storage / disposal
    notes TEXT
);

CREATE TABLE pcode_group (
    group_id TEXT PRIMARY KEY,
    group_name TEXT,
    description TEXT
);


CREATE TABLE hazard_code (
    hazard_id TEXT PRIMARY KEY,
    h_code TEXT,
    hazard_statements TEXT
);

CREATE TABLE hazard_classification (
    classification_id TEXT PRIMARY KEY,
    hazard_id TEXT REFERENCES hazard_code(hazard_id),
    hazard_class TEXT,
    category TEXT,
    signal_word TEXT,

    FOREIGN KEY (hazard_id)
        REFERENCES hazard_code(hazard_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);