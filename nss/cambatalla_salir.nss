void main()
{
  object oPC = GetExitingObject();
   //Scripts para eliminar los pnj del área.
  ExecuteScript ("z0_area_onexit", oPC);
  if(!GetIsPC(oPC)) return;

  SendMessageToPC(oPC, "<cþ>Has salido del campo de batalla.</c>");
  DeleteLocalInt(oPC, "CAMPOBATALLA");
}
