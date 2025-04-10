//::///////////////////////////////////////////////
//:: Player Tool 2 Instant Feat
//:: x3_pl_tool02
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
    GUIA DE PB
*/
//:://////////////////////////////////////////////
//:: Created By: Brian Chung
//:: Created On: 2007-12-05
//:://////////////////////////////////////////////

void main()
{
  object oPC = OBJECT_SELF;
  object oObjetivo = GetSpellTargetObject();

  SetLocalObject(oPC, "GUIAPB_OBJETIVO", oObjetivo);

  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionStartConversation(oPC, "guia_pb", TRUE));
}
