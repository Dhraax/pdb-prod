#include "mti_libreria"
#include "sute_libreria"
#include "lib_race"

void DestruirLenyos()
{
  object oLenyo = GetFirstItemInInventory();
  while(GetIsObjectValid(oLenyo) == TRUE)
  {
      if(GetStringLeft(GetTag(oLenyo), 9) == "carplenyo") DestroyObject(oLenyo);

      oLenyo = GetNextItemInInventory();
  }
}

void main()
{
  object oPC = GetLastClosedBy();

  // SI LA TABLA YA ESTA OCUPADA POR OTRA PERSONA, NADA OCURRE
  string sNombreMemorizado = GetLocalString(OBJECT_SELF, "TABLAOCUPADA");
  if(sNombreMemorizado != GetName(oPC, TRUE))
  {
      FloatingTextStringOnCreature("*Esta tabla de serrería ya está siendo usada por otra persona*", oPC, FALSE);
      return;
  }

  // SI LA TABLA ESTA VACIA, NADA OCURRE
  if(GetFirstItemInInventory() == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*No hay nada en la tabla, nada ocurre*", oPC, FALSE);
      DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA");
      return;
  }

  // NECESITAS TENER NIVEL 1 O MAS PARA USAR LA TABLA
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELSERRERIA");
  if(iNivelHabilidad == 0)
  {
      FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Carpintería antes de nada*", oPC, FALSE);
      DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA");
      return;
  }

  // SI NO HAY UN KIT DE HERRAMIENTAS DEL SERRADOR EN LA TABLA, EL SCRIPT NO SIGUE
  object oKit = GetItemPossessedBy(OBJECT_SELF, "carp_kitserr");
  if(oKit == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*Necesitas colocar un kit de herramientas del serrador para usar la tabla*", oPC, FALSE);
      DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA");
      return;
  }

  // SI NO HAY UNA SIERRA EN LA TABLA, EL SCRIPT NO SIGUE
  object oSierra = GetItemPossessedBy(OBJECT_SELF, "carp_sierra");
  if(oSierra == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*Necesitas colocar una sierra en la tabla para empezar a serrar los leños*", oPC, FALSE);
      DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA");
      return;
  }

  // MIRAMOS A VER QUE TIPO Y QUE CANTIDAD DE LENYO HEMOS METIDO
  int iLenyoPino = 0;
  int iLenyoCipres = 0;
  int iLenyoAbeto = 0;
  int iLenyoCedro = 0;
  int iLenyoAlamo = 0;
  int iLenyoOlmo = 0;
  int iLenyoRoble = 0;
  int iLenyoFresno = 0;

  object oLenyo = GetFirstItemInInventory();
  while(GetIsObjectValid(oLenyo) == TRUE)
  {
      if(GetTag(oLenyo) == "carplenyo_pino") iLenyoPino = iLenyoPino + 1;
      else if(GetTag(oLenyo) == "carplenyo_cipres") iLenyoCipres = iLenyoCipres + 1;
      else if(GetTag(oLenyo) == "carplenyo_abeto") iLenyoAbeto = iLenyoAbeto + 1;
      else if(GetTag(oLenyo) == "carplenyo_cedro") iLenyoCedro = iLenyoCedro + 1;
      else if(GetTag(oLenyo) == "carplenyo_alamo") iLenyoAlamo = iLenyoAlamo + 1;
      else if(GetTag(oLenyo) == "carplenyo_olmo") iLenyoOlmo = iLenyoOlmo + 1;
      else if(GetTag(oLenyo) == "carplenyo_roble") iLenyoRoble = iLenyoRoble + 1;
      else if(GetTag(oLenyo) == "carplenyo_fresno") iLenyoFresno = iLenyoFresno + 1;

      oLenyo = GetNextItemInInventory();
  }

  // SI NO HAY LENYOS, EL SCRIPT NO SIGUE
  int iSumaLenyos = iLenyoPino + iLenyoCipres + iLenyoAbeto + iLenyoCedro +
                    iLenyoAlamo + iLenyoOlmo + iLenyoRoble + iLenyoFresno;
  if(iSumaLenyos == 0)
  {
      FloatingTextStringOnCreature("*¡No hay ningún leño en la tabla!*", oPC, FALSE);
      DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA");
      return;
  }

  // SI HAY MAS DE 3 LENYOS, EL SCRIPT NO SIGUE
  if(iSumaLenyos > 3)
  {
      FloatingTextStringOnCreature("*¡La tabla sólo requiere 3 leños, no pongas más!*", oPC, FALSE);
      DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA");
      return;
  }

  // SI HAY 1 O 2 LENYOS, EL SCRIPT NO SIGUE
  if(iSumaLenyos == 1 || iSumaLenyos == 2)
  {
      FloatingTextStringOnCreature("*¡La tabla requiere 3 leños, no pongas menos!*", oPC, FALSE);
      DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA");
      return;
  }

  // LOS TRES LENYOS DEBEN SER DEL MISMO TIPO
  if(iLenyoPino != 3 && iLenyoCipres != 3 && iLenyoAbeto != 3 && iLenyoCedro != 3 &&
     iLenyoAlamo != 3 && iLenyoOlmo != 3 && iLenyoRoble != 3 && iLenyoFresno != 3)
  {
      FloatingTextStringOnCreature("*¡Todos los leños deben ser del mismo tipo!*", oPC, FALSE);
      DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA");
      return;
  }

  // -- A CREAR TABLONES!
  // OBTENIENDO LA COMBINACION ELEGIDA
  int iDificultad= 0;
  string sNombreTablon;
  string sReferenciaTablon;

  if(iLenyoPino == 3)
  {
      iDificultad = 80;
      sNombreTablon = "tablón de madera de pino";
      sReferenciaTablon = "carptablon_pino";
  }
  else if(iLenyoCipres == 3)
  {
      iDificultad = 145;
      sNombreTablon = "tablón de madera de cedro";
      sReferenciaTablon = "carptablon_cipre";
  }
  else if(iLenyoAbeto == 3)
  {
      iDificultad = 205;
      sNombreTablon = "tablón de madera de abeto";
      sReferenciaTablon = "carptablon_abeto";
  }
  else if(iLenyoCedro == 3)
  {
      iDificultad = 270;
      sNombreTablon = "tablón de madera de roble";
      sReferenciaTablon = "carptablon_cedro";
  }
  else if(iLenyoAlamo == 3)
  {
      iDificultad = 330;
      sNombreTablon = "tablón de madera de sombralto";
      sReferenciaTablon = "carptablon_alamo";
  }
  else if(iLenyoOlmo == 3)
  {
      iDificultad = 395;
      sNombreTablon = "tablón de madera de arbol del crepusculo";
      sReferenciaTablon = "carptablon_olmo";
  }
  else if(iLenyoRoble == 3)
  {
      iDificultad = 455;
      sNombreTablon = "tablón de madera de zalantar";
      sReferenciaTablon = "carptablon_roble";
  }
  else if(iLenyoFresno == 3)
  {
      iDificultad = 520;
      sNombreTablon = "tablón de madera de maderadique";
      sReferenciaTablon = "carptablon_fresn";
  }

  // ANIMACIONES DEL PJ
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.5, 6.0));
  FloatingTextStringOnCreature("Fabricando un " + sNombreTablon + "...", oPC, FALSE);
  AssignCommand(OBJECT_SELF, PlaySound("as_cv_sawing1"));
  DelayCommand(3.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_sawing2")));
  DelayCommand(0.1, SetCommandable(FALSE, oPC));
  DelayCommand(5.9, SetCommandable(TRUE, oPC));

  // LESIONES DE SERRERIA (TERMITAS, CORTADURA LEVE, SIERRA A TOMAR POR CULO)
  // Un 3% de que se joda la creacion del tablon
  int iLesion = d100();
  if(iLesion <= 3)
  {
      // Termitas
      if(iLesion == 1)
      {
          effect e1 = EffectVisualEffect(93);
          DelayCommand(6.0, DestruirLenyos());
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e1, OBJECT_SELF));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Los leños tenían termitas! Han quedado inservibles*", oPC, FALSE));
      }

      // Cortadura leve
      else if(iLesion == 2)
      {
          int iHP = GetCurrentHitPoints(oPC);
          effect e3 = EffectDamage(iHP/8, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Te has cortado levemente con la sierra!*", oPC, FALSE));
      }

      // Sierra rota
      else
      {
          int iHP = GetCurrentHitPoints(oPC);
          effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,4);
          effect e3 = EffectDamage(iHP/4, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡La sierra se parte en dos golpeándote fuertemente!*", oPC, FALSE));
          DelayCommand(6.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_woodbreak2")));
          DestroyObject(oSierra, 6.0);
      }
      DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA");
      return;
  }

  // USOS DE LA SIERRA
  int iUsosSierra = GetLocalInt(oSierra, "USOS");
  if(iUsosSierra == 0)
  {
      SetLocalInt(oSierra, "USOS", 25 + d6());
  }
  else if(iUsosSierra == 1)
  {
      DelayCommand(6.0, AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      DelayCommand(6.0, FloatingTextStringOnCreature("*¡Se te ha roto la sierra!*", oPC));
      DelayCommand(6.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_woodbreak2")));
      DelayCommand(7.0, PlayVoiceChat(VOICE_CHAT_CUSS, oPC));
      DestroyObject(oSierra, 6.0);
      DelayCommand(6.0, DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA"));
      return;
  }
  else
  {
      SetLocalInt(oSierra, "USOS", iUsosSierra - 1);
  }

  // SE DESTRUYEN LOS LENYOS
  DestruirLenyos();

  // ACCESO A FORMULA DE EXITO (PRIMERA TIRADA)
  int iTiradaAcceso = d100();
  int iBonoTiradaAcceso = (iNivelHabilidad/4);

  // 70% a nivel 0
  // 75% a nivel 20
  // 85% a nivel 60
  // 95% a nivel 100
  if(iTiradaAcceso + iBonoTiradaAcceso >= 30)
  {
      // FORMULA DE EXITO (SEGUNDA TIRADA)
      int iTiradaExito = d100();
      int iBonoFue = bonoRealCaracteristicaPJ(ABILITY_STRENGTH, oPC);
      int iBonoDes = bonoRealCaracteristicaPJ(ABILITY_DEXTERITY, oPC);
      int iBonoCaracteristica = iBonoFue + iBonoDes;

      // Bonos raciales
      int iRaza= GetRacialType(oPC);
      int iBonusRacial;
      if(PB_Race_GetIsElf(oPC)) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d4();
      else if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d3();
      else iBonusRacial = 0;

      // FORMULA DE CREACION DE TABLON (SEGUNDA TIRADA)
      float fProbabilidadExito = (1-((IntToFloat(iDificultad-(iNivelHabilidad*5 + iBonoCaracteristica + iBonusRacial)))/80))*100;
      if(IntToFloat(iTiradaExito) <= (fProbabilidadExito + IntToFloat(GetSkillRank(22,oPC))) )
      {
          // CREAS EL TABLON
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Has conseguido un "+ sNombreTablon + "!*", oPC));
          DelayCommand(6.0, FuncionCrearObjetoYTag(sReferenciaTablon, oPC));
          DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(72), GetLocation(OBJECT_SELF)));

          // SUBIDA DE NIVEL (TERCERA TIRADA)
          int iTiradaAprendizaje = d100();
          int iBonoInt = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
          float fProbablidadAprendizaje = ((IntToFloat(iDificultad - (iNivelHabilidad * 5) + iBonoInt))/80) * 100;
          if((iNivelHabilidad < 100) && (IntToFloat(iTiradaAprendizaje) <= fProbablidadAprendizaje))
          {
              int iExperiencia = (iNivelHabilidad + 1)/2;
              if(iExperiencia == 0) iExperiencia = 1;
              else if(iExperiencia > 50) iExperiencia = 50;
              DelayCommand(7.0, AssignCommand(OBJECT_SELF, PlaySound("gui_level_up")));
              DelayCommand(7.0, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Serrería!", oPC));
              DelayCommand(7.0, SetXP(oPC, GetXP(oPC) + iExperiencia));
              GuardarIntPersistente(oPC, "NIVELSERRERIA", iNivelHabilidad + 1);
          }
      }

      else
      {
          DelayCommand(6.0, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Fracasaste al crear el tablón!*", oPC));
          DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(55), GetLocation(OBJECT_SELF)));
      }
  }

  else
  {
      DelayCommand(6.0, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(6.0, FloatingTextStringOnCreature("*¡Fracasaste al crear el tablón!*", oPC));
      DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(55), GetLocation(OBJECT_SELF)));
  }

  DelayCommand(6.0, DeleteLocalString(OBJECT_SELF, "TABLAOCUPADA"));
}
