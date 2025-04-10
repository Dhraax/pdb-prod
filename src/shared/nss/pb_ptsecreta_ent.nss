void BuscandoPuertasTrampillasSecretas(object oPC, int iTipo, int iCD, string sDestino)
{
  // Si salimos del desencadenante, ya no buscamos mas
  if(GetLocalInt(oPC, "PTSECRETA_BUSCANDO") == FALSE) return;

  // Si dentro del desencadenante ya encontramos la puerta secreta, no hacemos tiradas
  if(GetLocalInt(OBJECT_SELF, "PTSECRETA_YAENCONTRADA") == TRUE)
  {
      DelayCommand(6.0, BuscandoPuertasTrampillasSecretas(oPC, iTipo, iCD, sDestino));
      return;
  }

  // Si superamos la tirada de buscar: creamos puerta secreta
  int iBuscar = GetSkillRank(SKILL_SEARCH, oPC);
  if(iBuscar + d20() >= iCD)
  {
      PlayVoiceChat(VOICE_CHAT_LOOKHERE, oPC);
      SendMessageToPC(oPC, "* ¡Descubres una puerta secreta! *");
      if(GetLocalString(OBJECT_SELF, "XP_PS") != GetName(oPC))
      {
          GiveXPToCreature(oPC, 10 + iCD);
          SetLocalString(OBJECT_SELF, "XP_PS", GetName(oPC));
      }

      string sResref;
      switch(iTipo)
      {
          case 0:
          case 1: sResref = "x0_sec_tdoor1"; break;  // trampilla de madera
          case 2: sResref = "x0_sec_tdoor2"; break;  // trampilla de piedra blanca
          case 3: sResref = "x0_sec_grate1"; break;  // rejilla de piedra blanca
          case 4: sResref = "x0_sec_grate2"; break;  // rejilla oxidada
          case 5: sResref = "x0_sec_door1"; break;   // puerta secreta de madera
          case 6: sResref = "x0_sec_door2"; break;   // puerta secreta de piedra blanca
          case 7: sResref = "x0_sec_door3"; break;   // puerta secreta ancha y granate
          case 8: sResref = "x0_sec_portal"; break;  // portal amarillo
      }

      location lLugar = GetLocation(GetNearestObjectByTag("pb_ptsecreta", oPC));
      object oPuertaSecreta = CreateObject(OBJECT_TYPE_PLACEABLE, sResref, lLugar, FALSE, sDestino);

      DestroyObject(oPuertaSecreta, 120.0);
      SetLocalInt(OBJECT_SELF, "PTSECRETA_YAENCONTRADA", TRUE);
      DelayCommand(120.0, DeleteLocalInt(OBJECT_SELF, "PTSECRETA_YAENCONTRADA"));

      DelayCommand(6.0, BuscandoPuertasTrampillasSecretas(oPC, iTipo, iCD, sDestino));
      return;
  }
  else
  {
      DelayCommand(6.0, BuscandoPuertasTrampillasSecretas(oPC, iTipo, iCD, sDestino));
      return;
  }
}

void main()
{
  object oPC = GetEnteringObject();
  int iTipo = GetLocalInt(OBJECT_SELF, "TIPO");
  int iCD = GetLocalInt(OBJECT_SELF, "CD");
  string sDestino = GetLocalString(OBJECT_SELF, "DESTINO");

  SetLocalInt(oPC, "PTSECRETA_BUSCANDO", TRUE);
  BuscandoPuertasTrampillasSecretas(oPC, iTipo, iCD, sDestino);
}
