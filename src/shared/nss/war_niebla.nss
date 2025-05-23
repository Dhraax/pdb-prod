//::///////////////////////////////////////////////
//:: NIEBLA DE OBSCURECIMIENTO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Niebla de obscurecimiento.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 30 de Marzo de 2011
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "war_utilities"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
    /*
        Spellcast Hook Code
        Added 2003-07-07 by Georg Zoeller
        If you want to make changes to all spells,
        check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

     if (!CheckWarlockSpellCharisma()) return;
    // End of Spell Cast Hook


    //Declare major variables
    int iNivelLanzador = GetTotalCasterLevel(OBJECT_SELF);
    int nDuration = iNivelLanzador; // * Duracion 1 turno / nivel

    effect eOcultacion1 = EffectConcealment(30);
    effect eVis = EffectVisualEffect(479); //423
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eOcultacionPersonal = EffectLinkEffects(eOcultacion1, eDur);
    eOcultacionPersonal = EffectLinkEffects(eOcultacionPersonal, eVis);


    //Apply VFX impact and bonus effects
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(33), GetLocation(OBJECT_SELF));  //1778
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOcultacionPersonal, OBJECT_SELF, HoursToSeconds(nDuration));


    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

