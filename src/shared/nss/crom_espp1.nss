int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Espada de plata
  string sEmpu = "emp_espada_plata";
  string sFilo ="filodeespadadepl";

  if(GetCampaignInt("CROMWELL", "ESPADADEPLATA", oPC) == 1) return FALSE;

  if(GetItemPossessedBy(oPC, sEmpu) != OBJECT_INVALID &&
     GetItemPossessedBy(oPC, sFilo) != OBJECT_INVALID) return FALSE;
  return TRUE;
}
