/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_language_inc
//
//  Desc:  This include collects much of the text used
//         in code by CNR.
//
//  Author: David Bobeck 01May03
//
//  modified by: Dhraax
/////////////////////////////////////////////////////////

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief The name of a trade as a player reads it, with its accent. Trade
///     names are stored without accents because they are database keys
///     (cnr_tradeskill.skill_name).
/// @param sTradeName Stored trade name, for example "Herreria".
/// @returns The display name, or sTradeName unchanged when it has no accent
///     or is not a known trade.
string CnrTextTradeName(string sTradeName);

// cnr_tree_osca
string CNR_TEXT_MINABLE_TREES_ARE_RESISTANT = "Los árboles talables resisten los ataques mágicos.";
// cnr_tree_opa
string CNR_TEXT_BROKEN_WOODCUTTERS_AXE = "Se te ha roto el hacha.";
string CNR_TEXT_REQUIRES_A_WOODCUTTERS_AXE = "Para talar hace falta un hacha de leñador.";
// cnr_tree_ondam
string CNR_TEXT_YOU_HAVE_CHOPPED_OFF_A = "Has cortado: "; // branch name will follow
string CNR_TEXT_THATS_THE_END_OF_THAT = "¡Hasta aquí ha llegado!";
// cnr_rock_osca
string CNR_TEXT_MINABLE_ROCKS_ARE_RESISTANT = "Las rocas minables resisten los ataques mágicos.";
// cnr_rock_opa
string CNR_TEXT_SHATTERED_PICKAXE = "Al picar esta roca se te ha roto el pico.";
string CNR_TEXT_REQUIRES_A_MINERS_PICKAXE = "Para picar esta roca hace falta un pico de minero.";
// cnr_rock_ondam
string CNR_TEXT_YOU_HAVE_CHIPPED_OFF_A = "Has arrancado: "; // nugget name will follow
string CNR_TEXT_AND_A_SECOND = "Y además: "; // gem or nugget name will follow
string CNR_TEXT_AND_A = "Y también: "; // mystery mineral name will follow
// cnr_deposit_ou
string CNR_TEXT_YOU_MUST_POSSESS_A_SHOVEL = "Necesitas una pala para cavar en: "; // deposit name will follow
string CNR_TEXT_YOU_HAVE_BROKEN_YOUR_SHOVEL = "Se te ha roto la pala.";
string CNR_TEXT_YOU_DUG_UP_A = "Has desenterrado: ";  // misc deposit item (ie: sand or clay) will follow
string CNR_TEXT_DEPOSIT_MUMBLE_1 = "Maldición, ¡qué difícil es cavar aquí!";
string CNR_TEXT_DEPOSIT_MUMBLE_2 = "¡Más vale que merezca la pena!";
string CNR_TEXT_DEPOSIT_MUMBLE_3 = "¡Huele como si algo hubiera muerto aquí!";
string CNR_TEXT_DEPOSIT_MUMBLE_4 = "Espero que no se me rompa la pala.";
string CNR_TEXT_DEPOSIT_MUMBLE_5 = "Uf... ¿hasta dónde tengo que cavar?";
string CNR_TEXT_DEPOSIT_MUMBLE_6 = "¡Esto no es tierra de jardín!";
// cnr_gemdep_ou
string CNR_TEXT_YOU_CHISELED_OFF_A = "Has tallado: ";
string CNR_TEXT_GEMDEP_MUMBLE_1 = "Maldición, ¡qué trabajo más duro!";
string CNR_TEXT_GEMDEP_MUMBLE_2 = "¡Arg! Esto avanza despacio.";
string CNR_TEXT_GEMDEP_MUMBLE_3 = "¿No encuentro nada?";
string CNR_TEXT_GEMDEP_MUMBLE_4 = "Espero que no se me rompa el cincel.";
string CNR_TEXT_GEMDEP_MUMBLE_5 = "Tiene que haber algo por aquí.";
string CNR_TEXT_GEMDEP_MUMBLE_6 = "¿Nada? ¡No me lo creo!";
string CNR_TEXT_YOU_MUST_HOLD_A_CHISEL = "Debes empuñar un cincel de tallador para buscar minerales.";
string CNR_TEXT_YOU_HAVE_BROKEN_YOUR_CHISEL = "Se te ha roto el cincel.";
// cnr_minbath_ou
string CNR_TEXT_MINBATH_MUMBLE_1 = "Ah... ¡ya lo reconozco! Es ";
string CNR_TEXT_MINBATH_MUMBLE_2 = "¡Claro que sí! Es ";
string CNR_TEXT_MINBATH_MUMBLE_3 = "Hmm, creo que es ";
// cnr_recipe_utils
string CNR_TEXT_STRENGTH = "fuerza";
string CNR_TEXT_DEXTERITY = "destreza";
string CNR_TEXT_CONSTITUTION = "constitución";
string CNR_TEXT_INTELLIGENCE = "inteligencia";
string CNR_TEXT_WISDOM = "sabiduría";
string CNR_TEXT_CHARISMA = "carisma";
string CNR_TEXT_COMPONENTS_AVAILABLE_REQUIRED = "Componentes (tienes/necesitas):";
string CNR_TEXT_OF = " de "; // # of #
string CNR_TEXT_SPELLS_OF = "Conjuro(s) de "; // spell name will follow
string CNR_INVALID_COMPONENT = "Componente no válido";
string CNR_THIS_RECIPE_IS_TRIVIAL = "Esta receta es trivial para ti.";
string CNR_TEXT_AND_LEVEL = " y nivel";  // "Given your strength, wisdom and level..."
string CNR_TEXT_AND = " y ";             // "Given your strength and widsom, ...
string CNR_TEXT_GIVEN_YOUR = "Por tu "; // "Given your strength and level..."
string CNR_TEXT_THIS_RECIPE_IS_IMPOSSIBLE = ", esta receta es imposible para ti a tu nivel.";
string CNR_TEXT_YOU_WILL_NEED_TO_REACH_LEVEL = "Necesitas llegar al nivel "; // number will follow
string CNR_TEXT_TO_HAVE_A_CHANCE_OF_SUCCESS = " para tener un 5% de probabilidad de éxito.";
string CNR_TEXT_YOU_HAVE_A = ", tienes un "; // percentage will follow
string CNR_TEXT_PERCENT_CHANCE_OF_SUCCESS = "% de probabilidad de fabricar esta receta con éxito.";
string CNR_TEXT_YOUR_ADVENTURING_XP_INCREASED_BY = "Tu experiencia de aventurero aumenta en "; // number will follow
string CNR_TEXT_YOUR_ADVENTURING_XP_DECREASED_BY = "Tu experiencia de aventurero disminuye en "; // number will follow
string CNR_TEXT_YOUR = "Tu experiencia de "; // "Your smelting XP increased by 5."
string CNR_TEXT_XP_INCREASED_BY = " aumenta en "; // "Your smelting XP increased by 5."
string CNR_TEXT_XP_DECREASED_BY = " disminuye en "; // "Your smelting XP decreased by 5."
string CNR_TEXT_YOU_HAVE_REACHED_LEVEL = "¡Has alcanzado el nivel "; // number will follow
string CNR_TEXT_IN = " en "; // "You have reached level 5 in smelting!"
string CNR_TEXT_YOU_NEED = "Necesitas ";
string CNR_TEXT_XP_TO_REACH_THE_NEXT_LEVEL_IN = " de experiencia para el siguiente nivel de "; // tradeskill name will follow
string CNR_TEXT_YOU_ARE_CURRENTLY_AT_LEVEL = "Tu nivel actual es "; // number will follow
string CNR_TEXT_YOU_SUCCESSFULLY_MADE = "Has fabricado con éxito "; // number will follow
string CNR_TEXT_ITEMS = " objetos.";
string CNR_TEXT_ITEM = " objeto.";
string CNR_TEXT_FAILURE = "Fallo.";
string CNR_TEXT_YOU_ROLLED_A = "Has sacado un "; // number will follow
string CNR_TEXT_YOU_NEEDED_TO_ROLL_A = "Necesitabas sacar en el d20 un "; // number will follow
string CNR_TEXT_OR_BETTER = " o más.";
string CNR_TEXT_YOU_HAVE_BROKEN_YOUR = "Se te ha roto: "; // tool name will follow
string CNR_TEXT_YOU_MUST_POSSESS_A = "Necesitas tener: "; // tool name will follow
string CNR_TEXT_YOU_MUST_HOLD_A = "Necesitas empuñar: "; // tool name will follow
string CNR_TEXT_TO_USE_THIS_DEVICE = " para usar esta estación.";
string CNR_TEXT_XP_EQUALS = "experiencia "; // "smelting, XP = 251/500, level = 2"
string CNR_TEXT_LEVEL_EQUALS = "nivel "; // "smelting, XP = 251/500, level = 2"
string CNR_TEXT_TOP_TEN_CRAFTERS_IN = "Los 10 mejores artesanos de "; // tradeskill name will follow
string CNR_TEXT_FOR_REFERENCE_ONLY = "(solo como referencia)";
string CNR_TEXT_LEVEL = "Nivel "; // a level number will follow
//cnr_recycler_ou: retired, the ingot recycler subsystem was removed.
//cnr_skin_onused
string CNR_TEXT_YOU_MUST_HOLD_A_SKINNING_KNIFE = "Debes empuñar un cuchillo de desollar para despellejar este cadáver.";
string CNR_TEXT_YOU_ACQUIRED_A_SKIN = "Has obtenido una piel del cadáver.";
string CNR_TEXT_YOU_ACQUIRED_SOME_MEAT = "Has obtenido carne del cadáver.";
//cnr_tinker_ou
string CNR_TEXT_YOU_NEED_TO_BE_MORE_CAREFUL = "¡Tienes que tener más cuidado!";

string CnrTextTradeName(string sTradeName)
{
    if (sTradeName == "Herreria")    { return "Herrería"; }
    if (sTradeName == "Carpinteria") { return "Carpintería"; }
    if (sTradeName == "Peleteria")   { return "Peletería"; }
    if (sTradeName == "Joyeria")     { return "Joyería"; }
    if (sTradeName == "Sastreria")   { return "Sastrería"; }
    return sTradeName;
}
