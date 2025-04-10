//::///////////////////////////////////////////////
//:: Mordenkainen's Disjunction
//:: NW_S0_MordDisj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Massive Dispel Magic and Spell Breach rolled into one
    If the target is a general area of effect they lose
    6 spell protections.  If it is an area of effect everyone
    in the area loses 2 spells protections.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated On: Oct 20, 2003, Georg Zoeller
//:://////////////////////////////////////////////
void StripEffects(int nNumber, object oTarget);

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "cerr_newdispel"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
    //--------------------------------------------------------------------------
    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

     effect  eVis        = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect   eImpact     = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
    object   oTarget     = GetSpellTargetObject();
    location lLocal      = GetSpellTargetLocation();
    int      nCasterLevel= GetTotalCasterLevel(OBJECT_SELF);


    //--------------------------------------------------------------------------
    // Mord's is not capped anymore as we can go past level 20 now
    //--------------------------------------------------------------------------
    /*
        if(nCasterLevel > 20)
        {
            nCasterLevel = 20;
        }
    */

     //Espada Planar
      object oMaster;
      string Espada = GetResRef(oTarget);
      string Espada2 = GetTag(oTarget);

  if(Espada == "espadaplanar" || Espada2 == "espadaplanar")
   {
       oMaster = GetMaster(oTarget);
       int nCasterLevel2 = GetTotalCasterLevel(oMaster);
       int nTirada = d20() + nCasterLevel;
       int nCD = 11 + nCasterLevel2;

       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

      if(nTirada > nCD)
       {
        DestroyObject(oTarget, 0.5);
       }
   }

   else if (GetIsObjectValid(oTarget))
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
        pbDispelMagic(oTarget, nCasterLevel, eVis, eImpact,TRUE,TRUE);
    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------

        //Apply the VFX impact and effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
        while (GetIsObjectValid(oTarget))
        {
        if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, OBJECT_SELF) || oTarget == OBJECT_SELF || GetMaster(oTarget) == OBJECT_SELF))
         {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oTarget);
        }
        else if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                pbDispelAoE(oTarget, OBJECT_SELF,nCasterLevel);

            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else
            {
                pbDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE,TRUE);
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);

        }
    }
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}



