void main()
{
  object oPC = GetPCSpeaker();

  SendMessageToPC(oPC, "<cÍþ>Ahora estás en el <cþ>[Modo Escritura]</c> y no podrás hablar con los demás jugadores. Habla el texto que desees aplicar en la descripción sin cerrar esta conversación y sin importar las veces que sean. Existen ciertos códigos para cambiar el color y formato del texto, consulta las 'Instrucciones de uso' para más información. Recuerda que para ver la descripción de tu PJ, coloca la opción 'Examinar' en un acceso directo y clickea a tu PJ.</c>");

  SetLocalInt(oPC, "MODOESCRITURA", 3);
}

