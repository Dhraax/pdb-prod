//::///////////////////////////////////////////////
//:: (PB) AUSENTE
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Guarda el PJ en el servervault.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 24 de Mayo de 2011
//:: Rebuild By: Zeratul 12/05/2014
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "lib_disguise"

void main()
{
    object oPC = OBJECT_SELF;
    string sName = PB_Disguise_GetNameOverride(oPC) == "" ? GetName(oPC) : PB_Disguise_GetNameOverride(oPC);

    //Solo los jugadores
    if (GetIsPC(oPC))
    {
        if (GetIsInCombat(oPC)) FloatingTextStringOnCreature("<c´þd>No puedes guardar el personaje en combate!!</c>", oPC);
        else
        {
            if (GetHasSpellEffect(834))
            {
                FloatingTextStringOnCreature("<cþ<<>** ["+sName+"] ya no está ausente **</c>", oPC);
                SetLocalInt(oPC, "AUSENTE_JUG", 0);
                RemoveEffectsFromSpell(oPC, 834);
            }
            else
            {
                FloatingTextStringOnCreature("<c´þd>** ["+sName+"] está ausente **</c>", oPC);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectCutsceneImmobilize()), oPC);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(751)), oPC);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(552)), oPC);
                SetLocalInt(oPC, "AUSENTE_JUG", 1);
            }
        }
    }
}
