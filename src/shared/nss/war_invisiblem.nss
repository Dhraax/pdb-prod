///::///////////////////////////////////////////////
//:: Improved Invisibility
//:: NW_S0_ImprInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature can attack and cast spells while
    invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "mti_libreria"
#include "pb_nivellanzador"
#include "X0_I0_SPELLS"
#include "war_utilities"

int GetDelayedSpellEffectsExpired(int nSpell_ID, object oTarget, object oCaster);
int GetDelayedSpellEffectsExpired(int nSpell_ID, object oTarget, object oCaster)
{

    if (!GetHasSpellEffect(nSpell_ID,oTarget) )
    {
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        return TRUE;
    }

    //--------------------------------------------------------------------------
    // GZ: 2003-Oct-15
    // If the caster is dead or no longer there, cancel the spell, as it is
    // directed
    //--------------------------------------------------------------------------
    if( !GetIsObjectValid(oCaster))
    {
        RemoveSpellEffects(nSpell_ID, oTarget, oTarget);
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        return TRUE;
    }

    if (GetIsDead(oCaster))
    {
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        RemoveSpellEffects(nSpell_ID, oTarget, oTarget);
        return TRUE;
    }

    if (!GetHasEffect(EFFECT_TYPE_INVISIBILITY, oCaster))
    {
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        return TRUE;
    }

    return FALSE;

}

void Explosion()
{
 //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oPC = OBJECT_SELF;
    int nDamage = d6(4) + GetLevelByClass(57, oPC);
    float fDelay;
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
    effect eDaze = EffectDazed();
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    effect eVis2 = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eLink = EffectLinkEffects(eDaze, eVis2);

    if(GetDelayedSpellEffectsExpired(1359, oPC, oPC))// Si ya no estamos invisibles, PUM!
       {
        if(GetLocalInt(oPC, "EXPLOSION") == 0)
         {
         //Efecto de area
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oPC);

         object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
         //Cycle through the targets within the spell shape until an invalid object is captured.
          while (GetIsObjectValid(oTarget))
              {
               if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) && oTarget != oPC)
                 {
                    //Get the distance between the explosion and the target to calculate delay
                     fDelay = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget))/20;

                    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetWarlockSpellDC(OBJECT_SELF)))
                       {
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
                       }

                       //Aplicamos daño sonico
                      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

                  }
                 //Select the next target within the spell shape.
                 oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
              }
            }

            //Solo una vez
            SetLocalInt(oPC, "EXPLOSION" , 1);
            return;
        }

    else if(GetLocalInt(oPC, "EXPLOSION") == 0) DelayCommand(6.0f, Explosion());

}


void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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


    // No funciona montado en montura
    if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
    {
        SendMessageToPC(OBJECT_SELF, "Los conjuros de invisivilidad no ocultan a criaturas montadas en montura.</c>");
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(816);
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eDur, eCover);


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMPROVED_INVISIBILITY, FALSE));
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);


    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, TurnsToSeconds(nDuration));


    DelayCommand(6.0f, Explosion());
    SetLocalInt(OBJECT_SELF, "EXPLOSION" , 0);

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


