void main()
{
  object oPC = GetPCSpeaker();

  SendMessageToPC(oPC, "<cÍþ>Ahora estás en el <cþ>[Modo Escritura]</c> y no podrás hablar con los demás jugadores. Habla el nombre del retrato que desees aplicar a tu PJ sin cerrar esta conversación. Para mirar el nombre del retrato debes irte a tu carpeta 'portraits' y fijarte en el retrato escogido. Su nombre será el mismo nombre del archivo exceptuando el último carácter, por ejemplo, el nombre del archivo 'ZY001_M' será 'ZY001_'.</c>");

  SetLocalInt(oPC, "MODOESCRITURA", 4);
}

