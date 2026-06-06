CREATE TABLE IF NOT EXISTS hazard_pcode (
    hazard_id TEXT,
    pcode_id TEXT,
    PRIMARY KEY (hazard_id, pcode_id),

    FOREIGN KEY (hazard_id)
        REFERENCES hazard_code(hazard_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,

    FOREIGN KEY (pcode_id)
        REFERENCES p_code(p_code_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS pcode_group_map (
    group_id TEXT,
    pcode_id TEXT,
    PRIMARY KEY (group_id, pcode_id),

    FOREIGN KEY (group_id)
        REFERENCES pcode_group(group_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,

    FOREIGN KEY (pcode_id)
        REFERENCES p_code(pcode_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS solvent_reference (
    solvent_id TEXT,
    reference_id TEXT,
    PRIMARY KEY (solvent_id, reference_id),

    FOREIGN KEY (solvent_id)
        REFERENCES solvent(solvent_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,

    FOREIGN KEY (reference_id)
        REFERENCES reference(reference_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS alias_reference (
    alias_id TEXT,
    reference_id TEXT,
    PRIMARY KEY (alias_id, reference_id),

       FOREIGN KEY (alias_id)
        REFERENCES alias(alias_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,

    FOREIGN KEY (reference_id)
        REFERENCES reference(reference_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS formula_hazard (
    formula_id TEXT,
    hazard_id TEXT,
    PRIMARY KEY (formula_id, hazard_id),
    
    FOREIGN KEY (formula_id)
        REFERENCES formula(formula_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,

    FOREIGN KEY (hazard_id)
        REFERENCES hazard_code(hazard_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS solvent_hazard (
    solvent_id TEXT,
    hazard_id TEXT,
    PRIMARY KEY (solvent_id, hazard_id),

    FOREIGN KEY (solvent_id)
        REFERENCES solvent(solvent_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,

    FOREIGN KEY (hazard_id)
        REFERENCES hazard_code(hazard_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);