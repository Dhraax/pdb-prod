#include "mti_libreria"
#include "sute_libreria"
#include "nw_i0_2q4luskan"
#include "lib_race"

// Pues los objetos de orfebreria del oficio de orfebreria
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
      if(GetStringLeft(GetTag(oIngrediente), 5) == "gema_" ||
         GetStringLeft(GetTag(oIngrediente), 8) == "platino_" ||
         GetStringLeft(GetTag(oIngrediente), 6) == "plata_" ||
         GetStringLeft(GetTag(oIngrediente), 4) == "oro_" ||
         GetStringLeft(GetTag(oIngrediente), 7) == "bronce_" ||
         GetStringLeft(GetTag(oIngrediente), 3) == "pu_" )
         {
             // SI HAY 1 ACCESORIO APILADO, EL SCRIPT TE DEVUELVE LAS SOBRANTES:
             int iStack = GetItemStackSize(oIngrediente);
             if(iStack > 1) SetItemStackSize(oIngrediente,iStack -1);
             else DestroyObject(oIngrediente);
         }

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
  AssignCommand(OBJECT_SELF, PlaySound("as_cv_chiseling3"));
  DelayCommand(0.9, AssignCommand(OBJECT_SELF, PlaySound("as_cv_chiseling3")));
  DelayCommand(1.8, AssignCommand(OBJECT_SELF, PlaySound("as_cv_chiseling1")));
  DelayCommand(2.6, AssignCommand(OBJECT_SELF, PlaySound("as_cv_potclang1")));
  DelayCommand(3.6, AssignCommand(OBJECT_SELF, PlaySound("as_cv_shopmetal2")));
  DelayCommand(0.1, SetCommandable(FALSE, oJugador));
  DelayCommand(6.0, SetCommandable(TRUE, oJugador));

  // Usos del punzon
  object oPunzon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oJugador);
  int iUsosPunzon = GetLocalInt(oPunzon, "USOS");
  if(iUsosPunzon == 0)
  {
      SetLocalInt(oPunzon, "USOS", 20 + d6());
  }
  else if(iUsosPunzon == 1)
  {
      DelayCommand(6.0, AssignCommand(oJugador, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      DelayCommand(6.0, FloatingTextStringOnCreature("*¡Se te ha roto el punzon de engarzar!*", oJugador));
      DelayCommand(7.0, PlayVoiceChat(VOICE_CHAT_CUSS, oJugador));
      DestroyObject(oPunzon, 6.0);
      EliminarVariablesBanco();
      return;
  }
  else
  {
      SetLocalInt(oPunzon, "USOS", iUsosPunzon - 1);
  }


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
      DelayCommand(6.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_barglass4")));
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
      // Cortar la mano
      if(iLesion == 1)
      {
          effect e1 = EffectVisualEffect(93);
          DelayCommand(6.0, DestruirIngredientes());
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e1, OBJECT_SELF));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Los materiales no estaban en buen estado!*", oJugador, FALSE));
      }

      // Cortadura leve
      else if(iLesion == 2)
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e3 = EffectDamage(iHP/8, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Te has pinchado en toda la mano!*", oJugador, FALSE));
          DelayCommand(6.0, PlayVoiceChat(VOICE_CHAT_PAIN1, oJugador));
      }

      // Esquirlas
      else
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,4);
          effect e3 = EffectDamage(iHP/6, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oJugador));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Se te clavan varias esquirlas metálicas en la mano!*", oJugador, FALSE));
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
      if(PB_Race_GetIsElf(oJugador)) iBonusRacial = d4();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d4();
      else if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d3();
      else if(PB_Race_GetIsHalfling(oJugador)) iBonusRacial = d4();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d6();
      else iBonusRacial = 0;

      // Probabilidad de conseguirlo
      float fProbabilidadExito = (1-((IntToFloat(iDificultad-(iNivelHabilidad*5 + iBonoDes + iBonusRacial)))/80))*100;
      if(IntToFloat(iTiradaExito) <= (fProbabilidadExito+ IntToFloat(GetSkillRank(22,oJugador)) ))
      {
          object oObjetoGuardado = GetLocalObject(OBJECT_SELF, "TIPOOBJETO");
          object oObjetoFabricado = CopyItem(oObjetoGuardado, OBJECT_SELF);
          SetIdentified(oObjetoFabricado, TRUE);
          SetLocalInt(oObjetoFabricado, "OROVENTAO", iOroVenta + iNivelHabilidad);
          SetLocalInt(oObjetoFabricado, "OFICIO_OBJETO_ENCANTABLE", TRUE);
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
              DelayCommand(7.0, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Engarzador!", oJugador));
              DelayCommand(7.0, SetXP(oJugador, GetXP(oJugador) + iExperiencia));
              GuardarIntPersistente(oJugador, "NIVELENGARZADOR", iNivelHabilidad + 1);
          }

          // Funciones varias
          effect eExito1 = EffectVisualEffect(56);
          effect eExito2 = EffectVisualEffect(238);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExito1, OBJECT_SELF));
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExito2, OBJECT_SELF));
          EliminarVariablesBanco();
          return;
      }

      else
      {
          effect eFracaso1 = EffectVisualEffect(96);
          effect eFracaso2 = EffectVisualEffect(97);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso1, OBJECT_SELF));
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso2, OBJECT_SELF));
          DelayCommand(6.0, FloatingTextStringOnCreature("*¡Fracasaste al fabricar el objeto!*", oJugador, FALSE));
          EliminarVariablesBanco();
          return;
      }
  }

  else
  {
      effect eFracaso1 = EffectVisualEffect(96);
      effect eFracaso2 = EffectVisualEffect(97);
      DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso1, OBJECT_SELF));
      DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso2, OBJECT_SELF));
      DelayCommand(6.0, FloatingTextStringOnCreature("*¡Fracasaste al fabricar el objeto!*", oJugador, FALSE));
      EliminarVariablesBanco();
      return;
  }
}
