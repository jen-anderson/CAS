# CAS
Solvent lookup
🧭 1. Core idea of your system

You are not modelling “solvents as chemicals”.

You are modelling:

a solvent product (what is sold/used) that may map to one or more chemical formulas, which determine hazards and precautions

That distinction is the whole system.

🧱 2. Full relational map (your actual architecture)
🟦 CORE LAYER (identity + data capture)
solvent
  │
  ├── alias
  ├── observation
  └── solvent_reference
Purpose:
what the product is called
what properties have been measured/reported
what sources support the data

🟨 COMPOSITION LAYER (chemical truth)
solvent
  │
  └── solvent_formula ──────── formula
Meaning:
solvent = commercial entity (white spirit, lab solvent, etc.)
formula = chemical identity (hexane, pentane, mixtures)
solvent_formula = mapping + optional composition fraction
🟥 HAZARD LAYER (regulatory classification)
formula
  │
  ├── formula_hazard ─────── hazard_code ─────── hazard_classification
  │
  └────────────────────────── hazard_pcode ───── p_code
Meaning:
formula determines hazard truth
hazard_code defines H-statements
classification refines category/strength
p_code defines required precautions

🟪 ORGANISATION LAYER (usability grouping)
p_code ───── pcode_group_map ───── pcode_group
Meaning:
purely structural grouping for UI, filtering, or reporting
does NOT affect hazard logic

🔗 3. End-to-end flow (this is the key diagram)

If you query a solvent:

SOLVENT
  ↓
solvent_formula
  ↓
FORMULA
  ↓
formula_hazard
  ↓
HAZARD_CODE
  ↓
hazard_pcode
  ↓
P_CODE

So the full chain is:

Product → composition → hazard → precaution

🧪 4. Your hexane / pentane example (why your design works)
Case:
Supplier A: “White Spirit” = mostly hexane
Supplier B: “White Spirit” = mostly pentane

Your system handles it as:
solvent (White Spirit A)
  → solvent_formula → hexane

solvent (White Spirit B)
  → solvent_formula → pentane

Then:

hexane → hazards → P-codes
pentane → hazards → P-codes

✔ No contradiction
✔ No forced single definition
✔ Supplier variation preserved
✔ Chemistry stays stable at formula level

⚠️ 5. The one critical design rule you now have

This is the thing that keeps your system consistent:

Hazards belong to FORMULA, not SOLVENT

Everything else inherits upward.

🧠 6. Mental model (very important)

Think of it like this:

Layer	Meaning
solvent	“what is on the bottle”
formula	“what it actually is”
hazard	“what it does”
p-code	“what you must do”


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


    🧭 Recommended ingestion pipeline
STEP 1 — Raw reference ingestion
reference table

Store:

source
URL
date accessed
supplier name

✔ immutable

STEP 2 — Solvent identity ingestion
solvent table

Only:

name
CAS
flags (mixture yes/no)

❌ NO hazards
❌ NO formulas embedded

STEP 3 — Formula resolution layer
solvent_formula
formula

This is where you absorb MSDS disagreement:

Example:

Supplier A → hexane-rich fraction
Supplier B → pentane-rich fraction

You store BOTH.

✔ You do NOT choose a “winner” immediately

STEP 4 — Hazard attachment (authoritative layer)
formula_hazard

Only attach hazards when:

CAS matches
trusted MSDS source exists
or curated rule exists

STEP 5 — P-code resolution
hazard_pcode

This is stable (GHS standard), so:

least likely to change
safe to seed early
🧠 3. How to handle your seed data (without redoing everything)

You already have semi-clean spreadsheets — good.

DO NOT try to “perfect” them first.

Instead:

✔ Step 1 — freeze what you already have

Treat your current dataset as:

“v1 curated ingestion snapshot”

✔ Step 2 — mark uncertainty, don’t delete it

Add (or use existing fields like note):

“supplier-conflict”
“MSDS disagreement”
“composition uncertain”
“source ambiguity”

This is critical — it prevents data loss.

✔ Step 3 — allow duplicates in formula layer

For now, accept:

multiple formulas per solvent
conflicting supplier interpretations

That is correct scientifically, not an error.

✔ Step 4 — only enforce strictness at hazard layer

Hazards should be:

consistent per formula
versioned via reference

⚠️ 4. Key design insight (this is the real “aha” point)

You are not building a database of:

“what solvents are”

You are building:

“what different sources claim solvents are, and what risks follow from each claim”

That means:

inconsistency is data, not noise
ambiguity must be preserved, not removed
🔥 5. Practical mental model going forward

Think in 3 layers:

🧪 Chemistry truth

(formula + hazards)

📦 Commercial ambiguity

(solvent + solvent_formula)

📚 Evidence trail

(reference + observation)

SOLVENT (commercial identity)
   ↓
SOLVENT_FORMULA (what it actually is chemically)
   ↓
FORMULA (true chemical identity)
   ↓
FORMULA_HAZARD (inherent hazards)
   ↓
HAZARD_CODE (H-codes + statements)
   ↓
HAZARD_PCODE (regulatory handling instructions)
   ↓
P_CODE (final safety instructions)