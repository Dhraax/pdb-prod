//::///////////////////////////////////////////////
//:: MAGNIFICA MANSION DE MORDENKAINEN
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Magnifica mansion de Mordenkainen:
    Puerta de salida.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 31 de Mayo de 2010
//:://////////////////////////////////////////////

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
  object oPC = GetClickingObject();
  location lMMM = GetLocalLocation(oPC, "MMM");
  DeleteLocalLocation(oPC, "MMM");
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, DelayCommand(0.1, JumpToLocation(lMMM)));
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
