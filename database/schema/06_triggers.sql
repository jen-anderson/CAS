DROP TRIGGER IF EXISTS solvent_fraction_sum_check ON solvent_formula;

CREATE TRIGGER solvent_fraction_sum_check
BEFORE INSERT OR UPDATE ON solvent_formula
FOR EACH ROW
EXECUTE FUNCTION check_solvent_fraction_sum();