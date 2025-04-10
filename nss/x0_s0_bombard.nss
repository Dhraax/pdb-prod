//::///////////////////////////////////////////////
//:: Bombardment
//:: X0_S0_Bombard
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Rocks fall from sky
// 1d8 damage/level to a max of 10d8
// Reflex save for half
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 22 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "mti_libreria"

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

// COMPONENTE MATERIAL

  object oItm = GetSpellCastItem();
  if(GetIsPC(OBJECT_SELF) == TRUE &&
     oItm == OBJECT_INVALID &&
     GetIsDM(OBJECT_SELF) == FALSE &&
     GetIsDMPossessed(OBJECT_SELF) == FALSE)

      if(GetLastSpellCastClass() == CLASS_TYPE_DRUID) // Druidas...
      {
          string sFocoPersonalizado = ObtenerStringPersistente(OBJECT_SELF, "FOCODIVINO");

          object oYelmo = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
          object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
          object oCapa = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
          object oBrazales = GetItemInSlot(INVENTORY_SLOT_ARMS, OBJECT_SELF);
          object oCinto = GetItemInSlot(INVENTORY_SLOT_BELT, OBJECT_SELF);
          object oCollar = GetItemInSlot(INVENTORY_SLOT_NECK, OBJECT_SELF);
          object oAnilloI = GetItemInSlot(INVENTORY_SLOT_LEFTRING, OBJECT_SELF);
          object oAnilloD = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, OBJECT_SELF);
          object oReliquia = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);

          if(GetName(oYelmo) != sFocoPersonalizado &&
             GetName(oArmadura) != sFocoPersonalizado &&
             GetName(oCapa) != sFocoPersonalizado &&
             GetName(oBrazales) != sFocoPersonalizado &&
             GetName(oCinto) != sFocoPersonalizado &&
             GetName(oCollar) != sFocoPersonalizado &&
             GetName(oAnilloI) != sFocoPersonalizado &&
             GetName(oAnilloD) != sFocoPersonalizado &&
             GetName(oReliquia) != sFocoPersonalizado &&
             GetTag(oCollar) != "focodivino" &&
             GetTag(oReliquia) != "focodivino" &&
             GetTag(oCinto) != "focodivino")
          {
              SendMessageToPC(OBJECT_SELF,"�Necesitas sujetar con fuerza un foco divino dotado de significado espiritual para lanzar este conjuro!");
              return;
          }

          else AssignCommand(OBJECT_SELF, ActionSpeakString("<c!}�>*Te concentras unos instantes en tu foco divino para lanzar el conjuro*</c>"));
      }

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetTotalCasterLevel(oCaster);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    //efectos extra para los escombros
    effect eHold = EffectParalyze();
    effect eDur = EffectVisualEffect(476 );
    eHold = EffectLinkEffects(eDur, eHold);
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 20)
    {
        nCasterLvl = 20;
    }

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        /*if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
        { */
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d8(nCasterLvl);
                //Resolve metamagic
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 8 * nCasterLvl;
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                   nDamage = nDamage + nDamage / 2;
                }
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_ALL);
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
                if(nDamage > 0)
                {

                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }

                //aplicamos escombros
                if (ReflexSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_ALL) == 0)
                {
                 DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, RoundsToSeconds(1)));
                }
            /*}*/
      }

       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
      
    }
	 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}



