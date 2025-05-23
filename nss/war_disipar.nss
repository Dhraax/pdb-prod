//::///////////////////////////////////////////////
//:: Dispel Magic
//:: NW_S0_DisMagic.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Attempts to dispel all magic on a targeted
//:: object, or simply the most powerful that it
//:: can on every object in an area if no target
//:: specified.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated On: Oct 20, 2003, Georg Zoeller
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "cerr_newdispel"
#include "war_utilities"

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
    if (!CheckWarlockSpellCharisma()) return;
    // End of Spell Cast Hook

    int       nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    effect    eVis         = EffectVisualEffect(1616);
    effect    eImpact      = EffectVisualEffect(922);
    effect    eDam         = EffectDamage(nCasterLevel, DAMAGE_TYPE_MAGICAL);
    object    oTarget      = GetSpellTargetObject();
    object    oMaster;
    location  lLocal       = GetSpellTargetLocation();

    if(nCasterLevel > 15)
    {
        nCasterLevel = 15;
    }

     //Espada Planar
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


    if (GetIsObjectValid(oTarget))
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
         pbDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oTarget);

    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
        while (GetIsObjectValid(oTarget))
        {

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
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                pbDispelAoE(oTarget, OBJECT_SELF, nCasterLevel);

            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else
            {
                pbDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oTarget);
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
           DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        }
    }
}





