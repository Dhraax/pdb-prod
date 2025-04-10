// DMFI Universal Wand executable by hahnsoo and Demetrious Version 1.07

#include "dmfi_dmw_inc"
#include "x2_inc_toollib"
#include "x0_i0_position"
#include "mti_libreria"
#include "q_inc_anims"

int iNightMusic;
int iDayMusic;
int iBattleMusic;

object DMFI_NextTarget(object oTarget, object oUser)
{
  object oNew;

  if(GetIsPC(oTarget))
  {
      if(GetIsObjectValid(GetNextFactionMember(oTarget))) oNew = GetNextFactionMember(oTarget);
      else oNew = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget, 1);
  }
  else oNew = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oTarget, 1);

  if(!GetIsObjectValid(oNew))
  {
      SendMessageToPC(oUser, "No hay objetivo válido para transferir.");
      oNew = oTarget;
  }

  SetLocalObject(oUser, "dmfi_univ_target", oNew);
  SetCustomToken(20680, GetName(oNew));
  FloatingTextStringOnCreature("Objetivo cambiado a : "+ GetName(oNew), oUser);
  return oNew;
}

int DMFI_GetNetWorth(object oTarget)
{
  int n;
  object oItem = GetFirstItemInInventory(oTarget);
  while(GetIsObjectValid(oItem))
  {
      n= n + GetGoldPieceValue(oItem);
      oItem = GetNextItemInInventory(oTarget);
  }

  n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget));
  n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_ARROWS, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_BELT, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_BOLTS, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_BOOTS, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_BULLETS, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CLOAK, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_HEAD, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_NECK, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget));
         n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oTarget));

  return n;
}

//DMFI Creates the "settings" creature
void CreateSetting(object oUser)
{
  object oSetting = CreateObject(OBJECT_TYPE_CREATURE, "dmfi_setting", GetLocation(oUser));
  DelayCommand(0.5f, AssignCommand(oSetting, ActionSpeakString(GetLocalString(oUser, "EffectSetting") + " actualmente en " + FloatToString(GetLocalFloat(oUser, GetLocalString(oUser, "EffectSetting"))))));
  SetLocalObject(oSetting, "MyMaster", oUser);
  SetListenPattern(oSetting, "**", 20600); //listen to all text
  SetLocalInt(oSetting, "hls_Listening", 1); //listen to all text
  SetListening(oSetting, TRUE);          //be sure NPC is listening
}

//By OldManWhistler for the DMFI Control Wand
void DestroyAllItems()
{
    if(GetIsDead(OBJECT_SELF))
    {
        object oItem = GetFirstItemInInventory();
        while(GetIsObjectValid(oItem))
        {
            DestroyObject(oItem);
            oItem = GetNextItemInInventory();
        }
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_ARMS)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_BELT)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_BOOTS)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_CARMOUR)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_CHEST)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_CLOAK)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_CWEAPON_B)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_CWEAPON_L)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_CWEAPON_R)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_HEAD)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_LEFTRING)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_NECK)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
            DestroyObject(oItem);
        if(GetIsObjectValid(oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTRING)))
            DestroyObject(oItem);
    }
}

// Function to destroy a target, by OldManWhistler, for the DMFI Control Wand
void DestroyCreature(object oTarget)
{
    AssignCommand(oTarget,SetIsDestroyable(TRUE,FALSE,FALSE));
    DestroyObject(oTarget);
}

//DMFI NPC Control Wand
void DoControlFunction(int iFaction, object oUser)
{
    object oTarget = GetLocalObject(oUser, "dmfi_univ_target");
    object oArea = GetArea(oUser);
    object oChange;
    float fAlignShift;
    int nAlignShift;
    int nReport;
    int nMessage;

    object oAlignTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oUser);

    fAlignShift = GetLocalFloat(oUser, "dmfi_reputation");

    if (fAlignShift == 0.0f)
        fAlignShift = 10.0f;


    nAlignShift = FloatToInt(fAlignShift);

    switch(iFaction)
    {
        case 11: ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);  break;
        case 12: ChangeToStandardFaction(oTarget, STANDARD_FACTION_COMMONER); break;
        case 13: ChangeToStandardFaction(oTarget, STANDARD_FACTION_DEFENDER); break;
        case 14: ChangeToStandardFaction(oTarget, STANDARD_FACTION_MERCHANT); break;
        case 15: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE && !GetIsPC(oChange))
                    ChangeToStandardFaction(oChange, STANDARD_FACTION_HOSTILE);
                  oChange = GetNextObjectInArea(oArea);}break;
        case 16: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE && !GetIsPC(oChange))
                    ChangeToStandardFaction(oChange, STANDARD_FACTION_COMMONER);
                 oChange = GetNextObjectInArea(oArea);}break;
        case 17: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE && !GetIsPC(oChange))
                    ChangeToStandardFaction(oChange, STANDARD_FACTION_DEFENDER);
                oChange = GetNextObjectInArea(oArea);}break;
        case 18: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE && !GetIsPC(oChange))
                    ChangeToStandardFaction(oChange, STANDARD_FACTION_MERCHANT);
                 oChange = GetNextObjectInArea(oArea);}break;
        case 21: oChange = GetFirstPC();
            while (GetIsObjectValid(oChange))
            {   SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 0, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 100, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 100, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 100, oChange);
                oChange = GetNextPC();}break;
        case 22: oChange = GetFirstPC();
            while (GetIsObjectValid(oChange))
            {   SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 20, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 91, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 100, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 50, oChange);
                oChange = GetNextPC();}break;
        case 23: oChange = GetFirstPC();
            while (GetIsObjectValid(oChange))
            {   SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 0 , oChange);
                SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 0, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 0, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 0, oChange);
                oChange = GetNextPC();}break;
        case 24: oChange = GetFirstPC();
            while (GetIsObjectValid(oChange))
            {   SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 100, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 100, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 100, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 100, oChange);
                oChange = GetNextPC();}break;
        case 25: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE){
                SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 0, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 0, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 0, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 0, oChange);}
                oChange = GetNextObjectInArea(oArea);}break;
        case 26: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE){
                AssignCommand(oChange, ClearAllActions(TRUE));
                SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 50, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 50, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 50, oChange);
                SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 50, oChange);}
                oChange = GetNextObjectInArea(oArea);}break;
        case 31: SetLocalObject(oUser, "dmfi_customfaction1", oTarget); nMessage = -1; break;
        case 32: SetLocalObject(oUser, "dmfi_customfaction2", oTarget); nMessage = -1;break;
        case 33: SetLocalObject(oUser, "dmfi_customfaction3", oTarget); nMessage = -1;break;
        case 34: SetLocalObject(oUser, "dmfi_customfaction4", oTarget); nMessage = -1;break;
        case 35: SetLocalObject(oUser, "dmfi_customfaction5", oTarget); nMessage = -1;break;
        case 36: SetLocalObject(oUser, "dmfi_customfaction6", oTarget); nMessage = -1;break;
        case 37: SetLocalObject(oUser, "dmfi_customfaction7", oTarget); nMessage = -1;break;
        case 38: SetLocalObject(oUser, "dmfi_customfaction8", oTarget); nMessage = -1;break;
        case 39: SetLocalObject(oUser, "dmfi_customfaction9", oTarget); nMessage = -1;break;
        case 41: ChangeFaction(oTarget, GetLocalObject(oUser, "dmfi_customfaction1")); nMessage = -1;break;
        case 42: ChangeFaction(oTarget, GetLocalObject(oUser, "dmfi_customfaction2")); nMessage = -1;break;
        case 43: ChangeFaction(oTarget, GetLocalObject(oUser, "dmfi_customfaction3")); nMessage = -1;break;
        case 44: ChangeFaction(oTarget, GetLocalObject(oUser, "dmfi_customfaction4")); nMessage = -1;break;
        case 45: ChangeFaction(oTarget, GetLocalObject(oUser, "dmfi_customfaction5")); nMessage = -1;break;
        case 46: ChangeFaction(oTarget, GetLocalObject(oUser, "dmfi_customfaction6")); nMessage = -1;break;
        case 47: ChangeFaction(oTarget, GetLocalObject(oUser, "dmfi_customfaction7")); nMessage = -1;break;
        case 48: ChangeFaction(oTarget, GetLocalObject(oUser, "dmfi_customfaction8")); nMessage = -1;break;
        case 49: ChangeFaction(oTarget, GetLocalObject(oUser, "dmfi_customfaction9")); nMessage = -1;break;
        case 51: RemoveHenchman(GetMaster(oTarget), oTarget);
                 SetLocalObject(oUser, "dmfi_henchman", oTarget); nMessage = -1;break;
        case 52: RemoveHenchman(oTarget, GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oTarget));
                 AddHenchman(oTarget, GetLocalObject(oUser, "dmfi_henchman")); nMessage = -1;break;
        case 61: AssignCommand(oTarget, ClearAllActions()); AssignCommand(oTarget, ActionMoveAwayFromObject(oUser, TRUE)); nMessage = -1;break;
        case 62: AssignCommand(oTarget, ClearAllActions()); AssignCommand(oTarget, ActionForceMoveToObject(oUser, TRUE, 2.0f, 30.0f)); nMessage = -1;break;
        case 63: AssignCommand(oTarget, ClearAllActions()); AssignCommand(oTarget, ActionRandomWalk());nMessage = -1; break;
        case 64: AssignCommand(oTarget, ClearAllActions()); AssignCommand(oTarget, ActionRest());nMessage = -1; break;
        case 65: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE && !GetIsPC(oChange)){
                    AssignCommand(oChange, ClearAllActions()); AssignCommand(oChange, ActionMoveAwayFromObject(oUser, TRUE));}
                oChange = GetNextObjectInArea(oArea);}nMessage = -1; break;
        case 66: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE && !GetIsPC(oChange)){
                    AssignCommand(oChange, ClearAllActions()); AssignCommand(oChange, ActionForceMoveToObject(oUser, TRUE, 2.0f, 30.0f));}
                oChange = GetNextObjectInArea(oArea);}nMessage = -1; break;
        case 67: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE && !GetIsPC(oChange)){
                    AssignCommand(oChange, ClearAllActions()); AssignCommand(oChange, ActionRandomWalk());}
                oChange = GetNextObjectInArea(oArea);}nMessage = -1; break;
        case 68: oChange = GetFirstObjectInArea(oArea);
            while (GetIsObjectValid(oChange))
            {if (GetObjectType(oChange) == OBJECT_TYPE_CREATURE && !GetIsPC(oChange)){
                    AssignCommand(oChange, ClearAllActions()); AssignCommand(oChange, ActionRest());}
                oChange = GetNextObjectInArea(oArea);} nMessage = -1;break;
        case 69: ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDisappear(), oTarget);
                DestroyObject(oTarget, 1.0); nMessage = -1;break;
        case 70: DestroyCreature(oTarget); nMessage = -1;break;
        case 71: AssignCommand(oTarget, SetIsDestroyable(FALSE, TRUE, TRUE)); nMessage = -1;break;
        case 72: AssignCommand(oTarget, SetIsDestroyable(FALSE, FALSE, TRUE)); nMessage = -1;break;
        case 73: AssignCommand(oTarget, SetIsDestroyable(FALSE, FALSE, FALSE));nMessage = -1; break;
        case 74: AssignCommand(oTarget, SetIsDestroyable(TRUE, FALSE, FALSE));nMessage = -1; break;
        case 75: AssignCommand(oTarget, SetIsDestroyable(FALSE, TRUE, TRUE));
            DelayCommand(0.1, AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeath(), oTarget))); nMessage = -1;break;
        case 76: AssignCommand(oTarget, SetIsDestroyable(FALSE, FALSE, TRUE));
            DelayCommand(0.1, AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeath(), oTarget))); nMessage = -1;break;
        case 77: AssignCommand(oTarget, SetIsDestroyable(FALSE, FALSE, FALSE));
            DelayCommand(0.1, AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeath(), oTarget))); nMessage = -1;break;
        case 78: AssignCommand(oTarget, SetIsDestroyable(TRUE, FALSE, FALSE));
            DelayCommand(0.1, AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeath(), oTarget)));nMessage = -1; break;
        case 79: AssignCommand(oTarget, DestroyAllItems());
            DelayCommand(1.0, DestroyCreature(oTarget));nMessage = -1;break;
        case 81:  //AdjustReputation(oAlignTarget, oTarget, nAlignShift);
                  AdjustReputation(oTarget, oAlignTarget, nAlignShift);
                  nReport = GetReputation(oAlignTarget, oTarget);
                  FloatingTextStringOnCreature("Actual Reputacion: "+ GetName(oTarget) + " vs. " +GetName(oAlignTarget)+": " + IntToString(nReport), oUser);
                  nReport = GetReputation(oTarget, oAlignTarget);
                  FloatingTextStringOnCreature("Actual Reputacion: "+ GetName(oAlignTarget) + " vs. " +GetName(oTarget)+": " + IntToString(nReport), oUser);
                  break;
        case 82:  //AdjustReputation(oAlignTarget, oTarget, -nAlignShift);
                  AdjustReputation(oTarget, oAlignTarget, -nAlignShift);
                  nReport = GetReputation(oAlignTarget, oTarget);
                  FloatingTextStringOnCreature("Actual Reputacion: "+ GetName(oTarget) + " vs. " +GetName(oAlignTarget)+": " + IntToString(nReport), oUser);
                  nReport = GetReputation(oTarget, oAlignTarget);
                  FloatingTextStringOnCreature("Actual Reputacion: "+ GetName(oAlignTarget) + " vs. " +GetName(oTarget)+": " + IntToString(nReport), oUser);
                  break;
        case 83:  SetLocalString(oUser, "EffectSetting", "dmfi_reputaion");
                  CreateSetting(oUser);nMessage = -1; break;
        case 84:  nReport = GetReputation(oAlignTarget, oTarget);
                  FloatingTextStringOnCreature("Actual Reputacion: "+ GetName(oTarget) + " vs. " +GetName(oAlignTarget)+": " + IntToString(nReport), oUser);
                  nReport = GetReputation(oTarget, oAlignTarget);
                  FloatingTextStringOnCreature("Actual Reputacion: "+ GetName(oAlignTarget) + " vs. " +GetName(oTarget)+": " + IntToString(nReport), oUser);
                  nMessage = -1;break;
        case 9:  {
                    if (GetLocalInt(GetModule(), "dmfi_safe_factions")!=1)
                        {
                        SetLocalInt(GetModule(), "dmfi_safe_factions", 1);
                        SetCampaignInt("dmfi", "dmfi_safe_factions", 1, oUser);
                        FloatingTextStringOnCreature("Facion no hostil por defecto deberia ignorar los ataques del PJs",oUser, FALSE);
                        }
                        else
                        {
                        SetLocalInt(GetModule(), "dmfi_safe_factions", 0);
                        SetCampaignInt("dmfi", "dmfi_safe_factions", 0, oUser);
                        FloatingTextStringOnCreature("Bioware faccion restaurada",oUser, FALSE);
                        }
                   }

        default: nMessage = -1;break;
    }

    if (nMessage!=-1)
    {
    if (GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS))
       FloatingTextStringOnCreature("La criatura es inmune a ceguera - no ocurriran ataques", oUser);
    else
        {
        effect eInvis =EffectBlindness();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, 6.1);
        FloatingTextStringOnCreature("Faccion Ajustada - Percepcion se activara en 6 segundos", oUser);
        }
    }
}

void IdenStuff(object oTarget)
{
   object oItem = GetFirstItemInInventory(oTarget);
   while(GetIsObjectValid(oItem))
   {
      if (GetIdentified(oItem)==FALSE)
            SetIdentified(oItem, TRUE);

      oItem = GetNextItemInInventory(oTarget);
   }
}

void TakeStuff(int Level, object oTarget, object oUser)
   {
   object oItem = GetFirstItemInInventory(oTarget);
   while(GetIsObjectValid(oItem))
   {
      DestroyObject(oItem);
      oItem = GetNextItemInInventory(oTarget);
   }

    if (Level == 1)
        {
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARMS,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARROWS,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_BELT,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_BOLTS,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_BOOTS,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_BULLETS,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_CLOAK,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_HEAD,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTRING,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_NECK,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oTarget));
        }
FloatingTextStringOnCreature("Intervencion de DM: Inventario Destruido por DM", oTarget);
}

void TakeUber(object oTarget)
{
    int nMultiplier;
    if (GetHitDice(oTarget)<11)
        nMultiplier = 1;
        else if (GetHitDice(oTarget)<16)
            nMultiplier = 2;
            else if (GetHitDice(oTarget)<20)
                nMultiplier = 3;
                else
                    nMultiplier = 5;
   object oItem = GetFirstItemInInventory(oTarget);
   while(GetIsObjectValid(oItem))
   {
      if (GetGoldPieceValue(oItem)>1000*nMultiplier*GetHitDice(oTarget))
                DestroyObject(oItem);
      oItem = GetNextItemInInventory(oTarget);
   }
FloatingTextStringOnCreature("DM Intervencion: Objetos magicos han sido eliminados", oTarget);
}

void DMFI_Object (object oTarget, int Action, object oUser)
    {
    location lLocation = GetLocation (oTarget);
    if (GetObjectType(oTarget) != OBJECT_TYPE_PLACEABLE)
            {
            oTarget = GetNearestObject(OBJECT_TYPE_PLACEABLE, oUser);
            FloatingTextStringOnCreature("El objetivo no era un ubicado, usa los más cercanos a tu avatar.", oUser);
            }
    if (GetIsObjectValid(oTarget))
       {
       if (Action==1)
              {
              DestroyObject(oTarget);
              DelayCommand(2.0, FloatingTextStringOnCreature(GetName(oTarget) + "destruido. Si es estático, debes abandonar y volver para ver el efecto.", oUser));
              }
       else if (Action ==2)
                    {
                    AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
                    DelayCommand(0.4,SetPlaceableIllumination(oTarget, FALSE));
                    DelayCommand(0.5,RecomputeStaticLighting(GetArea(oTarget)));
                    }
       else if (Action ==3)
                    {
                    AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
                    DelayCommand(0.4,SetPlaceableIllumination(oTarget, TRUE));
                    DelayCommand(0.5,RecomputeStaticLighting(GetArea(oTarget)));
                    }
       }
     }

void dmwand_SwapDayNight(int nDay)
{
   int nCurrentHour;
   int nCurrentMinute = GetTimeMinute();
   int nCurrentSecond = GetTimeSecond();
   int nCurrentMilli = GetTimeMillisecond();

   nCurrentHour = ((nDay == 1)?7:19);

   SetTime(nCurrentHour, nCurrentMinute, nCurrentSecond, nCurrentMilli);
}

void dmwand_AdvanceTime(int nHours)
{
   int nCurrentHour = GetTimeHour();
   int nCurrentMinute = GetTimeMinute();
   int nCurrentSecond = GetTimeSecond();
   int nCurrentMilli = GetTimeMillisecond();

   nCurrentHour += nHours;
   SetTime(nCurrentHour, nCurrentMinute, nCurrentSecond, nCurrentMilli);
}

void DMFI_Align(object oUser, object oTarget, int nAlign, int nParty)
{
if (GetObjectType(oTarget)== OBJECT_TYPE_CREATURE)
    {
    int nAmount = GetLocalInt(oUser, "dmfi_alignshift");

    if (nParty)
        {
        object oParty = GetFirstFactionMember(oTarget, TRUE);
        while (GetIsObjectValid(oParty))
            {
            AdjustAlignment(oParty, nAlign, nAmount);
            oParty = GetNextFactionMember(oTarget, TRUE);
            }
        FloatingTextStringOnCreature("Alineamiento del grupo cambiado en " + IntToString(nAmount), oUser);
        }
    else
        {
        AdjustAlignment(oTarget, nAlign, nAmount);
        FloatingTextStringOnCreature("Alineamiento del grupo cambiado en " + IntToString(nAmount), oUser);
        }
    }
else
     FloatingTextStringOnCreature("Debes apuntar a una criatura", oUser);

}

void DMFI_Roll(object oUser)
    {
    object oStoreState = GetItemPossessedBy(oUser, "dmfi_dmw");
    int n = GetLocalInt(oUser, "dmfi_alignshift");
                if (n == 1)
                    n = 2;
                else if (n ==2)
                    n = 5;
                else if (n ==5)
                   n = 10;
                else if (n == 10)
                   n = 1;
                FloatingTextStringOnCreature("Ajuste cambiado por " + IntToString(n), oUser);
                SetLocalInt(oUser, "dmfi_alignshift", n);
                SetCustomToken(20781, IntToString(n));
                SetCampaignInt("dmfi", "dmfi_alignshift", n, oUser);
     }


int GetAreaXAxis(object oArea)
{

    location locTile;
    int iX = 0;
    int iY = 0;
    vector vTile = Vector(0.0, 0.0, 0.0);

    for (iX = 0; iX < 32; ++iX)
    {
        vTile.x = IntToFloat(iX);
        locTile = Location(oArea, vTile, 0.0);
        int iRes = GetTileMainLight1Color(locTile);
        if (iRes > 32 || iRes < 0)
            return(iX);
    }

    return 32;
}

int GetAreaYAxis(object oArea)
{
    location locTile;
    int iX = 0;
    int iY = 0;
    vector  vTile = Vector(0.0, 0.0, 0.0);

    for (iY = 0; iY < 32; ++iY)
    {
        vTile.y = IntToFloat(iY);
        locTile = Location(oArea, vTile, 0.0);
        int iRes = GetTileMainLight1Color(locTile);
        if (iRes > 32 || iRes < 0)
            return(iY);
    }

    return 32;
}


void TilesetMagic(object oUser, int nEffect, int nType)
{
int iXAxis = GetAreaXAxis(GetArea(oUser));
int iYAxis = GetAreaYAxis(GetArea(oUser));
int nBase = GetLocalInt(GetModule(), "dmfi_tileset");

// nType definitions:
// 0 fill
// 1 flood
// 2 groundcover

// nBase definitions:
// 0 default
// 1 Sewer and City - raise the fill effect to -0.1

float ZEffectAdjust = 0.0;
float ZTypeAdjust = 0.1; //default is groundcover
float ZTileAdjust = 0.0;
float ZFinalAxis;

/*
if (nEffect == X2_TL_GROUNDTILE_ICE)
    ZEffectAdjust = -1.0;  // lower the effect based on trial and error
*/
if (nEffect == X2_TL_GROUNDTILE_SEWER_WATER)
    ZEffectAdjust = 0.8;

//now sep based on nType
if (nType == 0)  //fill
    ZTypeAdjust=-2.0;
else if (nType ==1)
    ZTypeAdjust = 2.0;
ZFinalAxis = ZEffectAdjust + ZTypeAdjust + ZTileAdjust;

//special case for filling of water and sewer regions
if ((nBase==1) && (nType==0))
    ZFinalAxis = -0.1;

TLResetAreaGroundTiles(GetArea(oUser), iXAxis, iYAxis);
TLChangeAreaGroundTiles(GetArea(oUser), nEffect , iXAxis, iYAxis, ZFinalAxis);
}


//New DM Wand by Demetrious
void DoNewDMThingy(int iChoice, object oUser)
    {
    location lLocation = GetLocalLocation(oUser, "dmfi_univ_location");
    object oTarget = GetLocalObject(oUser, "dmfi_univ_target");
    int iXAxis = GetAreaXAxis(GetArea(oUser));
    int iYAxis = GetAreaYAxis(GetArea(oUser));
    object oCopy; object oParty;
    int n; string sName;

     switch (iChoice)
     {
     case 11: TakeStuff(1, oTarget, oUser); break;
     case 12: TakeStuff(0, oTarget, oUser); break;
     case 13: IdenStuff(oTarget); break;
     case 14: TakeUber(oTarget); break;
     case 15: DMFI_NextTarget(oTarget, oUser);break;
     case 20: DMFI_NextTarget(oTarget, oUser);break;
     case 21: DMFI_Align(oUser, oTarget, ALIGNMENT_GOOD, 0);break;
     case 22: DMFI_Align(oUser, oTarget, ALIGNMENT_EVIL, 0);break;
     case 23: DMFI_Align(oUser, oTarget, ALIGNMENT_LAWFUL, 0);break;
     case 24: DMFI_Align(oUser, oTarget, ALIGNMENT_CHAOTIC, 0);break;
     case 25: DMFI_Align(oUser, oTarget, ALIGNMENT_GOOD, 1);break;
     case 26: DMFI_Align(oUser, oTarget, ALIGNMENT_EVIL, 1);break;
     case 27: DMFI_Align(oUser, oTarget, ALIGNMENT_LAWFUL, 1);break;
     case 28: DMFI_Align(oUser, oTarget, ALIGNMENT_CHAOTIC, 1);break;
     case 29: DMFI_Roll(oUser); break;
     case 31:   SendMessageToPC(oUser, "Item name: "+GetName(oTarget));
                SendMessageToPC(oUser, "Item value: "+IntToString(GetGoldPieceValue(oTarget)));
                if (GetDroppableFlag(oTarget)) SendMessageToPC(oUser, "Droppable");
                    else SendMessageToPC(oUser, "No soltable");
                if (GetItemCursedFlag(oTarget)) SendMessageToPC(oUser, "Cursed");
                    else SendMessageToPC(oUser, "No maldito");
                if (GetPlotFlag(oTarget)) SendMessageToPC(oUser, "Plot related");
                    else SendMessageToPC(oUser, "No es de trama");
                if (GetStolenFlag(oTarget)) SendMessageToPC(oUser, "Stolen");
                    else SendMessageToPC(oUser, "No robado");
                SendMessageToPC(oUser, "Cargas restantes: " + IntToString(GetItemCharges(oTarget)));
                break;

     case 32: if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)
                {
                SetPlotFlag(oTarget, FALSE); DestroyObject(oTarget);
                FloatingTextStringOnCreature(GetName(oTarget)+": Objeto destruido", oUser);
                }
              else
                 {
                 FloatingTextStringOnCreature("Objetivo Invalido. Apunta al objetivo directamente de la pantalla de inventario", oUser);
                 }
                 break;
    case 33: if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)
                {
                SetItemCharges(oTarget, 0);
                FloatingTextStringOnCreature( GetName(oTarget)+": Cargas restantes eliminadas", oUser);
                }
                else
                 {
                 FloatingTextStringOnCreature("Objetivo Invalido. Apunta al objetivo directamente de la pantalla de inventario", oUser);
                 }
                 break;


     case 34: if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)
                {
                SetItemCharges(oTarget, 999);
                FloatingTextStringOnCreature( GetName(oTarget)+": Objeto recargado al maximo",oUser); break;
                }
                else
                 {
                 FloatingTextStringOnCreature("Objetivo Invalido. Apunta al objetivo directamente de la pantalla de inventario", oUser);
                 }
                 break;

     case 35: if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)
                {
                if (GetDroppableFlag(oTarget))
                    {
                    SetDroppableFlag(oTarget, FALSE);
                    FloatingTextStringOnCreature(GetName(oTarget)+": NO puede ser dejado", oUser);
                    }
                    else
                    {
                    SetDroppableFlag(oTarget, TRUE);
                    FloatingTextStringOnCreature( GetName(oTarget)+": puede ser dejado", oUser);
                    }
                 }
                 else
                 {
                 FloatingTextStringOnCreature("Objetivo Invalido. Apunta al objetivo directamente de la pantalla de inventario", oUser);
                 }
                 break;

     case 36:   if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)
                {
                if (GetItemCursedFlag(oTarget))
                    {
                    SetItemCursedFlag(oTarget, FALSE);
                    FloatingTextStringOnCreature(GetName(oTarget)+": NO maldito", oUser);
                    }
                    else
                    {
                    SetItemCursedFlag(oTarget, TRUE);
                    FloatingTextStringOnCreature( GetName(oTarget)+": esta MALDITO", oUser);
                    }
                 }
                 else
                 {
                 FloatingTextStringOnCreature("Objetivo Invalido. Apunta al objetivo directamente de la pantalla de inventario", oUser);
                 }
                 break;

      case 37:  if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)
                {
                if (GetPlotFlag(oTarget))
                    {
                    SetPlotFlag(oTarget, FALSE);
                    FloatingTextStringOnCreature(GetName(oTarget)+": NO es de trama", oUser);
                    }
                    else
                    {
                    SetPlotFlag(oTarget, TRUE);
                    FloatingTextStringOnCreature( GetName(oTarget)+": es de TRAMA", oUser);
                    }
                 }
                 else
                 {
                 FloatingTextStringOnCreature("Objetivo Invalido. Apunta al objetivo directamente de la pantalla de inventario", oUser);
                 }
                 break;
     case 38:   if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)
                {
                if (GetStolenFlag(oTarget))
                    {
                    SetStolenFlag(oTarget, FALSE);
                    FloatingTextStringOnCreature(GetName(oTarget)+": NO robado", oUser);
                    }
                    else
                    {
                    SetStolenFlag(oTarget, TRUE);
                    FloatingTextStringOnCreature( GetName(oTarget)+": es robado", oUser);
                    }
                 }
                 else
                 {
                 FloatingTextStringOnCreature("Objetivo Invalido. Apunta al objetivo directamente de la pantalla de inventario", oUser);
                 }
                 break;


     case 41: DMFI_Object(oTarget, 1, oUser); break;
     case 42: DMFI_Object(oTarget, 2, oUser);break;
     case 43: DMFI_Object(oTarget, 3, oUser); break;
     case 51: dmwand_AdvanceTime(1);break;
     case 52: dmwand_AdvanceTime(4);break;
     case 53: dmwand_AdvanceTime(8);break;
     case 54: dmwand_AdvanceTime(24);break;
     case 55: dmwand_SwapDayNight(0);break;
     case 50: dmwand_SwapDayNight(1);break;
     case 56: SetWeather(GetArea(oUser), WEATHER_CLEAR); break;
     case 57: SetWeather(GetArea(oUser), WEATHER_RAIN); break;
     case 58: SetWeather(GetArea(oUser), WEATHER_SNOW); break;
     case 59: SetWeather(GetArea(oUser), WEATHER_USE_AREA_SETTINGS); break;
     case 60: SendMessageToPC(oUser, GetName(oTarget) +" tiene objetos por valor de " + IntToString(DMFI_GetNetWorth(oTarget)) + " monedas y tiene" + IntToString(GetGold(oTarget)) +" piezas de oro.");break;
     case 61: DMFI_toad(oTarget, oUser); break;
     case 62: DMFI_untoad(oTarget, oUser); break;
     case 63: AssignCommand(oUser, AddToParty( oUser, GetFactionLeader(oTarget)));break;
     case 64: RemoveFromParty(oUser);break;
     case 65: ExploreAreaForPlayer(GetArea(oTarget), oTarget); FloatingTextStringOnCreature("Mapa : Objetivo", oUser);break;
     case 66: {
                FloatingTextStringOnCreature("Mapa : Grupo", oUser);
                object oParty = GetFirstFactionMember(oTarget,TRUE);
                while (GetIsObjectValid(oParty))
                    {
                    ExploreAreaForPlayer(GetArea(oTarget), oTarget);
                    oParty = GetNextFactionMember(oTarget,TRUE);
                    }
     break;
     }
     case 67: ExportAllCharacters();break;
     case 68: dmwand_KickPC(oTarget, oUser);break;
     case 69: sName = GetModuleName();
                StartNewModule(sName);break;
     case 71: TilesetMagic(oUser, X2_TL_GROUNDTILE_WATER, 0);break;
     case 72: TilesetMagic(oUser, X2_TL_GROUNDTILE_ICE, 0);break;
     case 73: TilesetMagic(oUser, X2_TL_GROUNDTILE_LAVA, 0) ;break;
     case 74: TilesetMagic(oUser, X2_TL_GROUNDTILE_SEWER_WATER, 0);break;
     case 75: TilesetMagic(oUser, X2_TL_GROUNDTILE_WATER, 1);break;
     case 76: TilesetMagic(oUser, X2_TL_GROUNDTILE_ICE, 1);break;
     case 77: TilesetMagic(oUser, X2_TL_GROUNDTILE_LAVA, 1) ;break;
     case 78: TilesetMagic(oUser, X2_TL_GROUNDTILE_SEWER_WATER, 1);break;
     case 79: TLResetAreaGroundTiles(GetArea(oUser), iXAxis, iYAxis); break;
     case 81: TilesetMagic(oUser, X2_TL_GROUNDTILE_ICE, 2);break;
     case 82: TilesetMagic(oUser, X2_TL_GROUNDTILE_GRASS, 2);break;
     case 83: TilesetMagic(oUser, X2_TL_GROUNDTILE_CAVEFLOOR, 2) ;break;
     case 89: TLResetAreaGroundTiles(GetArea(oUser), iXAxis, iYAxis); break;
     case 91: StoreCampaignObject("dmfi", "dmfi_copyplayer1", oTarget);
              FloatingTextStringOnCreature("Objetivo Guardado", oUser);break;
     case 92:   oParty = GetFirstFactionMember(oTarget, TRUE);
                n=1;
                while (GetIsObjectValid(oParty))
                    {
                    StoreCampaignObject("dmfi", "dmfi_copyplayer"+IntToString(n), oParty);
                    SendMessageToPC(oUser, GetName(oParty) + " guardado");
                    n=n+1;
                    oParty = GetNextFactionMember(oTarget, TRUE);
                    }
                FloatingTextStringOnCreature("grupo grabado", oUser);
                break;

     case 93:n=1;
            oCopy = RetrieveCampaignObject("dmfi", "dmfi_copyplayer"+IntToString(n), lLocation);
            while (GetIsObjectValid(oCopy))
                {
                ChangeToStandardFaction(oCopy, STANDARD_FACTION_COMMONER);
                n=n+1;
                oCopy = RetrieveCampaignObject("dmfi", "dmfi_copyplayer"+IntToString(n), lLocation);
                }
            break;
     case 101: SetLocalInt(GetModule(), "dmfi_tileset" , 0);   break;
     case 102: SetLocalInt(GetModule(), "dmfi_tileset" , 1);  break; //sewer/city

     default: break;
     }

}

void DoOneRingFunction(int iRing, object oUser)
{
    switch(iRing)
    {
        case 1: SetLocalString(oUser, "dmfi_univ_conv", "afflict"); break;
        case 2: SetLocalString(oUser, "dmfi_univ_conv", "faction"); break;
        case 3: SetLocalString(oUser, "dmfi_univ_conv", "dicebag"); break;
        case 4: SetLocalString(oUser, "dmfi_univ_conv", "dmw"); break;
        case 5: SetLocalString(oUser, "dmfi_univ_conv", "emote"); break;
        case 6: SetLocalString(oUser, "dmfi_univ_conv", "encounter"); break;
        case 7: SetLocalString(oUser, "dmfi_univ_conv", "fx"); break;
        case 8: SetLocalString(oUser, "dmfi_univ_conv", "music"); break;
        case 91: SetLocalString(oUser, "dmfi_univ_conv", "sound"); break;
        case 92: SetLocalString(oUser, "dmfi_univ_conv", "voice"); break;
        case 93: SetLocalString(oUser, "dmfi_univ_conv", "xp"); break;
        case 94: SetLocalString(oUser, "dmfi_univ_conv", "buff");break;
        default: SetLocalString(oUser, "dmfi_univ_conv", "dmw"); break;
    }
    AssignCommand(oUser, ClearAllActions());
    AssignCommand(oUser, ActionStartConversation(OBJECT_SELF, "dmfi_universal", TRUE));
}

//This function is for the DMFI Sound FX Wand
void DoSoundFunction(int iSound, object oUser)
{

    location lLocation = GetLocalLocation(oUser, "dmfi_univ_location");
    float fDuration;
    float fDelay;
    object oTarget;

    fDuration = GetLocalFloat(oUser, "dmfi_effectduration");
    fDelay = GetLocalFloat(oUser, "dmfi_sound_delay");

    switch(iSound)
    {
        case 11: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_batsflap1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 12: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_bugsscary1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 13: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_crptvoice1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 14: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_orcgrunt1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 15: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_cv_minepick2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 16: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_ratssqeak1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 17: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_na_rockfallg1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 18: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_na_rockfalgl2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 19: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_wt_gustcavrn1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 21: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_cv_belltower3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 22: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_cv_claybreak3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 23: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_cv_glasbreak2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 24: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_cv_gongring3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 25: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_marketgrp4"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 26: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_cv_millwheel1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 27: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_cv_sawing1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 28: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_cv_bellwind1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 29: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_cv_smithhamr2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 31: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_na_firelarge1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 32: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_na_lavapillr1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 33: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_na_lavafire1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 34: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_na_firelarge2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 35: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_na_surf2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 36: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_na_drips1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 37: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_na_waterlap1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 38: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_na_stream4"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 39: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_na_waterfall2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 41: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_crynight3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 42: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_na_bushmove1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 43: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_birdsflap2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 44: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_na_grassmove3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 45: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_hawk1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 46: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_na_leafmove3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 47: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_gulls2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 48: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_songbirds1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 49: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_an_toads1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 51: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_mg_beaker1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 52: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_mg_cauldron1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 53: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_mg_chntmagic1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 54: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_mg_crystalev1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 55: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_mg_crystalic1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 56: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("al_mg_portal1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 57: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_mg_telepin1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 58: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_mg_telepout1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 59: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_mg_frstmagic1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 61: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_tavclap1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 62: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_battlegrp7"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 63: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_laughincf2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 64: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_comtntgrp3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 65: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_chantingm2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 66: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_cryingf2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 67: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_laughingf3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 68: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_chantingf2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 69: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_wailingm6"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 71: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_evilchantm"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 72: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_crows2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 73: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_wailingcf1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 74: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_crptvoice2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 75: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_lafspook2"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 76: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_owlhoot1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 77: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_an_wolfhowl1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 78: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_screamf3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 79: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_pl_zombiem3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 81: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_wt_gustsoft1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 82: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_wt_thundercl3"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 83: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_wt_thunderds4"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;
        case 84: oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLocation); DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("as_wt_gusforst1"))); DelayCommand(20.0f, DestroyObject(oTarget)); break;

        //Settings
        case 91:
        SetLocalString(oUser, "EffectSetting", "dmfi_effectduration");
        CreateSetting(oUser);
        break;
        case 92:
        SetLocalString(oUser, "EffectSetting", "dmfi_sound_delay");
        CreateSetting(oUser);
        break;
        case 93:
        SetLocalString(oUser, "EffectSetting", "dmfi_beamduration");
        CreateSetting(oUser);
        break;
        case 94: //Change Day Music
        iDayMusic = MusicBackgroundGetDayTrack(GetArea(oUser)) + 1;
        if (iDayMusic > 33) iDayMusic = 49;
        if (iDayMusic > 55) iDayMusic = 1;
        MusicBackgroundStop(GetArea(oUser));
        MusicBackgroundChangeDay(GetArea(oUser), iDayMusic);
        MusicBackgroundPlay(GetArea(oUser));
        break;
        case 95: //Change Night Music
        iNightMusic = MusicBackgroundGetDayTrack(GetArea(oUser)) + 1;
        if (iNightMusic > 33) iNightMusic = 49;
        if (iNightMusic > 55) iNightMusic = 1;
        MusicBackgroundStop(GetArea(oUser));
        MusicBackgroundChangeNight(GetArea(oUser), iNightMusic);
        MusicBackgroundPlay(GetArea(oUser));
        break;
        case 96: //Play Background Music
        MusicBackgroundPlay(GetArea(oUser));
        break;
        case 97: //Stop Background Music
        MusicBackgroundStop(GetArea(oUser));
        break;
        case 98: //Change and Play Battle Music
        iBattleMusic = MusicBackgroundGetBattleTrack(GetArea(oUser)) + 1;
        if (iBattleMusic < 34 || iBattleMusic > 48) iBattleMusic = 34;
        MusicBattleStop(GetArea(oUser));
        MusicBattleChange(GetArea(oUser), iBattleMusic);
        MusicBattlePlay(GetArea(oUser));
        break;
        case 99: //Stop Battle Music
        MusicBattleStop(GetArea(oUser));
        break;

        default: break;
    }
return;
}

//This function is for the DMFI DM Voice
void DoVoiceFunction(int iSay, object oUser)
{
    object oMod = GetModule();
    object oTarget = GetLocalObject(oUser, "dmfi_univ_target");
    location lLocation = GetLocalLocation(oUser, "dmfi_univ_location");
    object oVoice;
    string sSay;

    // Invalid target code - Loiter mode
    if (!GetIsObjectValid(oTarget))
    {
        switch (iSay)
        {
            // DM Spy Functionality - Currently BROKEN
            case 8: SetCampaignInt("dmfi", "dmfi_DMSpy", abs(GetCampaignInt("dmfi", "dmfi_DMSpy", oUser) - 1), oUser);
                if (GetCampaignInt("dmfi", "dmfi_DMSpy", oUser) == 1)
                     FloatingTextStringOnCreature("DM Spy esta on.", oUser, FALSE);
                else
                     FloatingTextStringOnCreature("DM Spy esta off.", oUser, FALSE);
                break;

            // Create a Ditto Voice
            case 9: //Destroy any existing Voice attached to the user
                if (GetIsObjectValid(GetLocalObject(oUser, "dmfi_MyVoice")))
                {
                    DestroyObject(GetLocalObject(oUser, "dmfi_MyVoice"));
                    DeleteLocalObject(oUser, "dmfi_MyVoice");
                    FloatingTextStringOnCreature("Has destruido tu voz previa", oUser, FALSE);
                }
                //Create the Voice
                oVoice = CreateObject(OBJECT_TYPE_CREATURE, "dmfi_voice", lLocation);
                //Sets the Voice as the object to throw to.
                SetLocalObject(oUser, "dmfi_VoiceTarget", oVoice);
                //Set Ownership of the Voice to the User
                SetLocalObject(oUser, "dmfi_MyVoice", oVoice);
                DelayCommand(1.0f, FloatingTextStringOnCreature("La Voz esta operativa", oUser, FALSE));
                break;

            // Create a Loiter Voice
            default: oVoice = CreateObject(OBJECT_TYPE_CREATURE, "dmfi_voice", lLocation);

                SetLocalInt(oVoice, "dmfi_Loiter", 1);
                SetLocalString(oVoice, "dmfi_LoiterSay", GetCampaignString("dmfi", "hls206" + IntToString(iSay)));
                break;
        }
    }

    // You targetted yourself = Record Mode
    else if (oTarget == oUser)
    {
        switch (iSay)
        {
            // Toggle the mute / unmute NPC function
            case 8: SetCampaignInt("dmfi", "dmfi_AllMute", abs(GetCampaignInt("dmfi", "dmfi_AllMute") - 1));
                    if (GetCampaignInt("dmfi", "dmfi_AllMute") == 1)
                        FloatingTextStringOnCreature("Todas las conversaciones pnjs son silenciadas", oUser, FALSE);
                    else
                        FloatingTextStringOnCreature("Todas las conversaciones de pnjs no estan silenciadas", oUser, FALSE);
                    break;

            // Create a Ditto Voice - Duplicate functionality
            case 9: //Destroy any existing Voice attached to the user
                if (GetIsObjectValid(GetLocalObject(oUser, "dmfi_MyVoice")))
                {
                    DestroyObject(GetLocalObject(oUser, "dmfi_MyVoice"));
                    DeleteLocalObject(oUser, "dmfi_MyVoice");
                    FloatingTextStringOnCreature("Has destrudio tu Voz previa", oUser, FALSE);
                }
                //Create the Voice
                oVoice = CreateObject(OBJECT_TYPE_CREATURE, "dmfi_voice", lLocation);

                SetLocalObject(oUser, "dmfi_VoiceTarget", oVoice);
                //Set Ownership of the Voice to the User
                SetLocalObject(oUser, "dmfi_MyVoice", oVoice);
                DelayCommand(1.0f, FloatingTextStringOnCreature("La Voz esta operativa", oUser, FALSE));
                break;
            default: FloatingTextStringOnCreature("Preparado para grabar nueva frase", oUser, FALSE);
                     SetLocalInt(oUser, "hls_EditPhrase", 20600 + iSay); break;
        }
    }

    // You targeted an NPC or Object - Say Something!
    else
    {
        switch (iSay)
        {
            // Toggle a SINGLE NPC mute / unmute function
            case 8: SetLocalInt(oTarget, "dmfi_Mute", abs(GetLocalInt(oTarget, "dmfi_Mute") - 1));

            // Set a Single NPC to listen and make it your target - VOICE WIDGET FUNCTION
            case 9: SetLocalObject(oUser, "dmfi_VoiceTarget", oTarget);
                if(!GetIsPC(oTarget))
                {
                FloatingTextStringOnCreature(GetName(oTarget) + " is listening", oUser, FALSE);
                SetListenPattern(oTarget, "**", 20600); //listen to all text
                SetLocalInt(oTarget, "hls_Listening", 1); //listen to all text
                SetListening(oTarget, TRUE);      //be sure NPC is listening
                }
                //You Targetted a PC - make a voice follow that sucker and listen.
                else
                {
                //delete any valid following voices to stop duplicates
                if (GetIsObjectValid(GetLocalObject(oTarget, "dmfi_VoiceFollow")))
                    {
                    DestroyObject(GetLocalObject(oUser, "dmfi_VoiceFollow"));
                    FloatingTextStringOnCreature("La anterior voz de este caracter fue destruida", oUser, FALSE);
                    }

                //Create the Voice
                oVoice = CreateObject(OBJECT_TYPE_CREATURE, "dmfi_voice", lLocation);
                //Sets the Voice as the object to throw to.
                DelayCommand(2.0, SetLocalObject(oTarget, "dmfi_VoiceFollow", oVoice)); //only set this for finding a duplicate later
                DelayCommand(2.0, SetLocalObject(oVoice, "dmfi_follow", oTarget));  //set up the player as something to follow
                DelayCommand(1.0f, FloatingTextStringOnCreature("La voz seguira y escuchara a " +GetName(oTarget), oUser, FALSE));
                }
                break;

            default: sSay = GetCampaignString("dmfi", "hls206" + IntToString(iSay));
            AssignCommand(oTarget, SpeakString(sSay)); break;
        }
    }
}
//This function is for the DMFI Affliction Wand
void ReportImmunity(object oT, object oUser)
{
SendMessageToPC(oUser, "Immunidades reporte: (en blanco si no tiene)");
if (GetIsImmune(oT, IMMUNITY_TYPE_ABILITY_DECREASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Decrementar Habilidad");
if (GetIsImmune(oT, IMMUNITY_TYPE_AC_DECREASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Decrementar CA");
if (GetIsImmune(oT, IMMUNITY_TYPE_ATTACK_DECREASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Decrementar Ataque");
if (GetIsImmune(oT, IMMUNITY_TYPE_BLINDNESS))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Ceguera");
if (GetIsImmune(oT, IMMUNITY_TYPE_CHARM))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Calma");
if (GetIsImmune(oT, IMMUNITY_TYPE_CONFUSED))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Confusion");
if (GetIsImmune(oT, IMMUNITY_TYPE_CRITICAL_HIT))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Golpe Critico");
if (GetIsImmune(oT, IMMUNITY_TYPE_CURSED))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Maldicion");
if (GetIsImmune(oT, IMMUNITY_TYPE_DAMAGE_DECREASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Decrementar Daño");
if (GetIsImmune(oT, IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Decrementar Inmunidad daño");
if (GetIsImmune(oT, IMMUNITY_TYPE_DAZED))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Aturdir");
if (GetIsImmune(oT, IMMUNITY_TYPE_DEAFNESS))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Sordera");
if (GetIsImmune(oT, IMMUNITY_TYPE_DEATH))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Muerte");
if (GetIsImmune(oT, IMMUNITY_TYPE_DISEASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Enfermedad");
if (GetIsImmune(oT, IMMUNITY_TYPE_DOMINATE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Dominar");
if (GetIsImmune(oT, IMMUNITY_TYPE_ENTANGLE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Inmobilizar");
if (GetIsImmune(oT, IMMUNITY_TYPE_FEAR))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Miedo");
if (GetIsImmune(oT, IMMUNITY_TYPE_KNOCKDOWN))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Derribo");
if (GetIsImmune(oT, IMMUNITY_TYPE_MIND_SPELLS))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Enajenadores");
if (GetIsImmune(oT, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Decrementar Velocidad");
if (GetIsImmune(oT, IMMUNITY_TYPE_NEGATIVE_LEVEL))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Nivel Negativo");
if (GetIsImmune(oT, IMMUNITY_TYPE_PARALYSIS))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Paralisis");
if (GetIsImmune(oT, IMMUNITY_TYPE_POISON))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Veneno");
if (GetIsImmune(oT, IMMUNITY_TYPE_SAVING_THROW_DECREASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Decrementar Tiradas de Salvacion");
if (GetIsImmune(oT, IMMUNITY_TYPE_SILENCE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Silencio");
if (GetIsImmune(oT, IMMUNITY_TYPE_SKILL_DECREASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Decrementar Habilidad");
if (GetIsImmune(oT, IMMUNITY_TYPE_SLEEP))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Dormir");
if (GetIsImmune(oT, IMMUNITY_TYPE_SLOW))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Ralentizar");
if (GetIsImmune(oT, IMMUNITY_TYPE_SNEAK_ATTACK))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Ataque Furtivo");
if (GetIsImmune(oT, IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Decrementar Resistencia a Conjuros");
if (GetIsImmune(oT, IMMUNITY_TYPE_STUN))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Aturdir");
if (GetIsImmune(oT, IMMUNITY_TYPE_TRAP))
    SendMessageToPC(oUser, GetName(oT) + " IMMUNE Trampas");
}

void CheckForEffect(effect eA, object oT, object oUser)
{
int Result = FALSE;
effect Check = GetFirstEffect(oT);

while (GetIsEffectValid(Check))
    {
    if (Check == eA)
        Result = TRUE;

    Check = GetNextEffect(oT);
    }
if (Result)
    FloatingTextStringOnCreature("Varita de Lamentaciones Fallo de tirada de salvacion: " + GetName(oT), oUser);
    else
    FloatingTextStringOnCreature("Varita de Lamentaciones Exito de tirada de salvacion: Sin Efecto: " + GetName(oT), oUser);
}

void DoAfflictFunction(int iAfflict, object oUser)
{
    effect eEffect;
    object oTarget = GetLocalObject(oUser, "dmfi_univ_target");
    float fDuration;
    int nDNum;
    effect eD;
    effect eA;
    effect eT;
    effect eVis;
    int nBug = 0;
    int nSaveAmount; float fSaveAmount;

    nDNum = GetLocalInt(oUser, "dmfi_damagemodifier");
    fDuration = GetLocalFloat(oUser, "dmfi_stunduration");
    fSaveAmount = GetLocalFloat(oUser, "dmfi_saveamount");

    nSaveAmount = FloatToInt(fSaveAmount);

    if (!(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) ||
        GetIsDM(oTarget))
    {
        FloatingTextStringOnCreature("Debes apuntar a una criatura valida!", oUser, FALSE);
        return;
    }
    switch(iAfflict)
    {
        case 11: eD= EffectDamage(d4(nDNum), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis = EffectVisualEffect(VFX_COM_BLOOD_SPARK_SMALL); break;
        case 12: eD = EffectDamage(d6(nDNum), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED); break;
        case 13: eD = EffectDamage(d8(nDNum), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED); break;
        case 14: eD = EffectDamage(d10(nDNum), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis = EffectVisualEffect(VFX_COM_BLOOD_SPARK_SMALL); break;
        case 15: eD = EffectDamage(d12(nDNum), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis = EffectVisualEffect(VFX_COM_BLOOD_SPARK_SMALL); break;
        case 16: eD = EffectDamage(GetCurrentHitPoints(oTarget)/4, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED); break;
        case 17: eD = EffectDamage(GetCurrentHitPoints(oTarget)/2, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED); break;
        case 18: eD = EffectDamage(GetCurrentHitPoints(oTarget) * 3 / 4, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis =EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL); break;
        case 19: eD = EffectDamage(GetCurrentHitPoints(oTarget)-1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis =EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL); break;
        case 21: eA =EffectDisease(DISEASE_FILTH_FEVER); break;
        case 22: eA =EffectDisease(DISEASE_MINDFIRE); break;
        case 23: eA =EffectDisease(DISEASE_DREAD_BLISTERS); break;
        case 24: eA =EffectDisease(DISEASE_SHAKES); break;
        case 25: eA =EffectDisease(DISEASE_VERMIN_MADNESS); break;
        case 26: eA =EffectDisease(DISEASE_DEVIL_CHILLS); break;
        case 27: eA =EffectDisease(DISEASE_SLIMY_DOOM); break;
        case 28: eA =EffectDisease(DISEASE_RED_ACHE); break;
        case 29: eA =EffectDisease(DISEASE_ZOMBIE_CREEP); break;
        case 31: eA =EffectDisease(DISEASE_BLINDING_SICKNESS); break;
        case 32: eA =EffectDisease(DISEASE_CACKLE_FEVER); break;
        case 33: eA =EffectDisease(DISEASE_BURROW_MAGGOTS); break;
        case 34: eA =EffectDisease(DISEASE_RED_SLAAD_EGGS); break;
        case 35: eA =EffectDisease(DISEASE_DEMON_FEVER); break;
        case 36: eA =EffectDisease(DISEASE_GHOUL_ROT); break;
        case 37: eA =EffectDisease(DISEASE_MUMMY_ROT); break;
        case 38: eA =EffectDisease(DISEASE_SOLDIER_SHAKES); break;
        case 39: eA =EffectDisease(DISEASE_SOLDIER_SHAKES); break;
        case 41: eA =EffectPoison(POISON_TINY_SPIDER_VENOM); break;
        case 42: eA =EffectPoison(POISON_ARANEA_VENOM); break;
        case 43: eA =EffectPoison(POISON_MEDIUM_SPIDER_VENOM); break;
        case 44: eA = EffectPoison(POISON_CARRION_CRAWLER_BRAIN_JUICE); break;
        case 45: eA = EffectPoison(POISON_OIL_OF_TAGGIT); break;
        case 46: eA = EffectPoison(POISON_ARSENIC); break;
        case 47: eA = EffectPoison(POISON_GREENBLOOD_OIL); break;
        case 48: eA = EffectPoison(POISON_NITHARIT); break;
        case 49: eA = EffectPoison(POISON_PHASE_SPIDER_VENOM); break;
        case 51: eA = EffectPoison(POISON_LICH_DUST); break;
        case 52: eA = EffectPoison(POISON_SHADOW_ESSENCE); break;
        case 53: eA = EffectPoison(POISON_LARGE_SPIDER_VENOM); break;
        case 54: eA = EffectPoison(POISON_PURPLE_WORM_POISON); break;
        case 55: eA = EffectPoison(POISON_IRON_GOLEM); break;
        case 56: eA = EffectPoison(POISON_PIT_FIEND_ICHOR); break;
        case 57: eA = EffectPoison(POISON_WYVERN_POISON); break;
        case 58: eA = EffectPoison(POISON_BLACK_LOTUS_EXTRACT); break;
        case 59: eA = EffectPoison(POISON_GARGANTUAN_SPIDER_VENOM); break;
        case 60: eT = EffectPetrify(); break;
        case 61: eT = EffectBlindness(); break;
        case 62: eT = EffectCurse(4,4,4,4,4,4); break;
        case 63: eT = EffectFrightened(); break;
        case 64: eT = EffectStunned(); break;
        case 65: eT = EffectSilence(); break;
        case 66: eT = EffectSleep(); break;
        case 67: eT = EffectSlow(); break;
        case 68: eT = EffectKnockdown(); nBug = 1; break;
        case 69: eD = EffectDamage( GetCurrentHitPoints(oTarget)-1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
                 AssignCommand( oTarget, ClearAllActions());
                 AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_LOOPING_DEAD_FRONT, 1.0, 99999.0));
                 DelayCommand(0.5, SetCommandable( FALSE, oTarget)); break;
        case 71: eA = EffectCutsceneDominated();break;
        case 72: eA = EffectCutsceneGhost(); break;
        case 73: eA = EffectCutsceneImmobilize(); break;
        case 74: eA = EffectCutsceneParalyze(); break;
        case 75: nBug = -1; break;  //special case for combo death effect
        case 81: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    if (GetEffectType(eEffect) == EFFECT_TYPE_POISON) RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;
        case 82: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    if (GetEffectType(eEffect) == EFFECT_TYPE_DISEASE) RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;
        case 83: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    if (GetEffectType(eEffect) == EFFECT_TYPE_BLINDNESS) RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;
        case 84: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    if (GetEffectType(eEffect) == EFFECT_TYPE_CURSE) RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;
        case 85: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    if (GetEffectType(eEffect) == EFFECT_TYPE_FRIGHTENED) RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;
        case 86: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    if (GetEffectType(eEffect) == EFFECT_TYPE_STUNNED) RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;
        case 87: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    if (GetEffectType(eEffect) == EFFECT_TYPE_SILENCE) RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;
        case 88: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;
        case 89: SetCommandable(TRUE, oTarget);
                 AssignCommand(oTarget, ClearAllActions()); break;
        case 80: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    if (GetEffectType(eEffect) == EFFECT_TYPE_PETRIFY) RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;//Added July 5, 2003

// 99 is a duplicate instance - simple copy. - Demetrious
        case 91: SetLocalString(oUser, "EffectSetting", "dmfi_stunduration");
                 CreateSetting(oUser);
        case 92: SetCampaignInt("dmfi", "DamageModifier", nDNum+1); SetCustomToken(20780, IntToString(nDNum+1));;  break;
        case 93:
                if (nDNum==1)
                {
                FloatingTextStringOnCreature("Illegal operacion:  Modificador minimo es 1.", oUser);
                break;
                }
                else
                {
                SetCampaignInt("dmfi", "DamageModifier", nDNum-1); SetCustomToken(20780, IntToString(nDNum-1)); ;break;
                break;
                }
        case 94: ReportImmunity(oTarget, oUser); break;
        case 95: DMFI_NextTarget(oTarget, oUser); break;
        case 99: SetLocalString(oUser, "EffectSetting", "SaveEffectAmount");
                  CreateSetting(oUser); break;
        case 101: eT = EffectSavingThrowDecrease(SAVING_THROW_FORT, nSaveAmount); break;
        case 102: eT = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, nSaveAmount); break;
        case 103: eT = EffectSavingThrowDecrease(SAVING_THROW_WILL, nSaveAmount); break;
        case 104: eT = EffectSavingThrowIncrease(SAVING_THROW_FORT, nSaveAmount); break;
        case 105: eT = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nSaveAmount); break;
        case 106: eT = EffectSavingThrowIncrease(SAVING_THROW_WILL, nSaveAmount); break;
        case 107: eT = EffectSavingThrowDecrease(SAVING_THROW_ALL, nSaveAmount); break;
        case 108: eT = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveAmount); break;
        case 109: SetLocalString(oUser, "EffectSetting", "SaveEffectAmount");
                  CreateSetting(oUser);
        case 100: eEffect = GetFirstEffect(oTarget);
                 while (GetIsEffectValid(eEffect))
                 {
                    if ((GetEffectType(eEffect) == EFFECT_TYPE_SAVING_THROW_INCREASE)
                     ||(GetEffectType(eEffect) == EFFECT_TYPE_SAVING_THROW_DECREASE))
                            RemoveEffect(oTarget, eEffect);
                    eEffect = GetNextEffect(oTarget);
                 } break;//Added July 5, 2003



        default: break;
    }
//code down here to apply the effects an then go back and see if the
//player successfully saved or did not for the diseases and poisons.

if ((GetEffectType(eD)!= EFFECT_TYPE_INVALIDEFFECT) ||
    (GetEffectType(eVis) != EFFECT_TYPE_INVALIDEFFECT))
    {
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eD, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    return;
    }
if (GetEffectType(eA)!= EFFECT_TYPE_INVALIDEFFECT)
    {
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eA, oTarget);
    DelayCommand(5.0, CheckForEffect(eA, oTarget, oUser));
    return;
    }
if ((GetEffectType(eT)!= EFFECT_TYPE_INVALIDEFFECT) || (nBug ==1))
    {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eT, oTarget, fDuration);

    if ((GetEffectType(eT)==EFFECT_TYPE_SAVING_THROW_INCREASE) ||
       (GetEffectType(eT)==EFFECT_TYPE_SAVING_THROW_DECREASE))
            {
            DelayCommand(1.0, FloatingTextStringOnCreature("Salvaciones de objetivo: Fortaleza " + IntToString(GetFortitudeSavingThrow(oTarget))
                        + " Reflejos " + IntToString(GetReflexSavingThrow(oTarget)) + " Voluntad " + IntToString(GetWillSavingThrow(oTarget)), oUser));
             }
    return;
    }
if (nBug == -1)
    {
    object oFollowMe = GetFirstFactionMember(oTarget, TRUE);

    if (!GetIsObjectValid(oFollowMe))
        oFollowMe = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget, 1,CREATURE_TYPE_IS_ALIVE, TRUE);

    if (GetIsDM(oFollowMe) || GetIsDMPossessed(oFollowMe))
        oFollowMe = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget, 2,CREATURE_TYPE_IS_ALIVE, TRUE);

    if (!GetIsObjectValid(oFollowMe))
        oFollowMe = oUser;

    AssignCommand(oFollowMe, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneDominated(), oTarget));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oTarget);
    }

return;
}

//An FX Wand function
void FXWand_Firestorm(object oDM)
{

   // FireStorm Effect
       location lDMLoc = GetLocation ( oDM);


   // tell the DM object to rain fire and destruction
   AssignCommand ( oDM, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_METEOR_SWARM), lDMLoc));
   AssignCommand ( oDM, DelayCommand (1.0, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_FNF_SCREEN_SHAKE), lDMLoc)));

   // create some fires
   object oTargetArea = GetArea(oDM);
   int nXPos, nYPos, nCount;
   for(nCount = 0; nCount < 15; nCount++)
  {
      nXPos = Random(30) - 15;
      nYPos = Random(30) - 15;

      vector vNewVector = GetPosition(oDM);
      vNewVector.x += nXPos;
      vNewVector.y += nYPos;

      location lFireLoc = Location(oTargetArea, vNewVector, 0.0);
      object oFire = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_flamelarge", lFireLoc, FALSE);
      object oDust = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_dustplume", lFireLoc, FALSE);
      DelayCommand ( 10.0, DestroyObject ( oFire));
      DelayCommand ( 14.0, DestroyObject ( oDust));
   }

}

//An FX Wand function
void FXWand_Earthquake(object oDM)
{
   // Earthquake Effect by Jhenne, 06/29/02
   // declare variables used for targetting and commands.
   location lDMLoc = GetLocation ( oDM);

   // tell the DM object to shake the screen
   AssignCommand( oDM, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lDMLoc));
   AssignCommand ( oDM, DelayCommand( 2.8, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_BUMP), lDMLoc)));
   AssignCommand ( oDM, DelayCommand( 3.0, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_SHAKE), lDMLoc)));
   AssignCommand ( oDM, DelayCommand( 4.5, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_BUMP), lDMLoc)));
   AssignCommand ( oDM, DelayCommand( 5.8, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_BUMP), lDMLoc)));
   // tell the DM object to play an earthquake sound
   AssignCommand ( oDM, PlaySound ("as_cv_boomdist1"));
   AssignCommand ( oDM, DelayCommand ( 2.0, PlaySound ("as_wt_thunderds3")));
   AssignCommand ( oDM, DelayCommand ( 4.0, PlaySound ("as_cv_boomdist1")));
   // create a dust plume at the DM and clicking location
   object oTargetArea = GetArea(oDM);
   int nXPos, nYPos, nCount;
   for(nCount = 0; nCount < 15; nCount++)
   {
      nXPos = Random(30) - 15;
      nYPos = Random(30) - 15;

      vector vNewVector = GetPosition(oDM);
      vNewVector.x += nXPos;
      vNewVector.y += nYPos;

      location lDustLoc = Location(oTargetArea, vNewVector, 0.0);
      object oDust = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_dustplume", lDustLoc, FALSE);
      DelayCommand ( 4.0, DestroyObject ( oDust));
   }
}

//An FX Wand function
void FXWand_Lightning(object oDM, location lDMLoc)
{
   // Lightning Strike by Jhenne. 06/29/02
   // tell the DM object to create a Lightning visual effect at targetted location
   AssignCommand( oDM, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lDMLoc));
   // tell the DM object to play a thunderclap
   AssignCommand ( oDM, PlaySound ("as_wt_thundercl3"));
   // create a scorch mark where the lightning hit
   object oScorch = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_weathmark", lDMLoc, FALSE);
   object oTargetArea = GetArea(oDM);
   int nXPos, nYPos, nCount;
   for(nCount = 0; nCount < 5; nCount++)
   {
      nXPos = Random(10) - 5;
      nYPos = Random(10) - 5;

      vector vNewVector = GetPositionFromLocation(lDMLoc);
      vNewVector.x += nXPos;
      vNewVector.y += nYPos;

      location lNewLoc = Location(oTargetArea, vNewVector, 0.0);
      AssignCommand( oDM, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_S), lNewLoc));
   }
   DelayCommand ( 20.0, DestroyObject ( oScorch));
}

void FnFEffect(object oUser, int VFX, location lEffect, float fDelay)
{
if (fDelay>2.0) FloatingTextStringOnCreature("Delay effect created", oUser, FALSE);
DelayCommand( fDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX),lEffect));
}

void CreateEffects(int iEffect, location lEffect, object oUser)
{
    float fDelay;
    float fDuration;
    float fBeamDuration;
    object oTarget;

    fDelay = GetLocalFloat(oUser, "dmfi_effectdelay");
    fDuration = GetLocalFloat(oUser, "dmfi_effectduration");
    fBeamDuration = GetLocalFloat(oUser, "dmfi_beamduration");

    if (!GetIsObjectValid(GetLocalObject(oUser, "dmfi_univ_target")))
        oTarget = oUser;
    else
        oTarget = GetLocalObject(oUser, "dmfi_univ_target");
    switch(iEffect)
    {
        //SoU/HotU Duration Effects(must have a target)
        case 101: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST), oTarget, fDuration); break;
        case 102: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND), oTarget, fDuration); break;
        case 103: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND), oTarget, fDuration); break;
        case 104: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND), oTarget, fDuration); break;
        case 105: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ICESKIN), oTarget, fDuration); break;
        case 106: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_INFERNO), oTarget, fDuration); break;
        case 107: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PIXIEDUST), oTarget, fDuration); break;
        case 108: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oTarget, fDuration); break;
        case 109: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), oTarget, fDuration); break;
        case 100: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_GHOSTLY_PULSE), oTarget, fDuration); break;
        //Magical Duration Effects
        case 10: ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CALTROPS),lEffect, fDuration); break;
        case 11: ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_TENTACLE),lEffect, fDuration); break;
        case 12: ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_WEB_MASS),lEffect, fDuration); break;
        case 13: FnFEffect(oUser, VFX_FNF_GAS_EXPLOSION_MIND,lEffect, fDelay); break;
        case 14: FnFEffect(oUser, VFX_FNF_LOS_HOLY_30,lEffect, fDelay); break;
        case 15: FnFEffect(oUser, VFX_FNF_LOS_EVIL_30,lEffect, fDelay); break;
        case 16: FnFEffect(oUser, VFX_FNF_SMOKE_PUFF,lEffect, fDelay); break;
        case 17: FnFEffect(oUser, VFX_FNF_GAS_EXPLOSION_NATURE,lEffect, fDelay); break;
        case 18: FnFEffect(oUser, VFX_FNF_DISPEL_DISJUNCTION,lEffect, fDelay); break;
        case 19: FnFEffect(oUser, VFX_FNF_GAS_EXPLOSION_EVIL,lEffect, fDelay); break;
        //Magical Status Effects (must have a target)
        case 21: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_BARKSKIN), oTarget, fDuration); break;
        case 22: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_GREATER_STONESKIN), oTarget, fDuration); break;
        case 23: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ENTANGLE), oTarget, fDuration); break;
        case 24: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE), oTarget, fDuration); break;
        case 25: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE), oTarget, fDuration); break;
        case 26: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_INVISIBILITY), oTarget, fDuration); break;
        case 27: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BARD_SONG), oTarget, fDuration); break;
        case 28: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY), oTarget, fDuration); break;
        case 29: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PARALYZED), oTarget, fDuration); break;
        case 20: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), oTarget, fDuration); break;
        //Magical Burst Effects
        case 31: FnFEffect(oUser, VFX_FNF_FIREBALL,lEffect, fDelay); break;
        case 32: FnFEffect(oUser, VFX_FNF_FIRESTORM,lEffect, fDelay); break;
        case 33: FnFEffect(oUser, VFX_FNF_HORRID_WILTING,lEffect, fDelay); break;
        case 34: FnFEffect(oUser, VFX_FNF_HOWL_WAR_CRY,lEffect, fDelay); break;
        case 35: FnFEffect(oUser, VFX_FNF_IMPLOSION,lEffect, fDelay); break;
        case 36: FnFEffect(oUser, VFX_FNF_PWKILL,lEffect, fDelay); break;
        case 37: FnFEffect(oUser, VFX_FNF_PWSTUN,lEffect, fDelay); break;
        case 38: FnFEffect(oUser, VFX_FNF_SOUND_BURST,lEffect, fDelay); break;
        case 39: FnFEffect(oUser, VFX_FNF_STRIKE_HOLY,lEffect, fDelay); break;
        case 30: FnFEffect(oUser, VFX_FNF_WORD,lEffect, fDelay); break;
          //Lighting Effects
        case 41: ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BLACKOUT),lEffect, fDuration); break;
        case 42: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10),oTarget, fDuration); break;
        case 43: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_BLUE_20),oTarget, fDuration); break;
        case 44: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_GREY_20),oTarget, fDuration); break;
        case 45: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_ORANGE_20),oTarget, fDuration); break;
        case 46: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_PURPLE_20),oTarget, fDuration); break;
        case 47: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_RED_20),oTarget, fDuration); break;
        case 48: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20),oTarget, fDuration); break;
        case 49: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20),oTarget, fDuration); break;
                 //Beam Effects
        case 50: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_CHAIN, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;
        case 51: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_COLD, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;
        case 52: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;
        case 53: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_FIRE, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;
        case 54: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_FIRE_LASH, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;
        case 55: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;
        case 56: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;
        case 57: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;
        case 58: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_ODD, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;
        case 59: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_COLD, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_FIRE, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_FIRE_LASH, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_ODD, oUser, BODY_NODE_CHEST, FALSE), oTarget, fBeamDuration); break;

        //Environmental Effects
        case 60: FnFEffect(oUser, VFX_FNF_NATURES_BALANCE,lEffect, fDelay);break;
        case 61: FXWand_Lightning(oTarget, lEffect); break;
        case 62: FXWand_Firestorm(oTarget); break;
        case 63: FXWand_Earthquake(oTarget); break;
        case 64: FnFEffect(oUser, VFX_FNF_ICESTORM,lEffect, fDelay); break;
        case 65: FnFEffect(oUser, VFX_FNF_SUNBEAM,lEffect, fDelay); break;
        case 66: SetWeather(GetArea(oUser), WEATHER_CLEAR); break;
        case 67: SetWeather(GetArea(oUser), WEATHER_RAIN); break;
        case 68: SetWeather(GetArea(oUser), WEATHER_SNOW); break;
        case 69: SetWeather(GetArea(oUser), WEATHER_USE_AREA_SETTINGS); break;
        //Summon Effects
        case 71: FnFEffect(oUser, VFX_FNF_SUMMON_MONSTER_1,lEffect, fDelay); break;
        case 72: FnFEffect(oUser, VFX_FNF_SUMMON_MONSTER_2,lEffect, fDelay); break;
        case 73: FnFEffect(oUser, VFX_FNF_SUMMON_MONSTER_3,lEffect, fDelay); break;
        case 74: FnFEffect(oUser, VFX_FNF_SUMMON_CELESTIAL,lEffect, fDelay); break;
        case 75: FnFEffect(oUser, VFX_FNF_SUMMONDRAGON,lEffect, fDelay); break;
        case 76: FnFEffect(oUser, VFX_FNF_SUMMON_EPIC_UNDEAD,lEffect, fDelay); break;
        case 77: FnFEffect(oUser, VFX_FNF_SUMMON_GATE,lEffect, fDelay); break;
        case 78: FnFEffect(oUser, VFX_FNF_SUMMON_UNDEAD,lEffect, fDelay); break;
        case 79: FnFEffect(oUser, VFX_FNF_UNDEAD_DRAGON,lEffect, fDelay); break;
        case 70: FnFEffect(oUser, VFX_FNF_WAIL_O_BANSHEES,lEffect, fDelay); break;
        //SoU/HotU Effects
        case 80: ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(322), oTarget, fDuration); break;
        case 81: ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(132), oTarget, fDuration); break;
        case 82: ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(133), oTarget, fDuration); break;
        case 83: ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(136), oTarget, fDuration); break;
        case 84: ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(137), oTarget, fDuration); break;
        case 85: FnFEffect(oUser, VFX_FNF_DEMON_HAND,lEffect, fDelay); break;
        case 86: FnFEffect(oUser, VFX_FNF_ELECTRIC_EXPLOSION,lEffect, fDelay); break;
        case 87: FnFEffect(oUser, VFX_FNF_GREATER_RUIN,lEffect, fDelay); break;
        case 88: FnFEffect(oUser, VFX_FNF_MYSTICAL_EXPLOSION,lEffect, fDelay); break;
        case 89: FnFEffect(oUser, VFX_FNF_SWINGING_BLADE,lEffect, fDelay); break;
        //Settings
        case 91:
        SetLocalString(oUser, "EffectSetting", "dmfi_effectduration");
        CreateSetting(oUser);
        break;
        case 92:
        SetLocalString(oUser, "EffectSetting", "dmfi_effectdelay");
        CreateSetting(oUser);
        break;
        case 93:
        SetLocalString(oUser, "EffectSetting", "dmfi_beamduration");
        CreateSetting(oUser);
        break;
        case 94: //Change Day Music
        iDayMusic = MusicBackgroundGetDayTrack(GetArea(oUser)) + 1;
        if (iDayMusic > 33) iDayMusic = 49;
        if (iDayMusic > 55) iDayMusic = 1;
        MusicBackgroundStop(GetArea(oUser));
        MusicBackgroundChangeDay(GetArea(oUser), iDayMusic);
        MusicBackgroundPlay(GetArea(oUser));
        break;
        case 95: //Change Night Music
        iNightMusic = MusicBackgroundGetDayTrack(GetArea(oUser)) + 1;
        if (iNightMusic > 33) iNightMusic = 49;
        if (iNightMusic > 55) iNightMusic = 1;
        MusicBackgroundStop(GetArea(oUser));
        MusicBackgroundChangeNight(GetArea(oUser), iNightMusic);
        MusicBackgroundPlay(GetArea(oUser));
        break;
        case 96: //Play Background Music
        MusicBackgroundPlay(GetArea(oUser));
        break;
        case 97: //Stop Background Music
        MusicBackgroundStop(GetArea(oUser));
        break;
        case 98: //Change and Play Battle Music
        iBattleMusic = MusicBackgroundGetBattleTrack(GetArea(oUser)) + 1;
        if (iBattleMusic < 34 || iBattleMusic > 48) iBattleMusic = 34;
        MusicBattleStop(GetArea(oUser));
        MusicBattleChange(GetArea(oUser), iBattleMusic);
        MusicBattlePlay(GetArea(oUser));
        break;
        case 99: //Stop Battle Music
        MusicBattleStop(GetArea(oUser));
        break;

        default: break;
    }
    DeleteLocalObject(oUser, "EffectTarget");
return;
}
void EmoteBesar(object oPC)
{
    object oPareja = GetNearestObject (OBJECT_TYPE_CREATURE, oPC);
    int iPer;
    if (GetIsPC(oPareja)==TRUE)
    {
       AssignCommand(oPareja, ActionStartConversation(oPareja, "conv_consenti", TRUE));
    }
    iPer=GetLocalInt(oPareja,"iPermiso");
    if (iPer==TRUE)
    {
       Q_ExecuteKiss2(oPC, oPareja, ANIMATION_LOOPING_CUSTOM11, 9999.0, "Q_WP_GUY1");
    }
    if (GetIsPC(oPareja)==TRUE)
    {
        SetLocalInt(oPareja,"iPermiso",0);
    }
}

void EmoteBesar2(object oPC)
{
    object oPareja = GetNearestObject (OBJECT_TYPE_CREATURE, oPC);
    int iPer, ianim;
    if (GetGender(oPC) == GENDER_FEMALE)
    {
        ianim = ANIMATION_LOOPING_CUSTOM13;
    }
    else
    {
        ianim = ANIMATION_LOOPING_CUSTOM12;
    }
    if (GetIsPC(oPareja)==TRUE)
    {
       AssignCommand(oPareja, ActionStartConversation(oPareja, "conv_consenti", TRUE));
    }
    iPer=GetLocalInt(oPareja,"iPermiso");
    if (iPer==TRUE)
    {
       Q_ExecuteKiss2(oPC, oPareja, ianim, 9999.0, "Q_WP_GUY2");
    }
    if (GetIsPC(oPareja)==TRUE)
    {
        SetLocalInt(oPareja,"iPermiso",0);
    }
}

void EmoteDance(object oPC)
{
object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
object oLeftHand =  GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

AssignCommand(oPC,ActionUnequipItem(oRightHand));
AssignCommand(oPC,ActionUnequipItem(oLeftHand));
if (GetGender(oPC)==GENDER_FEMALE)
{
    AssignCommand(oPC,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPC)));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_CUSTOM19, 1.5, 9999.9f));
}
else
{
     SendMessageToPC(oPC, "Los chicos no saben bailar sexymente.");
/*
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY2,1.0));
    AssignCommand(oPC,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPC)));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_TALK_LAUGHING, 2.0, 2.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY1,1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY3,2.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 3.0, 1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_TALK_FORCEFUL,1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY2,1.0));
    AssignCommand(oPC,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPC)));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_TALK_LAUGHING, 2.0, 2.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY1,1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY3,2.0));
    AssignCommand(oPC,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPC)));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 3.0, 1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY2,1.0));  */
}
AssignCommand(oPC,ActionDoCommand(ActionEquipItem(oLeftHand,INVENTORY_SLOT_LEFTHAND)));
AssignCommand(oPC,ActionDoCommand(ActionEquipItem(oRightHand,INVENTORY_SLOT_RIGHTHAND)));
}

void EmoteVals(object oPC)
{
    object oPareja = GetNearestObject (OBJECT_TYPE_CREATURE, oPC);
    int iPer;
    if (GetIsPC(oPareja)==TRUE)
    {
       AssignCommand(oPareja, ActionStartConversation(oPareja, "conv_consenti", TRUE));
    }
    iPer=GetLocalInt(oPareja,"iPermiso");
    if (iPer==TRUE)
    {

       Q_ExecutePartneredDance(oPC,oPareja,1.0,9999.0);
    }
    if (GetIsPC(oPareja)==TRUE)
    {
        SetLocalInt(oPareja,"iPermiso",0);
    }
}

void EmoteAbrazo(object oPC)
{
    object oPareja = GetNearestObject (OBJECT_TYPE_CREATURE, oPC);
    int iPer;
    if (GetIsPC(oPareja)==TRUE)
    {
       AssignCommand(oPareja, ActionStartConversation(oPareja, "conv_consenti", TRUE));
    }
    iPer=GetLocalInt(oPareja,"iPermiso");
    if (iPer==TRUE)
    {

        Q_ExecuteKiss2(oPC, oPareja, ANIMATION_LOOPING_CUSTOM14, 9999.0, "Q_WP_GUY1");
    }
    if (GetIsPC(oPareja)==TRUE)
    {
        SetLocalInt(oPareja,"iPermiso",0);
    }
}

//Smoking Function by Jason Robinson
location GetLocationAboveAndInFrontOf(object oPC, float fDist, float fHeight)
{
    float fDistance = -fDist;
    object oTarget = (oPC);
    object oArea = GetArea(oTarget);
    vector vPosition = GetPosition(oTarget);
    vPosition.z += fHeight;
    float fOrientation = GetFacing(oTarget);
    vector vNewPos = AngleToVector(fOrientation);
    float vZ = vPosition.z;
    float vX = vPosition.x - fDistance * vNewPos.x;
    float vY = vPosition.y - fDistance * vNewPos.y;
    fOrientation = GetFacing(oTarget);
    vX = vPosition.x - fDistance * vNewPos.x;
    vY = vPosition.y - fDistance * vNewPos.y;
    vNewPos = AngleToVector(fOrientation);
    vZ = vPosition.z;
    vNewPos = Vector(vX, vY, vZ);
    return Location(oArea, vNewPos, fOrientation);
}

//Smoking Function by Jason Robinson
void SmokePipe(object oActivator)
{
    string sEmote1 = "*Fumas de una pipa*";
    string sEmote2 = "*Das caladas a una pipa*";
    string sEmote3 = "*Haces anillos de humo con una pipa*";
    float fHeight = 1.7;
    float fDistance = 0.1;
    // Set height based on race and gender
    if (GetGender(oActivator) == GENDER_MALE)
    {
        switch (GetRacialType(oActivator))
        {
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFELF: fHeight = 1.7; fDistance = 0.12; break;
            case RACIAL_TYPE_ELF: fHeight = 1.55; fDistance = 0.08; break;
            case RACIAL_TYPE_GNOME:
            case RACIAL_TYPE_HALFLING: fHeight = 1.15; fDistance = 0.12; break;
            case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.12; break;
            case RACIAL_TYPE_HALFORC: fHeight = 1.9; fDistance = 0.2; break;
        }
    }
    else
    {
        // FEMALES
        switch (GetRacialType(oActivator))
        {
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFELF: fHeight = 1.6; fDistance = 0.12; break;
            case RACIAL_TYPE_ELF: fHeight = 1.45; fDistance = 0.12; break;
            case RACIAL_TYPE_GNOME:
            case RACIAL_TYPE_HALFLING: fHeight = 1.1; fDistance = 0.075; break;
            case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.1; break;
            case RACIAL_TYPE_HALFORC: fHeight = 1.8; fDistance = 0.13; break;
        }
    }
    location lAboveHead = GetLocationAboveAndInFrontOf(oActivator, fDistance, fHeight);
    // emotes
    switch (d3())
    {
        case 1: AssignCommand(oActivator, ActionSpeakString(sEmote1)); break;
        case 2: AssignCommand(oActivator, ActionSpeakString(sEmote2)); break;
        case 3: AssignCommand(oActivator, ActionSpeakString(sEmote3));break;
    }
    // glow red
    AssignCommand(oActivator, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_RED_5), oActivator, 0.15)));
    // wait a moment
    AssignCommand(oActivator, ActionWait(3.0));
    // puff of smoke above and in front of head
    AssignCommand(oActivator, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lAboveHead)));
    // if female, turn head to left
    if ((GetGender(oActivator) == GENDER_FEMALE) && (GetRacialType(oActivator) != RACIAL_TYPE_DWARF))
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 5.0));
}

//This function is for the DMFI Emote Wand
void DoEmoteFunction(int iEmote, object oUser)
{
    object oTarget = GetLocalObject(oUser, "dmfi_univ_target");
    if (!GetIsObjectValid(oTarget))
        oTarget = oUser;
    float fDur = 9999.0f; //Duration

    switch(iEmote)
    {
        case 1: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM8, 1.5, fDur)); break;  //ANIMATION_LOOPING_CUSTOM15
        case 2: AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_DRINK, 1.0)); break;
        case 3: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM10, 1.0, fDur)); break;  //ANIMATION_LOOPING_CUSTOM17
        case 4: AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_READ, 1.0)); DelayCommand(3.0f, AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_READ, 1.0)));break;
        case 5: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, fDur)); break;
        case 61: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CONJURE1, 1.0, fDur)); break;
        case 62: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CONJURE2, 1.0, fDur)); break;
        case 63: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_GET_LOW, 1.0, fDur)); break;
        case 64: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_GET_MID, 1.0, fDur)); break;
        case 65: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_MEDITATE, 1.0, fDur)); break;
        case 66: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, fDur)); break;
        case 67: AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_BOW, 1.0)); break; //ANIMATION_LOOPING_WORSHIP
        case 68: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_DEAD_FRONT, 1.0, fDur)); break;
        case 69: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 1.0, fDur)); break;
        case 71: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM3, 1.0, fDur)); break;
        case 72: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM4, 1.0, fDur)); break;
        case 73: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM16, 1.0, fDur)); break;  //ANIMATION_LOOPING_CUSTOM11
        case 74: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM17, 1.0, fDur)); break;   //ANIMATION_LOOPING_CUSTOM12
        case 75: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM5, 1.0, fDur)); break;  //ANIMATION_LOOPING_CUSTOM13
        case 76: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM7, 1.0, fDur)); break; //ANIMATION_LOOPING_CUSTOM14
        case 77: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM16, 2.0, fDur)); break; //ANIMATION_LOOPING_CUSTOM16
        case 78: EmoteBesar(oTarget); break;//AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM14, 1.0, fDur)); break;
        case 79: EmoteBesar2(oTarget); break; //AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM6, 1.5, fDur)); break;
        case 81: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_SPASM, 1.0, fDur)); break;  //ANIMATION_LOOPING_CUSTOM20
        case 82: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_CUSTOM18, 1.0, fDur)); break;
        case 83: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_TALK_PLEADING, 1.0, fDur)); break;
        case 84: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_LOOK_FAR, 1.0, fDur)); break;
        case 85: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_PAUSE_TIRED, 1.0, fDur)); break;
        case 87: AssignCommand(oTarget, ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, fDur)); DelayCommand(1.0f, AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_DRINK, 1.0))); DelayCommand(3.0f, AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, fDur)));break;
        case 88: AssignCommand(oTarget, ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, fDur)); DelayCommand(1.0f, AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_READ, 1.0))); DelayCommand(3.0f, AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, fDur)));break;
        case 91: AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_DODGE_SIDE, 1.0)); break;
        case 92: AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_DODGE_DUCK, 1.0)); break;
        case 93: AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_VICTORY1, 1.0)); AssignCommand(oTarget,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_CHEER,oTarget))); break;
        case 94: AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_VICTORY2, 1.0)); AssignCommand(oTarget,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_CHEER,oTarget))); break;
        case 95: AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_VICTORY3, 1.0)); AssignCommand(oTarget,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_CHEER,oTarget))); break;
        case 96: EmoteDance(oTarget); break;
        case 97: AssignCommand(oTarget, PlayAnimation( ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, fDur)); break;
        case 98: SmokePipe(oTarget); break;
        case 99: AssignCommand(oTarget, PlayAnimation( ANIMATION_FIREFORGET_TAUNT, 1.0)); break;  //ANIMATION_FIREFORGET_STEAL
        case 101: EmoteAbrazo(oTarget); break;
        case 102: EmoteVals(oTarget); break;
        case 11: if(ObtenerIntPersistente(oTarget, "CHAT_NOEMOCIONES") == FALSE)
                 {
                     FloatingTextStringOnCreature("<cþ<<>Emociones por chat desactivadas.</c>", oTarget, FALSE);
                     GuardarIntPersistente(oTarget, "CHAT_NOEMOCIONES", TRUE);
                 }
                 else
                 {
                     FloatingTextStringOnCreature("<c´þd>Emociones por chat activadas.</c>", oTarget, FALSE);
                     GuardarIntPersistente(oTarget, "CHAT_NOEMOCIONES", FALSE);
                 }break;
        default: break;
    }
}

void DoBuff (int iChoice, object oUser)
{
int nChoice = 0;
string sType;
object oTarget = GetLocalObject(oUser, "dmfi_univ_target");
int Party = GetLocalInt(oUser, "dmfi_buff_party");
int CL;
int nSpell1 = SPELL_ALL_SPELLS;
int nSpell2 = SPELL_ALL_SPELLS;
int nSpell3 = SPELL_ALL_SPELLS;


switch(iChoice)
{
case 10: nChoice = -1; break;
case 11: nChoice = SPELL_AURA_OF_VITALITY; break;
case 12: nChoice = SPELL_BARKSKIN; break;
case 13: nChoice = SPELL_BATTLETIDE; break;
case 14: nChoice = SPELL_BLESS;  break;
case 16: nChoice = SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE; break;
case 17: nChoice = SPELL_CLARITY;  break;
case 18: nChoice = SPELL_DEATH_WARD;  break;
case 19: nChoice = SPELL_DISPLACEMENT; break;
case 20: nChoice = -1;  break;
case 21: nChoice = SPELL_DIVINE_FAVOR;  break;
case 22: nChoice = SPELL_DIVINE_POWER;  break;
case 23: nChoice = SPELL_ENDURE_ELEMENTS; break;
case 24: nChoice = SPELL_ENTROPIC_SHIELD; break;
case 25: nChoice = SPELL_ELEMENTAL_SHIELD; break;
case 26: nChoice = SPELL_ENERGY_BUFFER;  break;
case 27: nChoice = SPELL_ETHEREAL_VISAGE;  break;
case 28: nChoice = SPELL_GHOSTLY_VISAGE; break;
case 29: nChoice = SPELL_GLOBE_OF_INVULNERABILITY; break;
case 30: nChoice = -1;  break;
case 31: nChoice = SPELL_SANCTUARY; break;
case 32: nChoice = SPELL_GREATER_STONESKIN; break;
case 33: nChoice = SPELL_GREATER_SPELL_MANTLE; break;
case 34: nChoice = SPELL_HASTE;  break;
case 35: nChoice = SPELL_INVISIBILITY;  break;
case 36: nChoice = SPELL_IMPROVED_INVISIBILITY; break;
case 37: nChoice = SPELL_LESSER_MIND_BLANK;break;
case 38: nChoice = SPELL_LESSER_SPELL_MANTLE; break;
case 39: nChoice = SPELL_MAGE_ARMOR; break;
case 40: nChoice = -1;  break;
case 41: nChoice = SPELL_MESTILS_ACID_SHEATH; break;
case 42: nChoice = SPELL_MONSTROUS_REGENERATION; break;
case 43: nChoice = SPELL_PRAYER;  break;
case 44: nChoice = SPELL_PREMONITION; break;
case 45: nChoice = SPELL_PROTECTION_FROM_ELEMENTS; break;
case 46: nChoice = SPELL_PROTECTION_FROM_SPELLS; break;
case 47: nChoice = SPELL_REGENERATE; break;
case 48: nChoice = SPELL_RESIST_ELEMENTS;  break;
case 49: nChoice = SPELL_SHADOW_SHIELD; break;
case 50: nChoice = -1;  break;
case 51: nChoice = SPELL_SHIELD; break;
case 52: nChoice = SPELL_SPELL_MANTLE; break;
case 53: nChoice = SPELL_SPELL_RESISTANCE; break;
case 54: nChoice = SPELL_STONE_BONES; break;
case 55: nChoice = SPELL_STONESKIN; break;
case 56: nChoice = SPELL_TENSERS_TRANSFORMATION; break;
case 57: nChoice = SPELL_TRUE_SEEING; break;
case 58: nChoice = SPELL_DARKNESS;  break;
case 59: nChoice = SPELL_WAR_CRY; break;
case 60: nChoice = -1;    break;
case 61: sType = "BARD_DEF"; break;
case 62: sType = "BARD_OFF";   break;
case 63: sType = "CLERIC_DEF"; break;
case 64: sType = "CLERIC_OFF";  break;
case 65: sType = "DRUID_DEF"; break;
case 66: sType = "DRUID_OFF"; break;
case 67: sType = "MAGE_DEF";  break;
case 68: sType = "MAGE_OFF"; break;
case 70: nChoice = -1;    break;
case 71: sType = "ARMOR";    break;
case 72: sType = "ELEMENTAL"; break;
case 73: sType = "INVIS";  break;
case 74: sType = "MELEE";  break;
case 75: sType = "MIND";  break;
case 76: sType = "SHIELD";  break;
case 77: sType = "SP_PROT"; break;
case 78: sType = "STEALTH"; break;

case 81: DMFI_NextTarget(oTarget, oUser); nChoice = -1; break;
case 82: SetLocalString(oUser, "dmfi_buff_level", "LOW"); nChoice = -1;
         FloatingTextStringOnCreature("Nivel de proteccion BAJO", oUser);
         SetCustomToken(20782, "Low");
         SetCampaignString("dmfi", "dmfi_buff_level", "LOW", oUser);
         break;
case 83: SetLocalString(oUser, "dmfi_buff_level", "MID"); nChoice = -1;
         FloatingTextStringOnCreature("Nivel de proteccion MEDIO", oUser);
         SetCustomToken(20782, "Mid");
         SetCampaignString("dmfi", "dmfi_buff_level", "MID", oUser);
         break;
case 84: SetLocalString(oUser, "dmfi_buff_level", "HIGH"); nChoice = -1;
         FloatingTextStringOnCreature("Nivel de proteccion GRANDE", oUser);
         SetCustomToken(20782, "High");
         SetCampaignString("dmfi", "dmfi_buff_level", "HIGH", oUser);
         break;
case 85: SetLocalString(oUser, "dmfi_buff_level", "EPIC"); nChoice = -1;
         FloatingTextStringOnCreature("Nivel de proteccion EPICO", oUser);
         SetCustomToken(20782, "Epic");
         SetCampaignString("dmfi", "dmfi_buff_level", "EPIC", oUser);
         break;
case 86: {
            if (GetLocalInt(oUser, "dmfi_buff_party")==1)
                {
                SetLocalInt(oUser, "dmfi_buff_party", 0);
                FloatingTextStringOnCreature("Proteccion en unico objetivo", oUser);
                SetCustomToken(20783, "Single Target");
                SetCampaignInt("dmfi","dmfi_buff_party", 0, oUser);
                }
                else
                {
                SetLocalInt(oUser, "dmfi_buff_party", 1);
                FloatingTextStringOnCreature("Proteccion en modo grupo", oUser);
                SetCustomToken(20783, "Party");
                SetCampaignInt("dmfi","dmfi_buff_party", 1, oUser);
                }
          }
case 80: nChoice = -1; break;
default: nChoice = -1; break;
}


if (nChoice==-1)
    return;

//set caster level based on set level
string sLevel = GetLocalString(oUser, "dmfi_buff_level");

     if (sLevel == "LOW") CL = 5;
else if (sLevel == "MID") CL = 10;
else if (sLevel == "HIGH") CL = 15;
else if (sLevel == "EPIC") CL = 20;

if (nChoice == 0)  //only get here if nChoice NOT set
{
string BUFF_TYPE = sType + "_" + sLevel;

if (BUFF_TYPE == "BARD_DEF_LOW")
    {
    nSpell1 = SPELL_RESISTANCE;
    nSpell2 = SPELL_MAGE_ARMOR;
    nSpell3 = SPELL_GHOSTLY_VISAGE;
    }
    else if (BUFF_TYPE =="BARD_OFF_LOW")
    {
    nSpell1 = SPELL_BULLS_STRENGTH;
    nSpell2 = SPELL_MAGE_ARMOR;
    nSpell3 = SPELL_MAGIC_WEAPON;
    }
    else if (BUFF_TYPE == "BARD_DEF_MID")
    {
    nSpell1 = SPELL_IMPROVED_INVISIBILITY;
    nSpell2 = SPELL_GHOSTLY_VISAGE;
    nSpell3 = SPELL_CLARITY;
    }
    else if (BUFF_TYPE == "BARD_OFF_MID")
    {
    nSpell1 = SPELL_WAR_CRY;
    nSpell2 = SPELL_SUMMON_CREATURE_V;
    nSpell3 = SPELL_ETHEREAL_VISAGE;
    }
    else if (BUFF_TYPE == "BARD_DEF_HIGH")
    {
    nSpell1 = SPELL_ETHEREAL_VISAGE;
    nSpell2 = SPELL_IMPROVED_INVISIBILITY;
    nSpell3 = SPELL_HASTE;
    }
    else if (BUFF_TYPE == "BARD_OFF_HIGH")
    {
    nSpell1 = SPELL_ETHEREAL_VISAGE;
    nSpell2 = SPELL_SUMMON_CREATURE_V;
    nSpell3 = SPELL_WAR_CRY;
    }
    else if (BUFF_TYPE == "BARD_DEF_EPIC")
    {
    nSpell1 = SPELL_ETHEREAL_VISAGE;
    nSpell2 = SPELL_ENERGY_BUFFER;
    nSpell3 = SPELL_IMPROVED_INVISIBILITY;
    }
    else if (BUFF_TYPE == "BARD_OFF_EPIC")
    {
    nSpell1 = SPELL_ETHEREAL_VISAGE;
    nSpell2 = SPELL_SUMMON_CREATURE_VI;
    nSpell3 = SPELL_MASS_HASTE;
    }

    else if (BUFF_TYPE == "MAGE_DEF_LOW")
    {
    nSpell1 = SPELL_CLARITY;
    nSpell2 = SPELL_GHOSTLY_VISAGE;
    nSpell3 = SPELL_PROTECTION_FROM_ELEMENTS;
    }
    else if (BUFF_TYPE == "MAGE_OFF_LOW")
    {
    nSpell1 = SPELL_GHOSTLY_VISAGE;
    nSpell2 = SPELL_DEATH_ARMOR;
    nSpell3 = SPELL_HASTE;
    }
    else if (BUFF_TYPE == "MAGE_DEF_MID")
    {
    nSpell1 = SPELL_LESSER_SPELL_MANTLE;
    nSpell2 = SPELL_STONESKIN;
    nSpell3 = SPELL_ELEMENTAL_SHIELD;
    }
    else if (BUFF_TYPE == "MAGE_OFF_MID")
    {
    nSpell1 = SPELL_SPELL_MANTLE;
    nSpell2 = SPELL_IMPROVED_INVISIBILITY;
    nSpell3 = SPELL_SUMMON_CREATURE_V;
    }
    else if (BUFF_TYPE == "MAGE_DEF_HIGH")
    {
    nSpell1 = SPELL_SPELL_MANTLE;
    nSpell2 = SPELL_SANCTUARY;
    nSpell3 = SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
    }
    else if (BUFF_TYPE == "MAGE_OFF_HIGH")
    {
    nSpell1 = SPELL_ETHEREAL_VISAGE;
    nSpell2 = SPELL_SUMMON_CREATURE_VIII;
    nSpell3 = SPELL_SPELL_MANTLE;
    }
    else if (BUFF_TYPE == "MAGE_DEF_EPIC")
    {
    nSpell1 = SPELL_PREMONITION;
    nSpell2 = SPELL_SPELL_MANTLE;
    nSpell3 = SPELL_GLOBE_OF_INVULNERABILITY;
    }
    else if (BUFF_TYPE == "MAGE_OFF_EPIC")
    {
    nSpell1 = SPELL_PREMONITION;
    nSpell2 = SPELL_MORDENKAINENS_SWORD;
    nSpell3 = SPELL_GLOBE_OF_INVULNERABILITY;
    }

    else if (BUFF_TYPE == "CLERIC_DEF_LOW")
    {
    nSpell1 = SPELL_PROTECTION_FROM_ELEMENTS;
    nSpell2 = SPELL_CLARITY;
    nSpell3 = SPELL_DARKVISION;
    }
    else if (BUFF_TYPE == "CLERIC_OFF_LOW")
    {
    nSpell1 = SPELL_PRAYER;
    nSpell2 = SPELL_MAGIC_VESTMENT;
    nSpell3 = SPELL_BULLS_STRENGTH;
    }
    else if (BUFF_TYPE == "CLERIC_MID_DEF")
    {
    nSpell1 = SPELL_SANCTUARY;
    nSpell2 = SPELL_SPELL_RESISTANCE;
    nSpell3 = SPELL_TRUE_SEEING;
    }
    else if (BUFF_TYPE == "CLERIC_OFF_MID")
    {
    nSpell1 = SPELL_SUMMON_CREATURE_VI;
    nSpell2 = SPELL_BATTLETIDE;
    nSpell3 = SPELL_MONSTROUS_REGENERATION;
    }
    else if (BUFF_TYPE == "CLERIC_DEF_HIGH")
    {
    nSpell1 = SPELL_SANCTUARY;
    nSpell2 = SPELL_REGENERATE;
    nSpell3 = SPELL_MONSTROUS_REGENERATION;
    }
    else if (BUFF_TYPE == "CLERIC_OFF_HIGH")
    {
    nSpell1 = SPELL_SUMMON_CREATURE_VIII;
    nSpell2 = SPELL_REGENERATE;
    nSpell3 = SPELL_BATTLETIDE;
    }
    else if (BUFF_TYPE == "CLERIC_DEF_EPIC")
    {
    nSpell1 = SPELL_UNDEATHS_ETERNAL_FOE;
    nSpell2 = SPELL_REGENERATE;
    nSpell3 = SPELL_SANCTUARY;
    }
    else if (BUFF_TYPE == "CLERIC_OFF_EPIC")
    {
    nSpell1 = SPELL_SUMMON_CREATURE_IX;
    nSpell2 = SPELL_REGENERATE;
    nSpell3 = SPELL_BATTLETIDE;
    }

    else if (BUFF_TYPE == "DRUID_DEF_LOW")
    {
    nSpell1 = SPELL_PROTECTION_FROM_ELEMENTS;
    nSpell2 = SPELL_BARKSKIN;
    nSpell3 = SPELL_ONE_WITH_THE_LAND;
    }
    else if (BUFF_TYPE == "DRUID_OFF_LOW")
    {
    nSpell1 = SPELL_GREATER_MAGIC_FANG;
    nSpell2 = SPELL_BULLS_STRENGTH;
    nSpell3 = SPELL_BLOOD_FRENZY;
    }
    else if (BUFF_TYPE == "DRUID_DEF_MID")
    {
    nSpell1 = SPELL_SPELL_RESISTANCE;
    nSpell2 = SPELL_MONSTROUS_REGENERATION;
    nSpell3 = SPELL_STONESKIN;
    }
    else if (BUFF_TYPE == "DRUID_OFF_MID")
    {
    nSpell1 = SPELL_STONESKIN;
    nSpell2 = SPELL_FREEDOM_OF_MOVEMENT;
    nSpell3 = SPELL_MASS_CAMOFLAGE;
    }
    else if (BUFF_TYPE == "DRUID_DEF_HIGH")
    {
    nSpell1 = SPELL_PREMONITION;
    nSpell2 = SPELL_TRUE_SEEING;
    nSpell3 = SPELL_GREATER_STONESKIN;
    }
    else if (BUFF_TYPE == "DRUID_OFF_HIGH")
    {
    nSpell1 = SPELL_SUMMON_CREATURE_VIII;
    nSpell2 = SPELL_AURA_OF_VITALITY;
    nSpell3 = SPELL_ENERGY_BUFFER;
    }
    else if (BUFF_TYPE == "DRUID_DEF_EPIC")
    {
    nSpell1 = SPELL_ELEMENTAL_SWARM;
    nSpell2 = SPELL_PREMONITION;
    nSpell3 = SPELL_TRUE_SEEING;
    }
    else if (BUFF_TYPE == "DRUID_OFF_EPIC")
    {
    nSpell1 = SPELL_PREMONITION;
    nSpell2 = SPELL_SHAPECHANGE;
    nSpell3 = SPELL_AURA_OF_VITALITY;
    }

    else if (BUFF_TYPE == "AMROR_LOW")
    {
    nSpell1 = SPELL_MAGE_ARMOR;
    nSpell2 = SPELL_INVISIBILITY_PURGE;
    }
    else if (BUFF_TYPE == "ARMOR_MID")
    {
    nSpell1 = SPELL_MAGE_ARMOR;
    nSpell2 = SPELL_DARKVISION;
    nSpell3 = SPELL_INVISIBILITY_PURGE;
    }
    else if (BUFF_TYPE == "ARMOR_HIGH")
    {
    nSpell1 = SPELL_MAGE_ARMOR;
    nSpell2 = SPELL_STONESKIN;
    nSpell3 = SPELL_GHOSTLY_VISAGE;
    }
    else if (BUFF_TYPE == "ARMOR_EPIC")
    {
    nSpell1 = SPELL_GHOSTLY_VISAGE;
    nSpell2 = SPELL_MAGE_ARMOR;
    nSpell3 = SPELL_PREMONITION;
    }
    else if (BUFF_TYPE == "ELEMENTAL_LOW")
    {
    nSpell1 = SPELL_RESISTANCE;
    nSpell2 = SPELL_ENDURE_ELEMENTS;
    nSpell3 = SPELL_ENDURANCE;
    }
    else if (BUFF_TYPE == "ELEMENTAL_MID")
    {
    nSpell1 = SPELL_RESISTANCE;
    nSpell2 = SPELL_RESIST_ELEMENTS;
    nSpell3 = SPELL_ENDURANCE;
    }
    else if (BUFF_TYPE == "ELEMENTAL_HIGH")
    {
    nSpell1 = SPELL_ENDURANCE;
    nSpell2 = SPELL_STONESKIN;
    nSpell3 = SPELL_PROTECTION_FROM_ELEMENTS;
    }
    else if (BUFF_TYPE == "ELEMENTAL_EPIC")
    {
    nSpell1 = SPELL_STONESKIN;
    nSpell2 = SPELL_ENERGY_BUFFER;
    nSpell3 = SPELL_ENDURANCE;
    }
    else if (BUFF_TYPE == "INVIS_LOW")
    {
    nSpell1 = SPELL_CATS_GRACE;
    nSpell2 = SPELL_INVISIBILITY;
    }
    else if (BUFF_TYPE == "INVIS_MID")
    {
    nSpell1 = SPELL_CATS_GRACE;
    nSpell2 = SPELL_MAGE_ARMOR;
    nSpell3 = SPELL_INVISIBILITY_SPHERE;
    }
    else if (BUFF_TYPE == "INVIS_HIGH")
    {
    nSpell1 = SPELL_MAGE_ARMOR;
    nSpell2 = SPELL_CATS_GRACE;
    nSpell3 = SPELL_IMPROVED_INVISIBILITY;
    }
    else if (BUFF_TYPE == "INVIS_EPIC")
    {
    nSpell1 = SPELL_MAGE_ARMOR;
    nSpell2 = SPELL_HASTE;
    nSpell3 = SPELL_SANCTUARY;
    }
    else if (BUFF_TYPE == "MELEE_LOW")
    {
    nSpell1 = SPELL_MAGIC_WEAPON;
    nSpell2 = SPELL_BULLS_STRENGTH;
    nSpell3 =  SPELL_STONE_BONES;
    }
    else if (BUFF_TYPE == "MELEE_MID")
    {
    nSpell1 = SPELL_BULLS_STRENGTH;
    nSpell2 = SPELL_STONESKIN;
    nSpell3 = SPELL_GREATER_MAGIC_WEAPON;
    }
    else if (BUFF_TYPE == "MELEE_HIGH")
    {
    nSpell1 = SPELL_ENDURANCE;
    nSpell2 = SPELL_GREATER_STONESKIN;
    nSpell3 = SPELL_KEEN_EDGE;
    }
    else if (BUFF_TYPE == "MELEE_EPIC")
    {
    nSpell1 = SPELL_TENSERS_TRANSFORMATION;
    nSpell2 = SPELL_PREMONITION;
    nSpell3 = SPELL_BULLS_STRENGTH;
    }
    else if (BUFF_TYPE == "MIND_LOW")
    {
    nSpell1 = SPELL_RESISTANCE;
    nSpell2 = SPELL_CLARITY;
    }
    else if (BUFF_TYPE == "MIND_MID")
    {
    nSpell1 = SPELL_RESISTANCE;
    nSpell2 = SPELL_OWLS_WISDOM;
    nSpell3 = SPELL_LESSER_MIND_BLANK;
    }
    else if (BUFF_TYPE == "MIND_HIGH")
    {
    nSpell1 = SPELL_OWLS_WISDOM;
    nSpell2 = SPELL_MAGE_ARMOR;
    nSpell3 = SPELL_LESSER_MIND_BLANK;
    }
    else if (BUFF_TYPE == "MIND_EPIC")
    {
    nSpell1 = SPELL_OWLS_WISDOM;
    nSpell2 = SPELL_LESSER_MIND_BLANK;
    nSpell3 = SPELL_HASTE;
    }
    else if (BUFF_TYPE == "SHIELD_LOW")
    {
    nSpell1 = SPELL_SHIELD;
    nSpell2 = SPELL_INVISIBILITY;
    }
    else if (BUFF_TYPE == "SHIELD_MID")
    {
    nSpell1 = SPELL_SHIELD;
    nSpell2 = SPELL_PRAYER;
    nSpell3 = SPELL_INVISIBILITY_SPHERE;
    }
    else if (BUFF_TYPE == "SHIELD_HIGH")
    {
    nSpell1 = SPELL_SHIELD;
    nSpell2 = SPELL_GHOSTLY_VISAGE;
    nSpell3 = SPELL_ELEMENTAL_SHIELD;
    }
    else if (BUFF_TYPE == "SHIELD_EPIC")
    {
    nSpell1 = SPELL_SHIELD;
    nSpell2 = SPELL_SHADOW_SHIELD;
    nSpell3 = SPELL_SPELL_MANTLE;
    }

    else if (BUFF_TYPE == "SP_PROT_LOW")
    {
    nSpell1 = SPELL_SHIELD;
    nSpell2 = SPELL_RESISTANCE;
    nSpell3 = SPELL_GHOSTLY_VISAGE;
    }
    else if (BUFF_TYPE == "SP_PROT_MID")
    {
    nSpell1 = SPELL_RESISTANCE;
    nSpell2 = SPELL_SHIELD;
    nSpell3 = SPELL_LESSER_SPELL_MANTLE;
    }
    else if (BUFF_TYPE == "SP_PROT_HIGH")
    {
    nSpell1 = SPELL_SHIELD;
    nSpell2 = SPELL_ETHEREAL_VISAGE;
    nSpell3 = SPELL_GLOBE_OF_INVULNERABILITY;
    }
    else if (BUFF_TYPE == "SP_PROT_EPIC")
    {
    nSpell1 = SPELL_PROTECTION_FROM_SPELLS;
    nSpell2 = SPELL_GREATER_SPELL_MANTLE;
    nSpell3 = SPELL_ETHEREAL_VISAGE;
    }
    else if (BUFF_TYPE == "STEALTH_LOW")
    {
    nSpell1 = SPELL_CATS_GRACE;
    nSpell2 = SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
    }
    else if (BUFF_TYPE == "STEALTH_MID")
    {
    nSpell1 = SPELL_CATS_GRACE;
    nSpell2 = SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
    nSpell3 = SPELL_DISPLACEMENT;
    }
    else if (BUFF_TYPE == "STEALTH_HIGH")
    {
    nSpell1 = SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
    nSpell2 = SPELL_CATS_GRACE;
    nSpell3 = SPELL_IMPROVED_INVISIBILITY;
    }
    else if (BUFF_TYPE == "STEALTH_EPIC")
    {
    nSpell1 = SPELL_CATS_GRACE;
    nSpell2 = SPELL_ETHEREAL_VISAGE;
    nSpell3 = SPELL_IMPROVED_INVISIBILITY;
    }
}
else
    {
    nSpell1 = nChoice;   //set up the single buffs if they were initialized by the choice
    }

string sParty = "target";
if (Party==1)
    {
    sParty = "party";
    object oParty = GetFirstFactionMember(oTarget, FALSE);
    while (GetIsObjectValid(oParty))
        {
        if (nSpell1!=SPELL_ALL_SPELLS)
            AssignCommand(oTarget, ActionCastSpellAtObject(nSpell1, oTarget, METAMAGIC_ANY, TRUE, CL, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        if (nSpell2!=SPELL_ALL_SPELLS)
            AssignCommand(oTarget, ActionCastSpellAtObject(nSpell2, oTarget, METAMAGIC_ANY, TRUE, CL, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        if (nSpell3!=SPELL_ALL_SPELLS)
            AssignCommand(oTarget, ActionCastSpellAtObject(nSpell3, oTarget, METAMAGIC_ANY, TRUE, CL, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        oParty = GetNextFactionMember (oTarget);
        }
     }
     else
     {
     if (nSpell1!=SPELL_ALL_SPELLS)
        AssignCommand(oTarget, ActionCastSpellAtObject(nSpell1, oTarget, METAMAGIC_ANY, TRUE, CL, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
     if (nSpell2!=SPELL_ALL_SPELLS)
        AssignCommand(oTarget, ActionCastSpellAtObject(nSpell2, oTarget, METAMAGIC_ANY, TRUE, CL, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
     if (nSpell3!=SPELL_ALL_SPELLS)
        AssignCommand(oTarget, ActionCastSpellAtObject(nSpell3, oTarget, METAMAGIC_ANY, TRUE, CL, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
     }

SendMessageToPC(oUser, "Protecciones apiladas a Grupo  " + sParty + ".  Nivel de Lanzador: " + IntToString(CL));
}

void main()
{
    string sDMFI = GetLocalString(OBJECT_SELF, "dmfi_univ_conv");
    int iDMFI = GetLocalInt(OBJECT_SELF, "dmfi_univ_int");
    location lDMFI = GetLocalLocation(OBJECT_SELF, "dmfi_univ_location");
    if (sDMFI == "emote" || sDMFI == "pc_emote")
        DoEmoteFunction(iDMFI, OBJECT_SELF);
    else if (sDMFI == "fx")
        CreateEffects(iDMFI, lDMFI, OBJECT_SELF);
    else if (sDMFI == "server")
        dmwand_DoDialogChoice(iDMFI);
    else if (sDMFI == "afflict")
        DoAfflictFunction(iDMFI, OBJECT_SELF);
    else if (sDMFI == "voice")
        DoVoiceFunction(iDMFI, OBJECT_SELF);
    else if (sDMFI == "sound")
        DoSoundFunction(iDMFI, OBJECT_SELF);
    else if (sDMFI == "onering")
        DoOneRingFunction(iDMFI, OBJECT_SELF);
    else if (sDMFI == "faction")
        DoControlFunction(iDMFI, OBJECT_SELF);
    else if (sDMFI == "dmw")
        DoNewDMThingy(iDMFI, OBJECT_SELF);
    else if (sDMFI == "buff")
        DoBuff(iDMFI, OBJECT_SELF);

    DeleteLocalInt(OBJECT_SELF,"Tens");
}
