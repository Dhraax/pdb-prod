int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Solo estara activa esta conversacion cuando tengas alguna montura muerta
  object oAnimalMuerto = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oAnimalMuerto) == TRUE)
  {
      if(GetTag(oAnimalMuerto) == "cab_montura" &&
         GetLocalInt(oAnimalMuerto, "CAB_MUERTO") == TRUE)
      {
          return TRUE;
      }

      oAnimalMuerto = GetNextItemInInventory(oPC);
  }

  return FALSE;
}
