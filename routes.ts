import { property_typeHandler, solventHandler, aliasHandler, observationHandler, formulaHandler, solvent_formulaHandler, hazard_codeHandler, p_codeHandler, hazard_classificationHandler, pcode_groupHandler, alias_referenceHandler, formula_hazardHandler, hazard_pcodeHandler, pcode_group_mapHandler, solvent_hazardHandler, solvent_referenceHandler } from './_handlers';

export const routes = {
  "/property_type": property_typeHandler,
  "/solvent": solventHandler,
  "/alias": aliasHandler,
  "/observation": observationHandler,
  "/formula": formulaHandler,
  "/solvent_formula": solvent_formulaHandler,
  "/hazard_code": hazard_codeHandler,
  "/p_code": p_codeHandler,
  "/hazard_classification": hazard_classificationHandler,
  "/pcode_group": pcode_groupHandler,
  "/alias_reference": alias_referenceHandler,
  "/formula_hazard": formula_hazardHandler,
  "/hazard_pcode": hazard_pcodeHandler,
  "/pcode_group_map": pcode_group_mapHandler,
  "/solvent_hazard": solvent_hazardHandler,
  "/solvent_reference": solvent_referenceHandler
};
