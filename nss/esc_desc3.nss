void main()
{
  object oPC = GetPCSpeaker();
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");

  DeleteLocalInt(oEscritoGuardado, "ESC_USADO");
  DeleteLocalString(oEscritoGuardado, "ESC_ANTERIORCAMBIO");
  SetDescription(oEscritoGuardado, "Esto es una libro o una nota en blanco, podrías escribir aquí si tuvieras una pluma con tinta. Usa la pluma sobre este objeto para escribir.");
  FloatingTextStringOnCreature("<c´þd>* Borras por completo el contenido de " + GetName(oEscritoGuardado) + " *</c>", oPC, FALSE);
}
