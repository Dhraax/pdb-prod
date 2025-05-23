#include "cab_inc"
void main()
{
  object oPC = GetPCSpeaker();

  // Si no tienes animales de carga nanay
  object oAnimalCarga1 = GetHenchman(oPC, 1);
  object oAnimalCarga2 = GetHenchman(oPC, 2);
  object oAnimalCarga3 = GetHenchman(oPC, 3);

  if(VerSiEsAnimalDeCarga(oAnimalCarga1) == FALSE &&
     VerSiEsAnimalDeCarga(oAnimalCarga2) == FALSE &&
     VerSiEsAnimalDeCarga(oAnimalCarga3) == FALSE)
  {
      SendMessageToPC(oPC, "<cüGB>No tienes ningún animal de carga que guardar.</c>");
      return;
  }

  // Animaciones
  location lLugarEstablo = GetLocation(GetWaypointByTag(GetTag(GetArea(oPC)) + "establo"));
  float fDistanciaEstablo = GetDistanceBetweenLocations(GetLocation(oPC), lLugarEstablo);
  location lLugarelegido;
  if(fDistanciaEstablo == -1.0 || fDistanciaEstablo > 15.0) lLugarelegido = GetLocation(oPC);
  else lLugarelegido = GetLocation(GetWaypointByTag(GetTag(GetArea(oPC)) + "establo"));

  effect eDesaparecer = EffectDisappear();
  int iAnimalesDevueltos, iOroADevolver;

  if(VerSiEsAnimalDeCarga(oAnimalCarga1) == TRUE)
  {
      iAnimalesDevueltos = iAnimalesDevueltos + 1;
      iOroADevolver = iOroADevolver + ObtenerDevolucionOroDeAnimalDeCarga(oAnimalCarga1);
      RemoveHenchman(oPC, oAnimalCarga1);
      DelayCommand(1.9, AssignCommand(oAnimalCarga1, ClearAllActions(TRUE)));
      DelayCommand(2.0, AssignCommand(oAnimalCarga1, ActionMoveToLocation(lLugarelegido, TRUE)));
      DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDesaparecer, oAnimalCarga1));
      DeleteLocalString(oAnimalCarga1, "AMO");
      string sVariableStock = GetLocalString(oAnimalCarga1, "CABSTOCK");
      int iValorStock = GetLocalInt(OBJECT_SELF, sVariableStock);
      SetLocalInt(OBJECT_SELF, sVariableStock, iValorStock + 1);
  }
  if(VerSiEsAnimalDeCarga(oAnimalCarga2) == TRUE)
  {
      iAnimalesDevueltos = iAnimalesDevueltos + 1;
      iOroADevolver = iOroADevolver + ObtenerDevolucionOroDeAnimalDeCarga(oAnimalCarga2);
      RemoveHenchman(oPC, oAnimalCarga2);
      DelayCommand(1.9, AssignCommand(oAnimalCarga2, ClearAllActions(TRUE)));
      DelayCommand(2.0, AssignCommand(oAnimalCarga2, ActionMoveToLocation(lLugarelegido, TRUE)));
      DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDesaparecer, oAnimalCarga2));
      DeleteLocalString(oAnimalCarga2, "AMO");
      string sVariableStock = GetLocalString(oAnimalCarga2, "CABSTOCK");
      int iValorStock = GetLocalInt(OBJECT_SELF, sVariableStock);
      SetLocalInt(OBJECT_SELF, sVariableStock, iValorStock + 1);
  }
  if(VerSiEsAnimalDeCarga(oAnimalCarga3) == TRUE)
  {
      iAnimalesDevueltos = iAnimalesDevueltos + 1;
      iOroADevolver = iOroADevolver + ObtenerDevolucionOroDeAnimalDeCarga(oAnimalCarga3);
      RemoveHenchman(oPC, oAnimalCarga3);
      DelayCommand(1.9, AssignCommand(oAnimalCarga3, ClearAllActions(TRUE)));
      DelayCommand(2.0, AssignCommand(oAnimalCarga3, ActionMoveToLocation(lLugarelegido, TRUE)));
      DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDesaparecer, oAnimalCarga3));
      DeleteLocalString(oAnimalCarga3, "AMO");
      string sVariableStock = GetLocalString(oAnimalCarga3, "CABSTOCK");
      int iValorStock = GetLocalInt(OBJECT_SELF, sVariableStock);
      SetLocalInt(OBJECT_SELF, sVariableStock, iValorStock + 1);
  }

  // Devolvemos el 75% del oro y Ajuste de animales devueltos
  if(iOroADevolver > 0)
  {
      GiveGoldToCreature(oPC, iOroADevolver);
      SendMessageToPC(oPC, "<ceî´>Te han devuelto el 75% ("+IntToString(iOroADevolver)+" monedas de oro) del coste de los animales de carga.</c>");

      int iAnimalesSinDevolver = ObtenerIntPersistente(oPC, "ANIMALES_SIN_DEVOLVER");
      GuardarIntPersistente(oPC, "ANIMALES_SIN_DEVOLVER", iAnimalesSinDevolver - iAnimalesDevueltos);
  }

  // Guardamos el PJ
  ExportSingleCharacter(oPC);
}
