void main()
{
  object oPC = GetPCSpeaker();
  SetDeity(oPC,GetLocalString(OBJECT_SELF,"#T"));

  string sDios = GetDeity(oPC);
  DelayCommand(1.0,AssignCommand(oPC,ActionSpeakString("¡Ahora venero a "+sDios+"!")));
  DelayCommand(1.0,AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_VICTORY1)));

  if (GetTag(OBJECT_SELF)=="sacerdote_baal") { ExecuteScript("pb_estasacer3",OBJECT_SELF);}
}
