-- Optional: wrap in transaction
BEGIN;

-- A. base tables
\copy reference FROM 'data/reference.csv' CSV HEADER;
\copy property_type FROM 'data/property_type.csv' CSV HEADER;
\copy p_code FROM 'data/p_code.csv' CSV HEADER;
\copy pcode_group FROM 'data/pcode_group.csv' CSV HEADER;
\copy hazard_code FROM 'data/hazard_code.csv' CSV HEADER;
\copy formula FROM 'data/formula.csv' CSV HEADER;
\copy solvent FROM 'data/solvent.csv' CSV HEADER;

-- B. dependent entities
\copy alias FROM 'data/alias.csv' CSV HEADER;
\copy hazard_classification FROM 'data/hazard_classification.csv' CSV HEADER;

-- C. fact tables
\copy observation FROM 'data/observation.csv' CSV HEADER;
\copy solvent_formula FROM 'data/solvent_formula.csv' CSV HEADER;

-- D. relationships
\copy hazard_pcode FROM 'data/hazard_pcode.csv' CSV HEADER;
\copy pcode_group_map FROM 'data/pcode_group_map.csv' CSV HEADER;
\copy solvent_reference FROM 'data/solvent_reference.csv' CSV HEADER;
\copy alias_reference FROM 'data/alias_reference.csv' CSV HEADER;
\copy formula_hazard FROM 'data/formula_hazard.csv' CSV HEADER;

COMMIT;