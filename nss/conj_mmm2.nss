//::///////////////////////////////////////////////
//:: MAGNIFICA MANSION DE MORDENKAINEN
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Magnifica mansion de Mordenkainen:
    Ubicado de puerta.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 31 de Mayo de 2010
//:://////////////////////////////////////////////

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
  object oMMM = OBJECT_SELF;
  object oActivator = GetLastUsedBy();
  object oCaster = GetLocalObject(oMMM, "CASTER");
  object oPC = GetFirstPC();
  int iUnaVez = FALSE;
  while(GetIsObjectValid(oPC) && iUnaVez == FALSE)
  {
      if(oPC == oCaster)
      {
          if(GetFactionLeader(oPC) == GetFactionLeader(oActivator))
          {
              SetLocalLocation(oActivator, "MMM", GetLocation(oActivator));
              AssignCommand(oActivator, ClearAllActions());
              AssignCommand(oActivator, JumpToLocation(GetLocation(GetWaypointByTag(GetTag(oMMM)+"_wp"))));
              iUnaVez = TRUE;
          }
      }

      oPC = GetNextPC();
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}
