//::///////////////////////////////////////////////
//:: Player Tool 2 Instant Feat
//:: x3_pl_tool02
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
    BOLSA DE DADOS
*/
//:://////////////////////////////////////////////
//:: Created By: Brian Chung
//:: Created On: 2007-12-05
//:://////////////////////////////////////////////

void main()
{
  object oPC = OBJECT_SELF;

  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionStartConversation(oPC, "pe_d20bolsadados", TRUE));
}
