void main()
{
  object oPC = GetEnteringObject();
  if(GetIsPC(oPC))
  {
      SetLocalInt(oPC, "estaEnDesencadentanteParaDescanso", 1);
      SendMessageToPC(oPC, "<c þ >Éste parece un buen lugar para descansar.</c>");
  }
}
