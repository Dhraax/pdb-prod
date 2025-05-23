//::///////////////////////////////////////////////
//:: Keen Edge
//:: X2_S0_KeenEdge
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Adds the keen property to one melee weapon,
  increasing its critical threat range.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System

#include "zep_inc_armas"
#include "x2_inc_spellhook"
#include "inc_sqlite_time"
#include "pb_nivellanzador"

void  AddKeenEffectToWeapon(object oMyWeapon, float fDuration)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
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
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = 10 * GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    object oMyWeapon = OBJECT_INVALID;
   object oTarget = GetSpellTargetObject();

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
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

//        if ( GetSlashingWeapon2(oMyWeapon)  )
        if (!GetWeaponRanged(oMyWeapon) )
        {
            if (nDuration>0)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
                AddKeenEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration));
                int nTimer = StringToInt(SQLite_GetSystemTime())+ FloatToInt(TurnsToSeconds(nDuration));
                if(nTimer > GetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR"))
                    SetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR", nTimer);
                DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
            }
            return;
        }
        else
        {
          FloatingTextStrRefOnCreature(83621, OBJECT_SELF); // not a slashing weapon
          return;
        }
     }
     else

     {
          FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
          return;
    }



}
