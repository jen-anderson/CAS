CREATE OR REPLACE FUNCTION check_solvent_fraction_sum()
RETURNS TRIGGER AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(fraction), 0)
    INTO total
    FROM solvent_formula
    WHERE solvent_id = NEW.solvent_id;

    total := total
        - COALESCE(OLD.fraction, 0)
        + COALESCE(NEW.fraction, 0);

    IF total <> 1 THEN
        RAISE EXCEPTION
        'Fractions for solvent % must sum to 1 (current total: %)',
        NEW.solvent_id, total;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;