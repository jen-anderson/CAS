drop extension if exists "pg_net";


  create table "public"."alias" (
    "alias_id" text not null,
    "solvent_id" text not null,
    "alias_name" text not null,
    "alias_type" text
      );


alter table "public"."alias" enable row level security;


  create table "public"."alias_reference" (
    "alias_id" text not null,
    "reference_id" text not null
      );


alter table "public"."alias_reference" enable row level security;


  create table "public"."formula" (
    "formula_id" text not null,
    "canonical_name" text not null,
    "molecular_formula_hill" text,
    "molecular_weight" numeric,
    "molar_vol" numeric,
    "smiles" text,
    "inchi" text,
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
    "notes" text,
    "standard_data_source" text,
    "variant" text
      );


alter table "public"."formula" enable row level security;


  create table "public"."formula_hazard" (
    "formula_id" text not null,
    "hazard_id" text not null
      );


alter table "public"."formula_hazard" enable row level security;


  create table "public"."hazard_classification" (
    "classification_id" text not null,
    "hazard_id" text,
    "hazard_class" text,
    "category" text,
    "signal_word" text
      );


alter table "public"."hazard_classification" enable row level security;


  create table "public"."hazard_code" (
    "hazard_id" text not null,
    "h_code" text,
    "hazard_statements" text
      );


alter table "public"."hazard_code" enable row level security;


  create table "public"."hazard_pcode" (
    "hazard_id" text not null,
    "pcode_id" text not null
      );


alter table "public"."hazard_pcode" enable row level security;


  create table "public"."observation" (
    "observation_id" text not null,
    "solvent_id" text not null,
    "property_code" text,
    "value" numeric(12,6) not null,
    "unit" text,
    "conditions" text,
    "reference_id" text,
    "notes" text
      );


alter table "public"."observation" enable row level security;


  create table "public"."p_code" (
    "p_code_id" text not null,
    "p_code" text,
    "phrase" text not null,
    "category" text,
    "notes" text
      );


alter table "public"."p_code" enable row level security;


  create table "public"."pcode_group" (
    "group_id" text not null,
    "group_name" text,
    "description" text
      );


alter table "public"."pcode_group" enable row level security;


  create table "public"."pcode_group_map" (
    "group_id" text not null,
    "p_code_id" text not null
      );


alter table "public"."pcode_group_map" enable row level security;


  create table "public"."property_type" (
    "property_code" text not null,
    "property_name" text not null,
    "default_unit" text
      );


alter table "public"."property_type" enable row level security;


  create table "public"."reference" (
    "reference_id" text not null,
    "title" text,
    "reference_type" text,
    "url" text,
    "publisher" text,
    "jurisdiction" text,
    "version" text,
    "published_date" date
      );


alter table "public"."reference" enable row level security;


  create table "public"."solvent" (
    "solvent_id" text not null,
    "canonical_name" text,
    "cas_number" text,
    "refchem_id" text,
    "is_mixture" boolean default false,
    "note" text,
    "is_deleted" boolean default false,
    "deleted_at" timestamp without time zone
      );


alter table "public"."solvent" enable row level security;


  create table "public"."solvent_formula" (
    "solvent_id" text not null,
    "formula_id" text not null,
    "fraction" numeric
      );


alter table "public"."solvent_formula" enable row level security;


  create table "public"."solvent_hazard" (
    "solvent_id" text not null,
    "hazard_id" text not null
      );


alter table "public"."solvent_hazard" enable row level security;


  create table "public"."solvent_reference" (
    "solvent_id" text not null,
    "reference_id" text not null
      );


alter table "public"."solvent_reference" enable row level security;

CREATE UNIQUE INDEX alias_pkey ON public.alias USING btree (alias_id);

CREATE UNIQUE INDEX alias_reference_pkey ON public.alias_reference USING btree (alias_id, reference_id);

CREATE UNIQUE INDEX alias_solvent_id_alias_name_key ON public.alias USING btree (solvent_id, alias_name);

CREATE UNIQUE INDEX formula_hazard_pkey ON public.formula_hazard USING btree (formula_id, hazard_id);

CREATE UNIQUE INDEX formula_pkey ON public.formula USING btree (formula_id);

CREATE UNIQUE INDEX hazard_classification_pkey ON public.hazard_classification USING btree (classification_id);

CREATE UNIQUE INDEX hazard_code_pkey ON public.hazard_code USING btree (hazard_id);

CREATE UNIQUE INDEX hazard_pcode_pkey ON public.hazard_pcode USING btree (hazard_id, pcode_id);

CREATE UNIQUE INDEX observation_pkey ON public.observation USING btree (observation_id);

CREATE UNIQUE INDEX p_code_pkey ON public.p_code USING btree (p_code_id);

CREATE UNIQUE INDEX pcode_group_map_pkey ON public.pcode_group_map USING btree (group_id, p_code_id);

CREATE UNIQUE INDEX pcode_group_pkey ON public.pcode_group USING btree (group_id);

CREATE UNIQUE INDEX property_type_pkey ON public.property_type USING btree (property_code);

CREATE UNIQUE INDEX property_type_property_name_key ON public.property_type USING btree (property_name);

CREATE UNIQUE INDEX reference_pkey ON public.reference USING btree (reference_id);

CREATE UNIQUE INDEX solvent_formula_pkey ON public.solvent_formula USING btree (solvent_id, formula_id);

CREATE UNIQUE INDEX solvent_hazard_pkey ON public.solvent_hazard USING btree (solvent_id, hazard_id);

CREATE UNIQUE INDEX solvent_pkey ON public.solvent USING btree (solvent_id);

CREATE UNIQUE INDEX solvent_reference_pkey ON public.solvent_reference USING btree (solvent_id, reference_id);

alter table "public"."alias" add constraint "alias_pkey" PRIMARY KEY using index "alias_pkey";

alter table "public"."alias_reference" add constraint "alias_reference_pkey" PRIMARY KEY using index "alias_reference_pkey";

alter table "public"."formula" add constraint "formula_pkey" PRIMARY KEY using index "formula_pkey";

alter table "public"."formula_hazard" add constraint "formula_hazard_pkey" PRIMARY KEY using index "formula_hazard_pkey";

alter table "public"."hazard_classification" add constraint "hazard_classification_pkey" PRIMARY KEY using index "hazard_classification_pkey";

alter table "public"."hazard_code" add constraint "hazard_code_pkey" PRIMARY KEY using index "hazard_code_pkey";

alter table "public"."hazard_pcode" add constraint "hazard_pcode_pkey" PRIMARY KEY using index "hazard_pcode_pkey";

alter table "public"."observation" add constraint "observation_pkey" PRIMARY KEY using index "observation_pkey";

alter table "public"."p_code" add constraint "p_code_pkey" PRIMARY KEY using index "p_code_pkey";

alter table "public"."pcode_group" add constraint "pcode_group_pkey" PRIMARY KEY using index "pcode_group_pkey";

alter table "public"."pcode_group_map" add constraint "pcode_group_map_pkey" PRIMARY KEY using index "pcode_group_map_pkey";

alter table "public"."property_type" add constraint "property_type_pkey" PRIMARY KEY using index "property_type_pkey";

alter table "public"."reference" add constraint "reference_pkey" PRIMARY KEY using index "reference_pkey";

alter table "public"."solvent" add constraint "solvent_pkey" PRIMARY KEY using index "solvent_pkey";

alter table "public"."solvent_formula" add constraint "solvent_formula_pkey" PRIMARY KEY using index "solvent_formula_pkey";

alter table "public"."solvent_hazard" add constraint "solvent_hazard_pkey" PRIMARY KEY using index "solvent_hazard_pkey";

alter table "public"."solvent_reference" add constraint "solvent_reference_pkey" PRIMARY KEY using index "solvent_reference_pkey";

alter table "public"."alias" add constraint "alias_alias_type_check" CHECK ((alias_type = ANY (ARRAY['IUPAC'::text, 'common'::text, 'trade'::text, 'abbreviation'::text, 'historical'::text, 'synonym'::text]))) not valid;

alter table "public"."alias" validate constraint "alias_alias_type_check";

alter table "public"."alias" add constraint "alias_solvent_id_alias_name_key" UNIQUE using index "alias_solvent_id_alias_name_key";

alter table "public"."alias" add constraint "alias_solvent_id_fkey" FOREIGN KEY (solvent_id) REFERENCES public.solvent(solvent_id) ON UPDATE RESTRICT ON DELETE CASCADE not valid;

alter table "public"."alias" validate constraint "alias_solvent_id_fkey";

alter table "public"."alias_reference" add constraint "alias_reference_alias_id_fkey" FOREIGN KEY (alias_id) REFERENCES public.alias(alias_id) ON DELETE CASCADE not valid;

alter table "public"."alias_reference" validate constraint "alias_reference_alias_id_fkey";

alter table "public"."alias_reference" add constraint "alias_reference_reference_id_fkey" FOREIGN KEY (reference_id) REFERENCES public.reference(reference_id) ON DELETE CASCADE not valid;

alter table "public"."alias_reference" validate constraint "alias_reference_reference_id_fkey";

alter table "public"."formula_hazard" add constraint "formula_hazard_formula_id_fkey" FOREIGN KEY (formula_id) REFERENCES public.formula(formula_id) ON DELETE CASCADE not valid;

alter table "public"."formula_hazard" validate constraint "formula_hazard_formula_id_fkey";

alter table "public"."formula_hazard" add constraint "formula_hazard_hazard_id_fkey" FOREIGN KEY (hazard_id) REFERENCES public.hazard_code(hazard_id) ON DELETE CASCADE not valid;

alter table "public"."formula_hazard" validate constraint "formula_hazard_hazard_id_fkey";

alter table "public"."hazard_classification" add constraint "hazard_classification_hazard_id_fkey" FOREIGN KEY (hazard_id) REFERENCES public.hazard_code(hazard_id) ON UPDATE RESTRICT ON DELETE RESTRICT not valid;

alter table "public"."hazard_classification" validate constraint "hazard_classification_hazard_id_fkey";

alter table "public"."hazard_pcode" add constraint "hazard_pcode_hazard_id_fkey" FOREIGN KEY (hazard_id) REFERENCES public.hazard_code(hazard_id) ON DELETE CASCADE not valid;

alter table "public"."hazard_pcode" validate constraint "hazard_pcode_hazard_id_fkey";

alter table "public"."hazard_pcode" add constraint "hazard_pcode_pcode_id_fkey" FOREIGN KEY (pcode_id) REFERENCES public.p_code(p_code_id) ON DELETE CASCADE not valid;

alter table "public"."hazard_pcode" validate constraint "hazard_pcode_pcode_id_fkey";

alter table "public"."observation" add constraint "observation_property_code_fkey" FOREIGN KEY (property_code) REFERENCES public.property_type(property_code) ON UPDATE RESTRICT ON DELETE RESTRICT not valid;

alter table "public"."observation" validate constraint "observation_property_code_fkey";

alter table "public"."observation" add constraint "observation_reference_id_fkey" FOREIGN KEY (reference_id) REFERENCES public.reference(reference_id) ON UPDATE RESTRICT ON DELETE RESTRICT not valid;

alter table "public"."observation" validate constraint "observation_reference_id_fkey";

alter table "public"."observation" add constraint "observation_solvent_id_fkey" FOREIGN KEY (solvent_id) REFERENCES public.solvent(solvent_id) ON UPDATE RESTRICT ON DELETE RESTRICT not valid;

alter table "public"."observation" validate constraint "observation_solvent_id_fkey";

alter table "public"."pcode_group_map" add constraint "pcode_group_map_group_id_fkey" FOREIGN KEY (group_id) REFERENCES public.pcode_group(group_id) ON DELETE CASCADE not valid;

alter table "public"."pcode_group_map" validate constraint "pcode_group_map_group_id_fkey";

alter table "public"."pcode_group_map" add constraint "pcode_group_map_p_code_id_fkey" FOREIGN KEY (p_code_id) REFERENCES public.p_code(p_code_id) ON DELETE CASCADE not valid;

alter table "public"."pcode_group_map" validate constraint "pcode_group_map_p_code_id_fkey";

alter table "public"."property_type" add constraint "property_type_property_name_key" UNIQUE using index "property_type_property_name_key";

alter table "public"."solvent_formula" add constraint "solvent_formula_formula_id_fkey" FOREIGN KEY (formula_id) REFERENCES public.formula(formula_id) ON UPDATE RESTRICT ON DELETE RESTRICT not valid;

alter table "public"."solvent_formula" validate constraint "solvent_formula_formula_id_fkey";

alter table "public"."solvent_formula" add constraint "solvent_formula_solvent_id_fkey" FOREIGN KEY (solvent_id) REFERENCES public.solvent(solvent_id) ON UPDATE RESTRICT ON DELETE CASCADE not valid;

alter table "public"."solvent_formula" validate constraint "solvent_formula_solvent_id_fkey";

alter table "public"."solvent_hazard" add constraint "solvent_hazard_hazard_id_fkey" FOREIGN KEY (hazard_id) REFERENCES public.hazard_code(hazard_id) ON DELETE CASCADE not valid;

alter table "public"."solvent_hazard" validate constraint "solvent_hazard_hazard_id_fkey";

alter table "public"."solvent_hazard" add constraint "solvent_hazard_solvent_id_fkey" FOREIGN KEY (solvent_id) REFERENCES public.solvent(solvent_id) ON DELETE CASCADE not valid;

alter table "public"."solvent_hazard" validate constraint "solvent_hazard_solvent_id_fkey";

alter table "public"."solvent_reference" add constraint "solvent_reference_reference_id_fkey" FOREIGN KEY (reference_id) REFERENCES public.reference(reference_id) ON DELETE CASCADE not valid;

alter table "public"."solvent_reference" validate constraint "solvent_reference_reference_id_fkey";

alter table "public"."solvent_reference" add constraint "solvent_reference_solvent_id_fkey" FOREIGN KEY (solvent_id) REFERENCES public.solvent(solvent_id) ON DELETE CASCADE not valid;

alter table "public"."solvent_reference" validate constraint "solvent_reference_solvent_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_solvent_fraction_sum()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

grant delete on table "public"."alias" to "anon";

grant insert on table "public"."alias" to "anon";

grant references on table "public"."alias" to "anon";

grant select on table "public"."alias" to "anon";

grant trigger on table "public"."alias" to "anon";

grant truncate on table "public"."alias" to "anon";

grant update on table "public"."alias" to "anon";

grant delete on table "public"."alias" to "authenticated";

grant insert on table "public"."alias" to "authenticated";

grant references on table "public"."alias" to "authenticated";

grant select on table "public"."alias" to "authenticated";

grant trigger on table "public"."alias" to "authenticated";

grant truncate on table "public"."alias" to "authenticated";

grant update on table "public"."alias" to "authenticated";

grant delete on table "public"."alias" to "service_role";

grant insert on table "public"."alias" to "service_role";

grant references on table "public"."alias" to "service_role";

grant select on table "public"."alias" to "service_role";

grant trigger on table "public"."alias" to "service_role";

grant truncate on table "public"."alias" to "service_role";

grant update on table "public"."alias" to "service_role";

grant delete on table "public"."alias_reference" to "anon";

grant insert on table "public"."alias_reference" to "anon";

grant references on table "public"."alias_reference" to "anon";

grant select on table "public"."alias_reference" to "anon";

grant trigger on table "public"."alias_reference" to "anon";

grant truncate on table "public"."alias_reference" to "anon";

grant update on table "public"."alias_reference" to "anon";

grant delete on table "public"."alias_reference" to "authenticated";

grant insert on table "public"."alias_reference" to "authenticated";

grant references on table "public"."alias_reference" to "authenticated";

grant select on table "public"."alias_reference" to "authenticated";

grant trigger on table "public"."alias_reference" to "authenticated";

grant truncate on table "public"."alias_reference" to "authenticated";

grant update on table "public"."alias_reference" to "authenticated";

grant delete on table "public"."alias_reference" to "service_role";

grant insert on table "public"."alias_reference" to "service_role";

grant references on table "public"."alias_reference" to "service_role";

grant select on table "public"."alias_reference" to "service_role";

grant trigger on table "public"."alias_reference" to "service_role";

grant truncate on table "public"."alias_reference" to "service_role";

grant update on table "public"."alias_reference" to "service_role";

grant delete on table "public"."formula" to "anon";

grant insert on table "public"."formula" to "anon";

grant references on table "public"."formula" to "anon";

grant select on table "public"."formula" to "anon";

grant trigger on table "public"."formula" to "anon";

grant truncate on table "public"."formula" to "anon";

grant update on table "public"."formula" to "anon";

grant delete on table "public"."formula" to "authenticated";

grant insert on table "public"."formula" to "authenticated";

grant references on table "public"."formula" to "authenticated";

grant select on table "public"."formula" to "authenticated";

grant trigger on table "public"."formula" to "authenticated";

grant truncate on table "public"."formula" to "authenticated";

grant update on table "public"."formula" to "authenticated";

grant delete on table "public"."formula" to "service_role";

grant insert on table "public"."formula" to "service_role";

grant references on table "public"."formula" to "service_role";

grant select on table "public"."formula" to "service_role";

grant trigger on table "public"."formula" to "service_role";

grant truncate on table "public"."formula" to "service_role";

grant update on table "public"."formula" to "service_role";

grant delete on table "public"."formula_hazard" to "anon";

grant insert on table "public"."formula_hazard" to "anon";

grant references on table "public"."formula_hazard" to "anon";

grant select on table "public"."formula_hazard" to "anon";

grant trigger on table "public"."formula_hazard" to "anon";

grant truncate on table "public"."formula_hazard" to "anon";

grant update on table "public"."formula_hazard" to "anon";

grant delete on table "public"."formula_hazard" to "authenticated";

grant insert on table "public"."formula_hazard" to "authenticated";

grant references on table "public"."formula_hazard" to "authenticated";

grant select on table "public"."formula_hazard" to "authenticated";

grant trigger on table "public"."formula_hazard" to "authenticated";

grant truncate on table "public"."formula_hazard" to "authenticated";

grant update on table "public"."formula_hazard" to "authenticated";

grant delete on table "public"."formula_hazard" to "service_role";

grant insert on table "public"."formula_hazard" to "service_role";

grant references on table "public"."formula_hazard" to "service_role";

grant select on table "public"."formula_hazard" to "service_role";

grant trigger on table "public"."formula_hazard" to "service_role";

grant truncate on table "public"."formula_hazard" to "service_role";

grant update on table "public"."formula_hazard" to "service_role";

grant delete on table "public"."hazard_classification" to "anon";

grant insert on table "public"."hazard_classification" to "anon";

grant references on table "public"."hazard_classification" to "anon";

grant select on table "public"."hazard_classification" to "anon";

grant trigger on table "public"."hazard_classification" to "anon";

grant truncate on table "public"."hazard_classification" to "anon";

grant update on table "public"."hazard_classification" to "anon";

grant delete on table "public"."hazard_classification" to "authenticated";

grant insert on table "public"."hazard_classification" to "authenticated";

grant references on table "public"."hazard_classification" to "authenticated";

grant select on table "public"."hazard_classification" to "authenticated";

grant trigger on table "public"."hazard_classification" to "authenticated";

grant truncate on table "public"."hazard_classification" to "authenticated";

grant update on table "public"."hazard_classification" to "authenticated";

grant delete on table "public"."hazard_classification" to "service_role";

grant insert on table "public"."hazard_classification" to "service_role";

grant references on table "public"."hazard_classification" to "service_role";

grant select on table "public"."hazard_classification" to "service_role";

grant trigger on table "public"."hazard_classification" to "service_role";

grant truncate on table "public"."hazard_classification" to "service_role";

grant update on table "public"."hazard_classification" to "service_role";

grant delete on table "public"."hazard_code" to "anon";

grant insert on table "public"."hazard_code" to "anon";

grant references on table "public"."hazard_code" to "anon";

grant select on table "public"."hazard_code" to "anon";

grant trigger on table "public"."hazard_code" to "anon";

grant truncate on table "public"."hazard_code" to "anon";

grant update on table "public"."hazard_code" to "anon";

grant delete on table "public"."hazard_code" to "authenticated";

grant insert on table "public"."hazard_code" to "authenticated";

grant references on table "public"."hazard_code" to "authenticated";

grant select on table "public"."hazard_code" to "authenticated";

grant trigger on table "public"."hazard_code" to "authenticated";

grant truncate on table "public"."hazard_code" to "authenticated";

grant update on table "public"."hazard_code" to "authenticated";

grant delete on table "public"."hazard_code" to "service_role";

grant insert on table "public"."hazard_code" to "service_role";

grant references on table "public"."hazard_code" to "service_role";

grant select on table "public"."hazard_code" to "service_role";

grant trigger on table "public"."hazard_code" to "service_role";

grant truncate on table "public"."hazard_code" to "service_role";

grant update on table "public"."hazard_code" to "service_role";

grant delete on table "public"."hazard_pcode" to "anon";

grant insert on table "public"."hazard_pcode" to "anon";

grant references on table "public"."hazard_pcode" to "anon";

grant select on table "public"."hazard_pcode" to "anon";

grant trigger on table "public"."hazard_pcode" to "anon";

grant truncate on table "public"."hazard_pcode" to "anon";

grant update on table "public"."hazard_pcode" to "anon";

grant delete on table "public"."hazard_pcode" to "authenticated";

grant insert on table "public"."hazard_pcode" to "authenticated";

grant references on table "public"."hazard_pcode" to "authenticated";

grant select on table "public"."hazard_pcode" to "authenticated";

grant trigger on table "public"."hazard_pcode" to "authenticated";

grant truncate on table "public"."hazard_pcode" to "authenticated";

grant update on table "public"."hazard_pcode" to "authenticated";

grant delete on table "public"."hazard_pcode" to "service_role";

grant insert on table "public"."hazard_pcode" to "service_role";

grant references on table "public"."hazard_pcode" to "service_role";

grant select on table "public"."hazard_pcode" to "service_role";

grant trigger on table "public"."hazard_pcode" to "service_role";

grant truncate on table "public"."hazard_pcode" to "service_role";

grant update on table "public"."hazard_pcode" to "service_role";

grant delete on table "public"."observation" to "anon";

grant insert on table "public"."observation" to "anon";

grant references on table "public"."observation" to "anon";

grant select on table "public"."observation" to "anon";

grant trigger on table "public"."observation" to "anon";

grant truncate on table "public"."observation" to "anon";

grant update on table "public"."observation" to "anon";

grant delete on table "public"."observation" to "authenticated";

grant insert on table "public"."observation" to "authenticated";

grant references on table "public"."observation" to "authenticated";

grant select on table "public"."observation" to "authenticated";

grant trigger on table "public"."observation" to "authenticated";

grant truncate on table "public"."observation" to "authenticated";

grant update on table "public"."observation" to "authenticated";

grant delete on table "public"."observation" to "service_role";

grant insert on table "public"."observation" to "service_role";

grant references on table "public"."observation" to "service_role";

grant select on table "public"."observation" to "service_role";

grant trigger on table "public"."observation" to "service_role";

grant truncate on table "public"."observation" to "service_role";

grant update on table "public"."observation" to "service_role";

grant delete on table "public"."p_code" to "anon";

grant insert on table "public"."p_code" to "anon";

grant references on table "public"."p_code" to "anon";

grant select on table "public"."p_code" to "anon";

grant trigger on table "public"."p_code" to "anon";

grant truncate on table "public"."p_code" to "anon";

grant update on table "public"."p_code" to "anon";

grant delete on table "public"."p_code" to "authenticated";

grant insert on table "public"."p_code" to "authenticated";

grant references on table "public"."p_code" to "authenticated";

grant select on table "public"."p_code" to "authenticated";

grant trigger on table "public"."p_code" to "authenticated";

grant truncate on table "public"."p_code" to "authenticated";

grant update on table "public"."p_code" to "authenticated";

grant delete on table "public"."p_code" to "service_role";

grant insert on table "public"."p_code" to "service_role";

grant references on table "public"."p_code" to "service_role";

grant select on table "public"."p_code" to "service_role";

grant trigger on table "public"."p_code" to "service_role";

grant truncate on table "public"."p_code" to "service_role";

grant update on table "public"."p_code" to "service_role";

grant delete on table "public"."pcode_group" to "anon";

grant insert on table "public"."pcode_group" to "anon";

grant references on table "public"."pcode_group" to "anon";

grant select on table "public"."pcode_group" to "anon";

grant trigger on table "public"."pcode_group" to "anon";

grant truncate on table "public"."pcode_group" to "anon";

grant update on table "public"."pcode_group" to "anon";

grant delete on table "public"."pcode_group" to "authenticated";

grant insert on table "public"."pcode_group" to "authenticated";

grant references on table "public"."pcode_group" to "authenticated";

grant select on table "public"."pcode_group" to "authenticated";

grant trigger on table "public"."pcode_group" to "authenticated";

grant truncate on table "public"."pcode_group" to "authenticated";

grant update on table "public"."pcode_group" to "authenticated";

grant delete on table "public"."pcode_group" to "service_role";

grant insert on table "public"."pcode_group" to "service_role";

grant references on table "public"."pcode_group" to "service_role";

grant select on table "public"."pcode_group" to "service_role";

grant trigger on table "public"."pcode_group" to "service_role";

grant truncate on table "public"."pcode_group" to "service_role";

grant update on table "public"."pcode_group" to "service_role";

grant delete on table "public"."pcode_group_map" to "anon";

grant insert on table "public"."pcode_group_map" to "anon";

grant references on table "public"."pcode_group_map" to "anon";

grant select on table "public"."pcode_group_map" to "anon";

grant trigger on table "public"."pcode_group_map" to "anon";

grant truncate on table "public"."pcode_group_map" to "anon";

grant update on table "public"."pcode_group_map" to "anon";

grant delete on table "public"."pcode_group_map" to "authenticated";

grant insert on table "public"."pcode_group_map" to "authenticated";

grant references on table "public"."pcode_group_map" to "authenticated";

grant select on table "public"."pcode_group_map" to "authenticated";

grant trigger on table "public"."pcode_group_map" to "authenticated";

grant truncate on table "public"."pcode_group_map" to "authenticated";

grant update on table "public"."pcode_group_map" to "authenticated";

grant delete on table "public"."pcode_group_map" to "service_role";

grant insert on table "public"."pcode_group_map" to "service_role";

grant references on table "public"."pcode_group_map" to "service_role";

grant select on table "public"."pcode_group_map" to "service_role";

grant trigger on table "public"."pcode_group_map" to "service_role";

grant truncate on table "public"."pcode_group_map" to "service_role";

grant update on table "public"."pcode_group_map" to "service_role";

grant delete on table "public"."property_type" to "anon";

grant insert on table "public"."property_type" to "anon";

grant references on table "public"."property_type" to "anon";

grant select on table "public"."property_type" to "anon";

grant trigger on table "public"."property_type" to "anon";

grant truncate on table "public"."property_type" to "anon";

grant update on table "public"."property_type" to "anon";

grant delete on table "public"."property_type" to "authenticated";

grant insert on table "public"."property_type" to "authenticated";

grant references on table "public"."property_type" to "authenticated";

grant select on table "public"."property_type" to "authenticated";

grant trigger on table "public"."property_type" to "authenticated";

grant truncate on table "public"."property_type" to "authenticated";

grant update on table "public"."property_type" to "authenticated";

grant delete on table "public"."property_type" to "service_role";

grant insert on table "public"."property_type" to "service_role";

grant references on table "public"."property_type" to "service_role";

grant select on table "public"."property_type" to "service_role";

grant trigger on table "public"."property_type" to "service_role";

grant truncate on table "public"."property_type" to "service_role";

grant update on table "public"."property_type" to "service_role";

grant delete on table "public"."reference" to "anon";

grant insert on table "public"."reference" to "anon";

grant references on table "public"."reference" to "anon";

grant select on table "public"."reference" to "anon";

grant trigger on table "public"."reference" to "anon";

grant truncate on table "public"."reference" to "anon";

grant update on table "public"."reference" to "anon";

grant delete on table "public"."reference" to "authenticated";

grant insert on table "public"."reference" to "authenticated";

grant references on table "public"."reference" to "authenticated";

grant select on table "public"."reference" to "authenticated";

grant trigger on table "public"."reference" to "authenticated";

grant truncate on table "public"."reference" to "authenticated";

grant update on table "public"."reference" to "authenticated";

grant delete on table "public"."reference" to "service_role";

grant insert on table "public"."reference" to "service_role";

grant references on table "public"."reference" to "service_role";

grant select on table "public"."reference" to "service_role";

grant trigger on table "public"."reference" to "service_role";

grant truncate on table "public"."reference" to "service_role";

grant update on table "public"."reference" to "service_role";

grant delete on table "public"."solvent" to "anon";

grant insert on table "public"."solvent" to "anon";

grant references on table "public"."solvent" to "anon";

grant select on table "public"."solvent" to "anon";

grant trigger on table "public"."solvent" to "anon";

grant truncate on table "public"."solvent" to "anon";

grant update on table "public"."solvent" to "anon";

grant delete on table "public"."solvent" to "authenticated";

grant insert on table "public"."solvent" to "authenticated";

grant references on table "public"."solvent" to "authenticated";

grant select on table "public"."solvent" to "authenticated";

grant trigger on table "public"."solvent" to "authenticated";

grant truncate on table "public"."solvent" to "authenticated";

grant update on table "public"."solvent" to "authenticated";

grant delete on table "public"."solvent" to "service_role";

grant insert on table "public"."solvent" to "service_role";

grant references on table "public"."solvent" to "service_role";

grant select on table "public"."solvent" to "service_role";

grant trigger on table "public"."solvent" to "service_role";

grant truncate on table "public"."solvent" to "service_role";

grant update on table "public"."solvent" to "service_role";

grant delete on table "public"."solvent_formula" to "anon";

grant insert on table "public"."solvent_formula" to "anon";

grant references on table "public"."solvent_formula" to "anon";

grant select on table "public"."solvent_formula" to "anon";

grant trigger on table "public"."solvent_formula" to "anon";

grant truncate on table "public"."solvent_formula" to "anon";

grant update on table "public"."solvent_formula" to "anon";

grant delete on table "public"."solvent_formula" to "authenticated";

grant insert on table "public"."solvent_formula" to "authenticated";

grant references on table "public"."solvent_formula" to "authenticated";

grant select on table "public"."solvent_formula" to "authenticated";

grant trigger on table "public"."solvent_formula" to "authenticated";

grant truncate on table "public"."solvent_formula" to "authenticated";

grant update on table "public"."solvent_formula" to "authenticated";

grant delete on table "public"."solvent_formula" to "service_role";

grant insert on table "public"."solvent_formula" to "service_role";

grant references on table "public"."solvent_formula" to "service_role";

grant select on table "public"."solvent_formula" to "service_role";

grant trigger on table "public"."solvent_formula" to "service_role";

grant truncate on table "public"."solvent_formula" to "service_role";

grant update on table "public"."solvent_formula" to "service_role";

grant delete on table "public"."solvent_hazard" to "anon";

grant insert on table "public"."solvent_hazard" to "anon";

grant references on table "public"."solvent_hazard" to "anon";

grant select on table "public"."solvent_hazard" to "anon";

grant trigger on table "public"."solvent_hazard" to "anon";

grant truncate on table "public"."solvent_hazard" to "anon";

grant update on table "public"."solvent_hazard" to "anon";

grant delete on table "public"."solvent_hazard" to "authenticated";

grant insert on table "public"."solvent_hazard" to "authenticated";

grant references on table "public"."solvent_hazard" to "authenticated";

grant select on table "public"."solvent_hazard" to "authenticated";

grant trigger on table "public"."solvent_hazard" to "authenticated";

grant truncate on table "public"."solvent_hazard" to "authenticated";

grant update on table "public"."solvent_hazard" to "authenticated";

grant delete on table "public"."solvent_hazard" to "service_role";

grant insert on table "public"."solvent_hazard" to "service_role";

grant references on table "public"."solvent_hazard" to "service_role";

grant select on table "public"."solvent_hazard" to "service_role";

grant trigger on table "public"."solvent_hazard" to "service_role";

grant truncate on table "public"."solvent_hazard" to "service_role";

grant update on table "public"."solvent_hazard" to "service_role";

grant delete on table "public"."solvent_reference" to "anon";

grant insert on table "public"."solvent_reference" to "anon";

grant references on table "public"."solvent_reference" to "anon";

grant select on table "public"."solvent_reference" to "anon";

grant trigger on table "public"."solvent_reference" to "anon";

grant truncate on table "public"."solvent_reference" to "anon";

grant update on table "public"."solvent_reference" to "anon";

grant delete on table "public"."solvent_reference" to "authenticated";

grant insert on table "public"."solvent_reference" to "authenticated";

grant references on table "public"."solvent_reference" to "authenticated";

grant select on table "public"."solvent_reference" to "authenticated";

grant trigger on table "public"."solvent_reference" to "authenticated";

grant truncate on table "public"."solvent_reference" to "authenticated";

grant update on table "public"."solvent_reference" to "authenticated";

grant delete on table "public"."solvent_reference" to "service_role";

grant insert on table "public"."solvent_reference" to "service_role";

grant references on table "public"."solvent_reference" to "service_role";

grant select on table "public"."solvent_reference" to "service_role";

grant trigger on table "public"."solvent_reference" to "service_role";

grant truncate on table "public"."solvent_reference" to "service_role";

grant update on table "public"."solvent_reference" to "service_role";


  create policy "Allow public read"
  on "public"."solvent"
  as permissive
  for select
  to public
using (true);


CREATE TRIGGER solvent_fraction_sum_check BEFORE INSERT OR UPDATE ON public.solvent_formula FOR EACH ROW EXECUTE FUNCTION public.check_solvent_fraction_sum();


