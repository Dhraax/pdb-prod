//::///////////////////////////////////////////////
//:: Flame Weapon
//:: X2_S0_FlmeWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Gives a melee weapon 1d4 fire damage +1 per caster
  level to a maximum of +10.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System

#include "mti_libreria"
#include "x2_i0_spells"
#include "zep_inc_armas"
#include "x2_inc_spellhook"
#include "inc_sqlite_time"
#include "pb_nivellanzador"

//ANTIAPILAMIENTO ESPECIAL: ARMA FLAMIGERA Y FUEGO OSCURO NO DEBEN APILARSE
void TienePropiedadesProhibidas(object oPC, object oItem)
{
    itemproperty ipLoop = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipLoop))
    {
        //Propiedades del ARMA FLAMIGERA
        //if(GetItemPropertyTag(ipLoop) == "Arma_Flamigera_CastSpell" || GetItemPropertyTag(ipLoop) == "Arma_Flamigera_Visual"){RemoveItemProperty(oItem,ipLoop);}
        //Propiedades del ARMA MALDITA
        if(GetItemPropertyTag(ipLoop) == "Fuego_Oscuro_CastSpell" || GetItemPropertyTag(ipLoop) == "Fuego_Oscuro_Visual"){RemoveItemProperty(oItem,ipLoop);}
        ipLoop=GetNextItemProperty(oItem);
    }

}

void AddFlamingEffectToWeapon(object oTarget, float fDuration, itemproperty ipCastSpell, itemproperty ipVisual)
{
    IPSafeAddItemProperty(oTarget, ipCastSpell, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE);
    IPSafeAddItemProperty(oTarget, ipVisual, fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
    return;
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
*/

  if(!X2PreSpellCastCode())
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
              SendMessageToPC(OBJECT_SELF,"¡Necesitas sujetar con fuerza un foco divino dotado de significado espiritual para lanzar este conjuro!");
              return;
          }

          else AssignCommand(OBJECT_SELF, ActionSpeakString("<c!}þ>*Te concentras unos instantes en tu foco divino para lanzar el conjuro*</c>"));
      }
      else// Hechieros y magos...
      {
          // Si tienes la dote Abstencion de materiales, no necesitas componentes
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes lanzar el conjuro sin necesitar ningún componente.</c>");
          else
          {
              if(GetItemPossessedBy(OBJECT_SELF, "polvoardor")==OBJECT_INVALID)
              {
                  SendMessageToPC(OBJECT_SELF,"¡Necesitas un poco de pasta de ardor desértico para lanzar el conjuro!");
                  return;
              }
              else
              {
                  object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"polvoardor");
                  int iUsosIngrediente = GetLocalInt(oIngrediente, "USOS");

                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oIngrediente, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de pasta de ardor desértico para lanzar este conjuro.");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oIngrediente);
                      SendMessageToPC(OBJECT_SELF,"Consumes toda la pasta de ardor desértico para lanzar este conjuro.");
                  }
                  else
                  {
                      SetLocalInt(oIngrediente, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de pasta de ardor desértico para lanzar este conjuro.");
                      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
                  }
              }
          }
      }
  }

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nCasterLvl = GetTotalCasterLevel(OBJECT_SELF);
    int nDuration = 2 * nCasterLvl;
    int nMetaMagic = GetMetaMagicFeat();

    //Limit nCasterLvl to 10, so it max out at +10 to the damage.
    if(nCasterLvl > 10)
    {
        nCasterLvl = 10;
    }

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

   object oMyWeapon = OBJECT_INVALID;
   object oTarget = GetSpellTargetObject();

    itemproperty ipCastSpell = ItemPropertyOnHitCastSpell(124,GetTotalCasterLevel(OBJECT_SELF));
    itemproperty ipVisual = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
    ipCastSpell = TagItemProperty(ipCastSpell, "Arma_Flamigera_CastSpell");
    ipVisual = TagItemProperty(ipVisual, "Arma_Flamigera_Visual");

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
          //Arma Flamígera no se acumula con Fuego Oscuro
           TienePropiedadesProhibidas(GetItemPossessor(oMyWeapon), oMyWeapon);
           //Añadimos los efectos y demases.
           AddFlamingEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration), ipCastSpell, ipVisual);
            // haaaack: store caster level on item for the on hit spell to work properly
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
            //Guardamos el nivel de lanzador para aplicar en Golpe Horrible Brujo
              SetLocalInt(oMyWeapon, "ARMAFLAMIGERA", nCasterLvl);
              DelayCommand(TurnsToSeconds(nDuration), DeleteLocalInt(oMyWeapon, "ARMAFLAMIGERA"));

            int nTimer = StringToInt(SQLite_GetSystemTime()) + FloatToInt(TurnsToSeconds(nDuration));
            if(nTimer > GetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR"))
                SetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR", nTimer);
         }
            return;
    }
    else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }
}

