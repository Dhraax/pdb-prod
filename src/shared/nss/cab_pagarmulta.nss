#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  int iMultasPagadas = ObtenerIntPersistente(oPC, "ANIMALES_SIN_DEVOLVER_MULTAS");
  int PrecioMulta = (iMultasPagadas + 1) * 5000;

  // No tienes el dinero necesario para pagar la multa
  if(GetGold(oPC) < PrecioMulta)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡no tienes las "+IntToString(PrecioMulta)+" monedas de oro para pagar la multa! No juegues conmigo, muchacho."));
      return;
  }

  // Pagamos
  SendMessageToPC(oPC, "<ceî´>Pagas "+IntToString(PrecioMulta)+" monedas de oro de multa al cuidador.</c>");
  AssignCommand(OBJECT_SELF, ActionSpeakString("¡Muy bien! La multa ha sido pagada, te dejaré alquilar animales de carga de nuevo."));
  AssignCommand(oPC, TakeGoldFromCreature(PrecioMulta, oPC, TRUE));
  GuardarIntPersistente(oPC, "ANIMALES_SIN_DEVOLVER", 0);
  GuardarIntPersistente(oPC, "ANIMALES_SIN_DEVOLVER_MULTAS", iMultasPagadas + 1);
}
