void main()
{
  object oPC = GetPCSpeaker();

  DeleteLocalString(oPC, "DSCPJ_ANTERIORCAMBIO");
  SetDescription(oPC, "\n");
  FloatingTextStringOnCreature("<c´þd>* Borras por completo la descripción de tu PJ *</c>", oPC, FALSE);
}

