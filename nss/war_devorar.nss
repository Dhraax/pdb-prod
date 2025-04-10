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

int TieneMagia(object oPC);
int TieneMagia(object oPC)
{
      effect eEfecto = GetFirstEffect(oPC);
      while(GetIsEffectValid(eEfecto))
      {
            if(GetEffectSubType(eEfecto) != SUBTYPE_SUPERNATURAL && GetEffectType(eEfecto) != EFFECT_TYPE_CURSE && GetEffectSpellId(eEfecto))
                    return TRUE;

            eEfecto = GetNextEffect(oPC);
      }
      return FALSE;
}

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
    effect    eHeal        = EffectTemporaryHitpoints(nCasterLevel);
    object    oTarget      = GetSpellTargetObject();
    object    oMaster;
    location  lLocal       = GetSpellTargetLocation();

    if(nCasterLevel > 20)
    {
        nCasterLevel = 20;
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

         if(TieneMagia(oTarget) && oTarget != OBJECT_SELF) {
                    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1935), oTarget));
                    DelayCommand(2.0, AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), OBJECT_SELF)));
                    DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_EVIL), OBJECT_SELF));
                    DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), OBJECT_SELF));
                    DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(55), OBJECT_SELF));
                    DelayCommand(4.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, OBJECT_SELF, 60.0));
                    }
                    pbDispelMagic(oTarget, nCasterLevel, eVis, eImpact);

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

                if(TieneMagia(oTarget) && oTarget != OBJECT_SELF){
                    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DESTRUCTION), oTarget));
                    DelayCommand(2.0, AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), OBJECT_SELF)));
                    DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_EVIL), OBJECT_SELF));
                    DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), OBJECT_SELF));
                    DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(55), OBJECT_SELF));
                    DelayCommand(4.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, OBJECT_SELF, 60.0));
                    }
                    pbDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);

        }
    }
     DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}





