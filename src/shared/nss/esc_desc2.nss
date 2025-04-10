void main()
{
  object oPC = GetPCSpeaker();
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");
  string sTextoAnteriorCambio = GetLocalString(oEscritoGuardado, "ESC_ANTERIORCAMBIO");

  SetDescription(oEscritoGuardado, sTextoAnteriorCambio);
  DeleteLocalString(oEscritoGuardado, "ESC_ANTERIORCAMBIO");
  FloatingTextStringOnCreature("<c´þd>* Deshaces el último cambio escrito *</c>", oPC);
}
