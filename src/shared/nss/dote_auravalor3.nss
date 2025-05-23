//::///////////////////////////////////////////////
//:: AURA DE VALOR (al salir del aura)
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Aptitud sobrenatural de los Paladines a Nivel 3.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 6 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "inc_spells"

void main()
{
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator();
    int iSpell = GetSpellId();

    gsSPRemoveEffect(oTarget, iSpell);
}
