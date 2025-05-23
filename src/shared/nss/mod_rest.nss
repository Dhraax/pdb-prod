void main()
{
ForceRest(GetLastPCRested());
SendMessageToPC(GetLastPCRested(),"Descanso instantaneo");
AssignCommand(GetLastPCRested(), ClearAllActions(TRUE));
}
