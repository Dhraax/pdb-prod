//::///////////////////////////////////////////////
//:: MAGNIFICA MANSION DE MORDENKAINEN
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Magnifica mansion de Mordenkainen:
    OnEnter del area.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 31 de Mayo de 2010
//:://////////////////////////////////////////////

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
  if(!GetLocalInt(OBJECT_SELF, "OBSAZENO"))
  {
      object oPC = GetEnteringObject();
      //Scripts para añadir los pnj del área.
       ExecuteScript ("z0_area_onenter", oPC);
      location lMMM = GetLocalLocation(oPC, "MMM");
      DeleteLocalLocation(oPC, "MMM");
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, DelayCommand(0.1, JumpToLocation(lMMM)));
  }

  ExecuteScript("hc_innroom_ente4",OBJECT_SELF); // Que no se pueda dormir
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
