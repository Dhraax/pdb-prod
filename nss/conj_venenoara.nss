//::///////////////////////////////////////////////
//:: VENENO DE ARANYA
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Veneno de aranya. Solo disponible para asesinos.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 4 de Abril de 2011
//:://////////////////////////////////////////////

#include "zep_inc_armas"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void VenenoDeAranya(object oTarget, float fDuration)
{
    //IPSafeAddItemProperty(oTarget, ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, IP_CONST_POISON_1D2_STRDAMAGE), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE);
    IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(141,GetTotalCasterLevel(OBJECT_SELF)), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
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

  //Declare major variables
  effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
  object oTarget = GetSpellTargetObject();
  int nDuration = 2 * GetTotalCasterLevel(OBJECT_SELF);

  object oMyWeapon = OBJECT_INVALID;

    /*if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM && GetBaseItemType(oTarget) == BASE_ITEM_GLOVES) {
        oMyWeapon = oTarget;
    }*/

    if(oMyWeapon == OBJECT_INVALID) {
        oMyWeapon = ArmaCuerpoACuerpoObjetivoOEquipada();
        if(oMyWeapon != OBJECT_INVALID) {
            int nItemBase = GetBaseItemType(oMyWeapon);
            object oGloves = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
            if(oGloves != OBJECT_INVALID && GetLevelByClass(CLASS_TYPE_MONK, oTarget) > 0 && (nItemBase == BASE_ITEM_CBLUDGWEAPON || nItemBase == BASE_ITEM_CPIERCWEAPON ||
                nItemBase == BASE_ITEM_CSLASHWEAPON || nItemBase == BASE_ITEM_CSLSHPRCWEAP) ) {
                oMyWeapon = oGloves;
            }
        } else {
            object oGloves = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
            if(oGloves != OBJECT_INVALID && GetLevelByClass(CLASS_TYPE_MONK, oTarget) > 0) {
                oMyWeapon = oGloves;
            }
        }
    }

  if(GetIsObjectValid(oMyWeapon) )
  {
      SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

      if (nDuration>0)
      {
          VenenoDeAranya(oMyWeapon, TurnsToSeconds(nDuration));
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
          DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
      }
  }

  else FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
}
