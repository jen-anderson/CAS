CREATE VIEW solvent_hazard_profile AS
SELECT
    s.solvent_id,
    s.canonical_name AS solvent_name,

    f.formula_id,
    f.canonical_name AS formula_name,

    h.hazard_id,
    h.h_code,
    h.hazard_statements,

    hc.hazard_class,
    hc.category,
    hc.signal_word,

    p.pcode_id,
    p.phrase AS pcode_phrase

FROM solvent s

JOIN solvent_formula sf
    ON sf.solvent_id = s.solvent_id

JOIN formula f
    ON f.formula_id = sf.formula_id

LEFT JOIN formula_hazard fh
    ON fh.formula_id = f.formula_id

LEFT JOIN hazard_code h
    ON h.hazard_id = fh.hazard_id

LEFT JOIN hazard_classification hc
    ON hc.hazard_id = h.hazard_id

LEFT JOIN hazard_pcode hp
    ON hp.hazard_id = h.hazard_id

LEFT JOIN p_code p
    ON p.pcode_id = hp.pcode_id;
