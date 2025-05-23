void main()
{
  object oPC = GetEnteringObject();
  if(!GetIsPC(oPC)) return;

  if(GetLocalInt(GetModule(), "USTMERCADESCLAV") == 1) return;

  object oVendedor = GetNearestObjectByTag("ust_comerc_esclav");
  AssignCommand(oVendedor, SpeakString("¡¡Miren que material!! ¡¡Qué músculos!! ¡¡Trasgos de calidad!!"));
  SetLocalInt(GetModule(), "USTMERCADESCLAV", 1);
  DelayCommand(100.0, DeleteLocalInt(GetModule(), "USTMERCADESCLAV"));
}
