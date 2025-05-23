void main()
{
  object oPC = GetLastOpenedBy();
  object oPuertaDestino;

  int x;
  for(x=0; x < 30; x++) // limite artificial pero asi limitamos el no plantar demasiadas
  {
      oPuertaDestino = GetObjectByTag(GetLocalString(OBJECT_SELF, "DESTINO"), x);

      // Salta a la puerta de salida con el mismo nombre que la de entrada
      if(GetName(OBJECT_SELF) == GetName(oPuertaDestino))
      {
          AssignCommand(oPC, ClearAllActions());
          AssignCommand(oPC, JumpToObject(oPuertaDestino));
          return;
      }
  }
}
