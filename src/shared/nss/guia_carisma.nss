#include "lib_disguise"

void main()
{
  object oPC = GetPCSpeaker();
  object oObjetivo =  GetLocalObject(oPC, "GUIAPB_OBJETIVO");

  if(GetIsPC(oObjetivo) == FALSE)
  {
      SendMessageToPC(oPC, "Debes usar el objeto sobre un personaje jugador.");
      return;
  }

  int iCarisma = GetAbilityScore(oObjetivo, ABILITY_CHARISMA);
  string sMensaje;
  string sNombreDestino = PB_Disguise_GetNameOverride(oObjetivo) == "" ? GetName(oObjetivo) : PB_Disguise_GetNameOverride(oObjetivo);

  string sNombreActivador = GetName(oPC);

  sMensaje = "*" + sNombreDestino + "*";

  //Vemos que mensaje enviar
  object oHead = GetItemInSlot(INVENTORY_SLOT_HEAD, oObjetivo);

  if (oHead != OBJECT_INVALID && !GetHiddenWhenEquipped(oHead)) sMensaje += " lleva yelmo o capucha y te resulta imposible evidenciar nada.";
  else if(iCarisma < 6) sMensaje += " es tan horrendo y repugnante que resulta física y personalmente casi demencial.";
  else if(iCarisma < 8) sMensaje += " es tan horrendo que resulta físicamente y/o personalmente Repugnante. ";
  else if(iCarisma <10) sMensaje += " es marcada y evidentemente feo, y/o con serías dificultades para atraer a la gente.";
  else if(iCarisma <12) sMensaje += " es como primera impresión Normal, ya sea físicamente o por su personalidad y/o gestos.";
  else if(iCarisma <14) sMensaje += " tiene el atractivo, personalidad y/o apariencia física de una persona que resalta un poco. ";
  else if(iCarisma <16) sMensaje += " resulta Atractivo a simple vista o cuando se expresa, resultando normalmente alguien con presencia cuando se lo propone.";
  else if(iCarisma <18) sMensaje += " es alguien muy Notable; resulta sencillo e instintivo acabar otorgándole la credibilidad y confianza que aparenta ya sea por su labia, o sus atractivos rasgos.";
  else if(iCarisma <20) sMensaje += " resalta de una manera más que evidente, dejando claro que es alguien Excelente para desempeñar tareas que requieran de una personalidad atrayente y/o de un aspecto físico imponente.";
  else if(iCarisma <22) sMensaje += " resulta casi Extraordinario, puedes notar cómo irradia un potentísimo magnetismo especial y/o posee una condición física más que envidiable.";
  else if(iCarisma <24) sMensaje += " resulta Excepcional, puedes notar cómo irradia un enorme magnetismo especial sobrehumano y posee una condición física imponente.";
  else if(iCarisma <26) sMensaje += " resulta Abrumador, puedes notar cómo irradia un magnetismo especial casi palpable y posee una condición física escultural.";
  else if(iCarisma <28) sMensaje += " resulta Sobrecogedor, puedes notar cómo irradia un magnetismo sobrecogedor y posee una condición física sobrenatural. ";
  else if(iCarisma <30) sMensaje += " resulta casi Divino, puedes notar cómo irradia un magnetismo especial sobrenatural y posee una condición física casi perfecta.";
  else sMensaje += " resulta Divino, puedes notar cómo irradia un abrumador magnetismo especial que limita con lo divino y posee una condición física perfecta en todos los sentidos.";

  SendMessageToPC(oPC, sMensaje);
}
