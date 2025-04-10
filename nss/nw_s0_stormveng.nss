//::///////////////////////////////////////////////
//:: Storm of Vengeance
//:: NW_S0_StormVeng.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an AOE that decimates the enemies of
    the cleric over a 30ft radius around the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 8, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void TormentaDeVenganza(object oCaster, object oCentro, int iCD);

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    //Declare major variables including Area of Effect Object
    location lTarget = GetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_FNF_STORM);
    effect eAOE = EffectAreaOfEffect(AOE_PER_STORM, "****", "****", "****");

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(10));

    object oCentro = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",lTarget);
    SetName(oCentro, "Centro de Tormenta de Venganza");
    TormentaDeVenganza(OBJECT_SELF, oCentro, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)));
}

void TormentaDeVenganza(object oCaster, object oCentro, int iCD)
{
    // Si el efecto de area se disipo, ya no seguimos
    object oAreaOfEffect = GetFirstObjectInShape(SHAPE_SPHERE, 0.1, GetLocation(oCentro), FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oAreaOfEffect) != TRUE)
    {
        DestroyObject(oCentro);
        return;
    }

    //Declare major variables
    effect eAcid = EffectDamage(d6(3), DAMAGE_TYPE_ACID);
    effect eElec = EffectDamage(d6(3), DAMAGE_TYPE_ELECTRICAL);
    effect eStun = EffectStunned();
    effect eVisAcid = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eVisElec = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    effect eVisStun = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eStun, eVisStun);
    eLink = EffectLinkEffects(eLink, eDur);
    float fDelay;

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCentro), FALSE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STORM_OF_VENGEANCE));

            //Make an SR Check
            fDelay = GetRandomDelay(0.5, 2.0);
            if(MyResistSpell(oCaster, oTarget, fDelay) == 0)
            {
                //Make a saving throw check
                // * if the saving throw is made they still suffer acid damage.
                // * if they fail the saving throw, they suffer Electrical damage too
                if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD, SAVING_THROW_TYPE_ELECTRICITY, oCaster, fDelay))
                {
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                    if(d2() == 1) DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
                }
                else
                {
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eElec, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
                }
            }
        }

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCentro), FALSE, OBJECT_TYPE_CREATURE);
    }

    // Solo dura 10 asaltos
    int iContador = GetLocalInt(oCentro, "TV_CONTADOR");
    SetLocalInt(oCentro, "TV_CONTADOR", iContador + 1);

    if(iContador == 9) DestroyObject(oCentro);
    else DelayCommand(6.0, TormentaDeVenganza(oCaster, oCentro, iCD));
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");

}
