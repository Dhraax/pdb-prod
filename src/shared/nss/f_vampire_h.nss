#include "f_vampire_spls_h"
#include "f_vampirebite_h"
#include "f_vampire_persis"
#include "mti_libreria"
#include "lib_race"

void DestruirHijoNoche(object oSelf)
{
    FloatingTextStringOnCreature("Has perdido el control sobre esta criatura.", oSelf, FALSE);
    DestroyObject(oSelf);
}

void LlamarHijosNoche(int tipo, int num, object oPJ)
{
    string sCriatura;
    int i;
    switch(tipo)
    {
        case 1: sCriatura = "asy_rata";
                break;
        case 2: sCriatura = "asy_murcielago2";
                break;
        case 3: sCriatura="asy_lobo";
                break;
    }
    object oCriatura;
    location lLocal = GetLocation(oPJ);
    effect eDom = SupernaturalEffect(EffectCutsceneDominated());
    effect eVisual = EffectVisualEffect(460);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual,lLocal,5.0);

    for(i=0;i<num;i++)
    {
        oCriatura = CreateObject(OBJECT_TYPE_CREATURE, sCriatura,lLocal);
        //if(!GetIsObjectValid(oCriatura)) return;
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDom, oCriatura);
        DelayCommand(HoursToSeconds(24), DestruirHijoNoche(oCriatura));
    }

}
//This resets the blood hunger system
void Vampire_Fresh_Blood(object oPC = OBJECT_SELF);

int Vampire_Remove_Aura(object oPC = OBJECT_SELF)
{
  int iReturn = FALSE;

  effect eEfecto = GetFirstEffect(oPC);
  while(GetIsEffectValid(eEfecto))
  {
      if(GetEffectSubType(eEfecto) == SUBTYPE_EXTRAORDINARY &&
         GetEffectType(eEfecto) == EFFECT_TYPE_AREA_OF_EFFECT)
      {
          iReturn = TRUE;
          RemoveEffect(oPC, eEfecto);
      }

      eEfecto = GetNextEffect(oPC);
  }

  return iReturn;
}

void Vampire_Apply_Aura(object oPC = OBJECT_SELF)
{
  effect eAuraSmall = ExtraordinaryEffect(EffectAreaOfEffect(SmallAuraType, "f_vampireaura", "****", "****"));
  effect eAuraLarge = ExtraordinaryEffect(EffectAreaOfEffect(LargeAuraType, "f_vampireaura", "****", "****"));
  effect eVisual;
  int iHD = Determine_Vampire_Level(oPC);

  if(iHD >= LargeAuraLevel){ ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAuraLarge, oPC);}
  if(iHD >= SmallAuraLevel){ ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAuraSmall, oPC);  }
}

void Vampire_Remove_Stats(object oPC = OBJECT_SELF)
{
  ReaplicarEfectosPB(oPC, FALSE);
}

void Vampire_Apply_Stats(object oPC = OBJECT_SELF)
{
    ReaplicarEfectosPB(oPC,TRUE);
}

void Vampire_Equipment_Removal_By_Level(object oPC = OBJECT_SELF)
{
    int iHD = Determine_Vampire_Level(oPC);
    object oItem = GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_MIST_ABILITY");
    if(iHD < MistLevel && GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_WOLF_ABILITY");
    if(iHD < WolfLevel && GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "asy_formalobo");
    if(iHD < WolfLevel && GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_BAT_ABILITY");
    if(iHD < BatLevel && GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "asy_formamurci");
    if(iHD < BatLevel && GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "asy_formarata");
    if(iHD < BatLevel && GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_SUNSTONE");
    if(iHD < SunstoneLevel && GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "asy_vuelo");
    if(iHD < BatLevel && GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "asy_llamarhijosnoche");
    if(iHD < BatLevel && GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "asy_obj_cemevuelo");
    if(iHD < 10 && GetIsObjectValid(oItem)) DestroyObject(oItem);


    if((!UseAuraItem || (iHD < LargeAuraLevel && iHD < SmallAuraLevel)) && GetIsObjectValid(oItem)) DestroyObject(oItem);
    if(iHD < 21 && BloodNeedAffectEpics)
    {
        GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_SUMMON");
        if(GetIsObjectValid(oItem)) DestroyObject(oItem);
        GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_REFUGE");
        if(GetIsObjectValid(oItem)) DestroyObject(oItem);
        GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_LOOK_HUNGER");
        if(GetIsObjectValid(oItem)) DestroyObject(oItem);
    }
}

void Vampire_Equipment_Removal(object oPC = OBJECT_SELF, int iDropCoffin = TRUE)
{
    object oO = GetFirstItemInInventory(oPC);
    string sS;
    while(GetIsObjectValid(oO))
    {
        sS = GetTag(oO);
        if(sS == "FALLEN_VAMPIRE_FANGS" || sS == "FALLEN_VAMPIRE_MIST_ABILITY"
        || sS == "FALLEN_VAMPIRE_WOLF_ABILITY" || sS == "FALLEN_VAMPIRE_BAT_ABILITY"
        || sS == "FALLEN_VAMPIRE_SUNSTONE" || sS == "FALLEN_VAMPIRE_AURA_ABILITY"
        || sS == "FALLEN_VAMPIRE_SUMMON" || sS == "FALLEN_VAMPIRE_REFUGE"
        || sS == "FALLEN_VAMPIRE_LOOK_HUNGER" || sS == "FALLEN_VAMPIRE_BITE_TOKEN"
        || sS == "asy_formalobo" || sS == "asy_vuelo"
        || sS == "asy_formarata" || sS == "asy_formamurci"
        || sS == "asy_llamarhijosnoche" || sS == "asy_obj_cemevuelo") DestroyObject(oO);
        else if(sS == "yourcoffin" && iDropCoffin)
        {
            DestroyObject(oO);
            SendMessageToPC(oPC, "Mientras tu cuerpo se debilita, dejas caer el sarcófago.");
            CreateObject(OBJECT_TYPE_PLACEABLE, "vampirecoffin", GetLocation(oPC));
        }
        oO = GetNextItemInInventory(oPC);
    }
}

void Vampire_Equipment_Creation(object oPC = OBJECT_SELF)
{
    int iHD = Determine_Vampire_Level(oPC);
    string sSubRace = GetStringLowerCase(GetSubRace(oPC));

    if(!GetIsObjectValid(GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_FANGS"))) CreateItemOnObject("vampirefangs", oPC);
    if(iHD >= MistLevel && !GetIsObjectValid(GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_MIST_ABILITY"))) CreateItemOnObject("vampiremistform", oPC);
    if(iHD >= SunstoneLevel && !GetIsObjectValid(GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_SUNSTONE"))) CreateItemOnObject("vampiresunstone", oPC);
    if(iHD >= BatLevel && !GetIsObjectValid(GetItemPossessedBy(oPC, "asy_obj_cemevuelo"))) CreateItemOnObject("asy_obj_cemevuelo", oPC);
    if (UseAuraItem && (iHD >= LargeAuraLevel || iHD >= SmallAuraLevel) && !GetIsObjectValid(GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_AURA_ABILITY"))) CreateItemOnObject("vampireaura", oPC);

    if (sSubRace == "vampiro") {
        if (iHD >= WolfLevel && !GetIsObjectValid(GetItemPossessedBy(oPC, "asy_formalobo"))) CreateItemOnObject("asy_forma003", oPC);
        if (iHD >= BatLevel && !GetIsObjectValid(GetItemPossessedBy(oPC, "FALLEN_VAMPIRE_BAT_ABILITY"))) CreateItemOnObject("vampirebatform", oPC);
        if (iHD >= BatLevel && !GetIsObjectValid(GetItemPossessedBy(oPC, "asy_formamurci"))) CreateItemOnObject("asy_forma01", oPC);
        if (iHD >= BatLevel && !GetIsObjectValid(GetItemPossessedBy(oPC, "asy_formarata"))) CreateItemOnObject("asy_forma002", oPC);
        if (iHD >= BatLevel && !GetIsObjectValid(GetItemPossessedBy(oPC, "asy_vuelo"))) CreateItemOnObject("asy_vuelo", oPC);
        if (iHD >= BatLevel && !GetIsObjectValid(GetItemPossessedBy(oPC, "asy_llamarhijosnoche"))) CreateItemOnObject("asy_llamarhijono", oPC);
        if (iHD >= 10 && !GetIsObjectValid(GetItemPossessedBy(oPC, "asy_obj_cemevuelo"))) CreateItemOnObject("asy_obj_cemevuelo", oPC);
    }
}

void Vampire_Remove_Advancement_Books(object oPC = OBJECT_SELF)
{
object oO = GetFirstItemInInventory(oPC);
while(GetIsObjectValid(oO))
    {
    if(GetTag(oO) == "fv_BookofElderVampireAdvancement") DestroyObject(oO);
    oO = GetNextItemInInventory(oPC);
    }
}

void SetIsVampire(int isVampire = TRUE, object oPC = OBJECT_SELF)
{
    if (GetIsVampire(oPC) == isVampire) return;
    if (isVampire)
    {
        Vampire_Apply_Stats(oPC);
        Vampire_Equipment_Creation(oPC);
        Vampire_Set_Int(oPC, "FALLEN_SUBRACE", 1);
        Vampire_Set_Location(oPC, "FALLEN_VAMPIRE_MARK", GetLocation(oPC));
        Vampire_Set_String(oPC, "FALLEN_VAMPIRE_ORIGINAL_SUBRACE", GetSubRace(oPC));
        if (AlterSubRaceField) SetSubRace(oPC, "Vampiro");
        Vampire_Delete_Int(oPC, "FALLEN_VAMPIRE_MIST");
        int iVLevel = VampireStartLevel;
        int iHD = GetHitDice(oPC);
        if(UseCharacterLevel) iVLevel = iHD;
        else if(CapVampireLevel && iVLevel > iHD) iVLevel = iHD;
        if(iVLevel > 40) iVLevel = 40;
        Vampire_Set_Int(oPC, "FALLEN_VAMPIRE_LEVEL", iVLevel);
    }
    else
    {
        Vampire_Equipment_Removal(oPC);
        Vampire_Remove_Stats(oPC);
        Vampire_Remove_Advancement_Books(oPC);
        Vampire_Delete_Int(oPC, "FALLEN_SUBRACE");
        Vampire_Delete_Location(oPC, "FALLEN_VAMPIRE_MARK");
        if (AlterSubRaceField)
        {
            Vampire_Read_String(oPC, "FALLEN_VAMPIRE_ORIGINAL_SUBRACE");
            SetSubRace(oPC, GetLocalString(oPC, "FALLEN_VAMPIRE_ORIGINAL_SUBRACE"));
        }
        Vampire_Delete_Int(oPC, "FALLEN_VAMPIRE_MIST");
        Vampire_Delete_Int(oPC, "FALLEN_VAMPIRE_LEVEL");
        Vampire_Delete_Int(oPC, "FALLEN_VAMPIRE_EPIC");
    }
}

void Vampire_Penalty_Expired(object oPC = OBJECT_SELF)
{ //starvation sucks!
    if(GetLocalInt(oPC, "FALLEN_VAMPIRE_BLOOD_SYSTEM") > 0) return;
    int iMark = GetLocalInt(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY_TIMER")- 1;
    //FloatingTextStringOnCreature("Vampire_Penalty_Expired called: mark is " + IntToString(iMark) + ".", oPC);
    if(iMark <= 0)
    {
        Vampire_Set_Int(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY_TIMER", BloodNeedPenalty);
        Vampire_Set_Int(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY", GetLocalInt(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY") + 1);
        Vampire_Apply_Stats(oPC);
        Vampire_Equipment_Removal_By_Level(oPC);
        FloatingTextStringOnCreature("¡Tu sed de sangre ha dañado tus capacidades vampíricas!", oPC, FALSE);
    }
    else Vampire_Set_Int(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY_TIMER", iMark);

    DelayCommand(HoursToSeconds(1), Vampire_Penalty_Expired(oPC));
}

void Vampire_Delay_Expired(object oPC = OBJECT_SELF)
{ //give a warning that they are getting hungry
    if(GetLocalInt(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY_TIMER") > 0) return;
    int iMark = GetLocalInt(oPC, "FALLEN_VAMPIRE_BLOOD_SYSTEM") - 1;
    //FloatingTextStringOnCreature("Vampire_Delay_Expired called: mark is " + IntToString(iMark) + ".", oPC);
    if(iMark <= 0)
    {
        Vampire_Set_Int(oPC, "FALLEN_VAMPIRE_BLOOD_SYSTEM", 0);
        Vampire_Set_Int(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY_TIMER", BloodNeedPenalty);
        FloatingTextStringOnCreature("Tu cuerpo tiene sed de sangre.", oPC, FALSE);
        DelayCommand(HoursToSeconds(1), Vampire_Penalty_Expired(oPC));
    }
    else
    {
        Vampire_Set_Int(oPC, "FALLEN_VAMPIRE_BLOOD_SYSTEM", iMark);
        DelayCommand(HoursToSeconds(1), Vampire_Delay_Expired(oPC));
    }
}

void Vampire_Fresh_Blood(object oPC = OBJECT_SELF)
{ //This will just update the blood need timestamp and remove any penalties you had
if(!UseBloodNeedSystem) return;
int isPenalized = (GetLocalInt(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY") > 0);
int iCurrent = GetLocalInt(oPC, "FALLEN_VAMPIRE_BLOOD_SYSTEM");
Vampire_Set_Int(oPC, "FALLEN_VAMPIRE_BLOOD_SYSTEM", BloodNeedDelay);
Vampire_Set_Int(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY_TIMER", 0);
if(iCurrent == 0) DelayCommand(HoursToSeconds(1), Vampire_Delay_Expired(oPC));
//FloatingTextStringOnCreature("Vampire_Fresh_Blood called.", oPC);
if(isPenalized)
    {
    Vampire_Delete_Int(oPC, "FALLEN_VAMPIRE_BLOOD_PENALTY");
    Vampire_Apply_Stats(oPC);
    Vampire_Equipment_Creation(oPC);
    FloatingTextStringOnCreature("La sangre restaura tu fuerza perdida.", oPC, FALSE);
    }
}

int GetIsRaceBite(object oTarget = OBJECT_SELF)
{
    int iRace =GetRacialType(oTarget);
    if(PB_Race_GetIsUndead(oTarget)  ||
           iRace == RACIAL_TYPE_VERMIN  ||
           iRace == RACIAL_TYPE_ELEMENTAL  ||
           iRace == RACIAL_TYPE_CONSTRUCT  ||
           iRace == RACIAL_TYPE_OOZE  ||
           iRace == RACIAL_TYPE_ABERRATION  ||
           iRace == RACIAL_TYPE_ANIMAL ||
           iRace == RACIAL_TYPE_BEAST ||
           iRace == RACIAL_TYPE_DRAGON ||
           iRace == RACIAL_TYPE_FEY ||
           iRace == RACIAL_TYPE_GIANT ||
           iRace == RACIAL_TYPE_HUMANOID_REPTILIAN ||
           iRace == RACIAL_TYPE_MAGICAL_BEAST ||
           iRace == RACIAL_TYPE_HUMANOID_GOBLINOID ||
           iRace == RACIAL_TYPE_OUTSIDER ||
           iRace == RACIAL_TYPE_INVALID)
        {
             return FALSE;
        }
    if(GetIsPC(oTarget)==TRUE)
    {
      if (PB_Race_GetIsUndead(oTarget) && GetIsVampire(oTarget) ==FALSE)
      {
            FloatingTextStringOnCreature("No puedes morder a un personaje no muerto.", oTarget, FALSE);
            return FALSE;
      }
      return TRUE;
    }

    return TRUE;
}
