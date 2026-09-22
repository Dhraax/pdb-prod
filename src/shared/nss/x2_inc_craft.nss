//::///////////////////////////////////////////////
//:: x2_inc_craft
//:: Copyright (c) 2003 Bioare Corp.
//:://////////////////////////////////////////////
/*

    Central include for crafting feat and
    crafting skill system.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-09
//:: Last Updated On: 2003-10-14
//:://////////////////////////////////////////////
#include "x2_inc_itemprop"
#include "x2_inc_switches"
#include "inc_sqlite_time"
#include "pb_constantes"

struct craft_struct
{
    int    nRow;
    string sResRef;
    int    nDC;
    int    nCost;
    string sLabel;
};

struct craft_receipe_struct
{
    int nMode;
    object oMajor;
    object oMinor;
};

const string  X2_CI_CRAFTSKILL_CONV ="x2_p_craftskills";

// Scribe Scroll related constants
const int     X2_CI_SCRIBESCROLL_FEAT_ID        = 945;
const int     X2_CI_SCRIBESCROLL_COSTMODIFIER   = 12;                 // Scribescroll Cost Modifier
const string  X2_CI_SCRIBESCROLL_NEWITEM_RESREF = "x2_it_pcscroll";   // ResRef for new scroll item

// Craft Wand related constants
const int     X2_CI_CRAFTWAND_FEAT_ID        = 946;
const int     X2_CI_CRAFTWAND_MAXLEVEL       = 4;
const int     X2_CI_CRAFTWAND_COSTMODIFIER   = 180; //375
const string  X2_CI_CRAFTWAND_NEWITEM_RESREF = "x2_it_pcwand";

// 2da for the craftskills
const string X2_CI_CRAFTING_WP_2DA = "des_crft_weapon" ;
const string X2_CI_CRAFTING_AR_2DA = "des_crft_armor" ;
const string X2_CI_CRAFTING_MAT_2DA = "des_crft_mat";


// 2da for matching spells to properties
const string X2_CI_CRAFTING_SP_2DA = "des_crft_spells" ;
// Base custom token for item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_CRAFTINGSKILL_CTOKENBASE = 13220;

// Base custom token for DC item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_CRAFTINGSKILL_DC_CTOKENBASE = 14220;

// Base custom token for DC item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_CRAFTINGSKILL_GP_CTOKENBASE = 14320;

// Base custom token for DC item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_MODIFYARMOR_GP_CTOKENBASE = 14420;

//How many items per 2da row in X2_IP_CRAFTING_2DA, do not change>4 until you want to create more conversation condition scripts as well
const int     X2_CI_CRAFTING_ITEMS_PER_ROW = 5;

// name of the scroll 2da
const string  X2_CI_2DA_SCROLLS = "mti_crft_scroll";

const int X2_CI_CRAFTMODE_INVALID   = 0;
const int X2_CI_CRAFTMODE_CONTAINER = 1; // no longer used, but left in for the community to reactivate
const int X2_CI_CRAFTMODE_BASE_ITEM  = 2;
const int X2_CI_CRAFTMODE_ASSEMBLE = 3;

const int X2_CI_MAGICTYPE_INVALID = 0;
const int X2_CI_MAGICTYPE_ARCANE  = 1;
const int X2_CI_MAGICTYPE_DIVINE  = 2;

const int X2_CI_MODMODE_INVALID = 0;
const int X2_CI_MODMODE_ARMOR = 1;
const int X2_CI_MODMODE_WEAPON = 2;

// *  Returns TRUE if an item is a Craft Base Item
// *  to be used in spellscript that can be cast on items - i.e light
int   CIGetIsCraftFeatBaseItem( object oItem );

// *  Checks if the last spell cast was used to scribe a scroll and handles the scribe scroll process
// *  Returns TRUE if the spell was indeed used to scribe a scroll (regardless of the actual outcome)
// *  Meant to be used in spellscripts only
int   CICraftCheckScribeScroll(object oSpellTarget, object oCaster);

// *   Create a new scroll item based on the spell nSpellID on the creator
object CICraftScribeScroll(object oCreator, int nSpellID);

// *  Checks if the caster intends to use his item creation feats and
// *  calls appropriate item creation subroutine if conditions are met (spell cast on correct item, etc).
// *  Returns TRUE if the spell was used for an item creation feat
int   CIGetSpellWasUsedForItemCreation(object oSpellTarget);


// *  Returns the innate level of a spell. If bDefaultZeroToOne is given
// *  Level 0 spell will be returned as level 1 spells
int   CIGetSpellInnateLevel(int nSpellID, int bDefaultZeroToOne = FALSE)
{
    int nRet = StringToInt(Get2DAString(X2_CI_CRAFTING_SP_2DA, "Level", nSpellID));
    if (nRet == 0)
        nRet =1;

    return nRet;
}

// * Makes oPC do a Craft check using nSkill to create the item supplied in sResRe
// * If oContainer is specified, the item will be created there.
// * Throwing weapons are created with stack sizes of 10, ammo with 20
// *  oPC       - The player crafting
// *  nSkill    - SKILL_CRAFT_WEAPON or SKILL_CRAFT_ARMOR,
// *  sResRef   - ResRef of the item to be crafted
// *  nDC       - DC to beat to succeed
// *  oContainer - if a container is specified, create item inside
object CIUseCraftItemSkill(object oPC, int nSkill, string sResRef, int nDC, object oContainer = OBJECT_INVALID);

// *  Returns TRUE if a spell is prevented from being used with one of the crafting feats
int   CIGetIsSpellRestrictedFromCraftFeat(int nSpellID, int nFeatID);

// *  Return craftitemstructdata
struct craft_struct CIGetCraftItemStructFrom2DA(string s2DA, int nRow, int nItemNo);

//Sacamos del 2da el nombre del conjuro.
string nombreConjuro(int nSpell)
{
   //Miramos en nombre en el spells.2da
   string sStrRef=Get2DAString("spells", "Name", nSpell);

   //Lo convertimos a entero para la llamada GetStringByStrRef
   int nStrRef=StringToInt(sStrRef);

   //Lo buscamos en el dialog.tlk
   string sNombre=GetStringByStrRef(nStrRef);

   return sNombre;
}

string ObtenerNombre(string sTipoObjeto, int iSpell)
{
    return sTipoObjeto + nombreConjuro(iSpell);
}

void AplicarRestriccionesClaseas(object oObjeto, int iConjuro, int iClasePJ = 500)
{
  IPRemoveMatchingItemProperties(oObjeto, ITEM_PROPERTY_USE_LIMITATION_CLASS, DURATION_TYPE_PERMANENT);

  string sBardo               = Get2DAString("spells", "Bard",     iConjuro);
  string sClerigo             = Get2DAString("spells", "Cleric",   iConjuro);
  string sDruida              = Get2DAString("spells", "Druid",    iConjuro);
  string sPaladin             = Get2DAString("spells", "Paladin",  iConjuro);
  string sExplorador          = Get2DAString("spells", "Ranger",   iConjuro);
  string sMagoHechi           = Get2DAString("spells", "Wiz_Sorc", iConjuro);
  string sPaladinAntiguo      = Get2DAString("spells", "PaladinAntiguos",  iConjuro);
  string sPaladinOscuro       = Get2DAString("spells", "PaladinOscuro",  iConjuro);
  string sPaladinVengador     = Get2DAString("spells", "PaladinVengador",  iConjuro);

  if(sBardo != "")      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_BARD));
  if(sClerigo != "")    IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_CLERIC));
  if(sDruida != "")     IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_DRUID));
  if(sPaladin != "")    IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_PALADIN));
  if(sExplorador != "") IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_RANGER));
  if(sMagoHechi != "")
  {
      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_WIZARD));
      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_SORCERER));
      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_INGENIERO));
  }
  if(sPaladinAntiguo != "") IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_PAL_ANTIGUO));
  if(sPaladinOscuro != "") IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_PAL_OSCURO));
  if(sPaladinVengador != "") IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_PAL_VENGADOR));

  if(iClasePJ != 500)
  {
    IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(iClasePJ));
  }

  if(iConjuro == 165 || iConjuro == 16   || iConjuro == 1106 || iConjuro == 1127 || iConjuro == 1128 ||
     iConjuro == 354 || iConjuro == 13   || iConjuro == 90   || iConjuro == 157  || iConjuro == 365  ||
     iConjuro ==  20 || iConjuro == 1100 || iConjuro == 62   || iConjuro == 15   || iConjuro == 41) IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_HARPER));

  if(iConjuro == 165 || iConjuro == 415  || iConjuro == 1138 || iConjuro == 1139 || iConjuro == 1127 ||
     iConjuro == 356 || iConjuro == 90   || iConjuro == 13   || iConjuro == 36   || iConjuro == 1100 ||
     iConjuro == 105 || iConjuro == 1136 || iConjuro == 1137 || iConjuro == 15   || iConjuro == 998  ||
     iConjuro == 20  || iConjuro == 88   || iConjuro == 62   || iConjuro == 129  || iConjuro == 1129) IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_ASSASSIN));

  if(iConjuro == 54 || iConjuro == 32  || iConjuro == 432 || iConjuro == 174 || iConjuro == 999 ||
     iConjuro == 36 || iConjuro == 34  || iConjuro == 433 || iConjuro == 175 || iConjuro == 9   ||
     iConjuro == 35 || iConjuro == 434 || iConjuro == 176 || iConjuro == 137 || iConjuro == 27  ||
     iConjuro == 31 || iConjuro == 435 || iConjuro == 177 || iConjuro == 62  || iConjuro == 129) IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_BLACKGUARD));
}

// -----------------------------------------------------------------------------
// Return true if oItem is a crafting target item
// -----------------------------------------------------------------------------
int CIGetIsCraftFeatBaseItem(object oItem)
{
    int nBt = GetBaseItemType(oItem);
    // blank scroll, empty potion, wand
    if (nBt == 101 || nBt == 102 || nBt == 103)
      return TRUE;
    else
      return FALSE;
}


// -----------------------------------------------------------------------------
// Wrapper for the crafting cost calculation, returns GP required
// -----------------------------------------------------------------------------
int CIGetCraftGPCost(int nLevel, int nMod)
{
    int nLvlRow =   IPGetIPConstCastSpellFromSpellID(GetSpellId());
    int nCLevel = StringToInt(Get2DAString("iprp_spells","CasterLvl",nLvlRow));

    // -------------------------------------------------------------------------
    // in case we don't get a valid CLevel, use spell level instead
    // -------------------------------------------------------------------------
    if (nCLevel ==0)
    {
        nCLevel = nLevel;
    }
    int nRet = (nCLevel * nLevel * nMod);
    return nRet;

}

int ComprobarIngredientesConjuro(object oCreator, int nClass, int nSpellID, string sObjeto = "inscribir el pergamino")
{
  if(nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_INGENIERO)
  {
      if(nSpellID == SPELL_FLAME_WEAPON || nSpellID == SPELL_FIREBRAND)  // Arma flamigera e Incendiario
      {
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes "+sObjeto+" sin necesitar ningún componente.</c>");
          else
          {
              object oPasta = GetItemPossessedBy(oCreator,"polvoardor");
              if(oPasta == OBJECT_INVALID)
              {
                  SendMessageToPC(oCreator,"<cþ<<>Necesitas una pasta de ardor desértico para "+sObjeto+".</c>");
                  return FALSE;
              }
              else
              {
                  int iUsosIngrediente = GetLocalInt(oPasta, "USOS");
                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oPasta, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de pasta de ardor desértico para "+sObjeto+".");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oPasta);
                      SendMessageToPC(OBJECT_SELF,"Consumes toda la pasta de ardor desértico para "+sObjeto+".");
                  }
                  else
                  {
                      SetLocalInt(oPasta, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de pasta de ardor desértico para "+sObjeto+".");
                  }
              }
          }
      }

      else if(nSpellID == SPELL_GREATER_MAGIC_WEAPON)  // Arma magica mayor
      {
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes "+sObjeto+" sin necesitar ningún componente.</c>");
          else
          {
              object oExtracto = GetItemPossessedBy(oCreator,"polvobrisa");
              if(oExtracto == OBJECT_INVALID)
              {
                  SendMessageToPC(oCreator,"<cþ<<>Necesitas extracto de brisa susurrante para "+sObjeto+".</c>");
                  return FALSE;
              }
              else
              {
                  int iUsosIngrediente = GetLocalInt(oExtracto, "USOS");
                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oExtracto, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de extracto de brisa susurrante para "+sObjeto+".");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oExtracto);
                      SendMessageToPC(OBJECT_SELF,"Consumes todo el extracto de brisa susurrante para "+sObjeto+".");
                  }
                  else
                  {
                      SetLocalInt(oExtracto, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de extracto de brisa susurrante para "+sObjeto+".");
                  }
              }
          }
      }

      else if(nSpellID == SPELL_WAIL_OF_THE_BANSHEE)  // Lamento de la banshee
      {
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes "+sObjeto+" sin necesitar ningún componente.</c>");
          else
          {
              object oSeta = GetItemPossessedBy(oCreator,"polvoseta");
              if(oSeta == OBJECT_INVALID)
              {
                  SendMessageToPC(oCreator,"<cþ<<>Necesitas un pellizco de polvo de seta nocturna para crear "+sObjeto+".</c>");
                  return FALSE;
              }
              else
              {
                  int iUsosIngrediente = GetLocalInt(oSeta, "USOS");
                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oSeta, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de polvo de seta nocturna para crear "+sObjeto+".");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oSeta);
                      SendMessageToPC(OBJECT_SELF,"Consumes todo el polvo de seta nocturna para crear "+sObjeto+".");
                  }
                  else
                  {
                      SetLocalInt(oSeta, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de polvo de seta nocturna para crear "+sObjeto+".");
                  }
              }
          }
      }

      else if(nSpellID == SPELL_BIGBYS_CLENCHED_FIST ||
              nSpellID == SPELL_BIGBYS_CRUSHING_HAND ||
              nSpellID == SPELL_BIGBYS_FORCEFUL_HAND ||
              nSpellID == SPELL_BIGBYS_GRASPING_HAND)  // Manos de Bigby
      {
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes "+sObjeto+" sin necesitar ningún componente.</c>");
          else
          {
              object oGuante = GetItemPossessedBy(oCreator,"guantearcano");
              if(oGuante == OBJECT_INVALID)
              {
                  SendMessageToPC(oCreator,"<cþ<<>Necesitas un guante arcano para "+sObjeto+".</c>");
                  return FALSE;
              }
              else
              {
                  int iUsosIngrediente = GetLocalInt(oGuante, "USOS");
                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oGuante, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Utilizas parte de un guante arcano para "+sObjeto+".");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oGuante);
                      SendMessageToPC(OBJECT_SELF,"Consumes todo un guante arcano para "+sObjeto+".");
                  }
                  else
                  {
                      SetLocalInt(oGuante, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Utilizas parte de un guante arcano para "+sObjeto+".");
                  }
              }
          }
      }

      else if(nSpellID == SPELL_ISAACS_GREATER_MISSILE_STORM)  // Tromba mayor
      {
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes "+sObjeto+" sin necesitar ningún componente.</c>");
          else
          {
              object oExtracto = GetItemPossessedBy(oCreator,"cnr_p_po_diam");
              if(oExtracto == OBJECT_INVALID) oExtracto = GetItemPossessedBy(oCreator,"polvo_dia");
              if(oExtracto == OBJECT_INVALID)
              {
                  SendMessageToPC(oCreator,"<cþ<<>Necesitas arenilla de diamante para "+sObjeto+".</c>");
                  return FALSE;
              }
              else
              {
                  int iUsosIngrediente = GetLocalInt(oExtracto, "USOS");
                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oExtracto, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de arenilla de diamante para "+sObjeto+".");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oExtracto);
                      SendMessageToPC(OBJECT_SELF,"Consumes todo la arenilla de diamante para "+sObjeto+".");
                  }
                  else
                  {
                      SetLocalInt(oExtracto, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de arenilla de diamante para "+sObjeto+".");
                  }
              }
          }
      }

      else if(nSpellID == SPELL_TIME_STOP)  // Detener el tiempo
      {
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes "+sObjeto+" sin necesitar ningún componente.</c>");
          else
          {
              object oExtracto = GetItemPossessedBy(oCreator,"reloj_ins");
              if(oExtracto == OBJECT_INVALID)
              {
                  SendMessageToPC(oCreator,"<cþ<<>Necesitas un reloj inservible para "+sObjeto+".</c>");
                  return FALSE;
              }
              else
              {
                  int iUsosIngrediente = GetLocalInt(oExtracto, "USOS");
                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oExtracto, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Haces uso del reloj inservible para "+sObjeto+".");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oExtracto);
                      SendMessageToPC(OBJECT_SELF,"El reloj inservible vuelve a funcionar y decides tirarlo.");
                  }
                  else
                  {
                      SetLocalInt(oExtracto, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Haces uso del reloj inservible para "+sObjeto+".");
                  }
              }
          }
      }
  }

  return TRUE;
}

// -----------------------------------------------------------------------------
// Georg, 2003-06-12
// Create a new playermade wand object with properties matching nSpellID
// and return it
// -----------------------------------------------------------------------------
object CICraftCraftWand(object oCreator, int nSpellID )
{
  int nPropID = IPGetIPConstCastSpellFromSpellID(nSpellID);
  int iTiempo = 8320;

  object oTarget;
  // * GZ 2003-09-11: If the current spell cast is not acid fog, and
  // *                returned property ID is 0, bail out to prevent
  // *                creation of acid fog items.
  if (nPropID == 0 && nSpellID != 0)
  {
      FloatingTextStrRefOnCreature(84544,oCreator);
      return OBJECT_INVALID;
  }

  // 5% de fallo permanente
  if(d20() == 1) return OBJECT_INVALID;

  // No spam de varitas (20 minutos por cada nivel de esfera de espera) 10 min ahora
  int iVariableSpam = GetLocalInt(GetModule(), "NOSPAM_VARITAS" + GetName(oCreator));
  if(iVariableSpam > SQLite_GetTimeStamp())
  {
      SendMessageToPC(oCreator,"<c´þd>No puedes crear varitas de nuevo tan rápido, debes esperar "+IntToString(iVariableSpam - SQLite_GetTimeStamp())+" segundos.</c>");
      return OBJECT_INVALID;
  }

  int nClass = GetLastSpellCastClass();
  if(ComprobarIngredientesConjuro(oCreator, nClass, nSpellID, "fabricar la varita") == FALSE) return OBJECT_INVALID;

  if(nPropID != -1)
  {
      oTarget = CreateItemOnObject(X2_CI_CRAFTWAND_NEWITEM_RESREF,oCreator);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(nPropID,IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE), oTarget);
      SetItemCharges(oTarget, 15);
      /*int iNumCargas = Random (17);
      while (iNumCargas < 12)
      {
        iNumCargas = Random(17);
      }
      SetItemCharges(oTarget, iNumCargas);   */
      SetStolenFlag(oTarget, TRUE);
      SetName(oTarget, ObtenerNombre("Varita de ", nSpellID));
      SetLocalInt(oTarget, "VAR_CRAFT", TRUE);
      AplicarRestriccionesClaseas(oTarget, nSpellID, GetLastSpellCastClass());
      if(GetLevelByClass(57, oCreator) > 0 )
      {
        SetLocalInt(GetModule(), "NOMASVARITAS" + GetName(oCreator), SQLite_GetTimeStamp() + iTiempo);
        //SetPlotFlag(oTarget,TRUE);
        //SetDroppableFlag(oTarget, FALSE);
        //SetItemCursedFlag(oTarget, TRUE);
        //SetLocalInt(oTarget, "DESTROYWAND", 1);
        SetLocalString(oTarget, "WAR_CREADOR", GetName(oCreator, TRUE));
      }
  }

  return oTarget;
}

// -----------------------------------------------------------------------------
// Georg, 2003-06-12
// Create and Return a magic wand with an item property
// matching nSpellID. Charges are set to 50
// -----------------------------------------------------------------------------
object CICraftScribeScroll(object oCreator, int nSpellID)
{
    int nPropID = IPGetIPConstCastSpellFromSpellID(nSpellID);
    object oTarget;

    // No spam de pergas (1 hora por cada nivel de esfera escrita de espera)
    int iVariableSpam = GetLocalInt(GetModule(), "NOSPAM_PERGAS" + GetName(oCreator));
    if(iVariableSpam > SQLite_GetTimeStamp())
    {
        SendMessageToPC(oCreator,"<c´þd>No puedes escribir pergaminos de nuevo tan rápido, debes esperar "+IntToString(iVariableSpam - SQLite_GetTimeStamp())+" segundos.</c>");
        return oTarget;
    }

    int nClass = GetLastSpellCastClass();
    if(ComprobarIngredientesConjuro(oCreator, nClass, nSpellID) == FALSE) return oTarget;

    if(nClass != CLASS_TYPE_INVALID)
    {
        string sResRef = Get2DAString(X2_CI_2DA_SCROLLS, "ResRef", nSpellID);
        if(sResRef != "")
        {
            oTarget = CreateItemOnObject(sResRef,oCreator);
            SetStolenFlag(oTarget, TRUE);
        }

        if(oTarget == OBJECT_INVALID)
        {
            WriteTimestampedLogEntry("[FALLO EN INSCRIBIR PERGAMINOS] Referencia: " + sResRef + ", Clase: " +IntToString(nClass) +", ID del Conjuro: " + IntToString (nSpellID));
            return oTarget;
        }

        AplicarRestriccionesClaseas(oTarget, nSpellID, nClass);
    }
    SetLocalInt(oTarget, "PER_CRAFT", TRUE);
    return oTarget;
}

// -----------------------------------------------------------------------------
// Returns TRUE if the player used the last spell to create a scroll
// -----------------------------------------------------------------------------
int CICraftCheckScribeScroll(object oSpellTarget, object oCaster)
{
    int  nID = GetSpellId();

    // -------------------------------------------------------------------------
    // check if scribe scroll feat is there
    // -------------------------------------------------------------------------
    if (GetHasFeat(X2_CI_SCRIBESCROLL_FEAT_ID, oCaster) != TRUE)
    {
      FloatingTextStrRefOnCreature(40487, oCaster); // Item Creation Failed - Don't know how to create that type of item
      return TRUE;
    }

    // -------------------------------------------------------------------------
    // Check if the spell is allowed to be used with Scribe Scroll
    // -------------------------------------------------------------------------
    if (CIGetIsSpellRestrictedFromCraftFeat(nID, X2_CI_SCRIBESCROLL_FEAT_ID))
    {
        FloatingTextStrRefOnCreature(83451, oCaster); // can not be used with this feat
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // Does Player have enough gold?
    // -------------------------------------------------------------------------
    int iNivelInnatoConjuro = CIGetSpellInnateLevel(nID,TRUE);
    int nCost = CIGetCraftGPCost(iNivelInnatoConjuro, X2_CI_SCRIBESCROLL_COSTMODIFIER);
    int nGoldCost = nCost ;

    if (GetGold(oCaster) < nGoldCost)  //  enough gold?
    {
        FloatingTextStrRefOnCreature(3786, oCaster); // Item Creation Failed - not enough gold!
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // check for sufficient XP to cast spell
    // -------------------------------------------------------------------------
    int iCosteXP = iNivelInnatoConjuro * 15; //30;
    if(iCosteXP == 0) iCosteXP = 15; //30;
    int nNewXP = GetXP(oCaster) - iCosteXP;

    int nHD = GetHitDice(oCaster);
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;

    if (nMinXPForLevel > nNewXP || nNewXP == 0 )
    {
         FloatingTextStrRefOnCreature(3785, oCaster); // Item Creation Failed - Not enough XP
         return TRUE;
    }

    // -------------------------------------------------------------------------
    // Verify Results
    // -------------------------------------------------------------------------
    object oScroll = CICraftScribeScroll(oCaster, nID);
    if (GetIsObjectValid(oScroll))
    {
        //----------------------------------------------------------------------
        // Some scrollsare ar not identified ... fix that here
        //----------------------------------------------------------------------
        SetIdentified(oScroll,TRUE);
        ActionPlayAnimation (ANIMATION_FIREFORGET_READ,1.0);
        TakeGoldFromCreature(nGoldCost, oCaster, TRUE);
        SetXP(oCaster, nNewXP);
        DestroyObject (oSpellTarget);
        FloatingTextStrRefOnCreature(8502, oCaster); // Item Creation successful
        SetLocalInt(GetModule(), "NOSPAM_PERGAS" + GetName(oCaster), SQLite_GetTimeStamp() + (180 * iNivelInnatoConjuro)); //360
        return TRUE;
     }
     else
     {
        //TakeGoldFromCreature(nGoldCost, oCaster, TRUE);
        FloatingTextStrRefOnCreature(76417, oCaster); // Item Creation Failed
        return TRUE;
     }

    return FALSE;
}


// -----------------------------------------------------------------------------
// Returns TRUE if the player used the last spell to craft a wand
// -----------------------------------------------------------------------------
int CICraftCheckCraftWand(object oSpellTarget, object oCaster)
{
    int nID = GetSpellId();

    // -------------------------------------------------------------------------
    // check if craft wand feat is there
    // -------------------------------------------------------------------------
    if (GetHasFeat(X2_CI_CRAFTWAND_FEAT_ID, oCaster) != TRUE)
    {
      FloatingTextStrRefOnCreature(40487, oCaster); // Item Creation Failed - Don't know how to create that type of item
      return TRUE; // tried item creation but do not know how to do it
    }

    // -------------------------------------------------------------------------
    // Check if the spell is allowed to be used with Craft Wand
    // -------------------------------------------------------------------------
    if (CIGetIsSpellRestrictedFromCraftFeat(nID, X2_CI_CRAFTWAND_FEAT_ID))
    {
        FloatingTextStrRefOnCreature(83452, oCaster); // can not be used with this feat
        return TRUE;
    }

    int iNivelInnatoConjuro = CIGetSpellInnateLevel(nID,TRUE);

    // -------------------------------------------------------------------------
    // check if spell is below maxlevel for wands
    // -------------------------------------------------------------------------
    if (iNivelInnatoConjuro > X2_CI_CRAFTWAND_MAXLEVEL)
    {
        FloatingTextStrRefOnCreature(83623, oCaster);
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // GP Cost Calculation. Does Player have enough gold?
    // -------------------------------------------------------------------------
    int nGoldCost = CIGetCraftGPCost(iNivelInnatoConjuro, X2_CI_CRAFTWAND_COSTMODIFIER);
    if (GetGold(oCaster) < nGoldCost)  //  enough gold?
    {
        FloatingTextStrRefOnCreature(3786, oCaster); // Item Creation Failed - not enough gold!
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // XP Cost Calculation. Check for sufficient XP to cast spell
    // -------------------------------------------------------------------------
    int iCosteXP = iNivelInnatoConjuro * 25; //50
    if(iCosteXP == 0) iCosteXP = 25; //50
    int iTiempo = 600; //1200;

    if(nID == SPELL_BLESS_WEAPON || nID == SPELL_DEAFENING_CLANG || nID == SPELL_TRUE_STRIKE || nID == SPELL_MAGIC_WEAPON || nID == 999) { iCosteXP = 150; iTiempo = 2000; } //iCosteXP = 300
    else if(nID == SPELL_FLAME_WEAPON) { iCosteXP = 200; iTiempo = 2000; }  //iCosteXP = 400
    else if(nID == SPELL_KEEN_EDGE || /*nID == SPELL_GREATER_MAGIC_WEAPON ||*/ nID == SPELL_DARKFIRE || nID == SPELL_BLADE_THIRST || nID == 998) { iCosteXP = 250; iTiempo = 2000; }  //iCosteXP = 500
    else if(nID == 994 || nID == 1129 || nID == 1024 || nID == SPELL_HOLY_SWORD) { iCosteXP = 400; iTiempo = 2000; }  //iCosteXP =600

    int nNewXP = GetXP(oCaster) - iCosteXP;
    int nHD = GetHitDice(oCaster);
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;

    if(nMinXPForLevel > nNewXP || nNewXP == 0 )
    {
        FloatingTextStrRefOnCreature(3785, oCaster); // Item Creation Failed - Not enough XP
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // Here we craft the wand. Verify Results
    // -------------------------------------------------------------------------
    object oWand = CICraftCraftWand(oCaster, nID);
    if(GetIsObjectValid(oWand))
    {
        TakeGoldFromCreature(nGoldCost, oCaster, TRUE);
        SetXP(oCaster, nNewXP);
        DestroyObject(oSpellTarget);
        FloatingTextStrRefOnCreature(8502, oCaster); // Item Creation successful
        iTiempo = iTiempo * iNivelInnatoConjuro;
        if(iTiempo == 0) iTiempo=600;//iTiempo = 1200;
        SetLocalInt(GetModule(), "NOSPAM_VARITAS" + GetName(oCaster), SQLite_GetTimeStamp() + iTiempo);
        return TRUE;
    }
    else
    {
        FloatingTextStrRefOnCreature(76417, oCaster); // Item Creation Failed
        return TRUE;
    }

    return FALSE;
}

// -----------------------------------------------------------------------------
// Georg, July 2003
// Checks if the caster intends to use his item creation feats and
// calls appropriate item creation subroutine if conditions are met
// (spell cast on correct item, etc).
// Returns TRUE if the spell was used for an item creation feat
// -----------------------------------------------------------------------------
int CIGetSpellWasUsedForItemCreation(object oSpellTarget)
{
    object oCaster = OBJECT_SELF;

    // -------------------------------------------------------------------------
    // Spell cast on crafting base item (blank scroll, etc) ?
    // -------------------------------------------------------------------------
    if (!CIGetIsCraftFeatBaseItem(oSpellTarget))
    {
       return FALSE; // not blank scroll baseitem
    }
    else
    {
        // ---------------------------------------------------------------------
        // Check Item Creation Feats were disabled through x2_inc_switches
        // ---------------------------------------------------------------------
        if (GetModuleSwitchValue(MODULE_SWITCH_DISABLE_ITEM_CREATION_FEATS) == TRUE)
        {
            FloatingTextStrRefOnCreature(83612, oCaster); // item creation disabled
            return FALSE;
        }

        // ---------------------------------------------------------------------
        // Ensure that item creation does not work one item was cast on another
        // ---------------------------------------------------------------------
        if (GetSpellCastItem() != OBJECT_INVALID)
        {
            FloatingTextStrRefOnCreature(83373, oCaster); // can not use one item to enchant another
            return TRUE;
        }

        // ---------------------------------------------------------------------
        // Ok, what kind of feat the user wants to use by examining the base itm
        // ---------------------------------------------------------------------
        int nBt = GetBaseItemType(oSpellTarget);
        int nRet = FALSE;
        switch (nBt)
        {
                case 102 :
                            // -------------------------------------------------
                            // Scribe Scroll
                            // -------------------------------------------------
                           nRet = CICraftCheckScribeScroll(oSpellTarget,oCaster);
                           break;


                case 103 :
                            // -------------------------------------------------
                            // Craft Wand
                            // -------------------------------------------------
                           nRet = CICraftCheckCraftWand(oSpellTarget,oCaster);
                           break;

                // you could add more crafting basetypes here....
        }

        return nRet;

    }

}

// -----------------------------------------------------------------------------
// Makes oPC do a Craft check using nSkill to create the item supplied in sResRe
// If oContainer is specified, the item will be created there.
// Throwing weapons are created with stack sizes of 10, ammo with 20
// -----------------------------------------------------------------------------
object CIUseCraftItemSkill(object oPC, int nSkill, string sResRef, int nDC, object oContainer = OBJECT_INVALID)
{
    int bSuccess = GetIsSkillSuccessful(oPC, nSkill, nDC);
    object oNew;
    if (bSuccess)
    {
        // actual item creation
        // if a crafting container was specified, create inside
        int bFix;
        if (oContainer == OBJECT_INVALID)
        {
            //------------------------------------------------------------------
            // We create the item in the work container to get rid of the
            // stackable item problems that happen when we create the item
            // directly on the player
            //------------------------------------------------------------------
            oNew =CreateItemOnObject(sResRef,IPGetIPWorkContainer(oPC));
            bFix = TRUE;
        }
        else
        {
            oNew =CreateItemOnObject(sResRef,oContainer);
        }

        int nBase = GetBaseItemType(oNew);
        if (nBase ==  BASE_ITEM_BOLT || nBase ==  BASE_ITEM_ARROW || nBase ==  BASE_ITEM_BULLET)
        {
            SetItemStackSize(oNew, 297);
        }
        else if (nBase ==  BASE_ITEM_THROWINGAXE || nBase ==  BASE_ITEM_SHURIKEN || nBase ==  BASE_ITEM_DART)
        {
            SetItemStackSize(oNew, 198);
        }

        //----------------------------------------------------------------------
        // Get around the whole stackable item mess...
        //----------------------------------------------------------------------
        if (bFix)
        {
            object oRet = CopyObject(oNew,GetLocation(oPC),oPC);
            DestroyObject(oNew);
            oNew = oRet;
        }


    }
    else
    {
        oNew = OBJECT_INVALID;
    }

    return oNew;
}


// -----------------------------------------------------------------------------
// georg, 2003-06-13 (
// Craft an item. This is only to be called from the crafting conversation
// spawned by x2_s2_crafting!!!
// -----------------------------------------------------------------------------
int CIDoCraftItemFromConversation(int nNumber)
{
  string    sNumber     = IntToString(nNumber);
  object    oPC         = GetPCSpeaker();
  //object    oMaterial   = GetLocalObject(oPC,"X2_CI_CRAFT_MATERIAL");
  object    oMajor       = GetLocalObject(oPC,"X2_CI_CRAFT_MAJOR");
  object    oMinor       = GetLocalObject(oPC,"X2_CI_CRAFT_MINOR");
  int       nSkill      =  GetLocalInt(oPC,"X2_CI_CRAFT_SKILL");
  int       nMode       =  GetLocalInt(oPC,"X2_CI_CRAFT_MODE");
  string    sResult;
  string    s2DA;
  int       nDC;


    DeleteLocalObject(oPC,"X2_CI_CRAFT_MAJOR");
    DeleteLocalObject(oPC,"X2_CI_CRAFT_MINOR");

    if (!GetIsObjectValid(oMajor))
    {
          FloatingTextStrRefOnCreature(83374,oPC);    //"Invalid target"
          DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
          return FALSE;
    }
    else
    {
          if (GetItemPossessor(oMajor) != oPC)
          {
               FloatingTextStrRefOnCreature(83354,oPC);     //"Invalid target"
               DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
               return FALSE;
          }
    }

    // If we are in container mode,
    if (nMode == X2_CI_CRAFTMODE_CONTAINER)
    {
        if (!GetIsObjectValid(oMinor))
        {
              FloatingTextStrRefOnCreature(83374,oPC);    //"Invalid target"
              DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
              return FALSE;
        }
        else if (GetItemPossessor(oMinor) != oPC)
         {
              FloatingTextStrRefOnCreature(83354,oPC);   //"Invalid target"
              DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
              return FALSE;
         }
   }


  if (nSkill == 26) // craft weapon
  {
        s2DA = X2_CI_CRAFTING_WP_2DA;
  }
  else if (nSkill == 25)
  {
        s2DA = X2_CI_CRAFTING_AR_2DA;
  }

  int nRow = GetLocalInt(oPC,"X2_CI_CRAFT_RESULTROW");
  struct craft_struct stItem =  CIGetCraftItemStructFrom2DA(s2DA,nRow,nNumber);
  object oContainer = OBJECT_INVALID;

  // ---------------------------------------------------------------------------
  // We once used a crafting container, but found it too complicated. Code is still
  // left in here for the community
  // ---------------------------------------------------------------------------
  if (nMode == X2_CI_CRAFTMODE_CONTAINER)
  {
        oContainer = GetItemPossessedBy(oPC,"x2_it_craftcont");
  }

  // Do the crafting...
  object oRet = CIUseCraftItemSkill( oPC, nSkill, stItem.sResRef, stItem.nDC, oContainer) ;

  // * If you made an item, it should always be identified;
  SetIdentified(oRet,TRUE);

  if (GetIsObjectValid(oRet))
  {
      // -----------------------------------------------------------------------
      // Copy all item properties from the major object on the resulting item
      // Through we problably won't use this, its a neat thing to have for the
      // community
      // to enable magic item creation from the crafting system
      // -----------------------------------------------------------------------
       if (GetGold(oPC)<stItem.nCost)
       {
          DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
          FloatingTextStrRefOnCreature(86675,oPC);
          DestroyObject(oRet);
          return FALSE;
       }
       else
       {
          TakeGoldFromCreature(stItem.nCost, oPC,TRUE);
          IPCopyItemProperties(oMajor,oRet);
        }
      // set success variable for conversation
      SetLocalInt(oPC,"X2_CRAFT_SUCCESS",TRUE);
  }
  else
  {
      TakeGoldFromCreature(stItem.nCost / 4, oPC,TRUE);
      // make sure there is no success
      DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
  }

  // Destroy first material component
  DestroyObject (oMajor);

  // if we are running in a container, destroy the second material component as well
  if (nMode == X2_CI_CRAFTMODE_CONTAINER || nMode == X2_CI_CRAFTMODE_ASSEMBLE)
  {
      DestroyObject (oMinor);
  }
  int nRet = (oRet != OBJECT_INVALID);
  return nRet;
}

// -----------------------------------------------------------------------------
// Retrieve craft information on a certain item
// -----------------------------------------------------------------------------
struct craft_struct CIGetCraftItemStructFrom2DA(string s2DA, int nRow, int nItemNo)
{
   struct craft_struct stRet;
   string sNumber = IntToString(nItemNo);

   stRet.nRow    =  nRow;
   string sLabel = Get2DAString(s2DA,"Label"+ sNumber, nRow);
   if (sLabel == "")
   {
      return stRet;  // empty, no need to read further
   }
   int nStrRef = StringToInt(sLabel);
   if (nStrRef != 0)  // Handle bioware StrRefs
   {
      sLabel = GetStringByStrRef(nStrRef);
   }
   stRet.sLabel  = sLabel;
   stRet.nDC     =  StringToInt(Get2DAString(s2DA,"DC"+ sNumber, nRow));
   stRet.nCost   =  StringToInt(Get2DAString(s2DA,"CostGP"+ sNumber, nRow));
   stRet.sResRef =  Get2DAString(s2DA,"ResRef"+ sNumber, nRow);

   return stRet;
}

// -----------------------------------------------------------------------------
// Return the cost
// -----------------------------------------------------------------------------
int CIGetItemPartModificationCost(object oOldItem, int nPart)
{
    int nRet = StringToInt(Get2DAString(X2_IP_ARMORPARTS_2DA,"CraftCost",nPart));
    nRet = (GetGoldPieceValue(oOldItem) / 100 * nRet);

    // minimum cost for modification is 1 gp
    if (nRet == 0)
    {
        nRet =1;
    }
    return nRet;
}

// -----------------------------------------------------------------------------
// Return the DC for modifying a certain armor part on oOldItem
// -----------------------------------------------------------------------------
int CIGetItemPartModificationDC(object oOldItem, int nPart)
{
    int nRet = StringToInt(Get2DAString(X2_IP_ARMORPARTS_2DA,"CraftDC",nPart));
    // minimum cost for modification is 1 gp
    return nRet;
}

// -----------------------------------------------------------------------------
// returns the dc
// dc to modify oOlditem to look like oNewItem
// -----------------------------------------------------------------------------
int CIGetArmorModificationCost(object oOldItem, object oNewItem)
{
   int nTotal = 0;
   int nPart;
   for (nPart = 0; nPart<ITEM_APPR_ARMOR_NUM_MODELS; nPart++)
   {

        if (GetItemAppearance(oOldItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart) !=GetItemAppearance(oNewItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart))
        {
            nTotal+= CIGetItemPartModificationCost(oOldItem,nPart);
        }
   }

   // Modification Cost should not exceed value of old item +1 GP
   if (nTotal > GetGoldPieceValue(oOldItem))
   {
        nTotal = GetGoldPieceValue(oOldItem)+1;
   }
   return nTotal;
}

// -----------------------------------------------------------------------------
// returns the cost in gold piece that it would
// cost to modify oOlditem to look like oNewItem
// -----------------------------------------------------------------------------
int CIGetArmorModificationDC(object oOldItem, object oNewItem)
{
   int nTotal = 0;
   int nPart;
   int nDC =0;
   for (nPart = 0; nPart<ITEM_APPR_ARMOR_NUM_MODELS; nPart++)
   {

        if (GetItemAppearance(oOldItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart) !=GetItemAppearance(oNewItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart))
        {
            nDC = CIGetItemPartModificationDC(oOldItem,nPart);
            if (nDC>nTotal)
            {
                nTotal = nDC;
            }
        }
   }

   nTotal = GetItemACValue(oOldItem) + nTotal + 5;

   return nTotal;
}

// -----------------------------------------------------------------------------
// returns TRUE if the spell matching nSpellID is prevented from being used
// with the CraftFeat matching nFeatID
// This is controlled in des_crft_spells.2da
// -----------------------------------------------------------------------------
int CIGetIsSpellRestrictedFromCraftFeat(int nSpellID, int nFeatID)
{
    string sCol;
    if (nFeatID == X2_CI_SCRIBESCROLL_FEAT_ID)
    {
        sCol = "NoScroll";
    }
    else if (nFeatID == X2_CI_CRAFTWAND_FEAT_ID)
    {
         sCol = "NoWand";
    }

    string sRet = Get2DAString(X2_CI_CRAFTING_SP_2DA,sCol,nSpellID);
    int nRet = (sRet == "1") ;

    return nRet;
}

// -----------------------------------------------------------------------------
// Retrieve the row in des_crft_bmat too look up receipe
// -----------------------------------------------------------------------------
int CIGetCraftingReceipeRow(int nMode, object oMajor, object oMinor, int nSkill)
{
    if (nMode == X2_CI_CRAFTMODE_CONTAINER || nMode == X2_CI_CRAFTMODE_ASSEMBLE )
    {
        int nMinorId = StringToInt(Get2DAString("des_crft_amat",GetTag(oMinor),1));
        int nMajorId = StringToInt(Get2DAString("des_crft_bmat",GetTag(oMajor),nMinorId));
        return nMajorId;
    }
    else if (nMode == X2_CI_CRAFTMODE_BASE_ITEM)
    {
       int nLookUpRow;
       string sTag = GetTag(oMajor);
       switch (nSkill)
       {
            case 26: nLookUpRow =1 ; break;
            case 25: nLookUpRow= 2 ; break;
       }
       int nRet = StringToInt(Get2DAString(X2_CI_CRAFTING_MAT_2DA,sTag,nLookUpRow));
       return nRet;
    }
    else
    {
        return 0; // error
    }
}

// -----------------------------------------------------------------------------
// used to set all variable required for the crafting conversation
// (Used materials, number of choises, 2da row, skill and mode)
// -----------------------------------------------------------------------------
void CISetupCraftingConversation(object oPC, int nNumber, int nSkill, int nReceipe, object oMajor, object oMinor, int nMode)
{

  SetLocalObject(oPC,"X2_CI_CRAFT_MAJOR",oMajor);
  if (nMode == X2_CI_CRAFTMODE_CONTAINER ||  nMode == X2_CI_CRAFTMODE_ASSEMBLE )
  {
      SetLocalObject(oPC,"X2_CI_CRAFT_MINOR", oMinor);
  }
  SetLocalInt(oPC,"X2_CI_CRAFT_NOOFITEMS",nNumber);    // number of crafting choises for this material
  SetLocalInt(oPC,"X2_CI_CRAFT_SKILL",nSkill);          // skill used (craft armor or craft waeapon)
  SetLocalInt(oPC,"X2_CI_CRAFT_RESULTROW",nReceipe);    // number of crafting choises for this material
  SetLocalInt(oPC,"X2_CI_CRAFT_MODE",nMode);
}

// -----------------------------------------------------------------------------
// oItem - The item used for crafting
// -----------------------------------------------------------------------------
struct craft_receipe_struct CIGetCraftingModeFromTarget(object oPC,object oTarget, object oItem = OBJECT_INVALID)
{
  struct craft_receipe_struct stStruct;


  if (GetBaseItemType(oItem) == 112 ) // small
  {
       stStruct.oMajor = oItem;
       stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
       return stStruct;
  }

  if (!GetIsObjectValid(oTarget))
  {
     stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
     return stStruct;
  }


  // A small craftitem was used on a large one
  if (GetBaseItemType(oItem) == 110 ) // small
  {
        if (GetBaseItemType(oTarget) == 109)  // large
        {
            stStruct.nMode = X2_CI_CRAFTMODE_ASSEMBLE; // Mode is ASSEMBLE
            stStruct.oMajor = oTarget;
            stStruct.oMinor = oItem;
            return stStruct;
        }
        else
        {
            FloatingTextStrRefOnCreature(84201,oPC);
        }

  }

  // -----------------------------------------------------------------------------
  // *** CONTAINER IS NO LONGER USED IN OFFICIAL CAMPAIGN
  //     BUT CODE LEFT IN FOR COMMUNITY.
  //     THE FOLLOWING CONDITION IS NEVER TRUE FOR THE OC (no crafting container)
  //     To reactivate, create a container with tag x2_it_craftcont
  int bCraftCont = (GetTag(oTarget) == "x2_it_craftcont");


  if (bCraftCont == TRUE)
  {
    // First item in container is baseitem  .. mode = baseitem
    if ( GetBaseItemType(GetFirstItemInInventory(oTarget)) == 112)
    {
        stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
        stStruct.oMajor = GetFirstItemInInventory(oTarget);
        return stStruct;
    }
    else
    {
        object oTest = GetFirstItemInInventory(oTarget);
        int nCount =1;
        int bMajor = FALSE;
        int bMinor = FALSE;
        // No item in inventory ... mode = fail
        if (!GetIsObjectValid(oTest))
        {
            FloatingTextStrRefOnCreature(84200,oPC);
            stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
            return stStruct;
        }
        else
        {
            while (GetIsObjectValid(oTest) && nCount <3)
            {
                if (GetBaseItemType(oTest) == 109)
                {
                    stStruct.oMajor = oTest;
                    bMajor = TRUE;
                }
                else if (GetBaseItemType(oTest) == 110)
                {
                    stStruct.oMinor = oTest;
                    bMinor = TRUE;
                }
                else if ( GetBaseItemType(oTest) == 112)
                {
                    stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
                    stStruct.oMajor = oTest;
                    return stStruct;
                }
                oTest = GetNextItemInInventory(oTarget);
                if (GetIsObjectValid(oTest))
                {
                    nCount ++;
                }
            }

            if (nCount >2)
            {
                FloatingTextStrRefOnCreature(84356,oPC);
                stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
                return stStruct;
            }
            else if (nCount <2)
            {
                FloatingTextStrRefOnCreature(84356,oPC);
                stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
                return stStruct;
            }

            if (bMajor && bMinor)
            {
                stStruct.nMode =  X2_CI_CRAFTMODE_CONTAINER;
                return stStruct;
            }
            else
            {
                FloatingTextStrRefOnCreature(84356,oPC);
                //FloatingTextStringOnCreature("Temp: Wrong combination of items in the crafting container",oPC);
                stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
                return stStruct;
            }

        }
    }
  }
  else
  {
    // not a container but a baseitem
    if (GetBaseItemType(oTarget) == 112)
    {
       stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
       stStruct.oMajor = oTarget;
       return stStruct;

    }
    else
    {
          if (GetBaseItemType(oTarget) == 109 || GetBaseItemType(oTarget) == 110)
          {
              FloatingTextStrRefOnCreature(84357,oPC);
              stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
              return stStruct;
          }
          else
          {
              FloatingTextStrRefOnCreature(84357,oPC);
              // not a valid item
              stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
              return stStruct;

          }
    }
  }
}

// -----------------------------------------------------------------------------
//                 *** Crafting Conversation Functions ***
// -----------------------------------------------------------------------------
int CIGetInModWeaponOrArmorConv(object oPC)
{
    return GetLocalInt(oPC,"X2_L_CRAFT_MODIFY_CONVERSATION");
}


void CISetCurrentModMode(object oPC, int nMode)
{
    if (nMode == X2_CI_MODMODE_INVALID)
    {
        DeleteLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE");
    }
    else
    {
        SetLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE",nMode);
    }
}

int CIGetCurrentModMode(object oPC)
{
  return GetLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE");
}


object CIGetCurrentModBackup(object oPC)
{
    return GetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_BACKUP");
}

object CIGetCurrentModItem(object oPC)
{
    return GetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_ITEM");
}


void CISetCurrentModBackup(object oPC, object oBackup)
{
    SetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_BACKUP",oBackup);
}

void CISetCurrentModItem(object oPC, object oItem)
{
    SetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_ITEM",oItem);
}


// -----------------------------------------------------------------------------
// * This does multiple things:
//   -  store the part currently modified
//   -  setup the custom token for the conversation
//   -  zoom the camera to that part
// -----------------------------------------------------------------------------
void CISetCurrentModPart(object oPC, int nPart, int nStrRef)
{
    SetLocalInt(oPC,"X2_TAILOR_CURRENT_PART",nPart);

    if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_ARMOR)
    {

        // * Make the camera float near the PC
        float fFacing  = GetFacing(oPC) + 180.0;

        if (nPart == ITEM_APPR_ARMOR_MODEL_LSHOULDER || nPart == ITEM_APPR_ARMOR_MODEL_LFOREARM ||
            nPart == ITEM_APPR_ARMOR_MODEL_LHAND || nPart == ITEM_APPR_ARMOR_MODEL_LBICEP)
        {
            fFacing += 80.0;
        }

        if (nPart == ITEM_APPR_ARMOR_MODEL_RSHOULDER || nPart == ITEM_APPR_ARMOR_MODEL_RFOREARM ||
            nPart == ITEM_APPR_ARMOR_MODEL_RHAND || nPart == ITEM_APPR_ARMOR_MODEL_RBICEP)
        {
            fFacing -= 80.0;
        }

        float fPitch = 75.0;
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }

        float  fDistance = 3.5f;
        if (nPart == ITEM_APPR_ARMOR_MODEL_PELVIS || nPart == ITEM_APPR_ARMOR_MODEL_BELT )
        {
            fDistance = 2.0f;
        }

        if (nPart == ITEM_APPR_ARMOR_MODEL_LSHOULDER || nPart == ITEM_APPR_ARMOR_MODEL_RSHOULDER )
        {
            fPitch = 50.0f;
            fDistance = 3.0f;
        }
        else  if (nPart == ITEM_APPR_ARMOR_MODEL_LFOREARM || nPart == ITEM_APPR_ARMOR_MODEL_LHAND)
        {
            fDistance = 2.0f;
            fPitch = 60.0f;
        }
        else if (nPart == ITEM_APPR_ARMOR_MODEL_NECK)
        {
            fPitch = 90.0f;
        }
        else if (nPart == ITEM_APPR_ARMOR_MODEL_RFOOT || nPart == ITEM_APPR_ARMOR_MODEL_LFOOT  )
        {
            fDistance = 3.5f;
            fPitch = 47.0f;
        }
         else if (nPart == ITEM_APPR_ARMOR_MODEL_LTHIGH || nPart == ITEM_APPR_ARMOR_MODEL_RTHIGH )
        {
            fDistance = 2.5f;
            fPitch = 65.0f;
        }
        else if (        nPart == ITEM_APPR_ARMOR_MODEL_RSHIN || nPart == ITEM_APPR_ARMOR_MODEL_LSHIN    )
        {
            fDistance = 3.5f;
            fPitch = 95.0f;
        }

        if (GetRacialType(oPC)  == RACIAL_TYPE_HALFORC)
        {
            fDistance += 1.0f;
        }

        SetCameraFacing(fFacing, fDistance, fPitch,CAMERA_TRANSITION_TYPE_VERY_FAST) ;
    }

    int nCost = GetLocalInt(oPC,"X2_TAILOR_CURRENT_COST");
    int nDC = GetLocalInt(oPC,"X2_TAILOR_CURRENT_DC");

    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE,IntToString(nCost));
    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE+1,IntToString(nDC));


    SetCustomToken(XP_IP_ITEMMODCONVERSATION_CTOKENBASE,GetStringByStrRef(nStrRef));
}

int CIGetCurrentModPart(object oPC)
{
    return GetLocalInt(oPC,"X2_TAILOR_CURRENT_PART");
}


void CISetDefaultModItemCamera(object oPC)
{
    float fDistance = 3.5f;
    float fPitch =  75.0f;
    float fFacing;

    if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_ARMOR)
    {
        fFacing  = GetFacing(oPC) + 180.0;
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }
    }
    else if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_WEAPON)
    {
        fFacing  = GetFacing(oPC) + 180.0;
        fFacing -= 90.0;
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }
    }

    SetCameraFacing(fFacing, fDistance, fPitch,CAMERA_TRANSITION_TYPE_VERY_FAST) ;
}

void CIUpdateModItemCostDC(object oPC, int nDC, int nCost)
{
        SetLocalInt(oPC,"X2_TAILOR_CURRENT_COST", nCost);
        SetLocalInt(oPC,"X2_TAILOR_CURRENT_DC",nDC);
        SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE,IntToString(nCost));
        SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE+1,IntToString(nDC));
}


// dc to modify oOlditem to look like oNewItem
int CIGetWeaponModificationCost(object oOldItem, object oNewItem)
{
   int nTotal = 0;
   int nPart;
   for (nPart = 0; nPart<=2; nPart++)
   {
        if (GetItemAppearance(oOldItem,ITEM_APPR_TYPE_WEAPON_MODEL, nPart) !=GetItemAppearance(oNewItem,ITEM_APPR_TYPE_WEAPON_MODEL, nPart))
        {
            nTotal+= (GetGoldPieceValue(oOldItem)/4)+1;
        }
   }

   // Modification Cost should not exceed value of old item +1 GP
   if (nTotal > GetGoldPieceValue(oOldItem))
   {
        nTotal = GetGoldPieceValue(oOldItem)+1;
   }
   return nTotal;
}

//void main(){}
