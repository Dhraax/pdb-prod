#include "inc_sqlite_time"

void main()
{

object oPC = OBJECT_SELF;
object oMod = GetModule();

    int iVariableSpam = GetLocalInt(oMod, "NOMASVARITAS" + GetName(oPC));
    if(iVariableSpam > SQLite_GetTimeStamp())
        {
        SendMessageToPC(oPC,"<c´þd>No puedes Imbuir mas objetos hasta pasados "+IntToString(iVariableSpam - SQLite_GetTimeStamp())+" segundos.</c>");
        IncrementRemainingFeatUses(oPC, 1498);
        return;
        }

  AssignCommand(oPC,ActionStartConversation(oPC,"war_varitas",TRUE,FALSE));
}
