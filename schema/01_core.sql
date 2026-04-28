CREATE TABLE solvent (
    solvent_id TEXT PRIMARY KEY,
    canonical_name TEXT,
    cas_number TEXT,
    refchem_id TEXT,
    is_mixture BOOLEAN,
    note TEXT,

    
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP
);

CREATE TABLE solvent_formula (
    solvent_id TEXT REFERENCES solvent(solvent_id),
    formula_id TEXT REFERENCES formula(formula_id),
    fraction NUMERIC,       -- optional: fraction by mass/volume
    PRIMARY KEY (solvent_id, formula_id),

    FOREIGN KEY (solvent_id)
        REFERENCES solvent(solvent_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,

    FOREIGN KEY (formula_id)
        REFERENCES formula(formula_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE reference (
    reference_id TEXT PRIMARY KEY,
    title TEXT,
    source TEXT,
    url TEXT,
    publisher TEXT,
    jurisdiction TEXT,
    date_accessed DATE
);

CREATE TABLE alias (
    alias_id TEXT PRIMARY KEY,
    solvent_id TEXT,
    alias_name TEXT,
    alias_type TEXT,
    UNIQUE (solvent_id, alias_name),
    FOREIGN KEY (solvent_id) REFERENCES solvent(solvent_id)

    FOREIGN KEY (solvent_id)
        REFERENCES solvent(solvent_id)
        ON DELETE CASCADE,
        ON UPDATE RESTRICT
);


CREATE TABLE observation (
    observation_id TEXT PRIMARY KEY,
    solvent_id TEXT NOT NULL REFERENCES solvent(solvent_id),
    property_code TEXT REFERENCES property_type(property_code),          -- e.g., boiling_point, flash_point, vapour_pressure
    value NUMERIC(12,6) NOT NULL,   -- measured or reported value
    unit TEXT,                       -- e.g., "°C", "mmHg", "g/L"
    conditions TEXT,                 -- e.g., temperature, pressure
    reference_id TEXT REFERENCES reference(reference_id),
    notes TEXT

    FOREIGN KEY (solvent_id)
        REFERENCES solvent(solvent_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    FOREIGN KEY (reference_id)
        REFERENCES reference(reference_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,  
   
    FOREIGN KEY (property_code)
        REFERENCES property_type(property_code)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE property_type (
    property_code TEXT PRIMARY KEY,
    property_name TEXT UNIQUE NOT NULL,  -- e.g., boiling_point, flash_point
    default_unit TEXT
);

