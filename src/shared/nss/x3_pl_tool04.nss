//::///////////////////////////////////////////////
//:: (PB) GUARDAR PERSONAJE
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Guarda el PJ en el servervault.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 24 de Mayo de 2011
//:: Rebuild by: Zeratul 11/05/2014
//:://////////////////////////////////////////////

#include "lib_disguise"

void main()
{
    object oPC = OBJECT_SELF;
    string sName = PB_Disguise_GetNameOverride(oPC) == "" ? GetName(oPC) : PB_Disguise_GetNameOverride(oPC);

    if(GetIsPC(oPC) || GetIsDM(oPC))
    {
        if(GetIsInCombat(oPC))
        {
            FloatingTextStringOnCreature("<c´þd>No puedes guardar el personaje en combate!!</c>", oPC);
        }
        else
        {
            FloatingTextStringOnCreature("<c´þd>** ["+sName+"] se ha guardado con éxito **</c>", oPC);
            ExportSingleCharacter(oPC);
        }
    }
}
