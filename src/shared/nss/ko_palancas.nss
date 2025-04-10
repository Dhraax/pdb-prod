void main()

{
  string sCerrada = GetLocalString(OBJECT_SELF, "dialogo_cerrada");
  string sAbierta = GetLocalString(OBJECT_SELF, "dialogo_abierta");
  string sVariable = GetLocalString(OBJECT_SELF, "variable_activacion");
  object oPersonaje = GetLastUsedBy();
  string sEtiquetaSimbolo = GetLockKeyTag(OBJECT_SELF);
  object oPuerta1 = GetObjectByTag("DOOR1_" + GetTag(OBJECT_SELF));
  object oPuerta2 = GetObjectByTag("DOOR2_" + GetTag(OBJECT_SELF));
  object oPuerta3 = GetObjectByTag("DOOR3_" + GetTag(OBJECT_SELF));
  object oPuerta4 = GetObjectByTag("DOOR4_" + GetTag(OBJECT_SELF));
  object oPuerta5 = GetObjectByTag("DOOR5_" + GetTag(OBJECT_SELF));
  // Si se necesita algún tipo de símbolo o llave (que será aquella que ponga en las propiedades del objeto palanca, en cerradura) para accionar la palanca ocurrirá lo siguiente.
  if(GetLocked(OBJECT_SELF) == TRUE)
  {
      if(GetItemPossessedBy(oPersonaje, sEtiquetaSimbolo) == OBJECT_INVALID)
      {
          AssignCommand(oPersonaje, SpeakString(sCerrada));
          return;
      }
  }
  // Se ha diseñado el script para hasta un máximo de cinco puertas que se abran con una sola palanca. Si es que es necesario que se amplíe dicho máximo dejar constancia
  // en el staff, para redefinir el script y no crear veinte de lo mismo.
  if (GetLocalInt(OBJECT_SELF,sVariable) == 0)

    {
    PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    SetLocalInt(OBJECT_SELF,sVariable,1);
    }
  else
    {
    PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
    SetLocalInt(OBJECT_SELF,"ko_nash_palanca_1",0);
    }
  ActionDoCommand(ActionOpenDoor(oPuerta1));
  ActionDoCommand(ActionOpenDoor(oPuerta2));
  ActionDoCommand(ActionOpenDoor(oPuerta3));
  ActionDoCommand(ActionOpenDoor(oPuerta4));
  ActionDoCommand(ActionOpenDoor(oPuerta5));
  AssignCommand(oPersonaje, SpeakString(sAbierta));

}
