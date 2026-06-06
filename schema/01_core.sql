CREATE TABLE IF NOT EXISTS solvent (
    solvent_id TEXT PRIMARY KEY,
    canonical_name TEXT,
    cas_number TEXT,
    refchem_id TEXT,
    is_mixture BOOLEAN DEFAULT FALSE,
    note TEXT,

    
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reference (
    reference_id TEXT PRIMARY KEY,
    title TEXT,
    reference_type TEXT,
    url TEXT,
    publisher TEXT,
    jurisdiction TEXT,
    version TEXT,
    published_date DATE
);

CREATE TABLE IF NOT EXISTS alias (
    alias_id TEXT PRIMARY KEY,
    solvent_id TEXT NOT NULL,
    alias_name TEXT NOT NULL,
    alias_type TEXT CHECK (
      alias_type IN ('IUPAC', 'common', 'trade', 'abbreviation', 'historical', 'synonym')),
    UNIQUE (solvent_id, alias_name),
  
    FOREIGN KEY (solvent_id)
        REFERENCES solvent(solvent_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS property_type (
    property_code TEXT PRIMARY KEY,
    property_name TEXT UNIQUE NOT NULL,  -- e.g., boiling_point, flash_point
    default_unit TEXT
);

CREATE TABLE IF NOT EXISTS observation (
    observation_id TEXT PRIMARY KEY,
    solvent_id TEXT NOT NULL,
    property_code TEXT,   -- e.g., boiling_point, flash_point, vapour_pressure
    value NUMERIC(12,6) NOT NULL,   -- measured or reported value
    unit TEXT,                       -- e.g., "°C", "mmHg", "g/L"
    conditions TEXT,                 -- e.g., temperature, pressure
    reference_id TEXT,
    notes TEXT,

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

