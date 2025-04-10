#include "mti_libreria"
#include "sute_libreria"
void main()
{
  object oPC = GetLastClosedBy();
  object oForja = OBJECT_SELF;
  object oBorrado;

  if(GetLocalInt(oForja, "PASO") == 0)
  {
      oBorrado = GetFirstItemInInventory();
      while(GetIsObjectValid(oBorrado))
      {
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
      }

      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(60), GetLocation(OBJECT_SELF)));
      return;
  }

  // SI LA FORJA ESTA VACIA, PUES QUE NO PASE NADA
  if(GetFirstItemInInventory() == OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "*La forja está vacía, nada ocurre*");
      DeleteLocalInt(oForja, "PASO");
      return;
  }

  // A NIVEL 0 NO SE PUEDE USAR LA FORJA
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELFUNDICION");
  if(iNivelHabilidad == 0)
  {
      DelayCommand(1.5, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(1.5, FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de herrería antes de nada*", oPC));
      SetLocalInt(oForja, "PASO", 0);
      return;
  }

  // ANIMACIONES DEL PJ
  DelayCommand(0.3, AssignCommand(oPC, ClearAllActions(TRUE)));
  DelayCommand(0.5, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 0.9)));

  // LESIONES DE FUNDICION (QUEMADURA GRAVE, LEVE Y HUMO)
  // Un 3% de que se joda la fundicion
  int iLesion = d100();
  if(iLesion <= 3)
  {
      oBorrado = GetFirstItemInInventory();
      while(GetIsObjectValid(oBorrado))
      {
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
      }

      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(60), GetLocation(OBJECT_SELF)));
      SetLocalInt(oForja, "PASO", 0);

      // Quemadura grave
      if(iLesion == 1)
      {
          int iHP = GetCurrentHitPoints(oPC);
          effect e1 = EffectAbilityDecrease(ABILITY_CHARISMA,6);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,6);
          effect e3 = EffectDamage(iHP/4,DAMAGE_TYPE_FIRE,DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has quemado gravemente en la forja!*", oPC, FALSE));
      }

      // Quemadura leve
      else if(iLesion == 2)
      {
          int iHP = GetCurrentHitPoints(oPC);
          effect e1 = EffectAbilityDecrease(ABILITY_CHARISMA,3);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,3);
          effect e3 = EffectDamage(iHP/8, DAMAGE_TYPE_FIRE, DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has quemado en la forja!*", oPC, FALSE));
      }

      // Humo
      else
      {
          effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,4);
          effect e2= EffectBlindness();
          effect e3= EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡El humo te entra en los pulmones y en los ojos!*", oPC, FALSE));
      }
      return;
  }

  // ACCESO A FORMULA DE EXITO (PRIMERA TIRADA)
  int iTiradaAcceso = d100();
  int iBonoTiradaAcceso = (iNivelHabilidad/4);

  // 70% a nivel 0
  // 75% a nivel 20
  // 85% a nivel 60
  // 95% a nivel 100
  if(iTiradaAcceso + iBonoTiradaAcceso >= 30)
  {
      // Miramos cantidades de pepitas y su tipo
      int nPepitaHierro = 0;
      int nPepitaCobre = 0;
      int nPepitaAcero = 0;
      int nPepitaPlata = 0;
      int nPepitaHierrofrio = 0;
      int nPepitaOro = 0;
      int nPepitaMithril = 0;
      int nPepitaCarbon = 0;
      int nPepitaDlarun = 0;
      int nPepitaHizagkuur = 0;
      int nPepitaAceroscuro = 0;
      int nPepitaPlatino = 0;
      int nPepitaArandur = 0;
      int nPepitaMetalvivo = 0;
      int nPepitaDerretido = 0;
      int nPepitaAdamantita = 0;
      int nPiedraFria = 0;
      int nAceite = 0;
      int nSangreDragon = 0;
      int nCristalCuarzo = 0;
      int nOjoRakhasa = 0;
      int nBelladona = 0;
      string sMetalTag;
      object oMetal = GetFirstItemInInventory();
      while(GetIsObjectValid(oMetal))
      {
          sMetalTag = GetTag(oMetal);
          if(sMetalTag == "pepitaHierro") nPepitaHierro = nPepitaHierro + 1;
          else if(sMetalTag == "pepitaCobre") nPepitaCobre = nPepitaCobre + 1;
          else if(sMetalTag == "pepitaAcero") nPepitaAcero = nPepitaAcero + 1;
          else if(sMetalTag == "pepitaPlata") nPepitaPlata = nPepitaPlata + 1;
          else if(sMetalTag == "pepitaHierrofrio") nPepitaHierrofrio = nPepitaHierrofrio + 1;
          else if(sMetalTag == "pepitaOro") nPepitaOro = nPepitaOro + 1;
          else if(sMetalTag == "pepitaMithril") nPepitaMithril = nPepitaMithril + 1;
          else if(sMetalTag == "pepitaDlarun") nPepitaDlarun = nPepitaDlarun + 1;
          else if(sMetalTag == "pepitaHizagkuur") nPepitaHizagkuur = nPepitaHizagkuur + 1;
          else if(sMetalTag == "pepitaAceroscuro") nPepitaAceroscuro = nPepitaAceroscuro + 1;
          else if(sMetalTag == "pepitaPlatino") nPepitaPlatino = nPepitaPlatino + 1;
          else if(sMetalTag == "pepitaArandur") nPepitaArandur = nPepitaArandur + 1;
          else if(sMetalTag == "pepitaMetalvivo") nPepitaMetalvivo = nPepitaMetalvivo + 1;
          else if(sMetalTag == "pepitaCarbon") nPepitaCarbon = nPepitaCarbon + 1;
          else if(sMetalTag == "pepitaDerretido") nPepitaDerretido = nPepitaDerretido + 1;
          else if(sMetalTag == "pepitaAdamantita") nPepitaAdamantita = nPepitaAdamantita + 1;
          else if(sMetalTag == "X1_IT_MSMLMISC01") nPiedraFria = nPiedraFria + 1;
          else if(sMetalTag == "NW_IT_MSMLMISC17") nSangreDragon = nSangreDragon + 1;
          else if(sMetalTag == "NW_IT_MSMLMISC11") nCristalCuarzo = nCristalCuarzo + 1;
          else if(sMetalTag == "NW_IT_MSMLMISC09") nOjoRakhasa = nOjoRakhasa + 1;
          else if(sMetalTag == "NW_IT_MSMLMISC23") nBelladona = nBelladona + 1;
          else if(sMetalTag == "AceiteHerrero") nAceite = nAceite + 1;
          oMetal = GetNextItemInInventory();
      }

      string sTipoPiedra= "";
      int iDificultad= 0;
      string sLingote;
      string sLingoteTag;
      effect eExito;


     //CONDICIONES ESPECIALES SEGUN EL TIPO DE LINGOTE
        int nForjaMagica = GetLocalInt(OBJECT_SELF, "Forja_magica");

     //Lingotes de plata solo en exterior y de noche.
        if(nPepitaPlata > 0 && !GetIsNight() && GetIsAreaInterior())
        {
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Parece que a la luz del dia estos lingotes no pueden ser moldeados!*", oPC, FALSE));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(60), GetLocation(OBJECT_SELF)));
            SetLocalInt(oForja, "PASO", 0);
            return;
        }

        else if(nPepitaPlata > 0 && nForjaMagica == 0 && GetIsNight() && GetIsAreaInterior())
        {
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Parece que estos lingotes no pueden ser moldeados en esta forja!*", oPC, FALSE));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(60), GetLocation(OBJECT_SELF)));
            SetLocalInt(oForja, "PASO", 0);
            return;
        }
        //Oro, Platino y HierroEnardecido, solo en forja magicas
        else if((nPepitaOro > 0 || nPepitaPlatino > 0 || nPepitaDerretido > 0) && nForjaMagica == 0)
        {
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Parece que estos lingotes no pueden ser moldeados en esta forja!*", oPC, FALSE));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(60), GetLocation(OBJECT_SELF)));
            SetLocalInt(oForja, "PASO", 0);
            return;
        }


   //RECETAS PARA FORJAR LINGOTES

      if(nPepitaHierro > 2 && nPepitaCarbon > 1 )
      {
          sTipoPiedra= "pepitaAcero";
          iDificultad= 205;
          sLingote= "lingote de acero";
          sLingoteTag= "lingoteAcero";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaHierro > 2)
      {
          sTipoPiedra= "pepitaHierro";
          iDificultad= 145;
          sLingote= "lingote de hierro";
          sLingoteTag= "lingoteHierro";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaCobre > 2)
      {
          sTipoPiedra= "pepitaCobre";
          iDificultad= 80;
          sLingote= "lingote de cobre";
          sLingoteTag= "lingoteCobre";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaPlata > 2 && (nBelladona > 2 || nCristalCuarzo > 1 || nSangreDragon >= 1 || nOjoRakhasa > 1))
      {
          sTipoPiedra= "pepitaPlata";
          iDificultad= 270;
          sLingote= "lingote de plata";
          sLingoteTag= "lingotePlata";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaHierrofrio > 2)
      {
          sTipoPiedra= "pepitaHierrofrio";
          iDificultad= 330;
          sLingote= "lingote de hierrofrío";
          sLingoteTag= "lingoteHierrofrio";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaOro > 2 && (nBelladona > 2 || nCristalCuarzo > 1 || nSangreDragon >= 1 || nOjoRakhasa > 1))
      {
          sTipoPiedra= "pepitaOro";
          iDificultad= 395;
          sLingote= "lingote de oro";
          sLingoteTag= "lingoteOro";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaMithril > 2)
      {
          sTipoPiedra= "pepitaMithril";
          iDificultad= 455;
          sLingote= "lingote de mithril";
          sLingoteTag= "lingoteMithril";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaDlarun > 2)
      {
          sTipoPiedra= "pepitaDlarun";
          iDificultad= 160;
          sLingote= "lingote de dlarun";
          sLingoteTag= "lingoteDlarun";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaHizagkuur > 2)
      {
          sTipoPiedra= "pepitaHizagkuur";
          iDificultad= 200;
          sLingote= "lingote de hizagkuur";
          sLingoteTag= "lingoteHizagkuur";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaAceroscuro > 2 && nAceite == 2)
      {
          sTipoPiedra= "pepitaAceroscuro";
          iDificultad= 320;
          sLingote= "lingote de aceroscuro";
          sLingoteTag= "lingoteAceroscuro";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaPlatino > 2 && (nBelladona > 2 || nCristalCuarzo > 1 || nSangreDragon >= 1 || nOjoRakhasa > 1))
      {
          sTipoPiedra= "pepitaPlatino";
          iDificultad= 360;
          sLingote= "lingote de platino";
          sLingoteTag= "lingotePlatino";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaArandur > 2)
      {
          sTipoPiedra= "pepitaArandur";
          iDificultad= 400;
          sLingote= "lingote de arandur";
          sLingoteTag= "lingoteArandur";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaMetalvivo > 2)
      {
          sTipoPiedra= "pepitaMetalvivo";
          iDificultad= 440;
          sLingote= "lingote de metal vivo";
          sLingoteTag= "lingoteMetalvivo";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaDerretido > 2 && nPiedraFria > 1)
      {
          sTipoPiedra= "pepitaDerretido";
          iDificultad= 240;
          sLingote= "lingote de hierro enardecido";
          sLingoteTag= "lingoteDerretido";
          eExito= EffectVisualEffect(54);
      }
      else if(nPepitaAdamantita > 2)
      {
          sTipoPiedra= "pepitaAdamantita";
          iDificultad= 520;
          sLingote= "lingote de adamantita";
          sLingoteTag= "lingoteAdamantita";
          eExito= EffectVisualEffect(54);
      }
      else
      {
          oBorrado = GetFirstItemInInventory();
          while(GetIsObjectValid(oBorrado))
          {
              DestroyObject(oBorrado);
              oBorrado = GetNextItemInInventory();
          }

          DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡No has puesto los materiales correctos, se ha hechado a perder todo!*", oPC));
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(60), GetLocation(OBJECT_SELF)));
          SetLocalInt(oForja, "PASO", 0);
          return;
      }

      // FORMULA DE EXITO (SEGUNDA TIRADA)
      int iTiradaExito = d100();
      int iBonoFue = bonoRealCaracteristicaPJ(ABILITY_STRENGTH, oPC)*2;

      // Bonos raciales
      int iRaza= GetRacialType(oPC);
      int iBonusRacial;
      if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d4();
      else iBonusRacial = 0;

      //Si estamos en la forja magica, el efecto es diferente
      if(nForjaMagica == 1) eExito= EffectVisualEffect(VFX_FNF_STRIKE_HOLY);

      // Probabilidad de conseguirlo
      float fProbabilidadExito = (1-((IntToFloat(iDificultad-(iNivelHabilidad*5 + iBonoFue + iBonusRacial)))/80))*100;
      if(IntToFloat(iTiradaExito) <= (fProbabilidadExito+ IntToFloat(GetSkillRank(22,oPC))) )
      {
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Has conseguido un "+ sLingote+ "!*", oPC));
          DelayCommand(2.0, FuncionCrearObjetoYTag(sLingoteTag, oPC));
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExito, GetLocation(OBJECT_SELF)));

          // SUBIDA DE NIVEL (TERCERA TIRADA)
          int iTiradaAprendizaje = d100();
          int iBonoInt = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
          float fProbablidadAprendizaje = ((IntToFloat(iDificultad - (iNivelHabilidad * 5) + iBonoInt))/80) * 100;
          if((iNivelHabilidad < 100) && (IntToFloat(iTiradaAprendizaje) <= fProbablidadAprendizaje))
          {
              int iExperiencia = (iNivelHabilidad + 1)/2;
              if(iExperiencia == 0) iExperiencia = 1;
              else if(iExperiencia > 50) iExperiencia = 50;
              DelayCommand(2.5, PlaySound("gui_level_up"));
              DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Fundición!", oPC));
              DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
              GuardarIntPersistente(oPC, "NIVELFUNDICION", iNivelHabilidad + 1);
          }
      }

      else
      {
          DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Fracasaste al fundir las pepitas!*", oPC));
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(60), GetLocation(OBJECT_SELF)));
      }

      oBorrado = GetFirstItemInInventory();
      while(GetIsObjectValid(oBorrado))
      {
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
      }

      SetLocalInt(oForja, "PASO", 0);
      return;
  }

  else
  {
      oBorrado = GetFirstItemInInventory();
      while(GetIsObjectValid(oBorrado))
      {
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
      }

      DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(2.0, FloatingTextStringOnCreature("*¡Fracasaste al fundir las pepitas¡*", oPC));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(60), GetLocation(OBJECT_SELF)));
      DeleteLocalInt(oForja, "PASO");
      return;
  }
}
