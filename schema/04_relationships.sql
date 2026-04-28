CREATE TABLE hazard_pcode (
    hazard_id TEXT REFERENCES hazard_code(hazard_id),
    pcode_id TEXT REFERENCES p_code(pcode_id),
    PRIMARY KEY (hazard_id, pcode_id),

    FOREIGN KEY (hazard_id)
        REFERENCES hazard_code(hazard_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,

    FOREIGN KEY (pcode_id)
        REFERENCES p_code(pcode_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE pcode_group_map (
    group_id TEXT REFERENCES pcode_group(group_id),
    pcode_id TEXT REFERENCES p_code(pcode_id),
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

CREATE TABLE solvent_reference (
    solvent_id TEXT REFERENCES solvent(solvent_id) ON DELETE CASCADE,
    reference_id TEXT REFERENCES reference(reference_id) ON DELETE CASCADE,
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

CREATE TABLE alias_reference (
    alias_id TEXT REFERENCES alias(alias_id),
    reference_id TEXT REFERENCES reference(reference_id),
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

CREATE TABLE formula_hazard (
    formula_id TEXT REFERENCES formula(formula_id),
    hazard_id TEXT REFERENCES hazard_code(hazard_id),
    PRIMARY KEY (formula_id, hazard_id),
    
    FOREIGN KEY (formula_id)
        REFERENCES formula(formula_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,

    FOREIGN KEY (hazard_id)
        REFERENCES hazard(hazard_id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);