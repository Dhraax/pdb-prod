//::///////////////////////////////////////////////
//:: Magic Vestment
//:: X2_S0_MagcVest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 AC bonus to armor touched per 3 caster
  levels (maximum of +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-29: Rewritten, Georg Zoeller

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "mti_libreria"
#include "x2_inc_spellhook"
#include "inc_sqlite_time"
#include "pb_nivellanzador"
#include "pb_constantes"

void  AddACBonusToArmor(object oMyArmor, float fDuration, int nAmount)
{
    IPSafeAddItemProperty(oMyArmor,ItemPropertyACBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
   return;
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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

// End of Spell Cast Hook
  object oItm = GetSpellCastItem();
  if(GetIsPC(OBJECT_SELF) == TRUE &&
     oItm == OBJECT_INVALID &&
     GetIsDM(OBJECT_SELF) == FALSE &&
     GetIsDMPossessed(OBJECT_SELF) == FALSE)
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
    effect eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nDuration  = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nAmount = nDuration/5+1;
    if (nAmount <0)
    {
        nAmount =1;
    }
    else if (nAmount>5)
    {
        nAmount =5;
    }

    object oMyArmor   =  IPGetTargetedOrEquippedArmor(TRUE);

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }


    if(GetIsObjectValid(oMyArmor) )
    {
        SignalEvent(GetItemPossessor(oMyArmor ), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {

            location lLoc = GetLocation(GetSpellTargetObject());
            DelayCommand(1.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyArmor)));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyArmor), HoursToSeconds(nDuration));
            AddACBonusToArmor(oMyArmor, HoursToSeconds(nDuration),nAmount);
            SetLocalInt(oMyArmor, "FIN_TEMPORIZADOR", StringToInt(SQLite_GetSystemTime()) + FloatToInt(HoursToSeconds(nDuration)));
            DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    }
        return;
    }
        else
    {
           FloatingTextStrRefOnCreature(83826, OBJECT_SELF);
           return;
    }
}
