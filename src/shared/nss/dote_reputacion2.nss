//Script de convocar aliados Ladron Cofrade//
// By Darth //

#include "prc_inc_util"
#include "x0_i0_henchman"
#include "henchman_inv"


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

    SetMaxHenchmen(3);

    string sSummon;
    string sMes = "No puedes convocar mas de un aliado de cada tipo.";
    object oCreature;

    effect eSummon = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    sSummon = "conj_ladsombras2";
    object oAllegado = GetLocalObject(oPC,"DOTE_REPUTACION2_PNJ");
    // Si esta muerto, return;
    if(ObtenerIntPersistente(oPC, "LADMUERTO2") > 0 )
    {
        SendMessageToPC(oPC, "<cþ<<>Tu aliado ha caido. Visita un clerigo para traerlo de vuelta.</c>");
        IncrementRemainingFeatUses(oPC, 1289);
        return;
    }

    ///Si ya tenemos uno, return;
   if(GetTag(GetHenchman(oPC, 1)) == sSummon ) { SendMessageToPC(oPC, sMes); return; }
   else if(GetTag(GetHenchman(oPC, 2)) == sSummon ) { SendMessageToPC(oPC, sMes); return; }
   else if(GetTag(GetHenchman(oPC, 3)) == sSummon ) { SendMessageToPC(oPC, sMes); return; }
   else if(GetTag(GetHenchman(oPC, 4)) == sSummon ) { SendMessageToPC(oPC, sMes); return; }

    //Si es válido el object, nanai de la china.
    if(GetIsObjectValid(oAllegado)) { SendMessageToPC(oPC, sMes); return; }

    //Check numero de convocaos permitidos.
    if(GetNumHenchmen(oPC) < 3)
    {
        if(ObtenerIntPersistente(oPC, "DOTE_REPUTACION2") == 1 ) //Si lo tenemos guardado
        {
            RestaurarLadron2(oPC);
            DelayCommand(1.0, GuardarLadron2(oPC));
            return;
        }

        else if(GetCanSummonOrc(oPC, sSummon)) //Doble check para evitar duplicados en la EE
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetSpellTargetLocation());
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
            oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
            DelayCommand(1.0, AddHenchman(oPC, oCreature));
            DelayCommand(1.5, AssignCommand(oCreature, LevelUpXP1Henchman(oPC)));
            GuardarIntPersistente(oPC, "DOTE_REPUTACION2", 1);
            SetLocalObject(oPC,"DOTE_REPUTACION2_PNJ",oCreature);
        }

        else //Por seguridad
        {
            SendMessageToPC(oPC, sMes);
            IncrementRemainingFeatUses(oPC, 1289);
        }
    }
    else
    {
        SendMessageToPC(oPC, "No puedes tener mas aliados");
        return;
    }

    //Siempre que invocamos guardamos
    DelayCommand(3.0, GuardarLadron2(oPC));
 }
