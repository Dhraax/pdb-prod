void main()
{
  object oPC = GetExitingObject();

  if(GetIsPC(oPC) != TRUE) return;

  DeleteLocalInt(oPC,"TRAMPACIDO");
}
