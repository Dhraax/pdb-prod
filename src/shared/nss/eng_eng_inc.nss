#include "mti_libreria"
#include "sute_libreria"
#include "nw_i0_2q4luskan"
#include "lib_race"

// Pues los objetos de madera del oficio de carpinteria
// sFraseFabricando = "Fabricando un..."
// sObjetoContenedor = Etiqueta del objeto a crear que esta en el contenedor
// sExito = Mensaje cuando creas el objeto
// iDificultad = Dificultad del objeto a crear (minimo 80 y maximo 520)
// iOroVenta = El dinero que te daran por el objeto al venderlo
// sContenedor = Ubicado donde se encuentra el objeto a copiar
void CrearObjetosOrfebreria(object oJugador, string sFraseFabricando, string sObjetoContenedor, string sExito, int iDificultad, int iOroVenta, string sContenedor = "contenedor_engar");

void EliminarVariablesBanco()
{
  DeleteLocalString(OBJECT_SELF, "BANCOOCUPADO");
  DeleteLocalObject(OBJECT_SELF, "ACCESORIO");
  DeleteLocalObject(OBJECT_SELF, "TIPOOBJETO");
}

void DestruirIngredientes()
{
  object oIngrediente = GetFirstItemInInventory();
  while(GetIsObjectValid(oIngrediente) == TRUE)
  {
      DestroyObject(oIngrediente);

      oIngrediente = GetNextItemInInventory();
  }
}

void DestruirTablones()
{
  object oTablon = GetFirstItemInInventory();
  while(GetIsObjectValid(oTablon) == TRUE)
  {
      if(GetStringLeft(GetTag(oTablon), 11) == "carptablon_") DestroyObject(oTablon);

      oTablon = GetNextItemInInventory();
  }
}

void CrearObjetosOrfebreria(object oJugador, string sFraseFabricando,
                             string sObjetoContenedor, string sExito,
                             int iDificultad, int iOroVenta,
                             string sContenedor = "contenedor_engar")
{
  // Animacion y sonido
  AssignCommand(oJugador, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.5, 6.0));
  FloatingTextStringOnCreature(sFraseFabricando, oJugador, FALSE);
  AssignCommand(OBJECT_SELF, PlaySound("as_cv_ropecreak2"));
  DelayCommand(1.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_woodframe1")));
  DelayCommand(2.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_ropecreak2")));
  DelayCommand(3.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_ropepully1")));
  DelayCommand(4.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_woodframe2")));
  DelayCommand(0.1, SetCommandable(FALSE, oJugador));
  DelayCommand(5.9, SetCommandable(TRUE, oJugador));

  // Usos del kit
  object oKit = GetItemPossessedBy(OBJECT_SELF, "eng_kiteng");
  int iUsosKit = GetLocalInt(oKit, "USOS");
  if(iUsosKit == 0)
  {
      SetLocalInt(oKit, "USOS", 20 + d6());
  }
  else if(iUsosKit == 1)
  {
      DelayCommand(6.0, FloatingTextStringOnCreature("*¡Las herramientas de engarzar se han roto!*", oJugador));
      DelayCommand(6.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_woodbreak2")));
      DestroyObject(oKit, 6.0);
      DelayCommand(7.0, PlayVoiceChat(VOICE_CHAT_CUSS, oJugador));
      EliminarVariablesBanco();
      return;
  }
  else
  {
      SetLocalInt(oKit, "USOS", iUsosKit - 1);
  }

  // Consigamos el objeto a crear del contenedor de objetos
  object oContenedor = GetObjectByTag(sContenedor);
  object oTipoObjeto = GetFirstItemInInventory(oContenedor);
  int iSoloUnTipo = 0;
  while(oTipoObjeto != OBJECT_INVALID && iSoloUnTipo == 0)
  {
      if(GetTag(oTipoObjeto) == sObjetoContenedor)
      {
          SetLocalObject(OBJECT_SELF, "TIPOOBJETO", oTipoObjeto);
          iSoloUnTipo = 1;
      }
      oTipoObjeto = GetNextItemInInventory(oContenedor);
  }

  // PROBABILIDAD DE LESIONES
  // Un 3% de que se joda la fabricacion del objeto
  int iLesion = d100();
  if(iLesion <= 3)
  {
      // Termitas
      if(iLesion == 1)
      {
          effect e1 = EffectVisualEffect(93);
          DelayCommand(6.0, DestruirTablones());
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e1, OBJECT_SELF));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Se te ha ido la cabeza y has estropeado los materiales!*", oJugador, FALSE));
      }

      // Cortadura leve
      else if(iLesion == 2)
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e3 = EffectDamage(iHP/8, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Te has cortado levemente!*", oJugador, FALSE));
          DelayCommand(6.0, PlayVoiceChat(VOICE_CHAT_PAIN1, oJugador));
      }

      // Astilla
      else
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,4);
          effect e3 = EffectDamage(iHP/6, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oJugador));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Te has cortado en las manos!*", oJugador, FALSE));
          DelayCommand(6.0, PlayVoiceChat(VOICE_CHAT_PAIN1, oJugador));
      }

      EliminarVariablesBanco();
      return;
  }

  // Eliminemos ya los materiales
  DestruirIngredientes();

  // ACCESO A FORMULA DE EXITO (PRIMERA TIRADA)
  int iTiradaAcceso = d100();
  int iNivelHabilidad = ObtenerIntPersistente(oJugador, "NIVELENGARZADOR");
  int iBonoTiradaAcceso = (iNivelHabilidad/4);

  // 70% a nivel 0
  // 75% a nivel 20
  // 85% a nivel 60
  // 95% a nivel 100
  if(iTiradaAcceso + iBonoTiradaAcceso >= 30)
  {
      // FORMULA DE EXITO (SEGUNDA TIRADA)
      int iTiradaExito = d100();
      int iBonoDes = bonoRealCaracteristicaPJ(ABILITY_DEXTERITY, oJugador)*2;

      // Bonos raciales
      int iRaza= GetRacialType(oJugador);
      int iBonusRacial;
      if(PB_Race_GetIsElf(oJugador)) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d4();
      else if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d3();
      else iBonusRacial = 0;

      // Probabilidad de conseguirlo
      float fProbabilidadExito = (1-((IntToFloat(iDificultad-(iNivelHabilidad*5 + iBonoDes + iBonusRacial)))/80))*100;
      if(IntToFloat(iTiradaExito) <= fProbabilidadExito)
      {
          object oObjetoGuardado = GetLocalObject(OBJECT_SELF, "TIPOOBJETO");
          object oObjetoFabricado = CopyItem(oObjetoGuardado, OBJECT_SELF);
          SetLocalInt(oObjetoFabricado, "OROVENTAC", iOroVenta + iNivelHabilidad);
          DelayCommand(6.0, FloatingTextStringOnCreature(sExito, oJugador, FALSE));

          // SUBIDA DE NIVEL (TERCERA TIRADA)
          int iTiradaAprendizaje = d100();
          int iBonoInt = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oJugador);
          float fProbablidadAprendizaje = ((IntToFloat(iDificultad - (iNivelHabilidad * 5) + iBonoInt))/80) * 100;
          if((iNivelHabilidad < 100) && (IntToFloat(iTiradaAprendizaje) <= fProbablidadAprendizaje))
          {
              int iExperiencia = (iNivelHabilidad + 1)/2;
              if(iExperiencia == 0) iExperiencia = 1;
              else if(iExperiencia > 50) iExperiencia = 50;
              DelayCommand(7.0, PlaySound("gui_level_up"));
              DelayCommand(7.0, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Engarce!", oJugador));
              DelayCommand(7.0, SetXP(oJugador, GetXP(oJugador) + iExperiencia));
              GuardarIntPersistente(oJugador, "NIVELENGARZADOR", iNivelHabilidad + 1);
          }

          // Funciones varias
          effect eExito = EffectVisualEffect(72);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExito, OBJECT_SELF));
          EliminarVariablesBanco();
          return;
      }

      else
      {
          effect eFracaso = EffectVisualEffect(55);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Fracasaste al fabricar el objeto!*", oJugador, FALSE));
          EliminarVariablesBanco();
          return;
      }
  }

  else
  {
      effect eFracaso = EffectVisualEffect(55);
      DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
      DelayCommand(6.0, FloatingTextStringOnCreature("*¡Fracasaste al fabricar el objeto!*", oJugador, FALSE));
      EliminarVariablesBanco();
      return;
  }
}
