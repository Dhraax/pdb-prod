// HCR v3.2.0 - Re-Added spell tracking code.
//            - Fixed rest in armor bug. Thx to Kornstalx.
//::////////////////////////////////////////////////////////////////////////////
//:: FileName:  HC_On_Play_Rest
//::////////////////////////////////////////////////////////////////////////////
/*
     Only allows PC's to use the rest command once ever 8 hours. (thats 16
    minutes normal time with a 2 min per day timer) This prevents casters from
    spam casting, rest 30 seconds, spam casting, etc.
*/
//::////////////////////////////////////////////////////////////////////////////
#include "mti_libreria"
#include "HC_Inc_HTF"
#include "HC_Inc_TimeCheck"
#include "HC_Text_Rest"
#include "f_vampire_spls_h"
#include "lib_race"
#include "pb_inc_mmf"

//::////////////////////////////////////////////////////////////////////////////
int iRESTSYSTEM;
int iRESTBREAK;
int iREALFAM;
int iBEDROLLSYSTEM;
int iFOODSYSTEM;
int iHUNGERSYSTEM;
int iLIMITEDRESTHEAL;
int iRESTARMORPEN;
int iBLEEDSYSTEM;
int iPARTYREST;
int iMinRest;
int nRestHP;
int nSSB;
int nHasFood;
object oBedroll;
int iCount;
//::////////////////////////////////////////////////////////////////////////////

void InitRestVariables()
{
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
    iPARTYREST = GetLocalInt(oMod,"PARTYREST");
    nSSB=SecondsSinceBegin();
}
//::////////////////////////////////////////////////////////////////////////////
void ApplyAutoFrenzy(object oPC, object oArmor)
{
     IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

int CheckBadEffects(object oPC)
{
    // if BADREST == 1 skip check.
    if (GetLocalInt(GetModule(), "BADREST"))
       return 0;
    //Declare major variables
    effect eBad = GetFirstEffect(oPC);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        int nEtype=GetEffectType(eBad);
        if (nEtype == EFFECT_TYPE_CHARMED  ||
            nEtype == EFFECT_TYPE_CURSE  ||
            nEtype == EFFECT_TYPE_DOMINATED  ||
            nEtype == EFFECT_TYPE_DARKNESS  ||
            nEtype == EFFECT_TYPE_ENTANGLE  ||
            nEtype == EFFECT_TYPE_BLINDNESS ||
            nEtype == EFFECT_TYPE_DEAF ||
            nEtype == EFFECT_TYPE_PARALYZE ||
            nEtype == EFFECT_TYPE_FRIGHTENED ||
            nEtype == EFFECT_TYPE_DAZED ||
            nEtype == EFFECT_TYPE_CONFUSED ||
            nEtype == EFFECT_TYPE_POISON ||
            nEtype == EFFECT_TYPE_PARALYZE  ||
            nEtype == EFFECT_TYPE_SLEEP  ||
            nEtype == EFFECT_TYPE_STUNNED  ||
            nEtype == EFFECT_TYPE_TURNED  ||
            nEtype == EFFECT_TYPE_SILENCE  ||
            nEtype == EFFECT_TYPE_DISEASE
            )
             {
                   SendMessageToPC(oPC, NOTWELL);
                   AssignCommand( oPC, ClearAllActions());
                   return 1;
             }
        eBad = GetNextEffect(oPC);
    }
return 0;
}
//::////////////////////////////////////////////////////////////////////////////
// party rest option code
void PartyRest(object oPC)
{
   object oPlayer = GetFirstFactionMember(oPC);
   while (GetIsObjectValid(oPlayer))
   {
     if (GetIsInCombat(oPlayer)|| (GetArea(oPC) != GetArea(oPlayer)
        && GetTag(GetArea(oPlayer)) != "plano_fuga")
        || IsInConversation(oPC))
     {
        SendMessageToPC(oPC, PCANTREST);
        return;
     }
     oPlayer = GetNextFactionMember(oPC);
   }
   SetLocalInt(GetModule(), "PREST", TRUE);
   // hcr3
   AssignCommand(oPC, ActionStartConversation(oPC, "hc_c_lprest", TRUE, FALSE));
}
//::////////////////////////////////////////////////////////////////////////////
object GetPCRestFood(object oPC)
{
    object oMyFood;
    object oEquip = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oEquip)) {
        if(!FindSubString(GetTag(oEquip),"Food")) {
            oMyFood = oEquip;
            break;
        }
        oEquip = GetNextItemInInventory(oPC);
    }
    return oMyFood;
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
   // 5.5 added eatfood variable to allow eating of food.
   if (!GetLocalInt(oPC, "ATEFOOD"))
    if(iFOODSYSTEM && !iHUNGERSYSTEM)
             {
                object oFood = GetPCRestFood(oPC);
                DestroyObject(oFood);
                SendMessageToPC(oPC, EATFOOD + " [" + GetName(oFood) + "]");
                // 5.5 added code to set the pc has eaten food once.
                SetLocalInt(oPC, "ATEFOOD", TRUE);
             }
  }
 }
}
//::////////////////////////////////////////////////////////////////////////////
int RestrictPartyRestOnLimitRestHealAndArmorPen(object oPC)
{
    // added party rest check
    if((iLIMITEDRESTHEAL || iRESTARMORPEN) && !iPARTYREST ) {
        object oPM=GetFirstFactionMember(oPC);
        while(GetIsObjectValid(oPM)) {
            if(GetLocalInt(oPM,"RESTING") && oPM != oPC) {
                AssignCommand(oPC, ClearAllActions());
                SendMessageToPC(oPC,ColorTexto("No puedes descansar mientras otro miembro de tu grupo lo está haciendo, por favor, espera a que acabe.",TXT_COLOR_ROJO));
                return 1;
            }
            oPM=GetNextFactionMember(oPC);
        }
    }
    return 0;
}
//::////////////////////////////////////////////////////////////////////////////
int DoesPCHaveBedroll(object oPC)
{
    if(iBEDROLLSYSTEM) {
        oBedroll = GetItemPossessedBy(oPC,"bedroll");
        if (GetIsObjectValid(oBedroll))
            return 1;
        else {
            oBedroll = GetLocalObject(oMod,"inbedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC));
            if (GetIsObjectValid(oBedroll))
                return 1;
        }
    }
    return 0;
}
//::////////////////////////////////////////////////////////////////////////////
int IsTooSoonToRest(object oPC)
{
    int nNotOkToRest = 0;

    string sRestedText = GetName(oPC, TRUE) + NOTTIRED;
    //First get the time last rested and the current time.
    int iLastRest = GetPersistentInt(oMod, ("LastRest" + GetName(oPC, TRUE) + GetPCPlayerName(oPC)));
    float fConv = IntToFloat(nConv);
    float fMinRest = IntToFloat(iMinRest);
    float fLastRest = IntToFloat(iLastRest);
    float fSSB = IntToFloat(nSSB);
    int iMin = StringToInt(GetSubString(FloatToString((( fMinRest + fLastRest) - fSSB)/ fConv), 9,2));
    iMin = FloatToInt(IntToFloat(iMin) * 0.6);
    /*// 5.5.3 fix for rest not displaying hours greater than 1 diget
    if (iRESTSYSTEM && iLastRest && ((iLastRest + iMinRest) > nSSB) && !GetPersistentInt( GetArea(oPC), "ALLOWREST") )
    {
        AssignCommand(oPC, ClearAllActions());
        sRestedText += " Prueba otra vez en ";
        sRestedText = sRestedText + GetSubString(FloatToString(((fMinRest+fLastRest) - fSSB) / fConv), 6,2)
        + " horas " + IntToString(iMin)+" minutos";
        FloatingTextStringOnCreature(ColorTexto(sRestedText,TXT_COLOR_CELESTE), oPC, FALSE);
        nNotOkToRest = 1;
    }    */
    if (iRESTSYSTEM && iLastRest && ((iLastRest + iMinRest) > nSSB) && !GetPersistentInt( GetArea(oPC), "ALLOWREST") )
    {
        AssignCommand(oPC, ClearAllActions());
        int iTiempoRestante = FloatToInt(((fMinRest+fLastRest) - fSSB)/60);
        sRestedText += " Prueba otra vez en "+ IntToString(iTiempoRestante+1)+" minutos.";
        FloatingTextStringOnCreature(ColorTexto(sRestedText,TXT_COLOR_CELESTE), oPC, FALSE);
        nNotOkToRest = 1;
    }
    return nNotOkToRest;
}
//::////////////////////////////////////////////////////////////////////////////
int DoesPCHaveFoodToRest(object oPC)
{
    int nNotOkToRest = 0;
    if(iRESTSYSTEM && iFOODSYSTEM && !nHasFood && !iHUNGERSYSTEM)
    {
        FloatingTextStringOnCreature(TOOHUNGRY, oPC, FALSE);
        AssignCommand( oPC, ClearAllActions());
        nNotOkToRest = 1;
    }
    return nNotOkToRest;
}
//::////////////////////////////////////////////////////////////////////////////
int IsPCTooHungryToRest(object oPC)
{
    int nNotOkToRest = 0;
    if(iRESTSYSTEM && iHUNGERSYSTEM)
    {
        int nHungerThirstRating = IsPCVeryHungryOrThirsty(oPC);
        if (nHungerThirstRating > 0)  {
            if (nHungerThirstRating==1)
                FloatingTextStringOnCreature(TOOHUNGRY, oPC, FALSE);
            if (nHungerThirstRating==2)
                FloatingTextStringOnCreature(TOOTHIRSTY, oPC, FALSE);
            if (nHungerThirstRating==3)
                FloatingTextStringOnCreature(TOOHUNGRYANDTHIRSTY, oPC, FALSE);
            AssignCommand( oPC, ClearAllActions());
            nNotOkToRest = 1;
        }
    }
    return nNotOkToRest;
}
//::////////////////////////////////////////////////////////////////////////////
int EsLugarPermitido(object oPC)
{
   int noPermitido= 0;
   int estaEnDesencadenante= GetLocalInt(oPC, "estaEnDesencadentanteParaDescanso");
   if (estaEnDesencadenante==0)
      {
      noPermitido= 1;
      AssignCommand( oPC, ClearAllActions());
      SendMessageToPC(oPC,ColorTexto("No puedes desansar aquí, busca otro lugar más resguardado.",TXT_COLOR_ROJO));
      }
   return noPermitido;
}
//::////////////////////////////////////////////////////////////////////////////
int TieneTiendaLlueve(object oPC)
{
   int sinTiendaLlueve= 0;
   int malTiempo= GetWeather(GetArea(oPC));
   object oTienda;
   if ((malTiempo==WEATHER_RAIN)||(malTiempo==WEATHER_SNOW))
      {
      int iNivelesDruida = GetLevelByClass(CLASS_TYPE_DRUID,oPC);

      oTienda = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, GetLocation(oPC), TRUE, OBJECT_TYPE_PLACEABLE);
      while(GetIsObjectValid(oTienda))
         {
         if (GetTag(oTienda)== "tienda_aventurer" || iNivelesDruida >= 1)
            {
            return 0;
            }
         oTienda = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, GetLocation(oPC), TRUE, OBJECT_TYPE_PLACEABLE);
         }

      sinTiendaLlueve= 1;
      AssignCommand( oPC, ClearAllActions());
      SendMessageToPC(oPC,ColorTexto("Con este tiempo no puedes dormir a la intemperie. ¡Monta una tienda de campaña!",TXT_COLOR_ROJO));
      }
   return sinTiendaLlueve;
}

void ApplySleepEffects(object oPC)
{
    effect eSnore = EffectVisualEffect(VFX_IMP_SLEEP);
    SetLocalInt(oPC,"RESTING",1);
    if (!PB_Race_GetIsElf(oPC) && GetRacialType(oPC) != RACIAL_TYPE_HALFELF)
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSnore, oPC, 7.0);
    //insert special effects here. I tried EffectSleep along with different
    //animations. They either get overrode by the rest anim or cancel the rest.
    if (!PB_Race_GetIsElf(oPC) && GetRacialType(oPC) != RACIAL_TYPE_HALFELF)
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSnore, oPC, 7.0);
    effect eBad = GetFirstEffect(oPC);
    //Search for negative effects
    int nBlindMe=1;
    while(GetIsEffectValid(eBad))
    {
        int nEtype=GetEffectType(eBad);
        if(nEtype==EFFECT_TYPE_TRUESEEING)
            nBlindMe=0;
        eBad=GetNextEffect(oPC);
    }
    if(nBlindMe)
    {
        effect eBlind =  ExtraordinaryEffect(EffectBlindness());
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 29.0);
    }
    if (!PB_Race_GetIsElf(oPC) && GetRacialType(oPC) != RACIAL_TYPE_HALFELF)
       DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSnore, oPC, 7.0));
    SetPanelButtonFlash(oPC,PANEL_BUTTON_REST,0);
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
void DoLimitedRestDamage(object oPC, int ExtraPostRestHealing = 0, int nLastRestType = 0)
{
    int nHD=GetHitDice(oPC);
    // hcr3.1 changed variable.
    int nSHP=GetLocalInt(oPC, "HPStartRest");
    int nDam;
    int nLTC;

    //Double healing rate if long term care was applied successfully.
    if(GetLocalInt(oMod, "LONGTERMCARE"+GetName(oPC, TRUE)+GetPCPlayerName(oPC)) == 2)
        nLTC=GetHitDice(oPC);
    else nLTC=0;

   if(nLastRestType == REST_EVENTTYPE_REST_FINISHED)
    {
      if(nRestHP > (nSHP+nHD+nLTC + ExtraPostRestHealing)) {
        nDam=(nRestHP - (nSHP+nHD+nLTC + ExtraPostRestHealing));
        // 5.5.4 fix for bug in resthitpoints.
        int nHeal = nHD + nLTC + ExtraPostRestHealing;
        //SendMessageToPC(oPC, "REST HEAL: " + IntToString(nHeal));
        if(GetIsVampire(oPC)) {}
        else {
        effect eDamage = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC); }
        // hcr3.1 took out disabled code.
      }
    }
    else if (GetLocalInt(oPC, "REST"))
    {
       if (nSHP < GetCurrentHitPoints(oPC)) {
        nDam=(GetCurrentHitPoints(oPC)-nSHP);
        if(GetIsVampire(oPC)) {}
        else {
        effect eDamage = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC); }
       }
    }
    SetLocalInt(oMod, "LONGTERMCARE"+GetName(oPC, TRUE)+GetPCPlayerName(oPC), 0);
}
//::////////////////////////////////////////////////////////////////////////////
void ReplaceBedroll(object oPC)
{
    oBedroll=GetLocalObject(oMod, "inbedroll"+GetName(oPC, TRUE)+GetPCPlayerName(oPC));
    CreateItemOnObject("bedroll", oPC);
    DestroyObject(oBedroll);
    DeleteLocalObject(oMod, "inbedroll"+GetName(oPC, TRUE)+GetPCPlayerName(oPC));
}
//::////////////////////////////////////////////////////////////////////////////
void ApplyArmorRestPenalty(object oPC)
{
    // Armor penalty.  Check only if rest fully completed.
    if (GetLastRestEventType() == REST_EVENTTYPE_REST_FINISHED ) {
        int bFatigued = GetLocalInt(oPC, "bFatigued");
        int bExhausted = GetLocalInt(oPC, "bExhausted");

        // Check for armor, and give a penalty for armor +5 and above.
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        int nNetAC = GetItemACValue(oArmor);
        int nBonus = IPGetWeaponEnhancementBonus(oArmor, ITEM_PROPERTY_AC_BONUS);
        int nBaseAC = nNetAC - nBonus;
        //FloatingTextStringOnCreature("Base AC: "+IntToString(nBaseAC), oPC, TRUE);
        //FloatingTextStringOnCreature("Enhancement: "+IntToString(nBonus), oPC, TRUE);
        //FloatingTextStringOnCreature("Net AC: "+IntToString(nNetAC), oPC, TRUE);
        if (nBaseAC > 5) {
            if (!bFatigued && !bExhausted)
                MakePlayerFatigued(oPC,FATIG);
            else {
                SetLocalInt(oPC, "bFatigued",FALSE);
                SetLocalInt(oPC, "bExhausted", FALSE);
                MakePlayerExhausted(oPC,EXHAUS);
            }
        }
        else {
            SetLocalInt(oPC, "bFatigued",FALSE);
            SetLocalInt(oPC, "bExhausted", FALSE);
        }
    }
}
//::////////////////////////////////////////////////////////////////////////////
void main()
{
    object oPC = GetLastPCRested();
    object oArea = GetArea(oPC);

    ////////////////////////
    // PRI Code
    // Apply rest in inn restrictions
    object oPRIForceInnRest = GetNearestObjectByTag("PRIForceInnRest", oPC);
    int iBedUse = GetLocalInt(oPC, "RSA_BedUse");
    // end PRI code

    if (GetIsObjectValid(oPC) && !GetIsDM(oPC)) {
        SetPersistentLocation(oPC, "PV_START_LOCATION", GetLocation(oPC));
    }

    if (GetHasFeat(1431, oPC)) SetLocalInt(oPC, "arcane_fire_active", 0);

    int iRESTSYSTEM = GetLocalInt(oMod, "RESTSYSTEM");
    if(!iRESTSYSTEM)
    {
        //sr6.1 reset fatigue system if not using restsystem.
        int iFATIGUESYSTEM = GetLocalInt(oMod,"FATIGUESYSTEM");
        if (iFATIGUESYSTEM )
           SetLocalInt(oMod,"FATIGUELEVEL" + GetName(oPC, TRUE) +   GetPCPlayerName(oPC), INITFATIGUELEVEL);

        return;
    }
    //call hc_innrest code if Variable set (this script can be changed to fit your inns)
    int InnRest = GetLocalInt(oArea, "HCINN");
    //sr6.1 added resetting fatigue level for inn rest
    if (InnRest)
    {
      ExecuteScript("hc_innrest", oPC);
      int iFATIGUESYSTEM = GetLocalInt(oMod,"FATIGUESYSTEM");
      if (iFATIGUESYSTEM )
        SetLocalInt(oMod,"FATIGUELEVEL" + GetName(oPC, TRUE) +   GetPCPlayerName(oPC), INITFATIGUELEVEL);
      return;
    }

    ///////////////////////////
    // PRI Code
    // Don't allow rest if it is restricted
    if( GetIsObjectValid(oPRIForceInnRest) && !iBedUse )
    {
        AssignCommand( oPC, ClearAllActions());
        SendMessageToPC(oPC,ColorTexto("Las autoridades locales te prohiben descansar aquí.",TXT_COLOR_ROJO));
        return;
    }
    // end PRI code

    InitRestVariables();
    nRestHP = GetCurrentHitPoints(oPC);
    if (RestrictPartyRestOnLimitRestHealAndArmorPen(oPC))
        return;

    int iBedroll = DoesPCHaveBedroll(oPC);
    // Added party rest system code
    int iPARTYREST = GetLocalInt(oMod, "PARTYREST");

    if (GetLastRestEventType() == REST_EVENTTYPE_REST_STARTED)
    {
        // Sin descanso si estas montado
        if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
        {
            AssignCommand(oPC, ClearAllActions(TRUE));
            SendMessageToPC(oPC,ColorTexto("No se puede descansar mientras estás montado en una montura",TXT_COLOR_ROJO));
            return;
        }

        if (iBEDROLLSYSTEM && iBedroll)
        {
        SetLocalInt(oMod, "LostBedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC),TRUE);
        DestroyObject(oBedroll);
        }
        // hcr3.1 only need to set for pc.
        SetLocalInt(oPC, "HPStartRest", nRestHP);

        nHasFood = 0;
        object oFood;
        //make sure to modify the time for rollover of day, month and year.
        // in NWN there are 28 days to a month, 12 months to a year.
        // 5.5.3 fix for resting using bedrolls.
        if(iBEDROLLSYSTEM && !iBedroll)
            iMinRest = (iRESTBREAK+(iRESTBREAK/2))*nConv;
        //figure out how long it has been since last rested
        if(iFOODSYSTEM && !iHUNGERSYSTEM) {

            oFood = GetPCRestFood(oPC);
            if (GetIsObjectValid(oFood))
                nHasFood = 1;
        }

        int iFail = 0;
        iFail = IsTooSoonToRest(oPC);
        // hcr3.1 took out recovery code.
        //if (!iFail)
            //iFail = IsPCTooWeakToRest(oPC);
        if (!iFail)
            iFail = DoesPCHaveFoodToRest(oPC);
        if (!iFail)
            iFail = IsPCTooHungryToRest(oPC);
        // sr6.1 check for bad effects.
        if (!iFail)
            iFail = CheckBadEffects(oPC);


        // Prueba de lugar permitido
        if (!iFail)
            iFail= EsLugarPermitido(oPC);
        // Prueba de tienda
        if (!iFail)
            iFail= TieneTiendaLlueve(oPC);

        if (!iFail)
        {
            if (!GetLocalInt(oPC, "REST") && GetIsPC(oPC)&& GetLocalInt(oMod, "RESTCONV"))
            {
                  AssignCommand(oPC, ClearAllActions());
                  // party rest code.
                  if (!iPARTYREST)
                  {
                     // hcr3
                     AssignCommand(oPC, ActionStartConversation(oPC, "hc_c_rest", TRUE, FALSE));
                  }
                  else
                     if (GetFactionLeader(oPC) == oPC)
                     {
                         PartyRest(oPC);
                     }
                     else
                         if (!GetLocalInt(GetFactionLeader(oPC), "REST"))
                         {
                            // hcr3
                            AssignCommand(oPC, ActionStartConversation(oPC, "hc_c_prest", TRUE, FALSE));
                         }
                  //end paty rest code.
                  SetLocalInt(oPC, "REST", FALSE);
                  return;
             }
             else
                 SetLocalInt(oPC, "REST", TRUE);

             //set the variables for the current time to mark the pc as resting
             iCount = iRESTBREAK;
             DelayCommand(1.5, SetRestTime(oPC, iCount));
             ApplySleepEffects(oPC);
             if (iBEDROLLSYSTEM && iBedroll)
                {
                  object oNewBedroll=CreateObject(OBJECT_TYPE_PLACEABLE,"bedroll",GetLocation(oPC));
                  SetLocalObject(oMod,"inbedroll"+GetName(oPC, TRUE)+GetPCPlayerName(oPC),oNewBedroll);
                 }

         }
    }


    int nLastRestType=GetLastRestEventType();
    int iFinished = FALSE;
    if (nLastRestType == REST_EVENTTYPE_REST_FINISHED ||
        nLastRestType == REST_EVENTTYPE_REST_CANCELLED)
    {
        ExportSingleCharacter(oPC);

        // hcr3
        DeleteLocalObject(oPC, "RESTOBJ");
        RemoveSleepBlindness(oPC);
        int ExtraPostRestHealing = 0;
        SetLocalInt(oPC,"RESTING",0);
        if(nLastRestType == REST_EVENTTYPE_REST_FINISHED)
            {
            iFinished = TRUE;
            if(!GetIsDM(oPC))
              SetPersistentInt(oMod, ("LastRest" + GetName(oPC, TRUE) + GetPCPlayerName(oPC)), nSSB);
            }

        if(iLIMITEDRESTHEAL)
            DoLimitedRestDamage( oPC, ExtraPostRestHealing, nLastRestType);
        DeleteLocalInt(oPC, "REST");
        if (iBEDROLLSYSTEM && (GetLocalInt(oMod, "LostBedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC))))
        {
            ReplaceBedroll(oPC);
            DeleteLocalInt(oMod, "LostBedroll" + GetName(oPC, TRUE) + GetPCPlayerName(oPC));
        }
        if(iRESTARMORPEN)
            ApplyArmorRestPenalty(oPC);
        string sID=GetName(oPC, TRUE)+GetPCPlayerName(oPC);
        effect eConDec = ExtraordinaryEffect(EffectAbilityDecrease
            (ABILITY_CONSTITUTION, GetPersistentInt(GetModule(), "CONPEN"+sID)));

        if (nLastRestType == REST_EVENTTYPE_REST_FINISHED)
        {
          // 5.5 delete food vars.
          DeleteLocalInt(oPC, "ATEFOOD");

          // Variable levitar usos drow
          DeleteLocalInt(oPC, "LEVITARUSOS");

          //Poderes Especialesde Sets de Armadura
          if(GetLocalInt(oPC, "Poder_Especial") == 1 )
          {
            ReaplicarEfectosPB(oPC, TRUE, TRUE);
            DeleteLocalInt(oPC, "Poder_Especial");
          }

          // Arqueros arcanos: eliminar flechas imbuidas
          if(GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW, oPC) == TRUE) ExecuteScript("aa_m_rest", OBJECT_SELF);

          // Eliminar variable convocacion de monturas de paladin
          GuardarIntPersistente(oPC, "MONTURACONVOCADA", FALSE);

          // Eliminar variable de indetectabilidad.
          if (ObtenerIntPersistente(oPC, "INDETECTABLE") == 1)
          {
              GuardarIntPersistente(oPC, "INDETECTABLE",0);
          }

          //Berserker Frenetico, AutoFrenesy
          if(GetLevelByClass(56, oPC) > 0 )
          {
            object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
            ApplyAutoFrenzy(oPC, oArmor);
          }
 
          //Maestro de Múltiples Formas recuperación de habilidades si descansa transformado.
          if(ObtenerIntPersistente(oPC,"POLYMORPHED"))
          {
            int iForm = ObtenerIntPersistente(oPC,"POLYMORPHED_FORM");
            RemoveAllMDFSpecialAbility(oPC);
            int iSPELL1 = StringToInt(Get2DAString(sPoly2DA,"SPELL1",iForm));
            int iSPELL2 = StringToInt(Get2DAString(sPoly2DA,"SPELL2",iForm));
            int iSPELL3 = StringToInt(Get2DAString(sPoly2DA,"SPELL3",iForm));
            if(iSPELL1 != 0) AddMDFSpecialAbility(oPC,iSPELL1,iForm);
            if(iSPELL2 != 0) AddMDFSpecialAbility(oPC,iSPELL2,iForm);
            if(iSPELL3 != 0) AddMDFSpecialAbility(oPC,iSPELL3,iForm);

          }
          //Variables de los DMs en PJs.
          if(GetLocalInt(oPC, "dm_noreg") == 1)
          {
            DeleteLocalInt(oPC, "dm_noreg");
            DeleteLocalInt(oPC, "DAMAGE_ROUND");
            SendMessageToPC(oPC,ColorTexto("Se te habilita de nuevo la posibilidad de regenerar vida que un DM te había deshabilitado.",TXT_COLOR_VERDE));
          }
          if(GetLocalInt(oPC, "dm_nocurar") == 1)
          {
            DeleteLocalInt(oPC, "dm_nocurar");
            SendMessageToPC(oPC,ColorTexto("Se te habilita de nuevo la posibilidad de curarte que un DM te había deshabilitado.",TXT_COLOR_VERDE));
          }

        }
    }

    int iFATIGUESYSTEM = GetLocalInt(oMod,"FATIGUESYSTEM");
    if (iFATIGUESYSTEM && (nLastRestType == REST_EVENTTYPE_REST_FINISHED))
        SetLocalInt(oMod,"FATIGUELEVEL" + GetName(oPC, TRUE) + GetPCPlayerName(oPC), INITFATIGUELEVEL);


}
