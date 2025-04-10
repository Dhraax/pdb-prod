#include "f_vampire_spls_h"
void main()
{
  object oPJ = GetLastUsedBy();
  object oTrampilla = GetNearestObjectByTag("tramp_vam_velada");
  object oLlave = GetItemPossessedBy(oPJ, "llav_crip_vv");
  string sSubraza = GetStringLowerCase(GetSubRace(oPJ));
  location lLugar = GetLocation(GetWaypointByTag("subida_vam_v_tramp"));

  if(GetLocalInt(OBJECT_SELF, "TRAMP_V_V") == 1)
  {
      AssignCommand(oPJ, ActionJumpToLocation(lLugar));
      return;
  }

  if(GetIsVampire(oPJ) || sSubraza == "ghul")
  {
      DelayCommand(0.5, AssignCommand(oTrampilla, PlayAnimation(ANIMATION_PLACEABLE_OPEN)));
      DelayCommand(0.5, SetLocalInt(oTrampilla, "TRAMP_V_V", 1));
      DelayCommand(1.4, AssignCommand(oPJ, ClearAllActions()));
      DelayCommand(1.5, AssignCommand(oPJ, ActionJumpToLocation(lLugar)));
      DelayCommand(5.0, AssignCommand(oTrampilla,PlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
      DelayCommand(5.0, DeleteLocalInt(oTrampilla, "TRAMP_V_V"));
      return;
  }

  if(oLlave != OBJECT_INVALID)
  {
      DestroyObject(oLlave);
      DelayCommand(0.5, AssignCommand(oTrampilla, PlayAnimation(ANIMATION_PLACEABLE_OPEN)));
      DelayCommand(0.5, SetLocalInt(oTrampilla, "TRAMP_V_V", 1));
      DelayCommand(1.4, AssignCommand(oPJ, ClearAllActions()));
      DelayCommand(1.5, AssignCommand(oPJ, ActionJumpToLocation(lLugar)));
      DelayCommand(5.0, AssignCommand(oTrampilla, PlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
      DelayCommand(5.0, DeleteLocalInt(oTrampilla, "TRAMP_V_V"));
  }
  else
  {
      PlaySound("as_dr_woodlgcl1");
      FloatingTextStringOnCreature("*Cerrada*", oPJ);
  }
}
