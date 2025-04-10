void main()
{
  object oPC = GetPCSpeaker();
  string sTextoAnteriorCambio = GetLocalString(oPC, "DSCPJ_ANTERIORCAMBIO");

  SetDescription(oPC, sTextoAnteriorCambio);
  DeleteLocalString(oPC, "DSCPJ_ANTERIORCAMBIO");
  FloatingTextStringOnCreature("<c´þd>* Deshaces el último cambio de la descripción de tu PJ *</c>", oPC);
}
