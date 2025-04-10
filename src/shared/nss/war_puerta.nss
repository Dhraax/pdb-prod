//::///////////////////////////////////////////////
//:: PUERTA DIMENSINAL
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Puerta Dimensional.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 29 de Marzo de 2011
//:://////////////////////////////////////////////
#include "nw_i0_generic"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "war_utilities"
#include "lib_disguise"

void CleanCopy(object oImage)
{
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void CreateObjectVoid(location lLoc, object oPC = OBJECT_SELF)
{
    string sName = PB_Disguise_GetNameOverride(oPC) == "" ? GetName(oPC) : PB_Disguise_GetNameOverride(oPC);
    object oCopy = CopyObject(OBJECT_SELF, lLoc, OBJECT_INVALID, "Imagen de" + sName);
    SetName(oCopy, sName);
    //Limpiamos Inventario!
    DelayCommand(0.1f, CleanCopy(oCopy));

    effect eDomi = SupernaturalEffect(EffectCutsceneDominated());
    effect eInmovil = ExtraordinaryEffect(EffectParalyze());
    effect eInmovil2 = ExtraordinaryEffect(EffectCutsceneImmobilize());

    DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInmovil, oCopy));
    DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInmovil2, oCopy));
    DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDomi, oCopy));
    SetStandardFactionReputation(STANDARD_FACTION_DEFENDER,100,OBJECT_SELF);
    SetIsTemporaryFriend(oCopy,OBJECT_SELF);
    DestroyObject(oCopy,RoundsToSeconds(1));
}



void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
        return;
    }

    if (!CheckWarlockSpellCharisma()) return;

    //Declare major variables
    object oLanzador = OBJECT_SELF;
    location lObjetivo = GetSpellTargetLocation();


    // En ciertas areas no se podra hacer la puerta dimensional
    if(GetLocalInt(GetArea(oLanzador), "NOPUERTADIMENSIONAL") == 1)
    {
        SendMessageToPC(oLanzador, "<c�<<>Puerta dimensional no se puede usar aqu�, algo te lo impide.</c>");
        return;
    }

    // Ancla dimensional
    if(GetHasSpellEffect(990))
    {
        FloatingTextStringOnCreature("<c�<<>El ancla dimensional te impide usar Puerta dimensional.</c>", OBJECT_SELF);
        return;
    }

    //Efectos Sombrios
    effect eNegrata = EffectVisualEffect(1599);
    effect eEstelaNegra = EffectVisualEffect(816);
    effect ePuerta = EffectVisualEffect(946);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oLanzador, 2.2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegrata, oLanzador, 5.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEstelaNegra, oLanzador, 5.0);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, ePuerta, lObjetivo, 5.0);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, ePuerta, GetLocation(oLanzador), 5.0);

    //Creamos la imagen mayor!
    DelayCommand(1.0, CreateObjectVoid(GetLocation(oLanzador)));
    DelayCommand(1.5,ClearAllActions(TRUE));
    DelayCommand(2.0, AssignCommand(oLanzador, ActionJumpToLocation(lObjetivo)));


    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
