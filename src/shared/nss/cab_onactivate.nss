#include "cab_inc"

void main()
{
  object oPC = GetItemActivator();
  object oObjetoActivado = GetItemActivated();

  object oAyudante1 = GetHenchman(oPC, 1);
  object oAyudante2 = GetHenchman(oPC, 2);
  object oAyudante3 = GetHenchman(oPC, 3);

  if(GetTag(oObjetoActivado) == "cab_montura")
  {
      // Necesitas tener al menos 1 punto en equitacion
      if(ObtenerIntPersistente(oPC, "NIVELEQUITACION") == 0)
      {
          SendMessageToPC(oPC, "<cüGB>No sabes montar a caballo, necesitas que alguien te enseñe.</c>");
          return;
      }

      // Si la montura esta muerta, nos sale esta conversacion
      if(GetLocalInt(oObjetoActivado, "CAB_MUERTO") == TRUE)
      {
          SetLocalInt(oPC, "CAB_POSIBLEMUERTO", 3);
          SetLocalObject(oPC, "CAB_POSIBLEMUERTO", oObjetoActivado);
          AssignCommand(oPC, ClearAllActions(TRUE));
          AssignCommand(oPC, ActionStartConversation(oPC, "cab_animalmuerto", TRUE, FALSE));
          return;
      }

      /*/Tanto para montarte como para desmontarte debes desequiparte las armas/escudos que lleves.
      if (GetIsPC(oPC))
      {
        AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC)));
        AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC)));
      }  */

      // Activamos el objeto de montura cuando ya lo llamamos anterioremente
      // Posibles situaciones:
      // 1. Si estamos montados, nos desmontamos
      // 2. Que el caballo lo tengamos que fijar como muerto
      // 3. Que no te encuentres lo suficiente cerca de un establo
      // 4. Que guardes la montura en un establo con exito
      location lLugarEstablo = GetLocation(GetWaypointByTag(GetTag(GetArea(oPC)) + "establo"));
      float fDistanciaEstablo = GetDistanceBetweenLocations(GetLocation(oPC), lLugarEstablo);
      if(GetItemCursedFlag(oObjetoActivado) == TRUE)
      {
          if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
          {
              MonturasDesmontarse(oPC, oObjetoActivado);
              return;
          }

          else if(VerSiEsMontura(oAyudante1) == FALSE &&
                  VerSiEsMontura(oAyudante2) == FALSE &&
                  VerSiEsMontura(oAyudante3) == FALSE)
          {
              SetLocalInt(oPC, "CAB_POSIBLEMUERTO", 1);
              SetLocalObject(oPC, "CAB_POSIBLEMUERTO", oObjetoActivado);
              AssignCommand(oPC, ClearAllActions(TRUE));
              AssignCommand(oPC, ActionStartConversation(oPC, "cab_animalmuerto", TRUE, FALSE));
              return;
          }

          else if(fDistanciaEstablo == -1.0 || fDistanciaEstablo > 15.0)
          {
              SendMessageToPC(oPC, "<cüGB>Usa este objeto para guardar tu montura si te encuentras cerca de un establo.</c>");
              return;
          }
          else
          {
              MonturasGuardar(oPC, oObjetoActivado);
              return;
          }
      }

      // Activamos el objeto de montura cuando ya llamamos anteriormente otra
      // Posibles situaciones:
      // 1. Que nos avisen de que antes de continuar fijemos como muerta la otra montura si es que no la tenemos en el grupo
      // 2. Que no nos dejen usar la montura porque ya tenemos otra activa y viva
      object oMonturaUsada = GetFirstItemInInventory(oPC);
      while(GetIsObjectValid(oMonturaUsada) == TRUE)
      {
          if(GetTag(oMonturaUsada) == "cab_montura" &&
             GetItemCursedFlag(oMonturaUsada) == TRUE &&
             GetLocalInt(oMonturaUsada, "CAB_MUERTO") == FALSE)
          {
              if(VerSiEsMontura(oAyudante1) == FALSE &&
                 VerSiEsMontura(oAyudante2) == FALSE &&
                 VerSiEsMontura(oAyudante3) == FALSE &&
                 ObtenerIntPersistente(oPC, "CAB_MONTADO") == 0)
              {
                  SetLocalInt(oPC, "CAB_POSIBLEMUERTO", 2);
                  SetLocalObject(oPC, "CAB_POSIBLEMUERTO", oMonturaUsada);
                  AssignCommand(oPC, ClearAllActions(TRUE));
                  AssignCommand(oPC, ActionStartConversation(oPC, "cab_animalmuerto", TRUE, FALSE));
                  return;
              }

              else
              {
                  SendMessageToPC(oPC, "<cüGB>Ya tienes otra montura en uso, sólo puedes tener una.</c>");
                  return;
              }
          }

          oMonturaUsada = GetNextItemInInventory(oPC);
      }

      // Intentamos sacar una montura pero tenemos el establo demasiado lejos
      if(fDistanciaEstablo == -1.0 || fDistanciaEstablo > 15.0)
      {
          SendMessageToPC(oPC, "<cüGB>Debes estar cerca de un establo para poder llamar a esta montura.</c>");
          return;
      }

      // No se pueden tener mas de 3 de ayudantes
      if(oAyudante1 != OBJECT_INVALID &&
         oAyudante2 != OBJECT_INVALID &&
         oAyudante3 != OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "<cüGB>No puedes tener más de 3 ayudantes a la vez.</c>");
          return;
      }

      // No se puede tener mas de una montura convocada
      if(VerSiEsMonturaConvocada(oAyudante1) == TRUE ||
         VerSiEsMonturaConvocada(oAyudante2) == TRUE ||
         VerSiEsMonturaConvocada(oAyudante3) == TRUE)
      {
          SendMessageToPC(oPC, "<cþ>Ya tienes una montura convocada, sólo puedes tener una montura.</c>");
          return;
      }

      // Intentamos sacar una montura pero no tenemos dinero para pagar
      if(GetGold(oPC) < 150)
      {
          SendMessageToPC(oPC, "<cüGB>Necesitas pagar 150 monedas de oro por el mantenimiento de la montura.</c>");
          return;
      }

      // RESTRICCIONES
      // No nos podemos montar cuando tenemos alguna forma rara
      int iAparienciaPJ = GetAppearanceType(oPC);
      int iFenotipoPJ = GetPhenoType(oPC);
      if((iAparienciaPJ > 6) || (iFenotipoPJ > 2 && iFenotipoPJ != 4))
      {
          SendMessageToPC(oPC, "<cüGB>No puedes llamar a una montura con esa apariencia o fenotipo.</c>");
          return;
      }

      // Gnomos y medianos... solo ponis, perros, lobos terribles y huargos
      string sIdentidadMontura = GetStringRight(GetResRef(oObjetoActivado), 2);
      if(!GetLocalInt(oObjetoActivado, "CAB_IGNORESIZE") && (iAparienciaPJ == 2 || iAparienciaPJ == 3) &&
         (sIdentidadMontura != "12" && sIdentidadMontura != "13" && sIdentidadMontura != "14" &&
          sIdentidadMontura != "23" && sIdentidadMontura != "27" && sIdentidadMontura != "28" &&
          sIdentidadMontura != "40" && sIdentidadMontura != "41" && sIdentidadMontura != "42" &&
          sIdentidadMontura != "43") )
      {
          SendMessageToPC(oPC, "<cüGB>Las apariencias de gnomos y medianos sólo pueden montarse en ponis, perros, lobos terribles, cabras y huargos.</c>");
          return;
      }

      // Perros solo para gnomos y medianos
      if(iAparienciaPJ != 2 && iAparienciaPJ != 3 && sIdentidadMontura == "23")
      {
          SendMessageToPC(oPC, "<cüGB>La montura de perro sólo puede ser usada por criaturas pequeñas.</c>");
          return;
      }

      // Las Cabras solo para gnomos, medianos ..... cabras
      if(iAparienciaPJ != 0 && iAparienciaPJ != 2 && iAparienciaPJ != 3 && (sIdentidadMontura == "40" ||
          sIdentidadMontura == "41" || sIdentidadMontura == "42" || sIdentidadMontura == "43"))
      {
          SendMessageToPC(oPC, "<cüGB>La montura de cabra sólo puede ser usada por criaturas pequeñas o medianas.</c>");
          return;
      }

      //Los ciervos solo pueden ser usados por los elfos.
      if(iAparienciaPJ != 1  && sIdentidadMontura == "48")
      {
          SendMessageToPC(oPC, "<cüGB>La montura de ciervo sólo puede ser usada por los elfos.</c>");
          return;
      }

      // Leon, leona, osos y leopardo necesitan 5 puntitos en Trato con animales!
      if(GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC, TRUE) < 5 &&
        (sIdentidadMontura == "21" || sIdentidadMontura == "22" ||
         sIdentidadMontura == "24" || sIdentidadMontura == "36" ||
         sIdentidadMontura == "44" || sIdentidadMontura == "45" ||
         sIdentidadMontura == "46" ))
      {
          SendMessageToPC(oPC, "<cüGB>El animal no acude a tu llamada, necesitas domesticarlo. Necesitas 5 rangos de Trato con animales para ello.</c>");
          return;
      }

      // Llamamos con exito a una montura
      // Activamos el objeto caballo
      SetItemCursedFlag(oObjetoActivado, TRUE);

      // Creamos la montura y la movemos hacia el PJ
      string sResrefMontura;
      if(sIdentidadMontura == "01") sResrefMontura = "cab_marron169";
      else if(sIdentidadMontura == "02") sResrefMontura = "cab_gris169";
      else if(sIdentidadMontura == "03") sResrefMontura = "cab_negro169";
      else if(sIdentidadMontura == "04") sResrefMontura = "cab_moteado169";
      else if(sIdentidadMontura == "05") sResrefMontura = "cab_pesadilla169";
      else if(sIdentidadMontura == "06") sResrefMontura = "cab_marroncep";
      else if(sIdentidadMontura == "07") sResrefMontura = "cab_blancocep";
      else if(sIdentidadMontura == "08") sResrefMontura = "cab_negrocep";
      else if(sIdentidadMontura == "09") sResrefMontura = "cab_aurenthilcep";
      else if(sIdentidadMontura == "10") sResrefMontura = "cab_uniblancocep";
      else if(sIdentidadMontura == "11") sResrefMontura = "cab_uninegrocep";
      else if(sIdentidadMontura == "12") sResrefMontura = "cab_ponimarcep";
      else if(sIdentidadMontura == "13") sResrefMontura = "cab_poniblacep";
      else if(sIdentidadMontura == "14") sResrefMontura = "cab_ponimotcep";
      else if(sIdentidadMontura == "15") sResrefMontura = "cab_uniblancocl1";
      else if(sIdentidadMontura == "16") sResrefMontura = "cab_uniblancocl2";
      else if(sIdentidadMontura == "17") sResrefMontura = "cab_blanco169";
      else if(sIdentidadMontura == "18") sResrefMontura = "cab_jabalired";
      else if(sIdentidadMontura == "19") sResrefMontura = "cab_jabaligrey";
      else if(sIdentidadMontura == "20") sResrefMontura = "cab_jabalinegro";
      else if(sIdentidadMontura == "21") sResrefMontura = "cab_leon";
      else if(sIdentidadMontura == "22") sResrefMontura = "cab_leona";
      else if(sIdentidadMontura == "23") sResrefMontura = "cab_perro";
      else if(sIdentidadMontura == "24") sResrefMontura = "cab_leopardo";
      else if(sIdentidadMontura == "25") sResrefMontura = "cab_lagartoverde";
      else if(sIdentidadMontura == "26") sResrefMontura = "cab_lagartonaran";
      else if(sIdentidadMontura == "27") sResrefMontura = "cab_loboterr";
      else if(sIdentidadMontura == "28") sResrefMontura = "cab_huargo";
      else if(sIdentidadMontura == "29") sResrefMontura = "cab_muertoviv";
      else if(sIdentidadMontura == "30") sResrefMontura = "cab_hipogrifo";
      else if(sIdentidadMontura == "31") sResrefMontura = "cab_grifo";
      else if(sIdentidadMontura == "32") sResrefMontura = "cab_jarilith";
      else if(sIdentidadMontura == "33") sResrefMontura = "cab_pegasoblanco";
      else if(sIdentidadMontura == "34") sResrefMontura = "cab_pegasonegro";
      else if(sIdentidadMontura == "35") sResrefMontura = "cab_pegasomarron";
      else if(sIdentidadMontura == "36") sResrefMontura = "cab_oso";
      else if(sIdentidadMontura == "37") sResrefMontura = "cab_jabaligrey2";
      else if(sIdentidadMontura == "38") sResrefMontura = "cab_jabalired2";
      else if(sIdentidadMontura == "39") sResrefMontura = "cab_jabalinegro2";
      else if(sIdentidadMontura == "40") sResrefMontura = "cab_cabranegra";
      else if(sIdentidadMontura == "41") sResrefMontura = "cab_cabramarron";
      else if(sIdentidadMontura == "42") sResrefMontura = "cab_cabramoteada";
      else if(sIdentidadMontura == "43") sResrefMontura = "cab_cabrablanca";
      else if(sIdentidadMontura == "44") sResrefMontura = "cab_osopolar";
      else if(sIdentidadMontura == "45") sResrefMontura = "cab_osomarron";
      else if(sIdentidadMontura == "46") sResrefMontura = "cab_osonegro";
      else if(sIdentidadMontura == "47") sResrefMontura = "cab_grifo2";
      else if(sIdentidadMontura == "48") sResrefMontura = "cab_ciervo";

      object oMontura = CreateObject(OBJECT_TYPE_CREATURE, sResrefMontura, lLugarEstablo);
      SetLocalInt(oMontura,"Ayudante_NoBorrar",1);
      AddHenchman(oPC, oMontura);
      DelayCommand(1.9, AssignCommand(oMontura, ClearAllActions(TRUE)));
      DelayCommand(2.0, AssignCommand(oMontura, ActionMoveToObject(oPC, TRUE)));

      // Amo y nombre de la montura
      SetLocalString(oMontura, "AMO", GetName(oPC, TRUE));
      string sNombre = GetLocalString(oObjetoActivado, "CABNOMBRE");
      if(sNombre != "") SetName(oMontura, sNombre);

      // Subimos de nivel a la montura
      int iNivelMontura = GetLocalInt(oObjetoActivado, "NIVELMONTURA");
      if(iNivelMontura == 0)
      {
          SetLocalInt(oObjetoActivado, "NIVELMONTURA", 1);
          SetLocalInt(oObjetoActivado, "NIVELMONTURAXP", 1);
      }
      else
      {
          int iClaseNivel = GetClassByPosition(1, oMontura);
          while(iNivelMontura != 1)
          {
              LevelUpHenchman(oMontura, iClaseNivel);
              iNivelMontura = iNivelMontura - 1;
          }
      }
      // Nombre del propietario del animal
      SetDescription(oMontura, GetDescription(oMontura) + "\n\n<c ~ >Propietario: </c>" + ObtenerStringPersistente(oPC,"Disfrazado_nombre"));

      // Sonidos de pasos montura
      if(VerSiDebeTenerSonidoCaballo(oMontura)) DelayCommand(1.5, SetFootstepType(17, oMontura));
      else DelayCommand(1.5, SetFootstepType(1, oMontura));

      // Guardamos la montura (por si tiene que desaparecer al establecerla como muerta)
      SetLocalObject(oPC, "CAB_MONTURAGUARDADA", oMontura);

      // Pagamos
      AssignCommand(oPC, TakeGoldFromCreature(150, oPC, TRUE));
      SendMessageToPC(oPC, "<ceî´>Pagas 150 monedas de oro por el mantenimiento de tu montura</c>");

      // Animaciones
      AssignCommand(oPC, PlaySound("as_pl_whistle" + IntToString(d2())));
      AssignCommand(oPC, SpeakString("*Llamas silbando a tu montura*"));
  }

  else if(GetTag(oObjetoActivado) == "cab_equitacion")
  {
      int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");
      int iXPEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACIONXP");
      int iNivelMontura, iXPMontura;
      string sNivelEquitacion = IntToString(iNivelEquitacion);
      string sXPEquitacionActual = IntToString(iXPEquitacion);
      string sXPEquitacionNivSig = IntToString(CalculoSiguienteNivelXPEquitacion(iNivelEquitacion));
      string sNivelMontura, sXPMonturaActual, sXPMonturaNivSig;

      object oMonturaUsada = GetFirstItemInInventory(oPC);
      int iUnaSolaVez;
      while(GetIsObjectValid(oMonturaUsada) == TRUE && iUnaSolaVez == FALSE)
      {
          if(GetTag(oMonturaUsada) == "cab_montura" &&
             GetItemCursedFlag(oMonturaUsada) == TRUE &&
             GetLocalInt(oMonturaUsada, "CAB_MUERTO") == FALSE)
          {
              iNivelMontura = GetLocalInt(oMonturaUsada, "NIVELMONTURA");
              iXPMontura = GetLocalInt(oMonturaUsada, "NIVELMONTURAXP");
              sNivelMontura = IntToString(iNivelMontura);
              sXPMonturaActual = IntToString(iXPMontura);
              sXPMonturaNivSig = IntToString(CalculoSiguienteNivelXPMontura(iNivelMontura));
              iUnaSolaVez == TRUE;
          }

          oMonturaUsada = GetNextItemInInventory(oPC);
      }

      string sExplicacionNivelEquitacion;
      if(iXPEquitacion >= CalculoSiguienteNivelXPEquitacion(iNivelEquitacion) &&
        (iNivelEquitacion == 9 || iNivelEquitacion == 24 || iNivelEquitacion == 49 ||
         iNivelEquitacion == 69 || iNivelEquitacion == 89 || iNivelEquitacion == 99)) sExplicacionNivelEquitacion = " (Para subir al siguiente nivel y rango de jinete necesitarás que algún cuidador de establos te entrenane)";

      string sExplicacionNivelMontura;
      if(iXPMontura >= CalculoSiguienteNivelXPMontura(iNivelMontura)) sExplicacionNivelMontura = " (Para subir al siguiente nivel necesitarás que algún cuidador de establos te entrene la montura)";

      SendMessageToPC(oPC,"<cþ>Nivel de equitación: <c´þd>"+sNivelEquitacion+sExplicacionNivelEquitacion+".</c></c>");
      SendMessageToPC(oPC,"<cþ>Experiencia de equitación: <c´þd>"+sXPEquitacionActual+"/"+sXPEquitacionNivSig+".</c></c>");
      SendMessageToPC(oPC,"<cþ>Rango de jinete: <c´þd>"+ObtenerRangoJineteString(oPC)+".</c></c>");
      if(sNivelMontura != "")
      {
          if(iNivelMontura == 20) SendMessageToPC(oPC,"<cþ>Nivel de la montura en uso: <c´þd>"+sNivelMontura+" (nivel máximo).</c></c>");
          else SendMessageToPC(oPC,"<cþ>Nivel de la montura en uso: <c´þd>"+sNivelMontura+sExplicacionNivelMontura+".</c></c>");
      }
      if(sXPMonturaActual != "")
      {
          if(iNivelMontura == 20) SendMessageToPC(oPC,"<cþ>Experiencia de la montura en uso: <c´þd>"+sXPMonturaActual+" (experiencia máxima).</c></c>");
          else SendMessageToPC(oPC,"<cþ>Experiencia de la montura en uso: <c´þd>"+sXPMonturaActual+"/"+sXPMonturaNivSig+".</c></c>");
      }

  }

  else if(GetTag(oObjetoActivado) == "cab_mascota")
  {
      if(GetLocalString(oObjetoActivado, "DUENYOMASCOTA") == "")
      {
          SetLocalString(oObjetoActivado, "DUENYOMASCOTA", GetName(oPC, TRUE));
          SendMessageToPC(oPC, "<c´þd>Esta mascota ha sido usada por primera vez y te has convertido en su dueño. Nadie excepto tú podrá usarla.</c>");
      }
      else
      {
          if(GetLocalString(oObjetoActivado, "DUENYOMASCOTA") != GetName(oPC, TRUE))
          {
              SendMessageToPC(oPC, "<cþ>No eres el dueño de esta mascota y por lo tanto no puedes llamarla, no acude a ti.</c>");
              return;
          }
      }

      // Invocamos la mascota y ajustamos sus caracteristicas
      AssignCommand(oPC, MascotaInvocacion(GetItemActivatedTargetLocation()));
      DelayCommand(0.5, MascotaAjustes(oPC, oObjetoActivado));
  }
}
