//::///////////////////////////////////////////////
//:: Greater Magic Weapon
//:: X2_S0_GrMagWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 enhancement bonus per 3 caster levels
  (maximum of +5).
  lasts 1 hour per level
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System

#include "zep_inc_armas"
#include "nw_i0_spells"
#include "x2_i0_spells"
#include "mti_libreria"
#include "x2_inc_spellhook"
#include "inc_sqlite_time"
#include "pb_nivellanzador"
#include "pb_constantes"

void  AddGreaterEnhancementEffectToWeapon(object oMyWeapon, float fDuration, int nBonus)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(nBonus), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
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

  // COMPONENTE MATERIAL O FOCO DIVINO
  object oItm = GetSpellCastItem();
  if(GetIsPC(OBJECT_SELF) == TRUE &&
     oItm == OBJECT_INVALID &&
     GetIsDM(OBJECT_SELF) == FALSE &&
     GetIsDMPossessed(OBJECT_SELF) == FALSE)
  {

      int nLastSpellCastClass = GetLastSpellCastClass();
      if(nLastSpellCastClass == CLASS_TYPE_CLERIC  || nLastSpellCastClass == CLASS_TYPE_FAVORED_SOUL ||
         nLastSpellCastClass == CLASS_TYPE_PALADIN || nLastSpellCastClass == CLASS_TYPE_SOLDIER_OF_LIGHT
         || nLastSpellCastClass == CLASS_TYPE_PAL_ANTIGUO || nLastSpellCastClass == CLASS_TYPE_PAL_OSCURO || nLastSpellCastClass == CLASS_TYPE_PAL_VENGADOR)  // Clerigos o paladines...
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
              SendMessageToPC(OBJECT_SELF,"¡Necesitas sujetar con fuerza un foco divino dotado de significado espiritual para lanzar este conjuro!");
              return;
          }


          else AssignCommand(OBJECT_SELF, ActionSpeakString("<c!}þ>*Te concentras unos instantes en tu foco divino para lanzar el conjuro*</c>"));
      }

      else  // Bardos, hechiceros y magos...
      {
          // Si tienes la dote Abstencion de materiales, no necesitas componentes
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes lanzar el conjuro sin necesitar ningún componente.</c>");

          else
          {
              if(GetItemPossessedBy(OBJECT_SELF, "polvobrisa")==OBJECT_INVALID)
              {
                  SendMessageToPC(OBJECT_SELF,"¡Necesitas un poco de extracto de brisa susurrante para lanzar el conjuro!");
                  return;
              }

              else
              {
                  object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"polvobrisa");
                  int iUsosIngrediente = GetLocalInt(oIngrediente, "USOS");

                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oIngrediente, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de extracto de brisa susurrante para lanzar este conjuro.");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oIngrediente);
                      SendMessageToPC(OBJECT_SELF,"Consumes todo el extracto de brisa susurrante para lanzar este conjuro.");
                  }
                  else
                  {
                      SetLocalInt(oIngrediente, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de extracto de brisa susurrante para lanzar este conjuro.");
                  }
              }
          }
      }
  }



    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nCasterLvl = nDuration / 3;
    int nMetaMagic = GetMetaMagicFeat();

    //Limit nCasterLvl to 5, so it max out at +5 enhancement to the weapon.
    if(nCasterLvl > 5)
    {
        nCasterLvl = 5;
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

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    if(GetIsObjectValid(oMyWeapon))
    {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), HoursToSeconds(nDuration));
            AddGreaterEnhancementEffectToWeapon(oMyWeapon, (HoursToSeconds(nDuration)), nCasterLvl);
            int nTimer = StringToInt(SQLite_GetSystemTime()) + FloatToInt(TurnsToSeconds(nDuration));
            if(nTimer > GetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR"))
            SetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR", nTimer);
            DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        }

    }
    else
    {
        // AJUSTE PARA ARCOS Y BALLESTAS
        object oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        if(GetWeaponRanged(oMyWeapon))
        {
        //Fire spell cast at event for target
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        //Apply VFX impact and bonus effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, HoursToSeconds(nDuration));
        AddGreaterEnhancementEffectToWeapon(oMyWeapon, (HoursToSeconds(nDuration)), nCasterLvl);
        int nTimer = StringToInt(SQLite_GetSystemTime()) + FloatToInt(TurnsToSeconds(nDuration));
        if(nTimer > GetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR"))
        SetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR", nTimer);
        }

    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
