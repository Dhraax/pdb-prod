void ComprobarCadenas(object oPC)
{
  object oMod = GetModule();

  string sVariable     = GetLocalString(oMod, "QUEST_SOMBRAS_CADENAS");
  int iVariableNivel   = GetLocalInt(oMod,    "QUEST_SOMBRAS_CADENAS_NIVEL");
  int iVariableStop    = GetLocalInt(oMod,    "QUEST_SOMBRAS_CADENAS_STOP");

  // Anti-saturamiento (usos simultaneos)
  int iUsosSimultaneos = GetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_USOS");
  SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_USOS", iUsosSimultaneos - 1);
  if(iUsosSimultaneos > 1) return;

  // Nivel 1
  if(sVariable == "A" && iVariableNivel == 0)
  {
      FloatingTextStringOnCreature("<c´þd>* La cadena cede *</c>", oPC);
      AssignCommand(oPC, PlaySound("as_dr_metlprtop1"));
      SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP", TRUE);
      DelayCommand(2.0, DeleteLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP"));
      SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_NIVEL", 1);
  }

  // Nivel 2
  else if(sVariable == "AATOR" || sVariable == "ATORA" && iVariableNivel == 1)
  {
      FloatingTextStringOnCreature("<c´þd>* La cadena cede *</c>", oPC);
      AssignCommand(oPC, PlaySound("as_dr_metlprtop1"));
      SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP", TRUE);
      DelayCommand(2.0, DeleteLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP"));
      SetLocalString(oMod, "QUEST_SOMBRAS_CADENAS", "AATOR");
      SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_NIVEL", 2);
  }

  // Nivel 3
  else if(sVariable == "AATORMAUNA" || sVariable == "AATORMANAU" || sVariable == "AATORUMANA" ||
          sVariable == "AATORUNAMA" || sVariable == "AATORNAUMA" || sVariable == "AATORNAMAU" &&
          iVariableNivel == 2)
  {
      FloatingTextStringOnCreature("<c´þd>* La cadena cede *</c>", oPC);
      AssignCommand(oPC, PlaySound("as_dr_metlprtop1"));
      SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP", TRUE);
      DelayCommand(2.0, DeleteLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP"));
      SetLocalString(oMod, "QUEST_SOMBRAS_CADENAS", "AATORMAUNA");
      SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_NIVEL", 3);
  }

  // Nivel 4
  else if(sVariable == "AATORMAUNAMATOR"  || sVariable == "AATORMAUNATORMA" &&
          iVariableNivel == 3)
  {
      FloatingTextStringOnCreature("<c´þd>* La cadena cede *</c>", oPC);
      AssignCommand(oPC, PlaySound("as_dr_metlprtop1"));
      SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP", TRUE);
      DelayCommand(2.0, DeleteLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP"));
      SetLocalString(oMod, "QUEST_SOMBRAS_CADENAS", "AATORMAUNAMATOR");
      SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_NIVEL", 4);
  }

  // Nivel 5
  else if(sVariable == "AATORMAUNAMATORUNA" || sVariable == "AATORMAUNAMATORNAU" &&
          iVariableNivel == 4)
  {
      FloatingTextStringOnCreature("<c´þd>* Un mecanismo oculto se ha activado, una puerta cercana se ha abierto *</c>", oPC);
      AssignCommand(oPC, PlaySound("as_dr_metllgcl1"));
      SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP", TRUE);
      DelayCommand(1000.0, DeleteLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_STOP"));
      DeleteLocalString(oMod, "QUEST_SOMBRAS_CADENAS");
      DeleteLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_NIVEL");

      object oPuerta = GetNearestObjectByTag("mti_quest_sombras_puerta2");
      SetLocked(oPuerta, FALSE);
      DelayCommand(2.0, AssignCommand(oPuerta, ActionOpenDoor(oPuerta)));

      DelayCommand(1000.0, AssignCommand(oPuerta, ActionCloseDoor(oPuerta)));
      DelayCommand(1002.0, SetLocked(oPuerta, TRUE));
  }

  // Persistencia, cuando varios jugadores tocan las cadenas a la vez
  else if(iVariableStop == TRUE)
  {
      FloatingTextStringOnCreature("<c´þd>* La cadena cede *</c>", oPC);
      AssignCommand(oPC, PlaySound("as_dr_metlprtop1"));
  }

  // Fallo, se reinicia todo
  else
  {
      FloatingTextStringOnCreature("<cþ<<>* La cadena no cede *</c>", oPC);
      DeleteLocalString(oMod, "QUEST_SOMBRAS_CADENAS");
      DeleteLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_NIVEL");
      AssignCommand(oPC, PlaySound("as_dr_locked3"));
  }
}

void main()
{
  object oPC = GetLastUsedBy();
  object oMod = GetModule();

  // Anti-saturamiento (usos simultaneos)
  int iUsosSimultaneos = GetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_USOS");
  SetLocalInt(oMod, "QUEST_SOMBRAS_CADENAS_USOS", iUsosSimultaneos + 1);

  string sTagCadena = GetTag(OBJECT_SELF);
  string sVariableCadenas = GetLocalString(oMod, "QUEST_SOMBRAS_CADENAS");
  string sOrdenCadenas = "";

  if(sTagCadena == "mti_quest_sombras_cad1") sOrdenCadenas = "A";
  else if(sTagCadena == "mti_quest_sombras_cad2") sOrdenCadenas = "MA";
  else if(sTagCadena == "mti_quest_sombras_cad3") sOrdenCadenas = "U";
  else if(sTagCadena == "mti_quest_sombras_cad4") sOrdenCadenas = "NA";
  else if(sTagCadena == "mti_quest_sombras_cad5") sOrdenCadenas = "TOR";

  FloatingTextStringOnCreature("<c´þd>* Tiras de la cadena *</c>", oPC);
  SetLocalString(oMod, "QUEST_SOMBRAS_CADENAS", sVariableCadenas + sOrdenCadenas);
  DelayCommand(2.0, ComprobarCadenas(oPC));
}
