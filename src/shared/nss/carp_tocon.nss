/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    carp_tocon
/// @author  Dhraax
/// @brief   OnSpellCastAt of a stump. A druid healing it grows a CNR tree in
///          its place, so reviving a stump is worth something again.
///
///          The stump says which tree it becomes through the local string
///          CNR_ARBOL. Without it, one of the eight is chosen at random, which
///          is what the old stumps carry: they were placed before the trees had
///          species.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

string CnrTocon_Arbol()
{
    switch (Random(8))
    {
        case 0: return "cnr_arbol_pino";
        case 1: return "cnr_arbol_cipres";
        case 2: return "cnr_arbol_abeto";
        case 3: return "cnr_arbol_cedro";
        case 4: return "cnr_arbol_alamo";
        case 5: return "cnr_arbol_olmo";
        case 6: return "cnr_arbol_roble";
    }
    return "cnr_arbol_fresno";
}

void main()
{
    object oPC = GetLastSpellCaster();
    int iConjuro = GetLastSpell();

    if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) <= 0 ||
        (iConjuro != SPELL_CURE_CRITICAL_WOUNDS &&
         iConjuro != SPELL_CURE_LIGHT_WOUNDS &&
         iConjuro != SPELL_CURE_MINOR_WOUNDS &&
         iConjuro != SPELL_CURE_MODERATE_WOUNDS &&
         iConjuro != SPELL_CURE_SERIOUS_WOUNDS &&
         iConjuro != SPELL_REGENERATE &&
         iConjuro != SPELL_MASS_HEAL &&
         iConjuro != SPELL_HEAL))
    {
        SendMessageToPC(oPC, "*Solamente los druidas lanzando conjuros de curacion "
            + "sobre el tocon podran revivir el arbol*");
        return;
    }

    string sArbol = GetLocalString(OBJECT_SELF, "CNR_ARBOL");
    if (sArbol == "")
    {
        sArbol = CnrTocon_Arbol();
    }

    location lSitio = GetLocation(OBJECT_SELF);
    object oArbol = CreateObject(OBJECT_TYPE_PLACEABLE, sArbol, lSitio, FALSE);
    if (!GetIsObjectValid(oArbol))
    {
        SendMessageToPC(oPC, "*El tocon no consigue retonar*");
        return;
    }

    SetXP(oPC, GetXP(oPC) + 25);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(29), lSitio);
    FloatingTextStringOnCreature("*Has regenerado el arbol, ya puede volver a talarse*", oPC);
    DestroyObject(OBJECT_SELF, 0.5);
}
