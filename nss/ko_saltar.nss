void main()
{
  object oPC = GetPCSpeaker();
  int iTirada = d20();
  int iDistancia = GetLocalInt(OBJECT_SELF, "DISTANCIA"); //Con la conversacion "ko_saltar_conv" se genera sola la distancia en pies.
  int iDificultad = (iDistancia*5)/6; //Regla de tres cutre... teniendo en cuenta que para 6 pies la CD es 5
  int iRango = GetSkillRank (26, oPC);
  int iTiradaSonidoPiedras = d6();
  int iMultiplicador = GetLocalInt (OBJECT_SELF,"MULTIPLICADOR"); //variable int MULTIPLICADOR de danyo a colocar en el ubicado --> Por cada 5 pies 1d6
  string sSonidoPiedrasAleatorio;
  string iEtiquetaDestino = GetLocalString (OBJECT_SELF, "DESTINO"); //variable string DESTINO por si tiene exito que vaya a esa zona.
  object oDestino = GetNearestObjectByTag (iEtiquetaDestino, OBJECT_SELF);
  string sEtiquetaDestinoFracaso = GetLocalString (OBJECT_SELF, "DESTINO_FRACASO"); //Destino si fracasa (caer a un foso o algo en caso de que se haya mapeado)
  object oDestinoFracaso = GetWaypointByTag(sEtiquetaDestinoFracaso);

  //Llevamos al personaje a la zona de salto y lo encaramos hacia donde hay que saltar.
  AssignCommand (oPC, JumpToObject (OBJECT_SELF));
  DelayCommand (1.0, AssignCommand(oPC, SetFacingPoint (GetPosition (oDestino))));

  //Hacemos sonidos aleatorios de desprendimiento de rocas, para ambientar.

  if(iTiradaSonidoPiedras == 1) sSonidoPiedrasAleatorio = "as_na_x2iccrmb7";
  else if(iTiradaSonidoPiedras == 2) sSonidoPiedrasAleatorio = "as_na_x2iccrmb6";
  else if(iTiradaSonidoPiedras == 3) sSonidoPiedrasAleatorio = "as_na_x2iccrmb5";
  else if(iTiradaSonidoPiedras == 4) sSonidoPiedrasAleatorio = "as_na_x2iccrmb4";
  else if(iTiradaSonidoPiedras == 5) sSonidoPiedrasAleatorio = "as_na_x2iccrmb3";
  else sSonidoPiedrasAleatorio = "as_na_x2iccrmb2";

  if((iTirada+iRango) >= iDificultad) //Si el personaje salta bien...
  {
      SetCutsceneMode(oPC, TRUE);
      DelayCommand(9.0, SetCutsceneMode(oPC, FALSE));
      DelayCommand(1.0, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM15, 1.0, 7.0)));
      DelayCommand(4.5, PlaySound(sSonidoPiedrasAleatorio));
      SendMessageToPC(oPC, "<c þ >Saltar: "+IntToString(iTirada)+" + "+IntToString(iRango)+ " = " +IntToString(iTirada+iRango)+ " vs CD "+IntToString(iDificultad)+": Éxito. ¡Consigues saltar la distancia sin problema!</c>");
      DelayCommand (8.0, AssignCommand (oPC, JumpToObject(oDestino)));
      DelayCommand (9.0, ClearAllActions());
  }
  else //si el personaje fracasa en el salto...
  {
      SetCutsceneMode(oPC, TRUE);
      DelayCommand(6.0, SetCutsceneMode(oPC, FALSE));
      DelayCommand(2.0, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 5.0)));
      DelayCommand(2.0, PlaySound(sSonidoPiedrasAleatorio));
      DelayCommand (2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamage(d6(iMultiplicador), DAMAGE_TYPE_BLUDGEONING) ,oPC, 3.0f));
      SendMessageToPC(oPC, "<cþ  >Saltar: "+IntToString(iTirada)+" + "+IntToString(iRango)+" vs CD "+IntToString(iDificultad)+": Fracaso. ¡Resbalas y no consigues salvar la distancia!</c>");
      DelayCommand (3.0, AssignCommand (oPC, JumpToObject(oDestinoFracaso)));
      DelayCommand (7.0, ClearAllActions());
  }
}
