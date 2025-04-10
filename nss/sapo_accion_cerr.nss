#include "mti_libreria"
#include "sute_libreria"
void main()
{
  object oPC = GetLastClosedBy();
  object oCuba = OBJECT_SELF;
  object oBorrado;

  if(GetLocalInt(oCuba, "PASO") == 0)
  {
      oBorrado = GetFirstItemInInventory();
      while(GetIsObjectValid(oBorrado))
      {
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
      }

      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(263), GetLocation(OBJECT_SELF)));
      return;
  }

  // SI LA CUBA ESTA VACIA, PUES QUE NO PASE NADA
  if(GetFirstItemInInventory() == OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "*La cuba está vacía, nada ocurre*");
      DeleteLocalInt(oCuba, "PASO");
      return;
  }

  // A NIVEL 0 NO SE PUEDE USAR LA CUBA
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "Profesion9");
  if(iNivelHabilidad == 0)
  {
      DelayCommand(1.5, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(1.5, FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro peletero antes de nada*", oPC));
      SetLocalInt(oCuba, "PASO", 0);
      return;
  }

  // ANIMACIONES DEL PJ
  DelayCommand(0.3, AssignCommand(oPC, ClearAllActions(TRUE)));
  DelayCommand(0.5, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 0.9)));

  /*/ LESIONES DE FUNDICION (QUEMADURA GRAVE, LEVE Y HUMO)
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
      SetLocalInt(oCuba, "PASO", 0);

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
  }*/

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
    int nPielRoedor = 0;
    int nPielHerbivoro = 0;
    int nPielBestia = 0;
    int nPielBestiaGrande = 0;
    int nPielMitica = 0;
    int nPielMiticaGrande = 0;
    int nPielDracoFuego = 0;
       int nPielDracoHielo = 0;
       int nPielDracoAcido = 0;
       int nPielDracoRayo = 0;
       int nSal = 0;
       int nTanino = 0;
       int nBarra = 0;
       int nBelladona = 0;
       int nSangreDraco = 0;
       int nPolvoHada = 0;
    string sMetalTag;
    object oMetal = GetFirstItemInInventory();
    while(GetIsObjectValid(oMetal))
      {
          sMetalTag = GetTag(oMetal);
          if(sMetalTag == "pielroedor") nPielRoedor = nPielRoedor + 1;
          else if(sMetalTag == "pielherbivoro") nPielHerbivoro = nPielHerbivoro + 1;
          else if(sMetalTag == "pielbestia") nPielBestia = nPielBestia + 1;
          else if(sMetalTag == "pielbestiag") nPielBestiaGrande = nPielBestiaGrande + 1;
          else if(sMetalTag == "pielmitica") nPielMitica = nPielMitica + 1;
          else if(sMetalTag == "pielmiticag") nPielMiticaGrande = nPielMiticaGrande + 1;
          else if(sMetalTag == "pieldragof") nPielDracoFuego = nPielDracoFuego + 1;
                else if(sMetalTag == "pieldracoh") nPielDracoHielo = nPielDracoHielo + 1;
                else if(sMetalTag == "pieldracoa") nPielDracoAcido = nPielDracoAcido + 1;
                else if(sMetalTag == "pieldracor") nPielDracoRayo = nPielDracoRayo + 1;
             else if(sMetalTag == "sapo_ing_sal") nSal = nSal + 1;
                else if(sMetalTag == "sapo_ing_tanino") nTanino = nTanino + 1;
                else if(sMetalTag == "sapo_ing_cera") nBarra = nBarra + 1;
                else if(sMetalTag == "NW_IT_MSMLMISC23") nBelladona = nBelladona + 1;
                else if(sMetalTag == "NW_IT_MSMLMISC17") nSangreDraco = nSangreDraco + 1;
                else if(sMetalTag == "NW_IT_MSMLMISC19") nPolvoHada = nPolvoHada + 1;
          oMetal = GetNextItemInInventory();
      }

      string sTipoPiel= "";
      int iDificultad= 0;
      string sPiel;
      string sPielTag;
      effect eExito;

   //RECETAS PARA CURTIR PIELES

      if(nPielRoedor >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1)
      {
          sTipoPiel= "roedor";
          iDificultad= 50;
          sPiel= "Cuero de piel de roedor";
          sPielTag= "cuero_roedor";
          eExito= EffectVisualEffect(VFX_IMP_POISON_L);
      }
      else if(nPielHerbivoro >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1)
      {
          sTipoPiel= "hervivoro";
          iDificultad= 100;
          sPiel= "Cuero de piel de hervivoro";
          sPielTag= "cuero_herbivoro";
          eExito= EffectVisualEffect(VFX_IMP_POLYMORPH);
      }
      else if(nPielBestia >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1)
      {
          sTipoPiel= "Bestia";
          iDificultad= 160;
          sPiel= "Cuero de piel de bestia";
          sPielTag= "cuero_bestia";
          eExito= EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
      }
      else if(nPielBestiaGrande >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1)
      {
          sTipoPiel= "Bestia Grande";
          iDificultad= 220;
          sPiel= "Cuero de piel de bestia grande";
          sPielTag= "cuero_bestiag";
          eExito= EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
      }
      else if(nPielMitica >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1 && nBelladona == 1)
      {
          sTipoPiel= "Mitica";
          iDificultad= 280;
          sPiel= "Cuero de piel de bestia mitica";
          sPielTag= "cuero_mitica";
          eExito= EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
      }
      else if(nPielMiticaGrande >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1 && nPolvoHada == 1)
      {
          sTipoPiel= "Mitica grande";
          iDificultad= 340;
          sPiel= "Cuero de piel de bestia mitica grande";
          sPielTag= "cuero_miticag";
          eExito= EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
      }
      else if(nPielDracoFuego >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1 && nSangreDraco == 1)
      {
          sTipoPiel= "dragon fuego";
          iDificultad= 400;
          sPiel= "Cuero de piel de draco de fuego";
          sPielTag= "cuero_dragof";
          eExito= EffectVisualEffect(VFX_IMP_FLAME_M);
      }
       else if(nPielDracoHielo >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1 && nSangreDraco == 1)
      {
          sTipoPiel= "dragon hielo";
          iDificultad= 400;
          sPiel= "Cuero de piel de draco de hielo";
          sPielTag= "cuero_dragoh";
          eExito= EffectVisualEffect(VFX_IMP_FROST_L);
      }
        else if(nPielDracoAcido >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1 && nSangreDraco == 1)
      {
          sTipoPiel= "dragon acido";
          iDificultad= 400;
          sPiel= "Cuero de piel de draco de acido";
          sPielTag= "cuero_dragoa";
          eExito= EffectVisualEffect(VFX_IMP_ACID_L);
      }
       else if(nPielDracoRayo >= 1 && nSal == 1 && nTanino == 1 && nBarra == 1 && nSangreDraco == 1)
      {
          sTipoPiel= "dragon rayo";
          iDificultad= 400;
          sPiel= "Cuero de piel de draco de rayo";
          sPielTag= "cuero_dragor";
          eExito= EffectVisualEffect(VFX_IMP_LIGHTNING_S);
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
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡No has puesto materiales correctos y se ha echado a perder todo!*", oPC));
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(60), GetLocation(OBJECT_SELF)));
          SetLocalInt(oCuba, "PASO", 0);
          return;
      }

      // FORMULA DE EXITO (SEGUNDA TIRADA)
      int iTiradaExito = d100();
      int iBonoFue = bonoRealCaracteristicaPJ(ABILITY_DEXTERITY, oPC)*2;

      // Bonos raciales
      int iRaza= GetRacialType(oPC);
      int iBonusRacial;
      if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d4();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d4();
      else if(iRaza == RACIAL_TYPE_ELF) iBonusRacial = d6();
      else iBonusRacial = 0;

      // Probabilidad de conseguirlo
      float fProbabilidadExito = (1-((IntToFloat(iDificultad-(iNivelHabilidad*5 + iBonoFue + iBonusRacial)))/80))*100;
      if(IntToFloat(iTiradaExito) <= (fProbabilidadExito+ IntToFloat(GetSkillRank(22,oPC))) )
      {
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Has conseguido un "+ sPiel+ "!*", oPC));
          DelayCommand(2.0, FuncionCrearObjetoYTag(sPielTag, oPC));
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
              DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Curtidor!", oPC));
              DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
              GuardarIntPersistente(oPC, "Profesion9", iNivelHabilidad + 1);
          }
      }

      else
      {
          DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Fracasaste al tratar las pieles!*", oPC));
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(263), GetLocation(OBJECT_SELF)));
      }

      oBorrado = GetFirstItemInInventory();
      while(GetIsObjectValid(oBorrado))
      {
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
      }

      SetLocalInt(oCuba, "PASO", 0);
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
      DelayCommand(2.0, FloatingTextStringOnCreature("*¡Fracasaste al tratar las pieles¡*", oPC));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(263), GetLocation(OBJECT_SELF)));
      DeleteLocalInt(oCuba, "PASO");
      return;
  }
}
