int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

  if(GetIsObjectValid(oArma) == FALSE ||
     GetLocalInt(oArma, "DOTE_ROMPERARMA_DESTROZADO") == FALSE) return FALSE;
  else
  {
      int iOro = 1000;
      int iValorOroReparacion = GetGoldPieceValue(oArma);
      if(iValorOroReparacion < 4500) iOro = 1000;
      else if(iValorOroReparacion < 17000) iOro = 2000;
      else if(iValorOroReparacion < 49000) iOro = 3000;
      else if(iValorOroReparacion < 120000) iOro = 4000;
      else iOro = 5000;

      SetCustomToken(333, IntToString(iOro));
      return TRUE;
  }
}
