////::///////////////////////////////////////////////
//:: Orc Warlord
//:://////////////////////////////////////////////
/*
    Gather Horde - Summons an Axe thrower of proper level as a henchmen.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////

#include "prc_inc_util"
#include "x0_i0_henchman"
#include "henchman_inv"
#include "nwnx_creature"


const int iNumSummon = 1;

int GetCanSummonOrc(object oPC, string sCreatureResRef)
{
     int bCanSummon;
     int iNumOrc = 0;

     object oHench1 = GetHenchman(oPC, 1);
     object oHench2 = GetHenchman(oPC, 2);
     object oHench3 = GetHenchman(oPC, 3);
     object oHench4 = GetHenchman(oPC, 4);

     if(GetResRef(oHench1) ==  sCreatureResRef) iNumOrc += 1;
     if(GetResRef(oHench2) ==  sCreatureResRef) iNumOrc += 1;
     if(GetResRef(oHench3) ==  sCreatureResRef) iNumOrc += 1;
     if(GetResRef(oHench4) ==  sCreatureResRef) iNumOrc += 1;

     if(iNumSummon > iNumOrc) bCanSummon = TRUE;
     else                     bCanSummon = FALSE;

     return bCanSummon;
}

void main()
{

    object oPC = OBJECT_SELF;

    int iHD = GetLevelByClass(49, oPC);
    int iMaxHenchmen = 3;

    //Menor a nivel 3, solo 2 convocados.
    if(iHD < 3) iMaxHenchmen -= 2;
    SetMaxHenchmen(iMaxHenchmen);

    string sSummon;
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    string sMes = "No puedes convocar mas de un orco de cada tipo.";
    object oCreature;

    effect eSummon = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    sSummon = "ow_sum_axe";
    object oAllegado = GetLocalObject(oPC,"WAR_AXE_PNJ");

    // Si esta muerto, return;
    if(ObtenerIntPersistente(oPC, "AXEMUERTO") > 0 )
    {
        SendMessageToPC(oPC, "<cþ<<>Tu aliado ha caido. Visita un clerigo para traerlo de vuelta.</c>");
        return;
    }

    //Si ya tenemos uno, return;
    if(GetTag(GetHenchman(oPC, 1)) == sSummon ) { SendMessageToPC(oPC, sMes); return; }
    else if(GetTag(GetHenchman(oPC, 2)) == sSummon ) { SendMessageToPC(oPC, sMes); return; }
    else if(GetTag(GetHenchman(oPC, 3)) == sSummon ) { SendMessageToPC(oPC, sMes); return; }
    else if(GetTag(GetHenchman(oPC, 4)) == sSummon ) { SendMessageToPC(oPC, sMes); return; }

    //Si es válido el object, nanai de la china.
    if(GetIsObjectValid(oAllegado)) { SendMessageToPC(oPC, sMes); return; }

    //Check numero de convocaos permitidos.
    if(GetNumHenchmen(oPC) < iMaxHenchmen)
    {
        if(ObtenerIntPersistente(oPC, "WAR_AXE") == 1 ) //Si lo tenemos guardado
        {
            RestaurarOrcAxe(oPC);
            DelayCommand(3.0, GuardarOrcAxe(oPC));
            return;
        }

        else if(GetCanSummonOrc(oPC, sSummon)) //Doble check para evitar duplicados en la EE
        {
              ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetSpellTargetLocation());
              ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
              oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
              DelayCommand(1.0, AddHenchman(oPC, oCreature));
              DelayCommand(1.5, AssignCommand(oCreature, LevelUpXP1Henchman(oPC)));
              GuardarIntPersistente(oPC, "WAR_AXE", 1);
              SetLocalObject(oPC,"WAR_AXE_PNJ",oCreature);

              //Asignamos la raza y apariencia segun el creador
            if(sSubraza == "trasgo" || sSubraza == "gran trasgo")
            {
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_GOBLINOID);
                SetCreatureAppearanceType(oCreature, APPEARANCE_TYPE_GOBLIN_CHIEF_B);
            }
            else if(sSubraza == "ogro" || sSubraza == "ogro hechicero")
            {
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_GIANT);
                SetCreatureAppearanceType(oCreature, APPEARANCE_TYPE_OGRE_CHIEFTAIN);
            }
            else if(sSubraza == "kobold")
            {
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                SetCreatureAppearanceType(oCreature, APPEARANCE_TYPE_KOBOLD_CHIEF_B);
            }
        }
    }
    else
    {
        SendMessageToPC(oPC, "No puedes tener mas aliados");
        return;
    }

    //Siempre que invocamos guardamos
    DelayCommand(3.0, GuardarOrcAxe(oPC));
 }
