//OJO: Se ha puesto como comentario las restricciones para entrar en las diferentes academias. 14/05/2013 por DM Pereza

int VerSiCumploRequisitosTierBreche(object oPC, string sEtiquetaPuerta)
{
  // Porton Melee Maghtere
  if(sEtiquetaPuerta == "ust_porton1")
  {
      /*if(GetLevelByClass(CLASS_TYPE_FIGHTER, oPC) > 0 ||
         GetLevelByClass(CLASS_TYPE_RANGER, oPC)  > 0 ||
         GetLevelByClass(CLASS_TYPE_ROGUE, oPC)   > 0 ||
         GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) > 0)*/ return TRUE;

      /*else
      {
          SendMessageToPC(oPC, "<cþ>¡No puedes cruzar las puertas de Melee Maghtere! Sólo los guerreros, exploradores, pícaros y asesinos pueden pasar.</c>");
          return FALSE;
      }*/
  }

  // Porton Arach Tinlilith
  if(sEtiquetaPuerta == "ust_porton2")
  {
      /*if((GetGender(oPC) == GENDER_FEMALE && GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0) ||
         (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) > 0))*/ return TRUE;

      /*else
      {
          SendMessageToPC(oPC, "<cþ>¡No puedes cruzar las puertas de Arach Tinlilith! Sólo las mujeres clérigas o los guardias negros pueden pasar.</c>");
          return FALSE;
      }*/
  }

  // Porton Sorcere
  if(sEtiquetaPuerta == "ust_porton3")
  {
      /*if(GetLevelByClass(CLASS_TYPE_BARD, oPC)       > 0 ||
         GetLevelByClass(CLASS_TYPE_SORCERER, oPC)   > 0 ||
         GetLevelByClass(CLASS_TYPE_WIZARD, oPC)     > 0)*/ return TRUE;

      /*else
      {
          SendMessageToPC(oPC, "<cþ>¡No puedes cruzar las puertas de Sorcere! Sólo los bardos, hechiceros y magos pueden pasar.</c>");
          return FALSE;
      }*/
  }

  SendMessageToPC(oPC, "<cþ>No puedes pasar.</c>");
  return FALSE;
}

void main()
{
  object oPC = GetLastUsedBy();
  string sEtiquetaPuerta =GetTag(OBJECT_SELF);

  // Porton de la Casa Despana - Quitado -

  // Portones de Tier Breche
  if(VerSiCumploRequisitosTierBreche(oPC, sEtiquetaPuerta) == FALSE) return;

  // No saturar la puerta
  if(GetLocalInt(OBJECT_SELF, "NOSATURAR") == TRUE) return;

  SetLocalInt(OBJECT_SELF, "NOSATURAR", TRUE);
  DelayCommand(5.0, DeleteLocalInt(OBJECT_SELF, "NOSATURAR"));

  // Animaciones
  FloatingTextStringOnCreature("<c´þd>* El portón se abre a tu paso *</c>", oPC);
  PlayAnimation(ANIMATION_PLACEABLE_OPEN);
  DestroyObject(GetLocalObject(OBJECT_SELF, "GateBlock"));
  SetLocalObject(OBJECT_SELF, "GateBlock", OBJECT_INVALID);

  string sGateBlock = GetLocalString(OBJECT_SELF, "CEP_L_GATEBLOCK");
  location lSelfLoc = GetLocation(OBJECT_SELF);

  DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
  DelayCommand(5.0, SetLocalObject(OBJECT_SELF, "GateBlock", CreateObject(OBJECT_TYPE_PLACEABLE, sGateBlock, lSelfLoc)));
}
