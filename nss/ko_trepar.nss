void main()
{
  object oPC = GetLastUsedBy();

  // Calculo tirada
  int iBono = 0;
  if(GetHasFeat(1248, GetPCSpeaker())) iBono = 10;      // Soltura epica
  else if(GetHasFeat(1236, GetPCSpeaker())) iBono = 3;  // Soltura normal
  int iTrepar = GetSkillRank (37, oPC) + iBono;
  int iTirada = d20();

  // Dificultad y destino
  int iDificultad = GetLocalInt (OBJECT_SELF, "DIFICULTAD");
  string iEtiquetaDestino = GetLocalString (OBJECT_SELF, "DESTINO");
  object oDestino = GetNearestObjectByTag (iEtiquetaDestino, OBJECT_SELF);

  if((iTirada + iTrepar) >= iDificultad) // Exito
  {
      SetCutsceneMode(oPC, TRUE);
      SendMessageToPC(oPC, "<c þ >Trepar: "+IntToString(iTirada)+" + "+IntToString(iTrepar)+ " = " +IntToString(iTirada+iTrepar)+ " vs CD "+IntToString(iDificultad)+": Éxito. ¡Consigues trepar sin problema!</c>");
      AssignCommand (oPC, JumpToObject(oDestino));
      DelayCommand(2.0, SetCutsceneMode(oPC, FALSE));
  }
  else // Fracaso
  {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 2.0));
      SendMessageToPC(oPC, "<cþ  >Trepar: "+IntToString(iTirada)+" + "+IntToString(iTrepar)+" vs CD "+IntToString(iDificultad)+": Fracaso. ¡Resbalas y no consigues subir!</c>");
  }
}
