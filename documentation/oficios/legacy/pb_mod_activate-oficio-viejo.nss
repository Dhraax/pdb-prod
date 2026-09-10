// Apartado de pb_mod_activate.nss durante la reconciliacion con produccion.
// No compila: necesita sute_libreria.nss (borrado en dc42be810) y
// bonoRealCaracteristicaPJ de pb_item_helpers.nss.
// Se guarda entero para decidir si vuelve.

#include "sute_libreria"

// --- activadores ---
  if(sTagDelObjeto == "pb_ofi_varita_es")   { ExecuteScript("pb_ofi_esencia_a", OBJECT_SELF); return; }
  if(sTagDelObjeto == "libroHerboristeria") { ManualHerboristeria(oPC);  return; }
  if(sTagDelObjeto == "libroHerreria")      { ManualHerreria(oPC);       return; }
  if(sTagDelObjeto == "carp_libro")         { ManualCarpinteria(oPC);    return; }
  if(sTagDelObjeto == "orf_libro")          { ManualOrfebreria(oPC);     return; }
  if(sTagDelObjeto == "pb_ofi_man_artes")   { ManualArtesaniaUrdimbrica(oPC);       return; }
  if(sTagDelObjeto == "sapocuelib")         { ManualPeleteria(oPC);          return; }

// --- desollado ---
//////////////////////////////////////
//          Tipos de piel
//
// 1 Piel de roedor
// 2 Piel de herbívoro
// 3 Piel de bestia salvaje
// 4 Piel de bestia salvaje grande
// 5 Piel de bestia mítica
// 6 Piel de bestia mítica gruesa
// 7 Piel de dragón de fuego
// 8 Piel de dragón de hielo
// 9 Piel de dragón de ácido
// 10 Piel de dragón de rayo
//
/////////////////////////////////

if(sTagDelObjeto == "kitdesollador")
{
  //SI NO CUMPLE LAS CONDICIONES NADA
  if(!GetIsDead(oTarget))
  {
    FloatingTextStringOnCreature("*¡No puedes desollar a una criatura viva!*", oPC);
    return;
  }
   //Si no es una criatura
  if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
    {
        FloatingTextStringOnCreature(StringToRGBString("*El objetivo debe ser una criatura.*","700"), oPC, FALSE);
        return;
    }

      // No polimorfado
    if(GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC) == TRUE || ObtenerIntPersistente(oPC,"POLYMORPHED"))
    {
        FloatingTextStringOnCreature(StringToRGBString("* Esta aptitud no se puede activar polimorfado.*","700"), oPC, FALSE);
        return;
    }

    // No funciona montado en montura
    if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
    {
        FloatingTextStringOnCreature(StringToRGBString("* Esta aptitud no se puede activar montado en montura.*","700"), oPC, FALSE);
        return;
    }

    //Si tenemos la apariencia cambiada nanay
    if(ObtenerIntPersistente(oPC, "APA_CAMBIADA") == TRUE)
    {
        FloatingTextStringOnCreature(StringToRGBString("* Vuelve a tu estado normal para poder usar esta aptitud.*","700"), oPC, FALSE);
        return;
    }

     //Si estamos lejos nada
    if(GetDistanceBetween(oPC, oTarget) > 2.0)
    {
        FloatingTextStringOnCreature(StringToRGBString("*¡Debes estar mas cerca para poder sacarle la piel!.*","700"), oPC, FALSE);
        return;
    }

  // ANTI-SATURAMIENTO DEL CADAVER
  if(GetLocalInt(oTarget,"LAVETANOSESATURA") == 1) return;
  SetLocalInt(oTarget, "LAVETANOSESATURA", 1);
  DelayCommand(3.0, DeleteLocalInt(oTarget, "LAVETANOSESATURA"));

  // NECESITAS TENER NIVEL 1 O MAS
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELDESOLLADOR");
  if(iNivelHabilidad == 0)
  {
      DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(2.0, FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Peleteria antes de nada*", oPC, FALSE));
      return;
  }

  // PROBABILIDAD DE QUE SE ROMPA EL CUCHILLO
  int iUsosPico = GetLocalInt(oItem, "USOSPICO");
  int iTipoPiel = GetLocalInt(oTarget, "PIEL");

  //SI NO TIENE LA VARIABLE NO PODEMOS SACAR NADA
  if(!iTipoPiel)
    {
        FloatingTextStringOnCreature(StringToRGBString("*¡Esta criatura no tiene ninguna piel para desollar!.*","700"), oPC, FALSE);
        return;
    }

  if(iUsosPico == 0) // El cuchillo es nuevo
  {
      if(sTagDelObjeto == "kitdesollador") SetLocalInt(oItem, "USOSPICO", d6(20));
  }

  else if(iUsosPico > 0 && iUsosPico < 6) // El cuchillo se rompe
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
      DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tu herramienta de desollar se ha roto!*", oPC));
      DestroyObject(oItem, 0.8);
      DelayCommand(1.8, PlayVoiceChat(VOICE_CHAT_CUSS, oPC));
      return;
  }
  else // Herramientas se consumen segun el tipo de piel
  {
      // La piel de bestias magicas en adelante consumen mas usos de la herramienta
      if(iTipoPiel > 5)
      {
          if(iTipoPiel == 6)
          {
              SetLocalInt(oItem, "USOSPICO", iUsosPico - d2());
          }

          else if(iTipoPiel == 7)
          {
              SetLocalInt(oItem, "USOSPICO", iUsosPico - d3());
          }

          else
          {
              SetLocalInt(oItem, "USOSPICO", iUsosPico - d4());
          }
      }

      else
      {
          SetLocalInt(oItem, "USOSPICO", iUsosPico - 1);
      }
  }


  // ANIMACIONES DEL PJ
  effect eSangre = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
  effect eBones = EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM);

  //SANGRE SEGUN PIEL
        if(iTipoPiel == 10 && iTipoPiel >= 7) eSangre = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
        else if(iTipoPiel == 6) eSangre = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_MEDIUM);
        else if(iTipoPiel == 5) eSangre = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
        else if(iTipoPiel == 4) eSangre = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
        else if(iTipoPiel == 3) eSangre = EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM);
        else if(iTipoPiel == 2) eSangre = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);

  DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
  DelayCommand(1.0, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0)));
  DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSangre, oTarget));
  DelayCommand(1.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBones, oTarget));
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSangre, oTarget));
  DelayCommand(2.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBones, oTarget));


  /*/ LESIONES DE MINERIA (LUXACION DE HOMBRO, LUMBALGIA Y FATIGA)
  int iLesion = d100(1);
  if(iLesion <= 3)
  {
      // Luxacion de hombro
      if(iLesion == 1)
      {
          int iHP = GetCurrentHitPoints(oPC);
          effect e1 = EffectAbilityDecrease(ABILITY_STRENGTH,6);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,6);
          effect e3 = EffectDamage(iHP/4,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has hecho una luxación en el hombro!*", oPC, FALSE));
          return;
      }

      // Lumbalgia
      else if(iLesion == 2)
      {
          effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,3);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,3);
          effect e3 = EffectMovementSpeedDecrease(30);
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e3, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te ha dado un terrible dolor de espalda!*", oPC, FALSE));
          return;
      }

      // Fatiga
      else
      {
          effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,4);
          effect e2 = EffectMovementSpeedDecrease(20);
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has fatigado enormemente picando!*", oPC, FALSE));
          return;
      }
  }*/

  // ACCESO A LA FORMULA DE EXITO (PRIMERA TIRADA)
  int iTiradaAcceso = d100();
  int iBonoTiradaAcceso = (iNivelHabilidad/2);

  // 25% a nivel 0
  // 35% a nivel 20
  // 55% a nivel 60
  // 75% a nivel 100
    if(iTiradaAcceso + iBonoTiradaAcceso >= 65)
    {

      // FORMULA DE EXITO (SEGUNDA TIRADA)
      int iTiradaExito = d100();
      int iTiradaCantidad = d6(2);
      int iBonoFue = bonoRealCaracteristicaPJ(ABILITY_DEXTERITY, oPC) * 2;
      int iDificultad;

         //DIFICULTAD SEGUN PIEL
              if(iTipoPiel == 10 && iTipoPiel >= 7) iDificultad = 420;
              else if(iTipoPiel == 6) iDificultad = 300;
              else if(iTipoPiel == 5) iDificultad = 250;
              else if(iTipoPiel == 4) iDificultad = 200;
              else if(iTipoPiel == 3) iDificultad = 150;
              else if(iTipoPiel == 2) iDificultad = 100;
              else if(iTipoPiel == 1) iDificultad = 50;


      /*/ Bonos raciales
      int iRaza = GetRacialType(oPC);
      int iBonusRacial;
      if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d4();
      else iBonusRacial = 0;
       */

      //Probabilidad de conseguirlo
      float fProbabilidadExito = (1-((IntToFloat(iDificultad -(iNivelHabilidad * 5 + iBonoFue)))/80))*100;
      if(IntToFloat(iTiradaExito) <= (fProbabilidadExito + IntToFloat(GetSkillRank(22,oPC))) )
      {
          //Animacion al conseguirlo
          switch(iTipoPiel)
          {
              case 1:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Has conseguido una Piel de roedor!*", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pielroedor", oPC));
                break;

             case 2:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Has conseguido una Piel de herbivoro!*", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pielherbivoro", oPC));
                break;

             case 3:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Has conseguido una Piel de bestia salvaje!*", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pielbestia", oPC));
                break;

             case 4:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Has conseguido una Piel de bestia salvaje grande!*", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pielbestiag", oPC));
                break;

             case 5:
                DelayCommand(3.0, FloatingTextStringOnCreature("**¡Has conseguido una Piel de bestia mitica!**", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pielmitica", oPC));
                break;

             case 6:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Has conseguido una Piel de bestia mitica gruesa!*", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pielmiticag", oPC));
                break;

             case 7:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Has conseguido una Piel de dragón de fuego!*", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pieldracor", oPC, 1, "", "", iTiradaCantidad));
                break;

             case 8:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Has conseguido una Piel de dragón de hielo!*", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pieldracor", oPC, 1, "", "", iTiradaCantidad));
                break;

             case 9:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Has conseguido una Piel de dragón de acido!*", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pieldracor", oPC, 1, "", "", iTiradaCantidad));
                break;

             case 10:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Has conseguido una Piel de dragón de rayo!*", oPC));
                DelayCommand(3.0, FuncionCrearObjetoYTag("pieldracor", oPC, 1, "", "", iTiradaCantidad));
                break;

             default:
                DelayCommand(3.0, FloatingTextStringOnCreature("*¡Este cuerpo ya no tiene una piel para desollar!*", oPC));
                break;
          }

          //Si tenemos exito ya no hay mas pieles
          DelayCommand(3.2, SetLocalInt(oTarget, "PIEL", 0));

          // SUBIDA DE NIVEL (TERCERA TIRADA)
          int iTiradaAprendizaje = d100();
          int iBonoInt = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
          float fProbablidadAprendizaje= ((IntToFloat(iDificultad-(iNivelHabilidad*5)-iBonoInt))/80)*100;

          if(iNivelHabilidad < 100 && (IntToFloat(iTiradaAprendizaje) <= fProbablidadAprendizaje + 25))
          {
              int iExperiencia = (iNivelHabilidad + 1)/2;
              if(iExperiencia == 0) iExperiencia = 1;
              else if(iExperiencia > 50) iExperiencia = 50;
              DelayCommand(2.5, PlaySound("gui_level_up"));
              DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Desollar!", oPC));
              DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
              GuardarIntPersistente(oPC, "NIVELDESOLLADOR", iNivelHabilidad + 1);
          }
      }
      else DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues extraer ninguna piel*"));

  }
  else
  {
      DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues extraer ninguna piel*"));
  }
}

