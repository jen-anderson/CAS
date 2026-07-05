CREATE TABLE IF NOT EXISTS formula (
    formula_id TEXT PRIMARY KEY,
    canonical_name TEXT NOT NULL,
    molecular_formula_hill TEXT,
    molecular_weight NUMERIC,
    molar_vol NUMERIC,
    SMILES TEXT,
    InChI TEXT,
    boiling_point NUMERIC,
    flash_point NUMERIC,
    vapour_pressure_min_20C NUMERIC,
    vapour_pressure_max NUMERIC,
    tlv_ppm NUMERIC,
    liquid_density_at_20C NUMERIC,
    water_solubility_g_L_at_20C NUMERIC,
    water_solubility_boolean NUMERIC,
    logP_min NUMERIC,
    logP_max NUMERIC,
    viscosity_cP_at_20C NUMERIC,
    notes TEXT,
    standard_data_source TEXT,
    variant TEXT
);

CREATE TABLE IF NOT EXISTS solvent_formula (
    solvent_id TEXT,
    formula_id TEXT,
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
