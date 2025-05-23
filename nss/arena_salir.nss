void main()
{
  object oPC = GetExitingObject();
   //Scripts para eliminar los pnj del área.
  ExecuteScript ("z0_area_onexit", oPC);
  if(!GetIsPC(oPC)) return;

  SendMessageToPC(oPC, "<cþ>Has salido del Modo Arena.</c>");
  DeleteLocalInt(oPC, "ARENA");
}
