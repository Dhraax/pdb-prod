//::///////////////////////////////////////////////
//:: Contagion
//:: NW_S0_Contagion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target must save or be struck down with
    Blidning Sickness, Cackle Fever, Filth Fever
    Mind Fire, Red Ache, the Shakes or Slimy Doom.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 6, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

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

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nRand = Random(7)+1;
    int nDisease;
    int nTouch = TouchAttackMelee(oTarget);
    //Use a random seed to determine the disease that will be delivered.
    switch (nRand)
    {
        case 1:
            nDisease = DISEASE_BLINDING_SICKNESS;
        break;
        case 2:
            nDisease = DISEASE_CACKLE_FEVER;
        break;
        case 3:
            nDisease = DISEASE_FILTH_FEVER;
        break;
        case 4:
            nDisease = DISEASE_MINDFIRE;
        break;
        case 5:
            nDisease = DISEASE_RED_ACHE;
        break;
        case 6:
            nDisease = DISEASE_SHAKES;
        break;
        case 7:
            nDisease = DISEASE_SLIMY_DOOM;
        break;
    }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
      if (nTouch > 0)
      {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTAGION));
        effect eDisease = EffectDisease(nDisease);
        //Make SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //The effect is permament because the disease subsystem has its own internal resolution
            //system in place.
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        }
      }
    }
}

