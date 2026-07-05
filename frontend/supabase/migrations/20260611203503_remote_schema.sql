


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS '@graphql({"introspection": true})';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."check_solvent_fraction_sum"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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
$$;


ALTER FUNCTION "public"."check_solvent_fraction_sum"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."alias" (
    "alias_id" "text" NOT NULL,
    "solvent_id" "text" NOT NULL,
    "alias_name" "text" NOT NULL,
    "alias_type" "text",
    CONSTRAINT "alias_alias_type_check" CHECK (("alias_type" = ANY (ARRAY['IUPAC'::"text", 'common'::"text", 'trade'::"text", 'abbreviation'::"text", 'historical'::"text", 'synonym'::"text"])))
);


ALTER TABLE "public"."alias" OWNER TO "postgres";


COMMENT ON TABLE "public"."alias" IS 'Alternative names for a solvent, including common names, IUPAC names, abbreviations, and trade names.';



COMMENT ON COLUMN "public"."alias"."alias_type" IS 'Controlled vocabulary indicating type of alias (e.g. IUPAC, common, trade, abbreviation).';



CREATE TABLE IF NOT EXISTS "public"."alias_reference" (
    "alias_id" "text" NOT NULL,
    "reference_id" "text" NOT NULL
);


ALTER TABLE "public"."alias_reference" OWNER TO "postgres";


COMMENT ON TABLE "public"."alias_reference" IS 'Associates references with specific aliases, enabling product- or name-specific documentation.';



CREATE TABLE IF NOT EXISTS "public"."formula" (
    "formula_id" "text" NOT NULL,
    "canonical_name" "text" NOT NULL,
    "molecular_formula_hill" "text",
    "molecular_weight" numeric,
    "molar_vol" numeric,
    "smiles" "text",
    "inchi" "text",
    "boiling_point" numeric,
    "flash_point" numeric,
    "vapour_pressure_min_20c" numeric,
    "vapour_pressure_max" numeric,
    "tlv_ppm" numeric,
    "liquid_density_at_20c" numeric,
    "water_solubility_g_l_at_20c" numeric,
    "water_solubility_boolean" numeric,
    "logp_min" numeric,
    "logp_max" numeric,
    "viscosity_cp_at_20c" numeric,
    "notes" "text",
    "standard_data_source" "text",
    "variant" "text"
);


ALTER TABLE "public"."formula" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."formula_hazard" (
    "formula_id" "text" NOT NULL,
    "hazard_id" "text" NOT NULL
);


ALTER TABLE "public"."formula_hazard" OWNER TO "postgres";


COMMENT ON TABLE "public"."formula_hazard" IS 'Associates intrinsic hazards with chemical formulas.';



CREATE TABLE IF NOT EXISTS "public"."hazard_classification" (
    "classification_id" "text" NOT NULL,
    "hazard_id" "text",
    "hazard_class" "text",
    "category" "text",
    "signal_word" "text"
);


ALTER TABLE "public"."hazard_classification" OWNER TO "postgres";


COMMENT ON TABLE "public"."hazard_classification" IS 'Provides classification metadata for hazards, including hazard class, category, and signal word.';



CREATE TABLE IF NOT EXISTS "public"."hazard_code" (
    "hazard_id" "text" NOT NULL,
    "h_code" "text",
    "hazard_statements" "text"
);


ALTER TABLE "public"."hazard_code" OWNER TO "postgres";


COMMENT ON TABLE "public"."hazard_code" IS 'Links hazard statements to associated precautionary statements.';



CREATE TABLE IF NOT EXISTS "public"."hazard_pcode" (
    "hazard_id" "text" NOT NULL,
    "pcode_id" "text" NOT NULL
);


ALTER TABLE "public"."hazard_pcode" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."observation" (
    "observation_id" "text" NOT NULL,
    "solvent_id" "text" NOT NULL,
    "property_code" "text",
    "value" numeric(12,6) NOT NULL,
    "unit" "text",
    "conditions" "text",
    "reference_id" "text",
    "notes" "text",
    "priority_score" integer DEFAULT 0
);


ALTER TABLE "public"."observation" OWNER TO "postgres";


COMMENT ON TABLE "public"."observation" IS 'Stores literature-reported measurements for solvent properties. 
Multiple values per property may exist across different references and conditions.';



COMMENT ON COLUMN "public"."observation"."property_code" IS 'References property_type; defines the meaning of the recorded value.';



COMMENT ON COLUMN "public"."observation"."value" IS 'Numeric value of the observed property.';



COMMENT ON COLUMN "public"."observation"."conditions" IS 'Experimental or environmental conditions under which the observation was recorded.';



CREATE TABLE IF NOT EXISTS "public"."p_code" (
    "p_code_id" "text" NOT NULL,
    "p_code" "text",
    "phrase" "text" NOT NULL,
    "category" "text",
    "notes" "text"
);


ALTER TABLE "public"."p_code" OWNER TO "postgres";


COMMENT ON TABLE "public"."p_code" IS 'Precautionary statements (P-codes) describing recommended handling, storage, and response actions.';



CREATE TABLE IF NOT EXISTS "public"."pcode_group" (
    "group_id" "text" NOT NULL,
    "group_name" "text",
    "description" "text"
);


ALTER TABLE "public"."pcode_group" OWNER TO "postgres";


COMMENT ON TABLE "public"."pcode_group" IS 'Logical grouping of precautionary codes for organisational purposes.';



CREATE TABLE IF NOT EXISTS "public"."pcode_group_map" (
    "group_id" "text" NOT NULL,
    "p_code_id" "text" NOT NULL
);


ALTER TABLE "public"."pcode_group_map" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."property_type" (
    "property_code" "text" NOT NULL,
    "property_name" "text" NOT NULL,
    "default_unit" "text"
);


ALTER TABLE "public"."property_type" OWNER TO "postgres";


COMMENT ON TABLE "public"."property_type" IS 'Controlled vocabulary defining measurable properties (e.g. boiling_point, flash_point, Hansen parameters).';



COMMENT ON COLUMN "public"."property_type"."default_unit" IS 'Recommended default unit for the property.';



CREATE TABLE IF NOT EXISTS "public"."reference" (
    "reference_id" "text" NOT NULL,
    "title" "text",
    "reference_type" "text",
    "url" "text",
    "publisher" "text",
    "jurisdiction" "text",
    "version" "text",
    "published_date" "date"
);


ALTER TABLE "public"."reference" OWNER TO "postgres";


COMMENT ON TABLE "public"."reference" IS 'Bibliographic or documentary sources, including SDS/MSDS, literature, and datasets. May support solvents, aliases, or observations.';



CREATE TABLE IF NOT EXISTS "public"."solvent" (
    "solvent_id" "text" NOT NULL,
    "canonical_name" "text",
    "cas_number" "text",
    "refchem_id" "text",
    "is_mixture" boolean DEFAULT false,
    "note" "text",
    "is_deleted" boolean DEFAULT false,
    "deleted_at" timestamp without time zone
);


ALTER TABLE "public"."solvent" OWNER TO "postgres";


COMMENT ON TABLE "public"."solvent" IS 'Represents a usable solvent entity. 
May correspond to a pure chemical, a mixture of several chemicals 
or a specific concentration. 
Acts as the primary operational unit in the system.';



COMMENT ON COLUMN "public"."solvent"."solvent_id" IS 'Human-readable primary key with prefix (e.g. SOLV-00001).';



COMMENT ON COLUMN "public"."solvent"."canonical_name" IS 'Preferred standard name for the solvent.';



COMMENT ON COLUMN "public"."solvent"."is_mixture" IS 'Indicates whether the solvent represents a mixture rather than a single chemical compound.';



CREATE TABLE IF NOT EXISTS "public"."solvent_formula" (
    "solvent_id" "text" NOT NULL,
    "formula_id" "text" NOT NULL,
    "fraction" numeric
);


ALTER TABLE "public"."solvent_formula" OWNER TO "postgres";


COMMENT ON TABLE "public"."solvent_formula" IS 'Links solvents to one or more formulas. 
Supports mixtures via multiple rows per solvent.';



COMMENT ON COLUMN "public"."solvent_formula"."fraction" IS 'Optional proportion of the formula within the solvent (e.g. mass or volume fraction).';



CREATE TABLE IF NOT EXISTS "public"."solvent_hazard" (
    "solvent_id" "text" NOT NULL,
    "hazard_id" "text" NOT NULL
);


ALTER TABLE "public"."solvent_hazard" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."solvent_reference" (
    "solvent_id" "text" NOT NULL,
    "reference_id" "text" NOT NULL
);


ALTER TABLE "public"."solvent_reference" OWNER TO "postgres";


COMMENT ON TABLE "public"."solvent_reference" IS 'Associates references with solvents at a general level (e.g. SDS documents).';



ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_pkey" PRIMARY KEY ("alias_id");



ALTER TABLE ONLY "public"."alias_reference"
    ADD CONSTRAINT "alias_reference_pkey" PRIMARY KEY ("alias_id", "reference_id");



ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_solvent_id_alias_name_key" UNIQUE ("solvent_id", "alias_name");



ALTER TABLE ONLY "public"."formula_hazard"
    ADD CONSTRAINT "formula_hazard_pkey" PRIMARY KEY ("formula_id", "hazard_id");



ALTER TABLE ONLY "public"."formula"
    ADD CONSTRAINT "formula_pkey" PRIMARY KEY ("formula_id");



ALTER TABLE ONLY "public"."hazard_classification"
    ADD CONSTRAINT "hazard_classification_pkey" PRIMARY KEY ("classification_id");



ALTER TABLE ONLY "public"."hazard_code"
    ADD CONSTRAINT "hazard_code_pkey" PRIMARY KEY ("hazard_id");



ALTER TABLE ONLY "public"."hazard_pcode"
    ADD CONSTRAINT "hazard_pcode_pkey" PRIMARY KEY ("hazard_id", "pcode_id");



ALTER TABLE ONLY "public"."observation"
    ADD CONSTRAINT "observation_pkey" PRIMARY KEY ("observation_id");



ALTER TABLE ONLY "public"."p_code"
    ADD CONSTRAINT "p_code_pkey" PRIMARY KEY ("p_code_id");



ALTER TABLE ONLY "public"."pcode_group_map"
    ADD CONSTRAINT "pcode_group_map_pkey" PRIMARY KEY ("group_id", "p_code_id");



ALTER TABLE ONLY "public"."pcode_group"
    ADD CONSTRAINT "pcode_group_pkey" PRIMARY KEY ("group_id");



ALTER TABLE ONLY "public"."property_type"
    ADD CONSTRAINT "property_type_pkey" PRIMARY KEY ("property_code");



ALTER TABLE ONLY "public"."property_type"
    ADD CONSTRAINT "property_type_property_name_key" UNIQUE ("property_name");



ALTER TABLE ONLY "public"."reference"
    ADD CONSTRAINT "reference_pkey" PRIMARY KEY ("reference_id");



ALTER TABLE ONLY "public"."solvent_formula"
    ADD CONSTRAINT "solvent_formula_pkey" PRIMARY KEY ("solvent_id", "formula_id");



ALTER TABLE ONLY "public"."solvent_hazard"
    ADD CONSTRAINT "solvent_hazard_pkey" PRIMARY KEY ("solvent_id", "hazard_id");



ALTER TABLE ONLY "public"."solvent"
    ADD CONSTRAINT "solvent_pkey" PRIMARY KEY ("solvent_id");



ALTER TABLE ONLY "public"."solvent_reference"
    ADD CONSTRAINT "solvent_reference_pkey" PRIMARY KEY ("solvent_id", "reference_id");



CREATE OR REPLACE TRIGGER "solvent_fraction_sum_check" BEFORE INSERT OR UPDATE ON "public"."solvent_formula" FOR EACH ROW EXECUTE FUNCTION "public"."check_solvent_fraction_sum"();



ALTER TABLE ONLY "public"."alias_reference"
    ADD CONSTRAINT "alias_reference_alias_id_fkey" FOREIGN KEY ("alias_id") REFERENCES "public"."alias"("alias_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."alias_reference"
    ADD CONSTRAINT "alias_reference_reference_id_fkey" FOREIGN KEY ("reference_id") REFERENCES "public"."reference"("reference_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_solvent_id_fkey" FOREIGN KEY ("solvent_id") REFERENCES "public"."solvent"("solvent_id") ON UPDATE RESTRICT ON DELETE CASCADE;



ALTER TABLE ONLY "public"."formula_hazard"
    ADD CONSTRAINT "formula_hazard_formula_id_fkey" FOREIGN KEY ("formula_id") REFERENCES "public"."formula"("formula_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."formula_hazard"
    ADD CONSTRAINT "formula_hazard_hazard_id_fkey" FOREIGN KEY ("hazard_id") REFERENCES "public"."hazard_code"("hazard_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."hazard_classification"
    ADD CONSTRAINT "hazard_classification_hazard_id_fkey" FOREIGN KEY ("hazard_id") REFERENCES "public"."hazard_code"("hazard_id") ON UPDATE RESTRICT ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."hazard_pcode"
    ADD CONSTRAINT "hazard_pcode_hazard_id_fkey" FOREIGN KEY ("hazard_id") REFERENCES "public"."hazard_code"("hazard_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."hazard_pcode"
    ADD CONSTRAINT "hazard_pcode_pcode_id_fkey" FOREIGN KEY ("pcode_id") REFERENCES "public"."p_code"("p_code_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."observation"
    ADD CONSTRAINT "observation_property_code_fkey" FOREIGN KEY ("property_code") REFERENCES "public"."property_type"("property_code") ON UPDATE RESTRICT ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."observation"
    ADD CONSTRAINT "observation_reference_id_fkey" FOREIGN KEY ("reference_id") REFERENCES "public"."reference"("reference_id") ON UPDATE RESTRICT ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."observation"
    ADD CONSTRAINT "observation_solvent_id_fkey" FOREIGN KEY ("solvent_id") REFERENCES "public"."solvent"("solvent_id") ON UPDATE RESTRICT ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."pcode_group_map"
    ADD CONSTRAINT "pcode_group_map_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."pcode_group"("group_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pcode_group_map"
    ADD CONSTRAINT "pcode_group_map_p_code_id_fkey" FOREIGN KEY ("p_code_id") REFERENCES "public"."p_code"("p_code_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."solvent_formula"
    ADD CONSTRAINT "solvent_formula_formula_id_fkey" FOREIGN KEY ("formula_id") REFERENCES "public"."formula"("formula_id") ON UPDATE RESTRICT ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."solvent_formula"
    ADD CONSTRAINT "solvent_formula_solvent_id_fkey" FOREIGN KEY ("solvent_id") REFERENCES "public"."solvent"("solvent_id") ON UPDATE RESTRICT ON DELETE CASCADE;



ALTER TABLE ONLY "public"."solvent_hazard"
    ADD CONSTRAINT "solvent_hazard_hazard_id_fkey" FOREIGN KEY ("hazard_id") REFERENCES "public"."hazard_code"("hazard_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."solvent_hazard"
    ADD CONSTRAINT "solvent_hazard_solvent_id_fkey" FOREIGN KEY ("solvent_id") REFERENCES "public"."solvent"("solvent_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."solvent_reference"
    ADD CONSTRAINT "solvent_reference_reference_id_fkey" FOREIGN KEY ("reference_id") REFERENCES "public"."reference"("reference_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."solvent_reference"
    ADD CONSTRAINT "solvent_reference_solvent_id_fkey" FOREIGN KEY ("solvent_id") REFERENCES "public"."solvent"("solvent_id") ON DELETE CASCADE;



CREATE POLICY "Allow public read" ON "public"."solvent" FOR SELECT USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."alias" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."alias_reference" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."formula" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."formula_hazard" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."hazard_classification" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."hazard_code" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."hazard_pcode" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."observation" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."p_code" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."pcode_group" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."pcode_group_map" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."property_type" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."reference" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."solvent" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."solvent_formula" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."solvent_hazard" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Enable read access for authenticated users" ON "public"."solvent_reference" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."alias" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."alias_reference" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."formula" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."formula_hazard" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."hazard_classification" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."hazard_code" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."hazard_pcode" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."observation" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."p_code" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pcode_group" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pcode_group_map" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."property_type" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."reference" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."solvent" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."solvent_formula" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."solvent_hazard" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."solvent_reference" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";








































































































































































GRANT ALL ON FUNCTION "public"."check_solvent_fraction_sum"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_solvent_fraction_sum"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_solvent_fraction_sum"() TO "service_role";





















GRANT ALL ON TABLE "public"."alias" TO "anon";
GRANT ALL ON TABLE "public"."alias" TO "authenticated";
GRANT ALL ON TABLE "public"."alias" TO "service_role";



GRANT ALL ON TABLE "public"."alias_reference" TO "anon";
GRANT ALL ON TABLE "public"."alias_reference" TO "authenticated";
GRANT ALL ON TABLE "public"."alias_reference" TO "service_role";



GRANT ALL ON TABLE "public"."formula" TO "anon";
GRANT ALL ON TABLE "public"."formula" TO "authenticated";
GRANT ALL ON TABLE "public"."formula" TO "service_role";



GRANT ALL ON TABLE "public"."formula_hazard" TO "anon";
GRANT ALL ON TABLE "public"."formula_hazard" TO "authenticated";
GRANT ALL ON TABLE "public"."formula_hazard" TO "service_role";



GRANT ALL ON TABLE "public"."hazard_classification" TO "anon";
GRANT ALL ON TABLE "public"."hazard_classification" TO "authenticated";
GRANT ALL ON TABLE "public"."hazard_classification" TO "service_role";



GRANT ALL ON TABLE "public"."hazard_code" TO "anon";
GRANT ALL ON TABLE "public"."hazard_code" TO "authenticated";
GRANT ALL ON TABLE "public"."hazard_code" TO "service_role";



GRANT ALL ON TABLE "public"."hazard_pcode" TO "anon";
GRANT ALL ON TABLE "public"."hazard_pcode" TO "authenticated";
GRANT ALL ON TABLE "public"."hazard_pcode" TO "service_role";



GRANT ALL ON TABLE "public"."observation" TO "anon";
GRANT ALL ON TABLE "public"."observation" TO "authenticated";
GRANT ALL ON TABLE "public"."observation" TO "service_role";



GRANT ALL ON TABLE "public"."p_code" TO "anon";
GRANT ALL ON TABLE "public"."p_code" TO "authenticated";
GRANT ALL ON TABLE "public"."p_code" TO "service_role";



GRANT ALL ON TABLE "public"."pcode_group" TO "anon";
GRANT ALL ON TABLE "public"."pcode_group" TO "authenticated";
GRANT ALL ON TABLE "public"."pcode_group" TO "service_role";



GRANT ALL ON TABLE "public"."pcode_group_map" TO "anon";
GRANT ALL ON TABLE "public"."pcode_group_map" TO "authenticated";
GRANT ALL ON TABLE "public"."pcode_group_map" TO "service_role";



GRANT ALL ON TABLE "public"."property_type" TO "anon";
GRANT ALL ON TABLE "public"."property_type" TO "authenticated";
GRANT ALL ON TABLE "public"."property_type" TO "service_role";



GRANT ALL ON TABLE "public"."reference" TO "anon";
GRANT ALL ON TABLE "public"."reference" TO "authenticated";
GRANT ALL ON TABLE "public"."reference" TO "service_role";



GRANT ALL ON TABLE "public"."solvent" TO "anon";
GRANT ALL ON TABLE "public"."solvent" TO "authenticated";
GRANT ALL ON TABLE "public"."solvent" TO "service_role";



GRANT ALL ON TABLE "public"."solvent_formula" TO "anon";
GRANT ALL ON TABLE "public"."solvent_formula" TO "authenticated";
GRANT ALL ON TABLE "public"."solvent_formula" TO "service_role";



GRANT ALL ON TABLE "public"."solvent_hazard" TO "anon";
GRANT ALL ON TABLE "public"."solvent_hazard" TO "authenticated";
GRANT ALL ON TABLE "public"."solvent_hazard" TO "service_role";



GRANT ALL ON TABLE "public"."solvent_reference" TO "anon";
GRANT ALL ON TABLE "public"."solvent_reference" TO "authenticated";
GRANT ALL ON TABLE "public"."solvent_reference" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































drop extension if exists "pg_net";


