#include "cab_inc"
void main()
{
  object oPC = GetPCSpeaker();
  object oMonturaMuerta = GetLocalObject(oPC, "CAB_POSIBLEMUERTO");
  object oMonturaGuardada = GetLocalObject(oPC, "CAB_MONTURAGUARDADA");

  // Fijamos la montura como muerta, mandamos mensajes y eliminamos variables inutiles al PJ
  SetLocalInt(oMonturaMuerta, "CAB_MUERTO", TRUE);
  SetItemCursedFlag(oMonturaMuerta, FALSE);
  DescripcionMontura(oMonturaMuerta, "Muerta");
  SendMessageToPC(oPC, "<cüGB>Has establecido esta montura como muerta, piensas que quizás puedas resucitarla en algún establo. (Activa el objeto de nuevo para más información)</c>");
  DeleteLocalObject(oPC, "CAB_POSIBLEMUERTO");

  // Si la montura se nos guardo bien y aun existe en el servidor, la destruimos
  if(oMonturaGuardada != OBJECT_INVALID)
  {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT,  EffectDisappear(), oMonturaGuardada);
      DeleteLocalObject(oPC, "CAB_MONTURAGUARDADA");
  }
}
