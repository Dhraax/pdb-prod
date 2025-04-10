// HCR v3.2.0 - Fixed rest in armor bug. Thx to Kornstalx.
//::////////////////////////////////////////////////////////////////////////////
//:: FileName:  HC_InnRest
//::////////////////////////////////////////////////////////////////////////////
/*
   This script replaces the normal rest script, modify it however you like.

  - If area local int "RESTONCE" is TRUE Only allow PC's to rest once in room
    once entered.
  - If area local int "LIMITREST" is TRUE then resting time limits will be
    enforced.
  - If area local int "ROOMTYPE" is 1,2, or 3 then extra healing will occur.
    This should only be used with RESTONCE.
  - If area local int "FOODNEEDED" is TRUE and foodsystem consume food when
    resting.
  - Remove PC local int "RESTED" when pc enters room for first time (as in
    hc_innroom_enter).
*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created By: Jamos
//:: Created On: Jan 2003
//::////////////////////////////////////////////////////////////////////////////
#include "mti_libreria"
#include "f_vampire_spls_h"
#include "HC_Inc_TimeCheck"
#include "HC_Text_InnRest"
#include "HC_Inc_HTF"
#include "lib_race"
//::////////////////////////////////////////////////////////////////////////////
int iROOMTYPE;
int iRESTED;
int iLIMITREST;
int iRESTONCE;
int iFOODNEEDED;
int iRESTSYSTEM;
int iRESTBREAK;
int iREALFAM;
int iBEDROLLSYSTEM;
int iFOODSYSTEM;
int iHUNGERSYSTEM;
int iLIMITEDRESTHEAL;
int iRESTARMORPEN;
int iBLEEDSYSTEM;
int iMinRest;
int nRestHP;
int nSSB;
int nHasFood;
object oBedroll;
int iCount;
object oPC;
object oArea;
//::////////////////////////////////////////////////////////////////////////////
void InitRestVariables()
{
    iROOMTYPE = GetLocalInt(oArea, "ROOMTYPE");
    iRESTED = GetLocalInt(oPC, "RESTED");
    iLIMITREST = GetLocalInt(oArea, "LIMITREST");
    iRESTONCE = GetLocalInt(oArea, "RESTONCE");
    iFOODNEEDED = GetLocalInt(oArea, "FOODNEEDED");
    iRESTSYSTEM = GetLocalInt(oMod, "RESTSYSTEM");
    iREALFAM=GetLocalInt(oMod,"REALFAM");
    iBEDROLLSYSTEM = GetLocalInt(oMod, "BEDROLLSYSTEM");
    iFOODSYSTEM = GetLocalInt(oMod, "FOODSYSTEM");
    iHUNGERSYSTEM = GetLocalInt(oMod, "HUNGERSYSTEM");
    iLIMITEDRESTHEAL = GetLocalInt(oMod, "LIMITEDRESTHEAL");
    iRESTARMORPEN = GetLocalInt(oMod, "RESTARMORPEN");
    iBLEEDSYSTEM = GetLocalInt(oMod, "BLEEDSYSTEM");
    iRESTBREAK = GetLocalInt(oMod,"RESTBREAK");
    iMinRest = GetLocalInt(oMod,"RESTBREAK")*nConv;
    nSSB=SecondsSinceBegin();
}
//::////////////////////////////////////////////////////////////////////////////
void PartyRest(object oPC)
{
  object oPlayer = GetFirstFactionMember(oPC);
  while (GetIsObjectValid(oPlayer))
    {
     if (GetIsInCombat(oPlayer) || (GetArea(oPC) != GetArea(oPlayer) &&
         GetTag(GetArea(oPlayer)) != "plano_fuga") || IsInConversation(oPC))
       {
        SendMessageToPC(oPC, PCANTREST);
        return;
       }
     oPlayer = GetNextFactionMember(oPC);
    }
  SetLocalInt(GetModule(), "PREST", TRUE);
  AssignCommand(oPC, ActionStartConversation(oPC, "hc_c_lprest", TRUE));
}
//::////////////////////////////////////////////////////////////////////////////
void SetRestTime(object oPC, int iCount)
{
  int iDec = iRESTBREAK/6;
  if (iDec < 1) iDec =1;
  iCount = iCount-iDec;
  if (iCount > 0)
    {
     int nNSB = nSSB-(iCount*60);
     if (nNSB < 1) nNSB = 1;
     if (GetLastRestEventType() == REST_EVENTTYPE_REST_STARTED)
       {
        SetPersistentInt(oMod, ("LastRest" + GetName(oPC, TRUE) + GetPCPlayerName(oPC)), nNSB);
        DelayCommand(1.5, SetRestTime(oPC, iCount));
       }
    }
}
//::////////////////////////////////////////////////////////////////////////////
int RestrictPartyRestOnLimitRestHealAndArmorPen(object oPC)
{
  if (iLIMITEDRESTHEAL || iRESTARMORPEN)
    {
     object oPM = GetFirstFactionMember(oPC);
     while (GetIsObjectValid(oPM))
       {
        if (GetLocalInt(oPM, "RESTING") && oPM != oPC)
          {
           AssignCommand(oPC, ClearAllActions());
           SendMessageToPC(oPC, "No puedes descansar mientras otro miembro de tu grupo lo está haciendo, por favor esperate a que acabe.");
           return 1;
          }
        oPM = GetNextFactionMember(oPC);
       }
    }
  return 0;
}
//::////////////////////////////////////////////////////////////////////////////
int DoesPCHaveBedroll(object oPC)
{
  if (iBEDROLLSYSTEM)
    {
     oBedroll = GetItemPossessedBy(oPC, "bedroll");
     if (GetIsObjectValid(oBedroll))
       { return 1; }
     else
       {
        oBedroll = GetLocalObject(oMod, "inbedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC));
        if (GetIsObjectValid(oBedroll))
           return 1;
       }
    }
  return 0;
}
//::////////////////////////////////////////////////////////////////////////////
object GetPCRestFood(object oPC)
{
  object oMyFood;
  object oEquip = GetFirstItemInInventory(oPC);
  while (GetIsObjectValid(oEquip))
    {
     if (!FindSubString(GetTag(oEquip), "Food"))
       {
        oMyFood = oEquip;
        break;
       }
     oEquip = GetNextItemInInventory(oPC);
    }
  return oMyFood;
}
//::////////////////////////////////////////////////////////////////////////////
int IsTooSoonToRest(object oPC)
{
  int nNotOkToRest = 0;
  string sRestedText = GetName(oPC, TRUE) + NOTTIRED;
  // First get the time last rested and the current time.
  int iLastRest = GetPersistentInt(oMod, ("LastRest" + GetName(oPC, TRUE) + GetPCPlayerName(oPC)));
  if (iRESTSYSTEM && iLastRest && ((iLastRest + iMinRest) > nSSB) &&
     !GetPersistentInt(GetArea(oPC), "ALLOWREST"))
    {
     AssignCommand(oPC, ClearAllActions());
     sRestedText += " Try again in ";
     if (((iMinRest + iLastRest) - nSSB) / nConv > 0)
        sRestedText += IntToString(((iMinRest + iLastRest) - nSSB) / nConv) + " hours.";
     else
        sRestedText += IntToString((iMinRest + iLastRest) - nSSB) + " minutes.";
     FloatingTextStringOnCreature(sRestedText, oPC, FALSE);
     nNotOkToRest = 1;
    }
  return nNotOkToRest;
}
//::////////////////////////////////////////////////////////////////////////////
int DoesPCHaveFoodToRest(object oPC)
{
  int nNotOkToRest = 0;
  if (iRESTSYSTEM && iFOODSYSTEM && !nHasFood && !iHUNGERSYSTEM)
    {
     FloatingTextStringOnCreature(TOOHUNGRY, oPC, FALSE);
     AssignCommand(oPC, ClearAllActions());
     nNotOkToRest = 1;
    }
  return nNotOkToRest;
}
//::////////////////////////////////////////////////////////////////////////////
int IsPCTooHungryToRest(object oPC)
{
  int nNotOkToRest = 0;
  if (iRESTSYSTEM && iHUNGERSYSTEM)
    {
     int nHungerThirstRating = IsPCVeryHungryOrThirsty(oPC);
     if (nHungerThirstRating > 0)
       {
        if (nHungerThirstRating == 1)
           FloatingTextStringOnCreature(TOOHUNGRY, oPC, FALSE);
        if (nHungerThirstRating == 2)
           FloatingTextStringOnCreature(TOOTHIRSTY, oPC, FALSE);
        if (nHungerThirstRating == 3)
           FloatingTextStringOnCreature(TOOHUNGRYANDTHIRSTY, oPC, FALSE);
        AssignCommand( oPC, ClearAllActions());
        nNotOkToRest = 1;
       }
    }
  return nNotOkToRest;
}
//::////////////////////////////////////////////////////////////////////////////
void ApplySleepEffects(object oPC)
{
  if (!PB_Race_GetIsElf(oPC) && GetRacialType(oPC) != RACIAL_TYPE_HALFELF)
    {
     effect eSnore = EffectVisualEffect(VFX_IMP_SLEEP);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSnore, oPC, 7.0);
     DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSnore, oPC, 7.0));
    }

  int nBlindMe = 1;
  effect eBad = GetFirstEffect(oPC);
  while (GetIsEffectValid(eBad))
    {
     int nEtype = GetEffectType(eBad);
     if (nEtype == EFFECT_TYPE_TRUESEEING)
        nBlindMe = 0;
     eBad = GetNextEffect(oPC);
    }
  if (nBlindMe)
    {
     effect eBlind = ExtraordinaryEffect(EffectBlindness());
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 29.0);
    }

  SetLocalInt(oPC, "RESTING", 1);
  SetPanelButtonFlash(oPC, PANEL_BUTTON_REST, 0);
}
//::////////////////////////////////////////////////////////////////////////////
void RemoveSleepBlindness(object oPC)
{
      effect eBad = GetFirstEffect(oPC);
      while(GetIsEffectValid(eBad))
      {
          if(GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS &&
             GetEffectSubType(eBad) == SUBTYPE_EXTRAORDINARY)
          {
              RemoveEffect(oPC, eBad);
          }
          eBad = GetNextEffect(oPC);
      }
}
//::////////////////////////////////////////////////////////////////////////////
void DoLimitedRestDamage(object oPC, int ExtraPostRestHealing = 0)
{
  int nHD = GetHitDice(oPC);
  int nSHP = GetLocalInt(oMod, "HPStartRest" + GetName(oPC, TRUE) + GetPCPlayerName(oPC));
  int nDam;
  int nLTC;

  // Double healing rate if long term care was applied successfully.
  if (GetLocalInt(oMod, "LONGTERMCARE" + GetName(oPC, TRUE) + GetPCPlayerName(oPC)) == 2)
    { nLTC = GetHitDice(oPC); }
  else
    { nLTC = 0; }

  // Depending on the room type healing is x3, x4, x5 o x6.
  if (iROOMTYPE == 1)
    { nHD = FloatToInt(nHD * 3.0); }
  else if (iROOMTYPE == 2)
    { nHD = nHD * 4; }
  else if (iROOMTYPE == 3)
    { nHD = nHD * 5; }
  else if (iROOMTYPE == 4)
    { nHD = nHD * 6; }
  else if (iROOMTYPE == 5)
    { nHD = nHD * 1000; }


  if (GetLastRestEventType() == REST_EVENTTYPE_REST_FINISHED)
    {
     if (nRestHP > (nSHP+nHD+nLTC + ExtraPostRestHealing))
       {
        if(GetIsVampire(oPC)) {}
        else
        {nDam = (nRestHP - (nSHP + nHD + nLTC + ExtraPostRestHealing));
        effect eDamage = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);}
       }
    }

  if (GetLastRestEventType() == REST_EVENTTYPE_REST_CANCELLED && !GetLocalInt(oPC, "RESTED"))
    {
     if (nSHP < GetCurrentHitPoints(oPC))
       {
        if(GetIsVampire(oPC)) {}
        else
        {nDam = (GetCurrentHitPoints(oPC) - nSHP);
        effect eDamage = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);}
       }
    }

  SetLocalInt(oMod, "LONGTERMCARE" + GetName(oPC, TRUE) + GetPCPlayerName(oPC), 0);
}
//::////////////////////////////////////////////////////////////////////////////
void ReplaceBedroll(object oPC)
{
  oBedroll = GetLocalObject(oMod, "inbedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC));
  CreateItemOnObject("bedroll", oPC);
  DestroyObject(oBedroll);
  DeleteLocalObject(oMod, "inbedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC));
}
//::////////////////////////////////////////////////////////////////////////////
void ApplyArmorRestPenalty(object oPC)
{
  // Armor penalty.  Check only if rest fully completed.
  if (GetLastRestEventType() == REST_EVENTTYPE_REST_FINISHED)
    {
     int bFatigued = GetLocalInt(oPC, "bFatigued");
     int bExhausted = GetLocalInt(oPC, "bExhausted");

     // Check for armor, and give a penalty for armor +5 and above.
     object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
     int nNetAC = GetItemACValue(oArmor);
     int nBonus = IPGetWeaponEnhancementBonus(oArmor, ITEM_PROPERTY_AC_BONUS);
     int nBaseAC = (nNetAC - nBonus);
     if (nBaseAC > 5)
       {
        if (!bFatigued && !bExhausted)
          { MakePlayerFatigued(oPC, FATIG); }
        else
          {
           SetLocalInt(oPC, "bFatigued", FALSE);
           SetLocalInt(oPC, "bExhausted", FALSE);
           MakePlayerExhausted(oPC, EXHAUS);
          }
       }
     else
       {
        SetLocalInt(oPC, "bFatigued", FALSE);
        SetLocalInt(oPC, "bExhausted", FALSE);
       }
    }
}
//::////////////////////////////////////////////////////////////////////////////
void main()
{
  oPC = OBJECT_SELF;
  oArea = GetArea(oPC);
  if (GetIsObjectValid(oPC) && !GetIsDM(oPC))
    { SetPersistentLocation(oPC, "PV_START_LOCATION", GetLocation(oPC)); }

  int iRESTSYSTEM = GetLocalInt(oMod, "RESTSYSTEM");
  if (!iRESTSYSTEM) { return; }

  InitRestVariables();

  int nLastRestType = GetLastRestEventType();

  // Added party rest system code.
  int iPARTYREST = GetLocalInt(oMod, "PARTYREST");

  // if area is set to restonce and pc already rested then dont allow rest.
  if ((nLastRestType == REST_EVENTTYPE_REST_STARTED) && iRESTONCE)
    {
     if (iRESTED)
       {
        SendMessageToPC(oPC, RESTED);
        AssignCommand(oPC, ClearAllActions());
        return;
       }
    }

  nRestHP = GetCurrentHitPoints(oPC);

  if (RestrictPartyRestOnLimitRestHealAndArmorPen(oPC)) { return; }

  if (GetLastRestEventType() == REST_EVENTTYPE_REST_STARTED)
    {
        // Sin descanso si estas montado
        if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
        {
            AssignCommand(oPC, ClearAllActions(TRUE));
            SendMessageToPC(oPC, "<cþ>No se puede descansar mientras estás montado en una montura.</c>");
            return;
        }

     SetLocalInt(oMod, "HPStartRest" + GetName(oPC, TRUE) + GetPCPlayerName(oPC), nRestHP);
     nHasFood = 0;
     object oFood;

     // make sure to modify the time for rollover of day, month and year.
     // in NWN there are 28 days to a month, 12 months to a year.
     if (iFOODSYSTEM && !iHUNGERSYSTEM && iFOODNEEDED)
       {
        oFood = GetPCRestFood(oPC);
        if (GetIsObjectValid(oFood))
           nHasFood = 1;
       }

     int iFail = 0;
     if (iLIMITREST)
        iFail = IsTooSoonToRest(oPC);
     if (!iFail && iFOODNEEDED)
        iFail = DoesPCHaveFoodToRest(oPC);
     if (!iFail && iFOODNEEDED)
        iFail = IsPCTooHungryToRest(oPC);
     if (!iFail)
       {
        if (!GetLocalInt(oPC, "REST") && GetIsPC(oPC) &&
             GetLocalInt(oMod, "RESTCONV"))
          {
           AssignCommand(oPC, ClearAllActions());

           // party rest code.
           if (!iPARTYREST)
             { AssignCommand(oPC, ActionStartConversation(oPC, "hc_c_rest", TRUE)); }
           else if (GetFactionLeader(oPC) == oPC)
             { PartyRest(oPC); }
           else if (!GetLocalInt(GetFactionLeader(oPC), "REST"))
             { AssignCommand(oPC, ActionStartConversation(oPC, "hc_c_prest", TRUE)); }
           SetLocalInt(oPC, "REST", FALSE);
           // end paty rest code.

           if (iBEDROLLSYSTEM &&
              (GetLocalInt(oMod, "LostBedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC))))
             {
              ReplaceBedroll(oPC);
              DeleteLocalInt(oMod, "LostBedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC));
             }
           return;
          }
        else
          { SetLocalInt(oPC, "REST", TRUE); }

        // party rest code.
        if (iPARTYREST && (GetFactionLeader(oPC) == oPC))
           // 5.5 added code for using rest break timeinstead of 8 hours fixed.
           SetTime(GetTimeHour()+iRESTBREAK, GetTimeMinute(), GetTimeSecond(), GetTimeMillisecond());

        // set the variables for the current time to mark the pc as resting.
        iCount = iRESTBREAK;
        DelayCommand(1.5, SetRestTime(oPC, iCount));
        ApplySleepEffects(oPC);
       }
    }

  if(nLastRestType == REST_EVENTTYPE_REST_FINISHED ||
     nLastRestType == REST_EVENTTYPE_REST_CANCELLED)
  {
      ExportSingleCharacter(oPC);

      RemoveSleepBlindness(oPC);
      int ExtraPostRestHealing = 0;
      SetLocalInt(oPC,"RESTING",0);
      DeleteLocalInt(oPC, "REST");

      if(nLastRestType == REST_EVENTTYPE_REST_FINISHED)
      {
          if(!GetIsDM(oPC))
          { SetPersistentInt(oMod, "LastRest" + GetName(oPC, TRUE) + GetPCPlayerName(oPC), nSSB); }
      }

      if(iLIMITEDRESTHEAL)
      { DoLimitedRestDamage(oPC, ExtraPostRestHealing); }

      if(iBEDROLLSYSTEM && (GetLocalInt(oMod, "LostBedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC))))
      {
          ReplaceBedroll(oPC);
          DeleteLocalInt(oMod, "LostBedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC));
      }

      if(iRESTARMORPEN)
      { ApplyArmorRestPenalty(oPC); }

      string sID = GetName(oPC, TRUE) + GetPCPlayerName(oPC);
      effect eConDec = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, GetPersistentInt(GetModule(), "CONPEN" + sID)));
      if(nLastRestType == REST_EVENTTYPE_REST_FINISHED)
      {
          if(iFOODSYSTEM && !iHUNGERSYSTEM)
          {
              object oFood = GetPCRestFood(oPC);
              DestroyObject(oFood);
              SendMessageToPC(oPC, EATFOOD + " [" + GetName(oFood) + "]");
          }
      }

      if(GetLastRestEventType()== REST_EVENTTYPE_REST_FINISHED)
      {
          SetLocalInt(oPC, "RESTED", TRUE);

          // Variable levitar usos drow
          DeleteLocalInt(oPC, "LEVITARUSOS");

          // Arqueros arcanos: eliminar flechas imbuidas
          if(GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW, oPC) == TRUE) ExecuteScript("aa_m_rest", OBJECT_SELF);

          // Eliminar variable convocacion de monturas de paladin
          GuardarIntPersistente(oPC, "MONTURACONVOCADA", FALSE);
      }
  }

  int iFATIGUESYSTEM = GetLocalInt(oMod, "FATIGUESYSTEM");
  if (iFATIGUESYSTEM && (nLastRestType == REST_EVENTTYPE_REST_FINISHED))
    { SetLocalInt(oMod, "FATIGUELEVEL" + GetName(oPC, TRUE) + GetPCPlayerName(oPC), INITFATIGUELEVEL); }
}
//::////////////////////////////////////////////////////////////////////////////
