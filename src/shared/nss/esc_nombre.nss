void main()
{
  object oPC = GetPCSpeaker();

  SendMessageToPC(oPC, "<cÍþ>Ahora estás en el <cþ>[Modo Escritura]</c> y no podrás hablar como de costumbre ya que ahora estás escribiendo. Para editar el objeto, habla el texto que desees aplicar sin cerrar esta conversación, sin importar las veces que sean. Existen ciertos códigos para cambiar el color y formato del texto, consulta las 'Instrucciones de uso' para más información.</c>");

  SetLocalInt(oPC, "MODOESCRITURA", 1);
}
