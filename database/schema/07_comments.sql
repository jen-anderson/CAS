--Statements to be included in the database for clarity
--Solvent
COMMENT ON TABLE solvent IS
'Represents a usable solvent entity. 
May correspond to a pure chemical, a mixture of several chemicals 
or a specific concentration. 
Acts as the primary operational unit in the system.';

COMMENT ON COLUMN solvent.solvent_id IS
'Human-readable primary key with prefix (e.g. SOLV-00001).';

COMMENT ON COLUMN solvent.canonical_name IS
'Preferred standard name for the solvent.';

COMMENT ON COLUMN solvent.is_mixture IS
'Indicates whether the solvent represents a mixture rather than a single chemical compound.';

--Solvent_Formula
COMMENT ON TABLE solvent_formula IS
'Links solvents to one or more formulas. 
Supports mixtures via multiple rows per solvent.';

COMMENT ON COLUMN solvent_formula.fraction IS
'Optional proportion of the formula within the solvent (e.g. mass or volume fraction).';

--Alias
COMMENT ON TABLE alias IS
'Alternative names for a solvent, including common names, IUPAC names, abbreviations, and trade names.';

COMMENT ON COLUMN alias.alias_type IS
'Controlled vocabulary indicating type of alias (e.g. IUPAC, common, trade, abbreviation).';

--Reference
COMMENT ON TABLE reference IS
'Bibliographic or documentary sources, including SDS/MSDS, literature, and datasets. May support solvents, aliases, or observations.';

--Observation
COMMENT ON TABLE observation IS
'Stores literature-reported measurements for solvent properties. 
Multiple values per property may exist across different references and conditions.';

COMMENT ON COLUMN observation.property_code IS
'References property_type; defines the meaning of the recorded value.';

COMMENT ON COLUMN observation.value IS
'Numeric value of the observed property.';

COMMENT ON COLUMN observation.conditions IS
'Experimental or environmental conditions under which the observation was recorded.';

--Property_type
COMMENT ON TABLE property_type IS
'Controlled vocabulary defining measurable properties (e.g. boiling_point, flash_point, Hansen parameters).';

COMMENT ON COLUMN property_type.default_unit IS
'Recommended default unit for the property.';

--Hazards
COMMENT ON TABLE hazard_code IS
'Defines hazard statements (e.g. GHS H-codes) and associated descriptions.';

COMMENT ON TABLE hazard_classification IS
'Provides classification metadata for hazards, including hazard class, category, and signal word.';

--P-Code
COMMENT ON TABLE p_code IS
'Precautionary statements (P-codes) describing recommended handling, storage, and response actions.';

COMMENT ON TABLE pcode_group IS
'Logical grouping of precautionary codes for organisational purposes.';

--Relationships
COMMENT ON TABLE hazard_pcode IS
'Links hazard statements to associated precautionary statements.';

COMMENT ON TABLE solvent_reference IS
'Associates references with solvents at a general level (e.g. SDS documents).';

COMMENT ON TABLE alias_reference IS
'Associates references with specific aliases, enabling product- or name-specific documentation.';

COMMENT ON TABLE formula_hazard IS
'Associates intrinsic hazards with chemical formulas.';
