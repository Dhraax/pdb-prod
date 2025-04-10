void main()
{
object oEntrante = GetEnteringObject();
if(GetLocalInt(oEntrante, "INFRACUERDA") == 0)
{
  AssignCommand(oEntrante, ActionSpeakString("Mmmmh... Creo que si tuviera una cuerda... podría cruzar al otro lado..."));
  SetLocalInt(oEntrante, "INFRACUERDA", 1);
  DelayCommand(200.0, DeleteLocalInt(oEntrante, "INFRACUERDA"));
}
}
