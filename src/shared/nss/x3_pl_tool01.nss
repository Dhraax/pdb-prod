//::///////////////////////////////////////////////
//:: Player Tool 1 Instant Feat
//:: x3_pl_tool01
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
    VARITA DE EMOCIONES
*/
//:://////////////////////////////////////////////
//:: Created By: Brian Chung
//:: Created On: 2007-12-05
//:://////////////////////////////////////////////

void main()
{
  object oPC = OBJECT_SELF;
  location lLocation = GetLocalLocation(oPC, "dmfi_location");
  if(!GetIsObjectValid(GetAreaFromLocation(lLocation))) lLocation = GetItemActivatedTargetLocation();

  SetLocalObject(oPC, "dmfi_univ_target", oPC);
  SetLocalLocation(oPC, "dmfi_univ_location", lLocation);
  SetLocalString(oPC, "dmfi_univ_conv", "pc_emote");
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionStartConversation(oPC, "dmfi_universal", TRUE));
}
