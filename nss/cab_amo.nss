#include "cab_inc"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sAmo = GetLocalString(OBJECT_SELF, "AMO");
  string sSummon = GetResRef(OBJECT_SELF);

  //Si ya tenemos uno, return;
   if(GetTag(GetHenchman(oPC, 1)) == sSummon ) return FALSE;
   else if(GetTag(GetHenchman(oPC, 2)) == sSummon ) return FALSE;
   else if(GetTag(GetHenchman(oPC, 3)) == sSummon ) return FALSE;
   else if(GetTag(GetHenchman(oPC, 4)) == sSummon ) return FALSE;

  if(sAmo == GetName(oPC, TRUE))
  {
      AddHenchman(oPC);

      if(VerSiEsMontura() == TRUE)
      {
          if(VerSiDebeTenerSonidoCaballo())
          {
              AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT));
              AssignCommand(oPC, PlaySound("c_horse_bat"+IntToString(d2())));
          }
          else
          {
              AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1));
              AssignCommand(oPC, PlaySound("c_maggris_bat"+IntToString(d3())));
          }
      }

      return TRUE;
  }

  return FALSE;
}
