#include "mti_libreria"
#include "sute_libreria"
#include "nw_i0_2q4luskan"

// Pues crea aros o cadenas, segun que datos pongas
// sFraseFabricando = "Fabricando un..."
// sObjetoContenedor = Etiqueta del objeto a crear que esta en el contenedor
// sExito1 = mensaje cuando creas 1 objeto
// sExito2 = mensaje cuando creas 2 objetos
// sExito3 = mensaje cuando creas 3 objetos
// iDificultad = Dificultad del objeto a crear (minimo 80 y maximo 520)
// iOroVenta = El dinero que te daran por el objeto al venderlo
// sContenedor = Ubicado donde se encuentra el objeto a copiar
void CrearArosCadenas(object oJugador, string sFraseFabricando, string sObjetoContenedor, string sExito1, string sExito2, string sExito3, int iDificultad, int iOroVenta, string sContenedor = "contenedor_engar");

// Pues crea armas, yelmos o escudos, segun que datos pongas
// sFraseFabricando = "Fabricando un..."
// sObjetoContenedor = Etiqueta del objeto a crear que esta en el contenedor
// sExito = Mensaje cuando creas el objeto
// iDificultad = Dificultad del objeto a crear (minimo 80 y maximo 520)
// iOroVenta = El dinero que te daran por el objeto al venderlo
// sContenedor = Ubicado donde se encuentra el objeto a copiar
void CrearArmasYelmosEscudos(object oJugador, string sFraseFabricando, string sObjetoContenedor, string sExito, int iDificultad, int iOroVenta, string sContenedor = "contenedor_yunque");
void CrearEquipoPeleteria(object oJugador, string sFraseFabricando, string sObjetoContenedor, string sExito, int iDificultad, int iOroVenta, string sContenedor = "contenedor_peletero");


void EliminarVariablesYunque()
{
  DeleteLocalString(OBJECT_SELF, "YUNQUEOCUPADO");
  DeleteLocalObject(OBJECT_SELF, "MOLDE");
  DeleteLocalObject(OBJECT_SELF, "TIPOOBJETO");
}

void DestruirIngredientes()
{
  object oDestruirlos;
  oDestruirlos = GetFirstItemInInventory();
  while(GetIsObjectValid(oDestruirlos) == TRUE)
  {
      DestroyObject(oDestruirlos);
      oDestruirlos = GetNextItemInInventory();
  }
}

void CrearArosCadenas(object oJugador, string sFraseFabricando,
                      string sObjetoContenedor, string sExito1,
                      string sExito2, string sExito3,
                      int iDificultad, int iOroVenta,
                      string sContenedor = "contenedor_engar")
{
  // Animacion y sonido
  AssignCommand(oJugador, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.5, 6.0));
  FloatingTextStringOnCreature(sFraseFabricando, oJugador, FALSE);
  PlaySound("as_cv_shopmetal1");
  PlaySound("as_cv_minepick1");
  DelayCommand(3.0, PlaySound("as_cv_shopmetal1"));
  DelayCommand(3.0, PlaySound("as_cv_minepick2"));
  DelayCommand(0.1, SetCommandable(FALSE, oJugador));
  DelayCommand(5.9, SetCommandable(TRUE, oJugador));

  // Usos del martillo
  object oMartillo = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oJugador);
  int iUsosMartillo = GetLocalInt(oMartillo, "USOS");
  if(iUsosMartillo == 0)
  {
      SetLocalInt(oMartillo, "USOS", 20 + d6());
  }
  else if(iUsosMartillo == 1)
  {
      DelayCommand(6.0, AssignCommand(oJugador, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      DelayCommand(6.0, FloatingTextStringOnCreature("*ùSe te han roto las pinzas de orfebre!*", oJugador));
      DelayCommand(7.0, PlayVoiceChat(VOICE_CHAT_CUSS, oJugador));
      DestroyObject(oMartillo, 6.0);
      EliminarVariablesYunque();
      return;
  }
  else
  {
      SetLocalInt(oMartillo, "USOS", iUsosMartillo - 1);
  }

  // Consigamos el objeto a crear del contenedor de objetos
  object oContenedor = GetObjectByTag(sContenedor);
  object oTipoObjeto;
  int iSoloUnTipo;
  oTipoObjeto = GetFirstItemInInventory(oContenedor);
  iSoloUnTipo = 0;
  while(oTipoObjeto != OBJECT_INVALID && iSoloUnTipo == 0)
  {
      if(GetTag(oTipoObjeto) == sObjetoContenedor)
      {
          SetLocalObject(OBJECT_SELF, "TIPOOBJETO", oTipoObjeto);
          iSoloUnTipo = 1;
      }
      oTipoObjeto = GetNextItemInInventory(oContenedor);
  }

  // Eliminemos ya los materiales
  DestruirIngredientes();

  // ACCESO A FORMULA DE EXITO (PRIMERA TIRADA)
  int iTiradaAcceso = d100();
  int iNivelHabilidad = ObtenerIntPersistente(oJugador, "NIVELHERRERIA");
  int iBonoTiradaAcceso = (iNivelHabilidad/4);

  // 70% a nivel 0
  // 75% a nivel 20
  // 85% a nivel 60
  // 95% a nivel 100
  if(iTiradaAcceso + iBonoTiradaAcceso >= 1)
  {
      // FORMULA DE EXITO (SEGUNDA TIRADA)
      int iTiradaExito = d100();
      int iBonoDes = bonoRealCaracteristicaPJ(ABILITY_DEXTERITY, oJugador)*2;

      // Bonos raciales
      int iRaza= GetRacialType(oJugador);
      int iBonusRacial;
      if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d4();
      else iBonusRacial = 0;

      // Probabilidad de conseguirlo
      //float fProbabilidadExito = (1-((IntToFloat(iDificultad-(iNivelHabilidad*5 + iBonoDes + iBonusRacial)))/80))*100;
      if(iTiradaExito >= 1)
      {
          // Probabilidad para que se te creen uno, dos o tres objetos
          object oObjetoGuardado = GetLocalObject(OBJECT_SELF, "TIPOOBJETO");
          int iProb = d3();
          if(iProb == 1)
          {
              object oObjeto1 = CopyItem(oObjetoGuardado, OBJECT_SELF);
              object oObjeto2 = CopyItem(oObjetoGuardado, OBJECT_SELF);
              object oObjeto3 = CopyItem(oObjetoGuardado, OBJECT_SELF);
              SetLocalInt(oObjeto1, "OROVENTA", iOroVenta + iNivelHabilidad);
              SetLocalInt(oObjeto2, "OROVENTA", iOroVenta + iNivelHabilidad);
              SetLocalInt(oObjeto3, "OROVENTA", iOroVenta + iNivelHabilidad);
              SetLocalInt(oObjeto1, "OFICIO_OBJETO_ENCANTABLE", TRUE);
              SetLocalInt(oObjeto2, "OFICIO_OBJETO_ENCANTABLE", TRUE);
              SetLocalInt(oObjeto3, "OFICIO_OBJETO_ENCANTABLE", TRUE);
              DelayCommand(6.0, FloatingTextStringOnCreature(sExito3, oJugador, FALSE));

          }
          else if(iProb == 2)
          {
              object oObjeto1 = CopyItem(oObjetoGuardado, OBJECT_SELF);
              object oObjeto2 = CopyItem(oObjetoGuardado, OBJECT_SELF);
              SetLocalInt(oObjeto1, "OROVENTA", iOroVenta + iNivelHabilidad);
              SetLocalInt(oObjeto2, "OROVENTA", iOroVenta + iNivelHabilidad);
              SetLocalInt(oObjeto1, "OFICIO_OBJETO_ENCANTABLE", TRUE);
              SetLocalInt(oObjeto2, "OFICIO_OBJETO_ENCANTABLE", TRUE);
              DelayCommand(6.0, FloatingTextStringOnCreature(sExito2, oJugador, FALSE));
          }
          else
          {
              object oObjeto1 = CopyItem(oObjetoGuardado, OBJECT_SELF);
              SetLocalInt(oObjeto1, "OROVENTA", iOroVenta + iNivelHabilidad);
              SetLocalInt(oObjeto1, "OFICIO_OBJETO_ENCANTABLE", TRUE);
              DelayCommand(6.0, FloatingTextStringOnCreature(sExito1, oJugador, FALSE));
          }

          // Funciones varias
          effect eExito = EffectVisualEffect(VFX_COM_HIT_FIRE);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExito, OBJECT_SELF));
          EliminarVariablesYunque();
          return;
      }

      else
      {
          effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
          DelayCommand(6.0, FloatingTextStringOnCreature("*ùFracasaste al forjar el objeto!*", oJugador, FALSE));
          EliminarVariablesYunque();
          return;
      }
  }

  else
  {
      effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
      DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
      DelayCommand(6.0, FloatingTextStringOnCreature("*ùFracasaste al forjar el objeto!*", oJugador, FALSE));
      EliminarVariablesYunque();
      return;
  }
}


void CrearArmasYelmosEscudos(object oJugador, string sFraseFabricando,
                             string sObjetoContenedor, string sExito,
                             int iDificultad, int iOroVenta,
                             string sContenedor = "contenedor_yunque")
{
  // Animacion y sonido
  AssignCommand(oJugador, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.5, 6.0));
  FloatingTextStringOnCreature(sFraseFabricando, oJugador, FALSE);
  PlaySound("as_cv_shopmetal1");
  PlaySound("as_cv_minepick1");
  DelayCommand(3.0, PlaySound("as_cv_shopmetal1"));
  DelayCommand(3.0, PlaySound("as_cv_minepick2"));
  DelayCommand(0.1, SetCommandable(FALSE, oJugador));
  DelayCommand(5.9, SetCommandable(TRUE, oJugador));

  // Usos del martillo
  object oMartillo = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oJugador);
  int iUsosMartillo = GetLocalInt(oMartillo, "USOS");
  if(iUsosMartillo == 0)
  {
      SetLocalInt(oMartillo, "USOS", 20 + d6());
  }
  else if(iUsosMartillo == 1)
  {
      DelayCommand(6.0, AssignCommand(oJugador, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      DelayCommand(6.0, FloatingTextStringOnCreature("*ùSe te ha roto el martillo de herrero!*", oJugador));
      DelayCommand(7.0, PlayVoiceChat(VOICE_CHAT_CUSS, oJugador));
      DestroyObject(oMartillo, 6.0);
      EliminarVariablesYunque();
      return;
  }
  else
  {
      SetLocalInt(oMartillo, "USOS", iUsosMartillo - 1);
  }

  // Consigamos el objeto a crear del contenedor de objetos
  object oContenedor = GetObjectByTag(sContenedor);
  object oTipoObjeto;
  int iSoloUnTipo;
  oTipoObjeto = GetFirstItemInInventory(oContenedor);
  iSoloUnTipo = 0;
  while(oTipoObjeto != OBJECT_INVALID && iSoloUnTipo == 0)
  {
      if(GetTag(oTipoObjeto) == sObjetoContenedor || GetResRef(oTipoObjeto) == sObjetoContenedor)
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
      // Machacarse la mano con el martillo
      if(iLesion == 1)
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e1 = EffectAbilityDecrease(ABILITY_STRENGTH, 4);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
          effect e3 = EffectDamage(iHP/4, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(3.9, AssignCommand(oJugador, ClearAllActions(TRUE)));
          DelayCommand(4.0, PlayVoiceChat(Random(3)+14, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oJugador));
          DelayCommand(4.0, FloatingTextStringOnCreature("*ùTe has machacado la mano con el martillo!*", oJugador, FALSE));
          effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
      }

      // Se te cae el martillo en un pie
      else if(iLesion == 2)
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e1 = EffectMovementSpeedDecrease(50);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY, 3);
          effect e3 = EffectDamage(iHP/8, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(3.9, AssignCommand(oJugador, ClearAllActions(TRUE)));
          DelayCommand(4.0, PlayVoiceChat(Random(3)+14, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oJugador));
          DelayCommand(4.0, FloatingTextStringOnCreature("*ùSe te resbala el martillo y se te cae en el pie!*", oJugador, FALSE));
          effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
      }

      // Hostiazo en la chola con la cabeza del martillo
      else
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e1 = EffectStunned();
          effect e2 = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 3);
          effect e3 = EffectDamage(iHP/3, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(4.0, PlayVoiceChat(Random(3)+14, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, e1, oJugador, 100.0));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oJugador));
          effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));

          if(GetTag(oMartillo) == "martillo_herrero2" ||
             GetTag(oMartillo) == "martillo_herrero3")
          {
              DelayCommand(4.0, FloatingTextStringOnCreature("*ùTe golpeas en la cabeza sin querer al subir el martillo!*", oJugador, FALSE));
          }

          else
          {
              DelayCommand(4.0, FloatingTextStringOnCreature("*ùLa cabeza del martillo se ha salido del mango, golpeùndote en la cabeza!*", oJugador, FALSE));
              DestroyObject(oMartillo, 4.0);
          }
      }

      EliminarVariablesYunque();
      return;
  }

  // Eliminemos ya los materiales
  DestruirIngredientes();

  // ACCESO A FORMULA DE EXITO (PRIMERA TIRADA)
  int iTiradaAcceso = d100();
  int iNivelHabilidad = ObtenerIntPersistente(oJugador, "NIVELHERRERIA");
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
      if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d4();
      else iBonusRacial = 0;

      // Probabilidad de conseguirlo
      float fProbabilidadExito = (1-((IntToFloat(iDificultad-(iNivelHabilidad*5 + iBonoDes + iBonusRacial)))/80))*100;
      if(IntToFloat(iTiradaExito) <= (fProbabilidadExito + IntToFloat(GetSkillRank(22,oJugador))) )
      {
          object oObjetoGuardado = GetLocalObject(OBJECT_SELF, "TIPOOBJETO");
          object oObjetoFabricado = CopyItem(oObjetoGuardado, OBJECT_SELF);
          SetIdentified(oObjetoFabricado, TRUE);
          SetLocalInt(oObjetoFabricado, "OROVENTA", iOroVenta + iNivelHabilidad);
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
              DelayCommand(7.0, FloatingTextStringOnCreature("ùHas subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Herrerùa!", oJugador));
              DelayCommand(7.0, SetXP(oJugador, GetXP(oJugador) + iExperiencia));
              GuardarIntPersistente(oJugador, "NIVELHERRERIA", iNivelHabilidad + 1);
          }

          // Funciones varias
          effect eExito = EffectVisualEffect(VFX_COM_HIT_FIRE);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExito, OBJECT_SELF));
          EliminarVariablesYunque();
          return;
      }

      else
      {
          effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
          DelayCommand(6.0, FloatingTextStringOnCreature("*ùFracasaste al forjar el objeto!*", oJugador, FALSE));
          EliminarVariablesYunque();
          return;
      }
  }

  else
  {
      effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
      DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
      DelayCommand(6.0, FloatingTextStringOnCreature("*ùFracasaste al forjar el objeto!*", oJugador, FALSE));
      EliminarVariablesYunque();
      return;
  }
}


void CrearEquipoPeleteria(object oJugador, string sFraseFabricando,
                             string sObjetoContenedor, string sExito,
                             int iDificultad, int iOroVenta,
                             string sContenedor = "contenedor_peletero")
{
  // Animacion y sonido
  AssignCommand(oJugador, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.5, 6.0));
  FloatingTextStringOnCreature(sFraseFabricando, oJugador, FALSE);
  PlaySound("as_cv_shopmetal1");
  PlaySound("as_cv_minepick1");
  DelayCommand(3.0, PlaySound("as_cv_shopmetal1"));
  DelayCommand(3.0, PlaySound("as_cv_minepick2"));
  DelayCommand(0.1, SetCommandable(FALSE, oJugador));
  DelayCommand(5.9, SetCommandable(TRUE, oJugador));

  // Usos del martillo
  object oMartillo = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oJugador);
  int iUsosMartillo = GetLocalInt(oMartillo, "USOS");
  if(iUsosMartillo == 0)
  {
      SetLocalInt(oMartillo, "USOS", 20 + d6());
  }
  else if(iUsosMartillo == 1)
  {
      DelayCommand(6.0, AssignCommand(oJugador, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      DelayCommand(6.0, FloatingTextStringOnCreature("*ùSe te ha roto la aguja de peletero!*", oJugador));
      DelayCommand(7.0, PlayVoiceChat(VOICE_CHAT_CUSS, oJugador));
      DestroyObject(oMartillo, 6.0);
      EliminarVariablesYunque();
      return;
  }
  else
  {
      SetLocalInt(oMartillo, "USOS", iUsosMartillo - 1);
  }

  // Consigamos el objeto a crear del contenedor de objetos
  object oContenedor = GetObjectByTag(sContenedor);
  object oTipoObjeto;
  int iSoloUnTipo;
  oTipoObjeto = GetFirstItemInInventory(oContenedor);
  iSoloUnTipo = 0;
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
      // Machacarse la mano con la aguja
      if(iLesion == 1)
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e1 = EffectAbilityDecrease(ABILITY_STRENGTH, 4);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
          effect e3 = EffectDamage(iHP/4, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(3.9, AssignCommand(oJugador, ClearAllActions(TRUE)));
          DelayCommand(4.0, PlayVoiceChat(Random(3)+14, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oJugador));
          DelayCommand(4.0, FloatingTextStringOnCreature("*ùTe has atravesado la mano con la aguja!*", oJugador, FALSE));
          effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
      }

      // Se te cae la aguja en un pie
      else if(iLesion == 2)
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e1 = EffectMovementSpeedDecrease(50);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY, 3);
          effect e3 = EffectDamage(iHP/8, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(3.9, AssignCommand(oJugador, ClearAllActions(TRUE)));
          DelayCommand(4.0, PlayVoiceChat(Random(3)+14, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oJugador));
          DelayCommand(4.0, FloatingTextStringOnCreature("*ùSe te resbala la aguja y se te clava en el pie!*", oJugador, FALSE));
          effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
      }

      // Te salta la aguja y de golpea en la cabeza
      else
      {
          int iHP = GetCurrentHitPoints(oJugador);
          effect e1 = EffectStunned();
          effect e2 = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 3);
          effect e3 = EffectDamage(iHP/3, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(4.0, PlayVoiceChat(Random(3)+14, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, e1, oJugador, 30.0));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oJugador));
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oJugador));
          effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
          DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
          DelayCommand(4.0, FloatingTextStringOnCreature("*ùLa aguja se ha partido en dos y el mango ha salido disparado contra tu cara!*", oJugador, FALSE));
          DestroyObject(oMartillo, 4.0);
      }

      EliminarVariablesYunque();
      return;
  }

  // Eliminemos ya los materiales
  DestruirIngredientes();

  // ACCESO A FORMULA DE EXITO (PRIMERA TIRADA)
  int iTiradaAcceso = d100();
  int iNivelHabilidad = ObtenerIntPersistente(oJugador, "Profesion12");
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
        if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d6();
        else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d3();
        else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d4();
        else iBonusRacial = 0;

        float fNivelHabilidad = iNivelHabilidad * 0.02;
        float fBonoDes = iBonoDes * 0.02;
        float fBonusRacial = iBonusRacial * 0.01;
        float fDificultad = iDificultad * 0.01;
        float fSuccess = (fNivelHabilidad + fBonoDes + fBonusRacial);
        //int iSuccess = (iNivelHabilidad*5 + iBonoDes + iBonusRacial);
        //float fProbabilidadExito = (1-((IntToFloat(iDificultad - iSuccess))/80))*100;
        float fProbabilidadExito = fSuccess / fDificultad * 100;
        float fVal   = (fProbabilidadExito + IntToFloat(GetSkillRank(22,oJugador)) + 20);

      // Probabilidad de conseguirlo
      if(IntToFloat(iTiradaExito) <= (fVal))
      {
          object oObjetoGuardado = GetLocalObject(OBJECT_SELF, "TIPOOBJETO");
          object oObjetoFabricado = CopyItem(oObjetoGuardado, OBJECT_SELF);
          SetIdentified(oObjetoFabricado, TRUE);
          SetLocalInt(oObjetoFabricado, "OROVENTA", iOroVenta + iNivelHabilidad);
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
              DelayCommand(7.0, FloatingTextStringOnCreature("ùHas subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Marroquineria!", oJugador));
              DelayCommand(7.0, SetXP(oJugador, GetXP(oJugador) + iExperiencia));
              GuardarIntPersistente(oJugador, "Profesion12", iNivelHabilidad + 1);
          }

          // Funciones varias
          effect eExito = EffectVisualEffect(VFX_IMP_POLYMORPH);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExito, OBJECT_SELF));
          EliminarVariablesYunque();
          return;
      }

      else
      {
          effect eFracaso = EffectVisualEffect(VFX_IMP_STUN);
          DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
          DelayCommand(6.0, FloatingTextStringOnCreature("*ùFracasaste al crear el objeto!*", oJugador, FALSE));
          EliminarVariablesYunque();
          return;
      }
  }

  else
  {
      effect eFracaso = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
      DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFracaso, OBJECT_SELF));
      DelayCommand(6.0, FloatingTextStringOnCreature("*ùFracasaste al forjar el objeto!*", oJugador, FALSE));
      EliminarVariablesYunque();
      return;
  }
}