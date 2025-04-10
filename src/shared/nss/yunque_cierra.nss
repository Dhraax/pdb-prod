#include "mti_libreria"
#include "yunque_inc"
void main()
{
  object oPC = GetLastClosedBy();

  // SI EL YUNQUE YA ESTA OCUPADO POR OTRA PERSONA, NADA OCURRE
  string sNombreMemorizado = GetLocalString(OBJECT_SELF, "YUNQUEOCUPADO");
  if(sNombreMemorizado != GetName(oPC, TRUE))
  {
      FloatingTextStringOnCreature("*El yunque ya está siendo usado por otra persona*", oPC, FALSE);
      return;
  }

  // SI EL YUNQUE ESTA VACIO, NADA OCURRE
  if(GetFirstItemInInventory() == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*No hay nada en el yunque, nada ocurre*", oPC, FALSE);
      return;
  }

  // NECESITAS TENER NIVEL 1 O MAS PARA USAR EL YUNQUE
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELHERRERIA");
  if(iNivelHabilidad == 0)
  {
      FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Herrería antes de nada*", oPC, FALSE);
      return;
  }

  // SI NO TE EQUIPAS UN MARTILLO LIGERO DE HERRERO, EL SCRIPT NO SIGUE
  object oMartillo = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if(GetTag(oMartillo) != "martillo_herrero"  &&
     GetTag(oMartillo) != "martillo_herrero2" &&
     GetTag(oMartillo) != "martillo_herrero3")
  {
      FloatingTextStringOnCreature("*No tienes equipado ningún martillo de herrero*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // MIREMOS A VER QUE TIPO DE MOLDE HEMOS METIDO Y LO GUARDAMOS
  object oMolde;
  oMolde = GetFirstItemInInventory();
  int iContadorMoldes;
  iContadorMoldes = 0;
  while(GetIsObjectValid(oMolde) == TRUE && iContadorMoldes < 2)
  {
      if(GetStringLeft(GetTag(oMolde), 6) == "molde_")
      {
          SetLocalObject(OBJECT_SELF, "MOLDE", oMolde);
          iContadorMoldes = iContadorMoldes + 1;
      }

      oMolde = GetNextItemInInventory();
  }

  // SI HAY MAS DE 1 MOLDE, EL SCRIPT NO SIGUE
  if(iContadorMoldes == 2)
  {
      FloatingTextStringOnCreature("*Sólo necesitas usar un tipo de molde*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // SI NO HAY MOLDE, EL SCRIPT NO SIGUE
  object oMoldeGuardado = GetLocalObject(OBJECT_SELF, "MOLDE");
  if(oMoldeGuardado == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*¡Sin un molde en el yunque no puedes forjar nada¡*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // MIREMOS A VER QUE TIPO(S) DE LINGOTE(S)/INGREDIENTE(S) HEMOS METIDO Y
  // GUARDAMOS LA CANTIDAD
  int iLingotesHierro = 0;
  int iLingotesCobre = 0;
  int iLingotesAcero = 0;
  int iLingotesPlata = 0;
  int iLingotesHierrofrio = 0;
  int iLingotesOro = 0;
  int iLingotesMithril = 0;
  int iLingotesAdamantita = 0;
  int iLingotesDlarun = 0;
  int iLingotesHizagkuur = 0;
  int iLingotesAceroscuro = 0;
  int iLingotesPlatino = 0;
  int iLingotesArandur = 0;
  int iLingotesMetalvivo = 0;
  int iLingotesCarbon = 0;
  int iLingotesDerretido = 0;
  int iSangreDragon = 0;
  int iEstatuillaDragon = 0;
  int iCristalCuarzo = 0;
  int iHumoGaseoso = 0;
  int iGlandulaSeda = 0;
  int iCalaveraGargola = 0;
  int iBastonMaderaAlamo = 0;
  int iDagaAcero = 0;
  int iPiedrasTrueno = 0;
  int iArenillaDiamante = 0;
  int iArenillaTopacio = 0;
  int iCristalAzabacheTallado = 0;

  object oLingIng = GetFirstItemInInventory();
  while(GetIsObjectValid(oLingIng) == TRUE)
  {
      if(GetTag(oLingIng) == "lingoteHierro") iLingotesHierro = iLingotesHierro + 1;
      else if(GetTag(oLingIng) == "lingoteCobre") iLingotesCobre = iLingotesCobre + 1;
      else if(GetTag(oLingIng) == "lingoteAcero") iLingotesAcero = iLingotesAcero + 1;
      else if(GetTag(oLingIng) == "lingotePlata") iLingotesPlata = iLingotesPlata + 1;
      else if(GetTag(oLingIng) == "lingoteHierrofrio") iLingotesHierrofrio = iLingotesHierrofrio + 1;
      else if(GetTag(oLingIng) == "lingoteOro") iLingotesOro = iLingotesOro + 1;
      else if(GetTag(oLingIng) == "lingoteMithril") iLingotesMithril = iLingotesMithril + 1;
      else if(GetTag(oLingIng) == "lingoteAdamantita") iLingotesAdamantita = iLingotesAdamantita + 1;
      else if(GetTag(oLingIng) == "lingoteDlarun") iLingotesDlarun = iLingotesDlarun + 1;
      else if(GetTag(oLingIng) == "lingoteHizagkuur") iLingotesHizagkuur = iLingotesHizagkuur + 1;
      else if(GetTag(oLingIng) == "lingoteAceroscuro") iLingotesAceroscuro = iLingotesAceroscuro + 1;
      else if(GetTag(oLingIng) == "lingotePlatino") iLingotesPlatino = iLingotesPlatino + 1;
      else if(GetTag(oLingIng) == "lingoteArandur") iLingotesArandur = iLingotesArandur + 1;
      else if(GetTag(oLingIng) == "lingoteMetalvivo") iLingotesMetalvivo = iLingotesMetalvivo + 1;
      else if(GetTag(oLingIng) == "lingoteCarbon") iLingotesCarbon = iLingotesCarbon + 1;
      else if(GetTag(oLingIng) == "lingoteDerretido") iLingotesDerretido = iLingotesDerretido + 1;
      else if(GetTag(oLingIng) == "NW_IT_MSMLMISC17") iSangreDragon = iSangreDragon + 1;
      else if(GetTag(oLingIng) == "Estatuilladedragon") iEstatuillaDragon = iEstatuillaDragon + 1;
      else if(GetTag(oLingIng) == "NW_IT_MSMLMISC11") iCristalCuarzo = iCristalCuarzo + 1;
      else if(GetTag(oLingIng) == "humoGaseoso") iHumoGaseoso = iHumoGaseoso + 1;
      else if(GetTag(oLingIng) == "NW_IT_MSMLMISC07") iGlandulaSeda = iGlandulaSeda + 1;
      else if(GetTag(oLingIng) == "NW_IT_MSMLMISC14") iCalaveraGargola = iCalaveraGargola + 1;
      else if(GetTag(oLingIng) == "al_baston") iBastonMaderaAlamo = iBastonMaderaAlamo + 1;
      else if(GetTag(oLingIng) == "ac_daga") iDagaAcero = iDagaAcero + 1;
      else if(GetTag(oLingIng) == "X1_WMGRENADE007") iPiedrasTrueno = iPiedrasTrueno + 1;
      else if(GetTag(oLingIng) == "polvo_dia") iArenillaDiamante = iArenillaDiamante + 1;
      else if(GetTag(oLingIng) == "polvo_top") iArenillaTopacio = iArenillaTopacio + 1;
      else if(GetTag(oLingIng) == "gema_aza") iCristalAzabacheTallado = iCristalAzabacheTallado + 1;

      oLingIng = GetNextItemInInventory();
  }

  int iSumaLingotes = iLingotesHierro + iLingotesCobre + iLingotesAcero +
      iLingotesPlata + iLingotesHierrofrio + iLingotesOro + iLingotesMithril +
      iLingotesAdamantita + iLingotesDlarun + iLingotesHizagkuur + iLingotesAceroscuro +
      iLingotesPlatino + iLingotesArandur + iLingotesMetalvivo + iLingotesCarbon +
      iLingotesDerretido;

  // SI NO HAY LINGOTE, EL SCRIPT NO SIGUE
  if(iSumaLingotes == 0)
  {
      FloatingTextStringOnCreature("*¡No hay ningún lingote en el yunque!*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // A CREAR OBJETOS!
  string sTagMolde = GetTag(oMoldeGuardado);



  // ALABARDAS
  if(sTagMolde == "molde_alabarda")
  {
      // Alabarda de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de hierro...",
          "hr_alabarda", "*¡Has logrado fabricar una alabarda de hierro!*",
          160, 90);
      }

      // Alabarda de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de cobre...",
          "co_alabarda", "*¡Has logrado fabricar una alabarda de cobre!*",
          103, 150);
      }

      // Alabarda de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de acero...",
          "ac_alabarda", "*¡Has logrado fabricar una alabarda de acero!*",
          218, 240);
      }

      // Alabarda de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de plata...",
          "pl_alabarda", "*¡Has logrado fabricar una alabarda de plata!*",
          275, 390);
      }

      // Alabarda de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de hierrofrío...",
          "hf_alabarda", "*¡Has logrado fabricar una alabarda de hierrofrío!*",
          333, 630);
      }

      // Alabarda de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de oro...",
          "or_alabarda", "*¡Has logrado fabricar una alabarda de oro!*",
          390, 1020);
      }

      // Alabarda de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de mithril...",
          "mi_alabarda", "*¡Has logrado fabricar una alabarda de mithril!*",
          448, 1950);
      }

      // Alabarda de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de adamantita...",
          "ad_alabarda", "*¡Has logrado fabricar una alabarda de adamantita!*",
          505, 3000);
      }


      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de dlarun...",
          "dl_alabarda", "*¡Has logrado fabricar una alabarda de dlarun!*",
          160, 3000);
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de Hizagkuur...",
          "hi_alabarda", "*¡Has logrado fabricar una alabarda de Hizagkuur!*",
          200, 3000);
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de Aceroscuro...",
          "aco_alabarda", "*¡Has logrado fabricar una alabarda de Aceroscuro!*",
          505, 3000);
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de Platino...",
          "platino_alabarda", "*¡Has logrado fabricar una alabarda de Platino!*",
          360, 3000);
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de Arandur...",
          "ar_alabarda", "*¡Has logrado fabricar una alabarda de Arandur!*",
          505, 3000);
      }
      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de metal vivo...",
          "me_alabarda", "*¡Has logrado fabricar una alabarda de metal vivo!*",
          505, 3000);
      }
      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una alabarda de hierro enardecido...",
          "meteo_alabarda", "*¡Has logrado fabricar una alabarda de hierro enardecido!*",
          320, 3000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // DAGAS
  else if(sTagMolde == "molde_daga")
  {
      // RECETA UNICA: Daga de parada
      if(iLingotesHierro == 2 && iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de parada...",
          "dagadeparada", "*¡Has logrado fabricar una daga de parada!*",
          205, 320, "contenedor_yunque3");
      }

      // Daga de hierro (1)
      else if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de hierro...",
          "hr_daga", "*¡Has logrado fabricar una daga de hierro!*",
          137, 30);
      }

      // Daga de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de cobre...",
          "co_daga", "*¡Has logrado fabricar una daga de cobre!*",
          80, 50);
      }

      // Daga de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de acero...",
          "ac_daga", "*¡Has logrado fabricar una daga de acero!*",
          195, 80);
      }

      // Daga de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de plata...",
          "pl_daga", "*¡Has logrado fabricar una daga de plata!*",
          252, 130);
      }

      // Daga de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de hierrofrío...",
          "hf_daga", "*¡Has logrado fabricar una daga de hierrofrío!*",
          310, 210);
      }

      // Daga de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de oro...",
          "or_daga", "*¡Has logrado fabricar una daga de oro!*",
          367, 340);
      }

      // Daga de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de mithril...",
          "mi_daga", "*¡Has logrado fabricar una daga de mithril!*",
          425, 650);
      }

      // Daga de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de adamantita...",
          "ad_daga", "*¡Has logrado fabricar una daga de adamantita!*",
          482, 1000);
      }

      else if(iLingotesDlarun == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de dlarun...",
          "dl_daga", "*¡Has logrado fabricar una daga de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de Hizagkuur...",
          "hi_daga", "*¡Has logrado fabricar una daga de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de Aceroscuro...",
          "aco_daga", "*¡Has logrado fabricar una daga de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de Platino...",
          "platino_daga", "*¡Has logrado fabricar una daga de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de Arandur...",
          "ar_daga", "*¡Has logrado fabricar una daga de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }
      else if(iLingotesMetalvivo == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de metal vivo...",
          "me_daga", "*¡Has logrado fabricar una daga de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }
      else if(iLingotesDerretido == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una daga de hierro enardecido...",
          "meteo_daga", "*¡Has logrado fabricar una daga de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // BALAS
  else if(sTagMolde == "molde_bala")
  {
      // RECETA UNICA: Balas rompedoras
      if(iLingotesHierrofrio == 1 && iPiedrasTrueno == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando balas rompedoras...",
          "receta_brompe", "*¡Has logrado fabricar 99 balas rompedoras!*",
          425, 700, "contenedor_yunque3");
          return;
      }

      // Balas de hierro (1)
      else if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando balas de hierro...",
          "hr_bala", "*¡Has logrado fabricar 99 balas de hierro!*",
          137, 30);
      }

      // Balas de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando balas de cobre...",
          "co_bala", "*¡Has logrado fabricar 99 balas de cobre!*",
          80, 50);
      }

      // Balas de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando balas de acero...",
          "ac_bala", "*¡Has logrado fabricar 99 balas de acero!*",
          195, 80);
      }

      // Balas de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando balas de plata...",
          "pl_bala", "*¡Has logrado fabricar 99 balas de plata!*",
          252, 130);
      }

      // Balas de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando balas de hierrofrío...",
          "hf_bala", "*¡Has logrado fabricar 99 balas de hierrofrío!*",
          310, 210);
      }

      // Balas de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando balas de oro...",
          "or_bala", "*¡Has logrado fabricar 99 balas de oro!*",
          367, 340);
      }

      // Balas de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando balas de mithril...",
          "mi_bala", "*¡Has logrado fabricar 99 balas de mithril!*",
          425, 650);
      }

      // Balas de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando balas de adamantita...",
          "ad_bala", "*¡Has logrado fabricar 99 balas de adamantita!*",
          482, 1000);
      }

      else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una bala de dlarun...",
          "dl_bala", "*¡Has logrado fabricar una bala de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una bala de Hizagkuur...",
          "hi_bala", "*¡Has logrado fabricar una bala de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una bala de Aceroscuro...",
          "aco_bala", "*¡Has logrado fabricar una bala de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una bala de Platino...",
          "platino_bala", "*¡Has logrado fabricar una bala de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una bala de Arandur...",
          "ar_bala", "*¡Has logrado fabricar una bala de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una bala de metal vivo...",
          "me_bala", "*¡Has logrado fabricar una bala de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una bala de hierro enardecido...",
          "meteo_bala", "*¡Has logrado fabricar una bala de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // VIROTES
  else if(sTagMolde == "molde_virote")
  {
      // RECETA UNICA: Virotes asesinos
      if(iLingotesMithril == 1 && iArenillaDiamante == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando virotes asesinos...",
          "receta_vasesinos", "*¡Has logrado fabricar 99 virotes asesinos!*",
          425, 700, "contenedor_yunque3");
          return;
      }
      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // SHURIKENS
  else if(sTagMolde == "molde_shuriken")
  {
      // Shurikens de hierro (1)
      if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando shurikens de hierro...",
          "hr_shuriken", "*¡Has logrado fabricar 50 shurikens de hierro!*",
          137, 30);
      }

      // Shurikens de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando shurikens de cobre...",
          "co_shuriken", "*¡Has logrado fabricar 50 shurikens de cobre!*",
          80, 50);
      }

      // Shurikens de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando shurikens de acero...",
          "ac_shuriken", "*¡Has logrado fabricar 50 shurikens de acero!*",
          195, 80);
      }

      // Shurikens de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando shurikens de plata...",
          "pl_shuriken", "*¡Has logrado fabricar 50 shurikens de plata!*",
          252, 130);
      }

      // Shurikens de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando shurikens de hierrofrío...",
          "hf_shuriken", "*¡Has logrado fabricar 50 shurikens de hierrofrío!*",
          310, 210);
      }

      // Shurikens de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando shurikens de oro...",
          "or_shuriken", "*¡Has logrado fabricar 50 shurikens de oro!*",
          367, 340);
      }

      // Shurikens de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando shurikens de mithril...",
          "mi_shuriken", "*¡Has logrado fabricar 50 shurikens de mithril!*",
          425, 650);
      }

      // Shurikens de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando shurikens de adamantita...",
          "ad_shuriken", "*¡Has logrado fabricar 50 shurikens de adamantita!*",
          482, 1000);
      }

      else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 shurikens de dlarun...",
          "dl_shurikens", "*¡Has logrado fabricar 50 shurikens de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 shurikens de Hizagkuur...",
          "hi_shurikens", "*¡Has logrado fabricar 50 shurikens de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 shurikens de Aceroscuro...",
          "aco_shurikens", "*¡Has logrado fabricar 50 shurikens de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 shurikens de Platino...",
          "platino_shurikens", "*¡Has logrado fabricar 50 shurikens de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 shurikens de Arandur...",
          "ar_shurikens", "*¡Has logrado fabricar 50 shurikens de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }
      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 shurikens de metal vivo...",
          "me_shurikens", "*¡Has logrado fabricar 50 shurikens de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }
      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 shurikens de hierro enardecido...",
          "meteo_shurikens", "*¡Has logrado fabricar 50 shurikens de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // HACHAS ARROJADIZAS
  else if(sTagMolde == "molde_axaarroja")
  {
      // Hachas arrojadizas de hierro (1)
      if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de hierro...",
          "hr_hachaar", "*¡Has logrado fabricar 50 hachas arrojadizas de hierro!*",
          137, 30);
      }

      // Hachas arrojadizas de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de cobre...",
          "co_hachaar", "*¡Has logrado fabricar 50 hachas arrojadizas de cobre!*",
          80, 50);
      }

      // Hachas arrojadizas de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de acero...",
          "ac_hachaar", "*¡Has logrado fabricar 50 hachas arrojadizas de acero!*",
          195, 80);
      }

      // Hachas arrojadizas de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de plata...",
          "pl_hachaar", "*¡Has logrado fabricar 50 hachas arrojadizas de plata!*",
          252, 130);
      }

      // Hachas arrojadizas de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de hierrofrío...",
          "hf_hachaar", "*¡Has logrado fabricar 50 hachas arrojadizas de hierrofrío!*",
          310, 210);
      }

      // Hachas arrojadizas de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de oro...",
          "or_hachaar", "*¡Has logrado fabricar 50 hachas arrojadizas de oro!*",
          367, 340);
      }

      // Hachas arrojadizas de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de mithril...",
          "mi_hachaar", "*¡Has logrado fabricar 50 hachas arrojadizas de mithril!*",
          425, 650);
      }

      // Hachas arrojadizas de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de adamantita...",
          "ad_hachaar", "*¡Has logrado fabricar 50 hachas arrojadizas de adamantita!*",
          482, 1000);
      }

      else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de dlarun...",
          "dl_hachaar", "*¡Has logrado fabricar hachas arrojadizas de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de Hizagkuur...",
          "hi_hachaar", "*¡Has logrado fabricar hachas arrojadizas de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de Aceroscuro...",
          "aco_hachaar", "*¡Has logrado fabricar hachas arrojadizas de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de Platino...",
          "platino_hachaar", "*¡Has logrado fabricar hachas arrojadizas de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de Arandur...",
          "ar_hachaar", "*¡Has logrado fabricar hachas arrojadizas de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }
      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de metal vivo...",
          "me_hachaar", "*¡Has logrado fabricar hachas arrojadizas de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }
      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando hachas arrojadizas de hierro enardecido...",
          "meteo_hachaar", "*¡Has logrado fabricar hachas arrojadizas de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // DARDOS
  else if(sTagMolde == "molde_dardo")
  {
      // RECETA UNICA: Dardos helados
      if(iLingotesHierrofrio == 1 && iArenillaTopacio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando dardos helados...",
          "receta_dhelados", "*¡Has logrado fabricar 50 dardos helados!*",
          425, 700, "contenedor_yunque3");
          return;
      }

      // Dardos de hierro (1)
      else if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando dardos de hierro...",
          "hr_dardo", "*¡Has logrado fabricar 50 dardos de hierro!*",
          137, 30);
      }

      // Dardos de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando dardos de cobre...",
          "co_dardo", "*¡Has logrado fabricar 50 dardos de cobre!*",
          80, 50);
      }

      // Dardos de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando dardos de acero...",
          "ac_dardo", "*¡Has logrado fabricar 50 dardos de acero!*",
          195, 80);
      }

      // Dardos de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando dardos de plata...",
          "pl_dardo", "*¡Has logrado fabricar 50 dardos de plata!*",
          252, 130);
      }

      // Dardos de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando dardos de hierrofrío...",
          "hf_dardo", "*¡Has logrado fabricar 50 dardos de hierrofrío!*",
          310, 210);
      }

      // Dardos de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando dardos de oro...",
          "or_dardo", "*¡Has logrado fabricar 50 dardos de oro!*",
          367, 340);
      }

      // Dardos de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando dardos de mithril...",
          "mi_dardo", "*¡Has logrado fabricar 50 dardos de mithril!*",
          425, 650);
      }

      // Dardos de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando dardos de adamantita...",
          "ad_dardo", "*¡Has logrado fabricar 50 dardos de adamantita!*",
          482, 1000);
      }

      else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 dardos de dlarun...",
          "dl_dardos", "*¡Has logrado fabricar 50 dardos de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 dardos de Hizagkuur...",
          "hi_dardos", "*¡Has logrado fabricar 50 dardos de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 dardos de Aceroscuro...",
          "aco_dardos", "*¡Has logrado fabricar 50 dardos de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 dardos de Platino...",
          "platino_dardos", "*¡Has logrado fabricar 50 dardos de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 dardos de Arandur...",
          "ar_dardos", "*¡Has logrado fabricar 50 dardos de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }
      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 dardos de metal vivo...",
          "me_dardos", "*¡Has logrado fabricar 50 dardos de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }
      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando 50 dardos de hierro enardecido...",
          "meteo_dardos", "*¡Has logrado fabricar 50 dardos de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }


      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // YELMOS/CAPACETES
  else if(sTagMolde == "molde_yelmo")
  {
      // RECETA UNICA: Capacete alado
      if(iLingotesHierro == 3 && iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un capacete alado...",
          "capacetealado", "*¡Has logrado fabricar un capacete alado!*",
          270, 350, "contenedor_yunque3");
      }

      // RECETA UNICA: Casco de los Shun
      else if(iLingotesPlata   == 1 &&
         iLingotesMithril == 1 &&
         iCristalAzabacheTallado == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un Casco de los Shun...",
          "receta_yshun", "*¡Has logrado fabricar un Casco de los Shun!*",
          425, 700, "contenedor_yunque3");
          return;
      }

      // Capacete de hierro (1)
      else if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un capacete de hierro...",
          "hr_yelmo", "*¡Has logrado fabricar un capacete de hierro!*",
          149, 60);
      }

      // Capacete de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un capacete de cobre...",
          "co_yelmo", "*¡Has logrado fabricar un capacete de cobre!*",
          91, 100);
      }

      // Capacete de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un capacete de acero...",
          "ac_yelmo", "*¡Has logrado fabricar un capacete de acero!*",
          206, 160);
      }

      // Capacete de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un capacete de plata...",
          "pl_yelmo", "*¡Has logrado fabricar un capacete de plata!*",
          264, 260);
      }

      // Capacete de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un capacete de hierrofrío...",
          "hf_yelmo", "*¡Has logrado fabricar un capacete de hierrofrío!*",
          321, 420);
      }

      // Capacete de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un capacete de oro...",
          "or_yelmo", "*¡Has logrado fabricar un capacete de oro!*",
          379, 680);
      }

      // Capacete de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un capacete de mithril...",
          "mi_yelmo", "*¡Has logrado fabricar un capacete de mithril!*",
          436, 1300);
      }

      // Capacete de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un capacete de adamantita...",
          "ad_yelmo", "*¡Has logrado fabricar un capacete de adamantita!*",
          494, 2000);
      }

      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un yelmo de dlarun...",
          "dl_yelmo", "*¡Has logrado fabricar un yelmo de dlarun!*",
          160, 3000);
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un yelmo de Hizagkuur...",
          "hi_yelmo", "*¡Has logrado fabricar un yelmo de Hizagkuur!*",
          200, 3000);
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un yelmo de Aceroscuro...",
          "aco_yelmo", "*¡Has logrado fabricar un yelmo de Aceroscuro!*",
          505, 3000);
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un yelmo de Platino...",
          "platino_yelmo", "*¡Has logrado fabricar un yelmo de Platino!*",
          360, 3000);
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un yelmo de Arandur...",
          "ar_yelmo", "*¡Has logrado fabricar un yelmo de Arandur!*",
          505, 3000);
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un yelmo de metal vivo...",
          "me_yelmo", "*¡Has logrado fabricar un yelmo de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un yelmo de hierro enardecido...",
          "meteo_yelmo", "*¡Has logrado fabricar un yelmo de hierro enardecido!*",
          320, 3000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // ARMADURAS COMPLETAS
  else if(sTagMolde == "molde_armorcompl")
  {
      // Armadura completa de hierro (1)
      if(iLingotesHierro == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de hierro...",
          "hr_armorc", "*¡Has logrado fabricar una armadura completa de hierro!*",
          126, 150);
      }

      // Armadura completa de cobre (2)
      else if(iLingotesCobre == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de cobre...",
          "co_armorc", "*¡Has logrado fabricar una armadura completa de cobre!*",
          183, 250);
      }

      // Armadura completa de acero (3)
      else if(iLingotesAcero == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de acero...",
          "ac_armorc", "*¡Has logrado fabricar una armadura completa de acero!*",
          241, 400);
      }

      // Armadura completa de plata (4)
      else if(iLingotesPlata == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de plata...",
          "pl_armorc", "*¡Has logrado fabricar una armadura completa de plata!*",
          298, 650);
      }

      // Armadura completa de hierrofrio (5)
      else if(iLingotesHierrofrio == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de hierrofrío...",
          "hf_armorc", "*¡Has logrado fabricar una armadura completa de hierrofrío!*",
          356, 1060);
      }

      // Armadura completa de oro (6)
      else if(iLingotesOro == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de oro...",
          "or_armorc", "*¡Has logrado fabricar una armadura completa de oro!*",
          414, 1700);
      }

      // Armadura completa de mithril (7)
      else if(iLingotesMithril == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de mithril...",
          "mi_armorc", "*¡Has logrado fabricar una armadura completa de mithril!*",
          471, 5200);
      }

      // Armadura completa de adamantita (8)
      else if(iLingotesAdamantita == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de adamantita...",
          "ad_armorc", "*¡Has logrado fabricar una armadura completa de adamantita!*",
          528, 10000);
      }

        else if(iLingotesDlarun == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de dlarun...",
          "dl_armorc", "*¡Has logrado fabricar una armadura completa de dlarun!*",
          160, 3000);
      }

      else if(iLingotesHizagkuur == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de Hizagkuur...",
          "hi_armorc", "*¡Has logrado fabricar una armadura completa de Hizagkuur!*",
          200, 3000);
      }

      else if(iLingotesAceroscuro == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de Aceroscuro...",
          "aco_armorc", "*¡Has logrado fabricar una armadura completa de Aceroscuro!*",
          505, 3000);
      }

      else if(iLingotesPlatino == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de Platino...",
          "platino_armorc", "*¡Has logrado fabricar una armadura completa de Platino!*",
          360, 3000);
      }

      else if(iLingotesArandur == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de Arandur...",
          "ar_armorc", "*¡Has logrado fabricar una armadura completa de Arandur!*",
          505, 3000);
      }

      else if(iLingotesMetalvivo == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de metal vivo...",
          "me_armorc", "*¡Has logrado fabricar una armadura completa de metal vivo!*",
          505, 3000);
      }

      else if(iLingotesDerretido == 5)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una armadura completa de hierro enardecido...",
          "meteo_armorc", "*¡Has logrado fabricar una armadura completa de hierro enardecido!*",
          320, 3000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // COTAS DE ESCAMAS
  else if(sTagMolde == "molde_armorcotae")
  {
      // Cota de escamas de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de hierro...",
          "hr_cotaesc", "*¡Has logrado fabricar una cota de escamas de hierro!*",
          103, 90);
      }

      // Cota de escamas de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de cobre...",
          "co_cotaesc", "*¡Has logrado fabricar una cota de escamas de cobre!*",
          160, 150);
      }

      // Cota de escamas de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de acero...",
          "ac_cotaesc", "*¡Has logrado fabricar una cota de escamas de acero!*",
          218, 240);
      }

      // Cota de escamas de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de plata...",
          "pl_cotaesc", "*¡Has logrado fabricar una cota de escamas de plata!*",
          275, 390);
      }

      // Cota de escamas de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de hierrofrío...",
          "hf_cotaesc", "*¡Has logrado fabricar una cota de escamas de hierrofrío!*",
          333, 630);
      }

      // Cota de escamas de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de oro...",
          "or_cotaesc", "*¡Has logrado fabricar una cota de escamas de oro!*",
          390, 1020);
      }

      // Cota de escamas de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de mithril...",
          "mi_cotaesc", "*¡Has logrado fabricar una cota de escamas de mithril!*",
          448, 3250);
      }

      // Cota de escamas de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de adamantita...",
          "ad_cotaesc", "*¡Has logrado fabricar una cota de escamas de adamantita!*",
          505, 6000);
      }

       else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de dlarun...",
          "dl_cotaesc", "*¡Has logrado fabricar una cota de escamas de dlarun!*",
          160, 3000);
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de Hizagkuur...",
          "hi_cotaesc", "*¡Has logrado fabricar una cota de escamas de Hizagkuur!*",
          200, 3000);
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de Aceroscuro...",
          "aco_cotaesc", "*¡Has logrado fabricar una cota de escamas de Aceroscuro!*",
          505, 3000);
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de Platino...",
          "platino_cotaesc", "*¡Has logrado fabricar una cota de escamas de Platino!*",
          360, 3000);
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de Arandur...",
          "ar_coraza", "*¡Has logrado fabricar una cota de escamas de Arandur!*",
          505, 3000);
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de metal vivo...",
          "me_coraza", "*¡Has logrado fabricar una cota de escamas de metal vivo!*",
          505, 3000);
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de escamas de hierro enardecido...",
          "meteo_coraza", "*¡Has logrado fabricar una cota de escamas de hierro enardecido!*",
          320, 3000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // COTAS DE MALLAS
  else if(sTagMolde == "molde_armorcotam")
  {
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de hierro...",
          "hr_cotamall", "*¡Has logrado fabricar una cota de mallas de hierro!*",
          103, 90);
      }

      // Cota de mallas de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de cobre...",
          "co_cotamall", "*¡Has logrado fabricar una cota de mallas de cobre!*",
          160, 150);
      }

      // Cota de mallas de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de acero...",
          "ac_cotamall", "*¡Has logrado fabricar una cota de mallas de acero!*",
          218, 240);
      }

      // Cota de mallas de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de plata...",
          "pl_cotamall", "*¡Has logrado fabricar una cota de mallas de plata!*",
          275, 390);
      }

      // Cota de mallas de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de hierrofrío...",
          "hf_cotamall", "*¡Has logrado fabricar una cota de mallas de hierrofrío!*",
          333, 630);
      }

      // Cota de mallas de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de oro...",
          "or_cotamall", "*¡Has logrado fabricar una cota de mallas de oro!*",
          390, 1020);
      }

      // Cota de mallas de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de mithril...",
          "mi_cotamall", "*¡Has logrado fabricar una cota de mallas de mithril!*",
          448, 3250);
      }

      // Cota de mallas de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de adamantita...",
          "ad_cotamall", "*¡Has logrado fabricar una cota de mallas de adamantita!*",
          505, 6000);
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de dlarun...",
          "dl_cotamall", "*¡Has logrado fabricar una cota de mallas de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de Hizagkuur...",
          "hi_cotamall", "*¡Has logrado fabricar una cota de mallas de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de Aceroscuro...",
          "aco_cotamall", "*¡Has logrado fabricar una cota de mallas de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de Platino...",
          "platino_cotamall", "*¡Has logrado fabricar una cota de mallas de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de Arandur...",
          "ar_cotamall", "*¡Has logrado fabricar una cota de mallas de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de metal vivo...",
          "me_cotamall", "*¡Has logrado fabricar una cota de mallas de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cota de mallas de hierro enardecido...",
          "meteo_cotamall", "*¡Has logrado fabricar una cota de mallas de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // CIMITARRAS
  else if(sTagMolde == "molde_cimitarra")
  {
      // Cimitarra de hierro (1)
      if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de hierro...",
          "hr_cimitarra", "*¡Has logrado fabricar una cimitarra de hierro!*",
          149, 60, "contenedor_yunque2");
      }

      // Cimitarra de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de cobre...",
          "co_cimitarra", "*¡Has logrado fabricar una cimitarra de cobre!*",
          91, 100, "contenedor_yunque2");
      }

      // Cimitarra de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de acero...",
          "ac_cimitarra", "*¡Has logrado fabricar una cimitarra de acero!*",
          206, 160, "contenedor_yunque2");
      }

      // Cimitarra de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de plata...",
          "pl_cimitarra", "*¡Has logrado fabricar una cimitarra de plata!*",
          264, 260, "contenedor_yunque2");
      }

      // Cimitarra de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de hierrofrío...",
          "hf_cimitarra", "*¡Has logrado fabricar una cimitarra de hierrofrío!*",
          321, 420, "contenedor_yunque2");
      }

      // Cimitarra de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de oro...",
          "or_cimitarra", "*¡Has logrado fabricar una cimitarra de oro!*",
          379, 680, "contenedor_yunque2");
      }

      // Cimitarra de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de mithril...",
          "mi_cimitarra", "*¡Has logrado fabricar una cimitarra de mithril!*",
          436, 1950, "contenedor_yunque2");
      }

      // Cimitarra de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de adamantita...",
          "ad_cimitarra", "*¡Has logrado fabricar una cimitarra de adamantita!*",
          494, 4000, "contenedor_yunque2");
      }

      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de dlarun...",
          "dl_cimitarra", "*¡Has logrado fabricar una cimitarra de dlarun!*",
          160, 3000, "contenedor_yunque2");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de Hizagkuur...",
          "hi_cimitarra", "*¡Has logrado fabricar una cimitarra de Hizagkuur!*",
          200, 3000, "contenedor_yunque2");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de Aceroscuro...",
          "aco_cimitarra", "*¡Has logrado fabricar una cimitarra de Aceroscuro!*",
          505, 3000, "contenedor_yunque2");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de Platino...",
          "platino_cimitarra", "*¡Has logrado fabricar una cimitarra de Platino!*",
          360, 3000, "contenedor_yunque2");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de Arandur...",
          "ar_cimitarra", "*¡Has logrado fabricar una cimitarra de Arandur!*",
          505, 3000, "contenedor_yunque2");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de metal vivo...",
          "me_cimitarra", "*¡Has logrado fabricar una cimitarra de metal vivo!*",
          505, 3000, "contenedor_yunque2");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una cimitarra de hierro enardecido...",
          "meteo_cimitarra", "*¡Has logrado fabricar una cimitarra de hierro enardecido!*",
          320, 3000, "contenedor_yunque2");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // ESPADA CORTA
  else if(sTagMolde == "molde_espcorta")
  {
      // Espada corta de hierro (1)
      if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de hierro...",
          "hr_espadac", "*¡Has logrado fabricar una espada corta de hierro!*",
          137, 30);
      }

      // Espada corta de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de cobre...",
          "co_espadac", "*¡Has logrado fabricar una espada corta de cobre!*",
          80, 50);
      }

      // Espada corta de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de acero...",
          "ac_espadac", "*¡Has logrado fabricar una espada corta de acero!*",
          195, 80);
      }

      // Espada corta de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de plata...",
          "pl_espadac", "*¡Has logrado fabricar una espada corta de plata!*",
          252, 130);
      }

      // Espada corta de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de hierrofrío...",
          "hf_espadac", "*¡Has logrado fabricar una espada corta de hierrofrío!*",
          310, 210);
      }

      // Espada corta de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de oro...",
          "or_espadac", "*¡Has logrado fabricar una espada corta de oro!*",
          367, 340);
      }

      // Espada corta de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de mithril...",
          "mi_espadac", "*¡Has logrado fabricar una espada corta de mithril!*",
          425, 1300);
      }

      // Espada corta de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de adamantita...",
          "ad_espadac", "*¡Has logrado fabricar una espada corta de adamantita!*",
          482, 2000);
      }

      else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de dlarun...",
          "dl_espadac", "*¡Has logrado fabricar una espada corta de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de Hizagkuur...",
          "hi_espadac", "*¡Has logrado fabricar una espada corta de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de Aceroscuro...",
          "aco_espadac", "*¡Has logrado fabricar una espada corta de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de Platino...",
          "platino_espadac", "*¡Has logrado fabricar una espada corta de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de Arandur...",
          "ar_espadac", "*¡Has logrado fabricar una espada corta de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de metal vivo...",
          "me_espadac", "*¡Has logrado fabricar una espada corta de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada corta de hierro enardecido...",
          "meteo_espadac", "*¡Has logrado fabricar una espada corta de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }



      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // ESPADA LARGA
  else if(sTagMolde == "molde_esplarga")
  {
      // RECETA UNICA: Espada dorada
      if(iLingotesAcero == 3 && iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada dorada...",
          "espadadorada", "*¡Has logrado fabricar una espada dorada!*",
          400, 920, "contenedor_yunque3");
      }

      // Espada larga de hierro (1)
      else if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de hierro...",
          "hr_espadal", "*¡Has logrado fabricar una espada larga de hierro!*",
          149, 60, "contenedor_yunque2");
      }

      // Espada larga de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de cobre...",
          "co_espadal", "*¡Has logrado fabricar una espada larga de cobre!*",
          91, 100, "contenedor_yunque2");
      }

      // Espada larga de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de acero...",
          "ac_espadal", "*¡Has logrado fabricar una espada larga de acero!*",
          206, 160, "contenedor_yunque2");
      }

      // Espada larga de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de plata...",
          "pl_espadal", "*¡Has logrado fabricar una espada larga de plata!*",
          264, 260, "contenedor_yunque2");
      }

      // Espada larga de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de hierrofrío...",
          "hf_espadal", "*¡Has logrado fabricar una espada larga de hierrofrío!*",
          321, 420, "contenedor_yunque2");
      }

      // Espada larga de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de oro...",
          "or_espadal", "*¡Has logrado fabricar una espada larga de oro!*",
          379, 680, "contenedor_yunque2");
      }

      // Espada larga de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de mithril...",
          "mi_espadal", "*¡Has logrado fabricar una espada larga de mithril!*",
          436, 1950, "contenedor_yunque2");
      }

      // Espada larga de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de adamantita...",
          "ad_espadal", "*¡Has logrado fabricar una espada larga de adamantita!*",
          494, 4000, "contenedor_yunque2");
      }

        else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de dlarun...",
          "dl_espadal", "*¡Has logrado fabricar una espada larga de dlarun!*",
          160, 3000, "contenedor_yunque5");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de Hizagkuur...",
          "hi_espadal", "*¡Has logrado fabricar una espada larga de Hizagkuur!*",
          200, 3000, "contenedor_yunque5");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de Aceroscuro...",
          "aco_espadal", "*¡Has logrado fabricar una espada larga de Aceroscuro!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de Platino...",
          "platino_espadal", "*¡Has logrado fabricar una espada larga de Platino!*",
          360, 3000, "contenedor_yunque5");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de Arandur...",
          "ar_espadal", "*¡Has logrado fabricar una espada larga de Arandur!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de metal vivo...",
          "me_espadal", "*¡Has logrado fabricar una espada larga de metal vivo!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada larga de hierro enardecido...",
          "meteo_espadal", "*¡Has logrado fabricar una espada larga de hierro enardecido!*",
          320, 3000, "contenedor_yunque5");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // ESPADA BASTARDA
  else if(sTagMolde == "molde_espbastard")
  {
      // RECETA UNICA: Matadragones
      if(iEstatuillaDragon == 1 && iLingotesAcero == 5 &&
              iCristalCuarzo == 5 && iHumoGaseoso == 8 && iSangreDragon == 10)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando la Matadragones...",
          "matadragones", "*¡Has logrado fabricar la Matadragones!*",
          460, 10000, "contenedor_yunque3");
      }

      // Espada bastarda de hierro (1)
      else if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de hierro...",
          "hr_espadab", "*¡Has logrado fabricar una espada bastarda de hierro!*",
          149, 60, "contenedor_yunque5");
      }

      // Espada bastarda de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de cobre...",
          "co_espadab", "*¡Has logrado fabricar una espada bastarda de cobre!*",
          91, 100, "contenedor_yunque2");
      }

      // Espada bastarda de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de acero...",
          "ac_espadab", "*¡Has logrado fabricar una espada bastarda de acero!*",
          206, 160, "contenedor_yunque2");
      }

      // Espada bastarda de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de plata...",
          "pl_espadab", "*¡Has logrado fabricar una espada bastarda de plata!*",
          264, 260, "contenedor_yunque2");
      }

      // Espada bastarda de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de hierrofrío...",
          "hf_espadab", "*¡Has logrado fabricar una espada bastarda de hierrofrío!*",
          321, 420, "contenedor_yunque2");
      }

      // Espada bastarda de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una bastarda larga de oro...",
          "or_espadab", "*¡Has logrado fabricar una bastarda larga de oro!*",
          379, 680, "contenedor_yunque2");
      }

      // Espada bastarda de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de mithril...",
          "mi_espadab", "*¡Has logrado fabricar una espada bastarda de mithril!*",
          436, 1950, "contenedor_yunque2");
      }

      // Espada bastarda de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de adamantita...",
          "ad_espadab", "*¡Has logrado fabricar una espada bastarda de adamantita!*",
          494, 4000, "contenedor_yunque2");
      }

      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de dlarun...",
          "dl_espadab", "*¡Has logrado fabricar una espada bastarda de dlarun!*",
          160, 3000, "contenedor_yunque5");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de Hizagkuur...",
          "hi_espadab", "*¡Has logrado fabricar una espada bastarda de Hizagkuur!*",
          200, 3000, "contenedor_yunque5");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de Aceroscuro...",
          "aco_espadab", "*¡Has logrado fabricar una espada bastarda de Aceroscuro!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de Platino...",
          "platino_espadab", "*¡Has logrado fabricar una espada bastarda de Platino!*",
          360, 3000, "contenedor_yunque5");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de Arandur...",
          "ar_espadab", "*¡Has logrado fabricar una espada bastarda de Arandur!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de metal vivo...",
          "me_espadab", "*¡Has logrado fabricar una espada bastarda de metal vivo!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada bastarda de hierro enardecido...",
          "meteo_espadab", "*¡Has logrado fabricar una espada bastarda de hierro enardecido!*",
          320, 3000, "contenedor_yunque5");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // ESTOQUE
  else if(sTagMolde == "molde_estoque")
  {
      // Estoque de hierro (1)
      if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de hierro...",
          "hr_estoque", "*¡Has logrado fabricar un estoque de hierro!*",
          149, 60, "contenedor_yunque2");
      }

      // Estoque de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de cobre...",
          "co_estoque", "*¡Has logrado fabricar un estoque de cobre!*",
          91, 100, "contenedor_yunque2");
      }

      // Estoque de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de acero...",
          "ac_estoque", "*¡Has logrado fabricar un estoque de acero!*",
          206, 160, "contenedor_yunque2");
      }

      // Estoque de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de plata...",
          "pl_estoque", "*¡Has logrado fabricar un estoque de plata!*",
          264, 260, "contenedor_yunque2");
      }

      // Estoque de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de hierrofrío...",
          "hf_estoque", "*¡Has logrado fabricar un estoque de hierrofrío!*",
          321, 420, "contenedor_yunque2");
      }

      // Estoque de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de oro...",
          "or_estoque", "*¡Has logrado fabricar un estoque de oro!*",
          379, 680, "contenedor_yunque2");
      }

      // Estoque de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de mithril...",
          "mi_estoque", "*¡Has logrado fabricar un estoque de mithril!*",
          436, 1950, "contenedor_yunque2");
      }

      // Estoque de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de adamantita...",
          "ad_estoque", "*¡Has logrado fabricar un estoque de adamantita!*",
          494, 4000, "contenedor_yunque2");
      }

      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de dlarun...",
          "dl_estoque", "*¡Has logrado fabricar un estoque de dlarun!*",
          160, 3000, "contenedor_yunque2");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de Hizagkuur...",
          "hi_estoque", "*¡Has logrado fabricar un estoque de Hizagkuur!*",
          200, 3000, "contenedor_yunque2");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de Aceroscuro...",
          "aco_estoque", "*¡Has logrado fabricar un estoque de Aceroscuro!*",
          505, 3000, "contenedor_yunque2");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de Platino...",
          "platino_estoque", "*¡Has logrado fabricar un estoque de Platino!*",
          360, 3000, "contenedor_yunque2");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de Arandur...",
          "ar_estoque", "*¡Has logrado fabricar un estoque de Arandur!*",
          505, 3000, "contenedor_yunque2");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de metal vivo...",
          "me_estoque", "*¡Has logrado fabricar un estoque de metal vivo!*",
          505, 3000, "contenedor_yunque2");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un estoque de hierro enardecido...",
          "meteo_estoque", "*¡Has logrado fabricar un estoque de hierro enardecido!*",
          320, 3000, "contenedor_yunque2");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // HOZ
  else if(sTagMolde == "molde_hoz")
  {
      // Hoz de hierro (1)
      if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de hierro...",
          "hr_hoz", "*¡Has logrado fabricar una hoz de hierro!*",
          137, 30);
      }

      // Hoz de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de cobre...",
          "co_hoz", "*¡Has logrado fabricar una hoz de cobre!*",
          80, 50);
      }

      // Hoz de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de acero...",
          "ac_hoz", "*¡Has logrado fabricar una hoz de acero!*",
          195, 80);
      }

      // Hoz de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de plata...",
          "pl_hoz", "*¡Has logrado fabricar una hoz de plata!*",
          252, 130);
      }

      // Hoz de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de hierrofrío...",
          "hf_hoz", "*¡Has logrado fabricar una hoz de hierrofrío!*",
          310, 210);
      }

      // Hoz de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de oro...",
          "or_hoz", "*¡Has logrado fabricar una hoz de oro!*",
          367, 340);
      }

      // Hoz de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de mithril...",
          "mi_hoz", "*¡Has logrado fabricar una hoz de mithril!*",
          425, 1300);
      }

      // Hoz de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de adamantita...",
          "ad_hoz", "*¡Has logrado fabricar una hoz de adamantita!*",
          482, 2000);
      }

          else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de dlarun...",
          "dl_hoz", "*¡Has logrado fabricar una hoz de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de Hizagkuur...",
          "hi_hoz", "*¡Has logrado fabricar una hoz de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de Aceroscuro...",
          "aco_hoz", "*¡Has logrado fabricar una hoz de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de Platino...",
          "platino_hoz", "*¡Has logrado fabricar una hoz de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de Arandur...",
          "ar_hoz", "*¡Has logrado fabricar una hoz de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de metal vivo...",
          "me_hoz", "*¡Has logrado fabricar una hoz de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de hierro enardecido...",
          "meteo_hoz", "*¡Has logrado fabricar una hoz de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // KATANA
  else if(sTagMolde == "molde_katana")
  {
      // Katana de hierro (1)
      if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de hierro...",
          "hr_katana", "*¡Has logrado fabricar una katana de hierro!*",
          149, 60, "contenedor_yunque3");
      }

      // Katana de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de cobre...",
          "co_katana", "*¡Has logrado fabricar una katana de cobre!*",
          91, 100, "contenedor_yunque3");
      }

      // Katana de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de acero...",
          "ac_katana", "*¡Has logrado fabricar una katana de acero!*",
          206, 160, "contenedor_yunque3");
      }

      // Katana de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de plata...",
          "pl_katana", "*¡Has logrado fabricar una katana de plata!*",
          264, 260, "contenedor_yunque3");
      }

      // Katana de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de hierrofrío...",
          "hf_katana", "*¡Has logrado fabricar una katana de hierrofrío!*",
          321, 420, "contenedor_yunque3");
      }

      // Katana de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de oro...",
          "or_katana", "*¡Has logrado fabricar una katana de oro!*",
          379, 680, "contenedor_yunque3");
      }

      // Katana de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de mithril...",
          "mi_katana", "*¡Has logrado fabricar una katana de mithril!*",
          436, 1950, "contenedor_yunque3");
      }

      // Katana de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de adamantita...",
          "ad_katana", "*¡Has logrado fabricar una katana de adamantita!*",
          494, 4000, "contenedor_yunque3");
      }

          else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de dlarun...",
          "dl_katana", "*¡Has logrado fabricar una katana de dlarun!*",
          160, 3000, "contenedor_yunque3");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de Hizagkuur...",
          "hi_katana", "*¡Has logrado fabricar una katana de Hizagkuur!*",
          200, 3000, "contenedor_yunque3");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de Aceroscuro...",
          "aco_katana", "*¡Has logrado fabricar una katana de Aceroscuro!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de Platino...",
          "platino_katana", "*¡Has logrado fabricar una katana de Platino!*",
          360, 3000, "contenedor_yunque3");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de Arandur...",
          "ar_katana", "*¡Has logrado fabricar una katana de Arandur!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de metal vivo...",
          "me_katana", "*¡Has logrado fabricar una katana de metal vivo!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una katana de hierro enardecido...",
          "meteo_katana", "*¡Has logrado fabricar una katana de hierro enardecido!*",
          320, 3000, "contenedor_yunque3");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // MARTILLO DE GUERRA
  else if(sTagMolde == "molde_martguerra")
  {
      // Martillo de guerra de hierro (1)
      if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de hierro...",
          "hr_martig", "*¡Has logrado fabricar un martillo de guerra de hierro!*",
          149, 60, "contenedor_yunque3");
      }

      // Martillo de guerra de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de cobre...",
          "co_martig", "*¡Has logrado fabricar un martillo de guerra de cobre!*",
          91, 100, "contenedor_yunque3");
      }

      // Martillo de guerra de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de acero...",
          "ac_martig", "*¡Has logrado fabricar un martillo de guerra de acero!*",
          206, 160, "contenedor_yunque3");
      }

      // Martillo de guerra de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de plata...",
          "pl_martig", "*¡Has logrado fabricar un martillo de guerra de plata!*",
          264, 260, "contenedor_yunque3");
      }

      // Martillo de guerra de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de hierrofrío...",
          "hf_martig", "*¡Has logrado fabricar un martillo de guerra de hierrofrío!*",
          321, 420, "contenedor_yunque3");
      }

      // Martillo de guerra de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de oro...",
          "or_martig", "*¡Has logrado fabricar un martillo de guerra de oro!*",
          379, 680, "contenedor_yunque3");
      }

      // Martillo de guerra de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de mithril...",
          "mi_martig", "*¡Has logrado fabricar un martillo de guerra de mithril!*",
          436, 1950, "contenedor_yunque3");
      }

      // Martillo de guerra de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de adamantita...",
          "ad_martig", "*¡Has logrado fabricar un martillo de guerra de adamantita!*",
          494, 4000, "contenedor_yunque3");
      }


      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de dlarun...",
          "dl_martig", "*¡Has logrado fabricar un martillo de guerra de dlarun!*",
          160, 3000, "contenedor_yunque3");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de Hizagkuur...",
          "hi_martig", "*¡Has logrado fabricar un martillo de guerra de Hizagkuur!*",
          200, 3000, "contenedor_yunque3");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de Aceroscuro...",
          "aco_martig", "*¡Has logrado fabricar un martillo de guerra de Aceroscuro!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de Platino...",
          "platino_martig", "*¡Has logrado fabricar un martillo de guerra de Platino!*",
          360, 3000, "contenedor_yunque3");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de Arandur...",
          "ar_martig", "*¡Has logrado fabricar un martillo de guerra de Arandur!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de metal vivo...",
          "me_martig", "*¡Has logrado fabricar un martillo de guerra de metal vivo!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo de guerra de hierro enardecido...",
          "meteo_martig", "*¡Has logrado fabricar un martillo de guerra de hierro enardecido!*",
          320, 3000, "contenedor_yunque3");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // MANGUAL LIGERO
  else if(sTagMolde == "molde_manglig")
  {
      // Mangual ligero de hierro (1)
      if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de hierro...",
          "hr_manguall", "*¡Has logrado fabricar un mangual ligero de hierro!*",
          149, 60, "contenedor_yunque3");
      }

      // Mangual ligero de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de cobre...",
          "co_manguall", "*¡Has logrado fabricar un mangual ligero de cobre!*",
          91, 100, "contenedor_yunque3");
      }

      // Mangual ligero de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de acero...",
          "ac_manguall", "*¡Has logrado fabricar un mangual ligero de acero!*",
          206, 160, "contenedor_yunque3");
      }

      // Mangual ligero de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de plata...",
          "pl_manguall", "*¡Has logrado fabricar un mangual ligero de plata!*",
          264, 260, "contenedor_yunque3");
      }

      // Mangual ligero de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de hierrofrío...",
          "hf_manguall", "*¡Has logrado fabricar un mangual ligero de hierrofrío!*",
          321, 420, "contenedor_yunque3");
      }

      // Mangual ligero de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de oro...",
          "or_manguall", "*¡Has logrado fabricar un mangual ligero de oro!*",
          379, 680, "contenedor_yunque3");
      }

      // Mangual ligero de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de mithril...",
          "mi_manguall", "*¡Has logrado fabricar un mangual ligero de mithril!*",
          436, 1950, "contenedor_yunque3");
      }

      // Mangual ligero de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de adamantita...",
          "ad_manguall", "*¡Has logrado fabricar un mangual ligero de adamantita!*",
          494, 4000, "contenedor_yunque3");
      }

      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de dlarun...",
          "dl_manguall", "*¡Has logrado fabricar un mangual ligero de dlarun!*",
          160, 3000, "contenedor_yunque3");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de Hizagkuur...",
          "hi_manguall", "*¡Has logrado fabricar un mangual ligero de Hizagkuur!*",
          200, 3000, "contenedor_yunque3");;
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de Aceroscuro...",
          "aco_manguall", "*¡Has logrado fabricar un mangual ligero de Aceroscuro!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de Platino...",
          "platino_manguall", "*¡Has logrado fabricar un mangual ligero de Platino!*",
          360, 3000, "contenedor_yunque3");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de Arandur...",
          "ar_manguall", "*¡Has logrado fabricar un mangual ligero de Arandur!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de metal vivo...",
          "me_manguall", "*¡Has logrado fabricar un mangual ligero de metal vivo!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual ligero de hierro enardecido...",
          "meteo_manguall", "*¡Has logrado fabricar un mangual ligero de hierro enardecido!*",
          320, 3000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // HACHA DE BATALLA
  else if(sTagMolde == "molde_axabatalla")
  {
      // RECETA UNICA: Hacha de hielo
      if(iLingotesHierro == 1 && iLingotesHierrofrio == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de hielo...",
          "hachadehielo", "*¡Has logrado fabricar un hacha de hielo!*",
          333, 870, "contenedor_yunque3");
          return;
      }

      // RECETA UNICA: Hacha de hielo mayor
      else if(iLingotesHierro == 1 && iLingotesHierrofrio == 6)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de hielo mayor...",
          "hachadehielo2", "*¡Has logrado fabricar un hacha de hielo mayor!*",
          367, 1300, "contenedor_yunque3");
          return;
      }

      // RECETA UNICA: Hacha de fuego
      else if(iLingotesCobre == 1 && iLingotesHierrofrio == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un Hacha de Fuego...",
          "receta_hfuego", "*¡Has logrado fabricar un Hacha de Fielo!*",
          333, 870, "contenedor_yunque3");
          return;
      }

      // RECETA UNICA: Hacha de fuego mayor
      else if(iLingotesCobre == 1 && iLingotesHierrofrio == 6)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un Hacha de Fuego Mayor...",
          "receta_hfuegom", "*¡Has logrado fabricar un Hacha de Fuego Mayor!*",
          367, 1300, "contenedor_yunque3");
          return;
      }

      // Hacha de batalla de hierro (1)
      else if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de hierro...",
          "hr_hachab", "*¡Has logrado fabricar un hacha de batalla de hierro!*",
          149, 60, "contenedor_yunque2");
      }

      // Hacha de batalla de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de cobre...",
          "co_hachab", "*¡Has logrado fabricar un hacha de batalla de cobre!*",
          91, 100, "contenedor_yunque2");
      }

      // Hacha de batalla de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de acero...",
          "ac_hachab", "*¡Has logrado fabricar un hacha de batalla de acero!*",
          206, 160, "contenedor_yunque2");
      }

      // Hacha de batalla de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de plata...",
          "pl_hachab", "*¡Has logrado fabricar un hacha de batalla de plata!*",
          264, 260, "contenedor_yunque2");
      }

      // Hacha de batalla de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de hierrofrío...",
          "hf_hachab", "*¡Has logrado fabricar un hacha de batalla de hierrofrío!*",
          321, 420, "contenedor_yunque2");
      }

      // Hacha de batalla de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de oro...",
          "or_hachab", "*¡Has logrado fabricar un hacha de batalla de oro!*",
          379, 680, "contenedor_yunque2");
      }

      // Hacha de batalla de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de mithril...",
          "mi_hachab", "*¡Has logrado fabricar un hacha de batalla de mithril!*",
          436, 1950, "contenedor_yunque2");
      }

      // Hacha de batalla de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de adamantita...",
          "ad_hachab", "*¡Has logrado fabricar un hacha de batalla de adamantita!*",
          494, 4000, "contenedor_yunque2");
      }

      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de dlarun...",
          "dl_hachab", "*¡Has logrado fabricar un hacha de batalla de dlarun!*",
          160, 3000, "contenedor_yunque5");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de Hizagkuur...",
          "hi_hachab", "*¡Has logrado fabricar un hacha de batalla de Hizagkuur!*",
          200, 3000, "contenedor_yunque5");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de Aceroscuro...",
          "aco_hachab", "*¡Has logrado fabricar un hacha de batalla de Aceroscuro!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de Platino...",
          "platino_hachab", "*¡Has logrado fabricar un hacha de batalla de Platino!*",
          360, 3000, "contenedor_yunque5");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de Arandur...",
          "ar_hachab", "*¡Has logrado fabricar un hacha de batalla de Arandur!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de metal vivo...",
          "me_hachab", "*¡Has logrado fabricar un hacha de batalla de metal vivo!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de batalla de hierro enardecido...",
          "meteo_hachab", "*¡Has logrado fabricar un hacha de batalla de hierro enardecido!*",
          320, 3000, "contenedor_yunque5");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // HACHA DE GUERRA ENANA
  else if(sTagMolde == "molde_axaenana")
  {
      // Hacha de guerra enana de hierro (1)
      if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de hierro...",
          "hr_hachage", "*¡Has logrado fabricar un hacha de guerra enana de hierro!*",
          149, 60, "contenedor_yunque2");
      }

      // Hacha de guerra enana de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de cobre...",
          "co_hachage", "*¡Has logrado fabricar un hacha de guerra enana de cobre!*",
          91, 100, "contenedor_yunque2");
      }

      // Hacha de guerra enana de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de acero...",
          "ac_hachage", "*¡Has logrado fabricar un hacha de guerra enana de acero!*",
          206, 160, "contenedor_yunque2");
      }

      // Hacha de guerra enana de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de plata...",
          "pl_hachage", "*¡Has logrado fabricar un hacha de guerra enana de plata!*",
          264, 260, "contenedor_yunque2");
      }

      // Hacha de guerra enana de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de hierrofrío...",
          "hf_hachage", "*¡Has logrado fabricar un hacha de guerra enana de hierrofrío!*",
          321, 420, "contenedor_yunque2");
      }

      // Hacha de guerra enana de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de oro...",
          "or_hachage", "*¡Has logrado fabricar un hacha de guerra enana de oro!*",
          379, 680, "contenedor_yunque2");
      }

      // Hacha de guerra enana de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de mithril...",
          "mi_hachage", "*¡Has logrado fabricar un hacha de guerra enana de mithril!*",
          436, 1950, "contenedor_yunque2");
      }

      // Hacha de guerra enana de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de adamantita...",
          "ad_hachage", "*¡Has logrado fabricar un hacha de guerra enana de adamantita!*",
          494, 4000, "contenedor_yunque2");
      }


      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de dlarun...",
          "dl_hachage", "*¡Has logrado fabricar un hacha de guerra enana de dlarun!*",
          160, 3000, "contenedor_yunque5");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de Hizagkuur...",
          "hi_hachage", "*¡Has logrado fabricar un hacha de guerra enana de Hizagkuur!*",
          200, 3000, "contenedor_yunque5");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de Aceroscuro...",
          "aco_hachage", "*¡Has logrado fabricar un hacha de guerra enana de Aceroscuro!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de Platino...",
          "platino_hachage", "*¡Has logrado fabricar un hacha de guerra enana de Platino!*",
          360, 3000, "contenedor_yunque5");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de Arandur...",
          "ar_hachage", "*¡Has logrado fabricar un hacha de guerra enana de Arandur!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de metal vivo...",
          "me_hachage", "*¡Has logrado fabricar un hacha de guerra enana de metal vivo!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de guerra enana de hierro enardecido...",
          "meteo_hachage", "*¡Has logrado fabricar un hacha de guerra enana de hierro enardecido!*",
          320, 3000, "contenedor_yunque5");
      }


      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // ESCUDO PEQUEÑO
  else if(sTagMolde == "molde_escudopeq")
  {
      // Escudo pequenyo de hierro (1)
      if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de hierro...",
          "hr_escudopq", "*¡Has logrado fabricar un escudo pequeño de hierro!*",
          149, 60);
      }

      // Escudo pequenyo de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de cobre...",
          "co_escudopq", "*¡Has logrado fabricar un escudo pequeño de cobre!*",
          91, 100);
      }

      // Escudo pequenyo de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de acero...",
          "ac_escudopq", "*¡Has logrado fabricar un escudo pequeño de acero!*",
          206, 160);
      }

      // Escudo pequenyo de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de plata...",
          "pl_escudopq", "*¡Has logrado fabricar un escudo pequeño de plata!*",
          264, 260);
      }

      // Escudo pequenyo de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de hierrofrío...",
          "hf_escudopq", "*¡Has logrado fabricar un escudo pequeño de hierrofrío!*",
          321, 420);
      }

      // Escudo pequenyo de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de oro...",
          "or_escudopq", "*¡Has logrado fabricar un escudo pequeño de oro!*",
          379, 680);
      }

      // Escudo pequenyo de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de mithril...",
          "mi_escudopq", "*¡Has logrado fabricar un escudo pequeño de mithril!*",
          436, 1950);
      }

      // Escudo pequenyo de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de adamantita...",
          "ad_escudopq", "*¡Has logrado fabricar un escudo pequeño de adamantita!*",
          494, 4000);
      }


      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de dlarun...",
          "dl_escudopq", "*¡Has logrado fabricar un escudo pequeño de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de Hizagkuur...",
          "hi_escudopq", "*¡Has logrado fabricar un escudo pequeño de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de Aceroscuro...",
          "aco_escudopq", "*¡Has logrado fabricar un escudo pequeño de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de Platino...",
          "platino_escudopq", "*¡Has logrado fabricar un escudo pequeño de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de Arandur...",
          "ar_escudopq", "*¡Has logrado fabricar un escudo pequeño de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de metal vivo...",
          "me_escudopq", "*¡Has logrado fabricar un escudo pequeño de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pequeño de hierro enardecido...",
          "meteo_escudopq", "*¡Has logrado fabricar un escudo pequeño de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // MAZA DE ARMAS
  else if(sTagMolde == "molde_mazarmas")
  {
      // Maza de armas de hierro (1)
      if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de hierro...",
          "hr_mazaarm", "*¡Has logrado fabricar una maza de armas de hierro!*",
          149, 60);
      }

      // Maza de armas de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de cobre...",
          "co_mazaarm", "*¡Has logrado fabricar una maza de armas de cobre!*",
          91, 100);
      }

      // Maza de armas de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de acero...",
          "ac_mazaarm", "*¡Has logrado fabricar una maza de armas de acero!*",
          206, 160);
      }

      // Maza de armas de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de plata...",
          "pl_mazaarm", "*¡Has logrado fabricar una maza de armas de plata!*",
          264, 260);
      }

      // Maza de armas de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de hierrofrío...",
          "hf_mazaarm", "*¡Has logrado fabricar una maza de armas de hierrofrío!*",
          321, 420);
      }

      // Maza de armas de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de oro...",
          "or_mazaarm", "*¡Has logrado fabricar una maza de armas de oro!*",
          379, 680);
      }

      // Maza de armas de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de mithril...",
          "mi_mazaarm", "*¡Has logrado fabricar una maza de armas de mithril!*",
          436, 1950);
      }

      // Maza de armas de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de adamantita...",
          "ad_mazaarm", "*¡Has logrado fabricar una maza de armas de adamantita!*",
          494, 4000);
      }

      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de dlarun...",
          "dl_mazaarm", "*¡Has logrado fabricar una maza de armas de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de Hizagkuur...",
          "hi_mazaarm", "*¡Has logrado fabricar una maza de armas de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de Aceroscuro...",
          "aco_mazaarm", "*¡Has logrado fabricar una maza de armas de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de Platino...",
          "platino_mazaarm", "*¡Has logrado fabricar una maza de armas de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de Arandur...",
          "ar_mazaarm", "*¡Has logrado fabricar una maza de armas de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de metal vivo...",
          "me_mazaarm", "*¡Has logrado fabricar una maza de armas de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de armas de hierro enardecido...",
          "meteo_mazaarm", "*¡Has logrado fabricar una maza de armas de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // LANZA
  else if(sTagMolde == "molde_lanza")
  {
      // Lanza de hierro (1)
      if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de hierro...",
          "hr_lanza", "*¡Has logrado fabricar una lanza de hierro!*",
          149, 60, "contenedor_yunque3");
      }

      // Lanza de cobre (2)
      else if(iLingotesCobre == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de cobre...",
          "co_lanza", "*¡Has logrado fabricar una lanza de cobre!*",
          91, 100, "contenedor_yunque3");
      }

      // Lanza de acero (3)
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de acero...",
          "ac_lanza", "*¡Has logrado fabricar una lanza de acero!*",
          206, 160, "contenedor_yunque3");
      }

      // Lanza de plata (4)
      else if(iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de plata...",
          "pl_lanza", "*¡Has logrado fabricar una lanza de plata!*",
          264, 260, "contenedor_yunque3");
      }

      // Lanza de hierrofrio (5)
      else if(iLingotesHierrofrio == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de hierrofrío...",
          "hf_lanza", "*¡Has logrado fabricar una lanza de hierrofrío!*",
          321, 420, "contenedor_yunque3");
      }

      // Lanza de oro (6)
      else if(iLingotesOro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de oro...",
          "or_lanza", "*¡Has logrado fabricar una lanza de oro!*",
          379, 680, "contenedor_yunque3");
      }

      // Lanza de mithril (7)
      else if(iLingotesMithril == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de mithril...",
          "mi_lanza", "*¡Has logrado fabricar una lanza de mithril!*",
          436, 1950, "contenedor_yunque3");
      }

      // Lanza de adamantita (8)
      else if(iLingotesAdamantita == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de adamantita...",
          "ad_lanza", "*¡Has logrado fabricar una lanza de adamantita!*",
          494, 4000, "contenedor_yunque3");
      }

      else if(iLingotesDlarun == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de dlarun...",
          "dl_lanza", "*¡Has logrado fabricar una lanza de dlarun!*",
          160, 3000, "contenedor_yunque3");
      }

      else if(iLingotesHizagkuur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de Hizagkuur...",
          "hi_lanza", "*¡Has logrado fabricar una lanza de Hizagkuur!*",
          200, 3000, "contenedor_yunque3");
      }

      else if(iLingotesAceroscuro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de Aceroscuro...",
          "aco_lanza", "*¡Has logrado fabricar una lanza de Aceroscuro!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesPlatino == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de Platino...",
          "platino_lanza", "*¡Has logrado fabricar una lanza de Platino!*",
          360, 3000, "contenedor_yunque3");
      }

      else if(iLingotesArandur == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de Arandur...",
          "ar_lanza", "*¡Has logrado fabricar una lanza de Arandur!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesMetalvivo == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de metal vivo...",
          "me_lanza", "*¡Has logrado fabricar una lanza de metal vivo!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesDerretido == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una lanza de hierro enardecido...",
          "meteo_lanza", "*¡Has logrado fabricar una lanza de hierro enardecido!*",
          320, 3000, "contenedor_yunque3");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // ESPADA DE DOS HOJAS
  else if(sTagMolde == "molde_esp2hojas")
  {
      // Espada de dos hojas de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de hierro...",
          "hr_espada2h", "*¡Has logrado fabricar una espada de dos hojas de hierro!*",
          160, 90, "contenedor_yunque2");
      }

      // Espada de dos hojas de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de cobre...",
          "co_espada2h", "*¡Has logrado fabricar una espada de dos hojas de cobre!*",
          103, 150, "contenedor_yunque2");
      }

      // Espada de dos hojas de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de acero...",
          "ac_espada2h", "*¡Has logrado fabricar una espada de dos hojas de acero!*",
          218, 240, "contenedor_yunque2");
      }

      // Espada de dos hojas de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de plata...",
          "pl_espada2h", "*¡Has logrado fabricar una espada de dos hojas de plata!*",
          275, 390, "contenedor_yunque2");
      }

      // Espada de dos hojas de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de hierrofrío...",
          "hf_espada2h", "*¡Has logrado fabricar una espada de dos hojas de hierrofrío!*",
          333, 630, "contenedor_yunque2");
      }

      // Espada de dos hojas de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de oro...",
          "or_espada2h", "*¡Has logrado fabricar una espada de dos hojas de oro!*",
          390, 1020, "contenedor_yunque2");
      }

      // Espada de dos hojas de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de mithril...",
          "mi_espada2h", "*¡Has logrado fabricar una espada de dos hojas de mithril!*",
          448, 3250, "contenedor_yunque2");
      }

      // Espada de dos hojas de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de adamantita...",
          "ad_espada2h", "*¡Has logrado fabricar una espada de dos hojas de adamantita!*",
          505, 6000, "contenedor_yunque2");
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de dlarun...",
          "dl_espada2h", "*¡Has logrado fabricar una espada de dos hojas de dlarun!*",
          160, 3000, "contenedor_yunque5");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de Hizagkuur...",
          "hi_espada2h", "*¡Has logrado fabricar una espada de dos hojas de Hizagkuur!*",
          200, 3000, "contenedor_yunque5");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de Aceroscuro...",
          "aco_espada2h", "*¡Has logrado fabricar una espada de dos hojas de Aceroscuro!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de Platino...",
          "platino_espada2h", "*¡Has logrado fabricar una espada de dos hojas de Platino!*",
          360, 3000, "contenedor_yunque5");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de Arandur...",
          "ar_espada2h", "*¡Has logrado fabricar una espada de dos hojas de Arandur!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de metal vivo...",
          "me_espada2h", "*¡Has logrado fabricar una espada de dos hojas de metal vivo!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una espada de dos hojas de hierro enardecido...",
          "meteo_espada2h", "*¡Has logrado fabricar una espada de dos hojas de hierro enardecido!*",
          320, 3000, "contenedor_yunque5");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          SetLocked(OBJECT_SELF, FALSE);
          return;
      }
  }

  // MANDOBLE
  else if(sTagMolde == "molde_mandoble")
  {
      // Mandoble de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de hierro...",
          "hr_espadon", "*¡Has logrado fabricar un mandoble de hierro!*",
          160, 90, "contenedor_yunque2");
      }

      // Mandoble de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de cobre...",
          "co_espadon", "*¡Has logrado fabricar un mandoble de cobre!*",
          103, 150, "contenedor_yunque2");
      }

      // Mandoble de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de acero...",
          "ac_espadon", "*¡Has logrado fabricar un mandoble de acero!*",
          218, 240, "contenedor_yunque2");
      }

      // Mandoble de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de plata...",
          "pl_espadon", "*¡Has logrado fabricar un mandoble de plata!*",
          275, 390, "contenedor_yunque2");
      }

      // Mandoble de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de hierrofrío...",
          "hf_espadon", "*¡Has logrado fabricar un mandoble de hierrofrío!*",
          333, 630, "contenedor_yunque2");
      }

      // Mandoble de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de oro...",
          "or_espadon", "*¡Has logrado fabricar un mandoble de oro!*",
          390, 1020, "contenedor_yunque2");
      }

      // Mandoble de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de mithril...",
          "mi_espadon", "*¡Has logrado fabricar un mandoble de mithril!*",
          448, 3250, "contenedor_yunque2");
      }

      // Mandoble de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de adamantita...",
          "ad_espadon", "*¡Has logrado fabricar un mandoble de adamantita!*",
          505, 6000, "contenedor_yunque2");
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de dlarun...",
          "dl_espadon", "*¡Has logrado fabricar un mandoble de dlarun!*",
          160, 3000, "contenedor_yunque5");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de Hizagkuur...",
          "hi_espadon", "*¡Has logrado fabricar un mandoble de Hizagkuur!*",
          200, 3000, "contenedor_yunque5");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de Aceroscuro...",
          "aco_espadon", "*¡Has logrado fabricar un mandoble de Aceroscuro!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de Platino...",
          "platino_espadon", "*¡Has logrado fabricar un mandoble de Platino!*",
          360, 3000, "contenedor_yunque5");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de Arandur...",
          "ar_espadon", "*¡Has logrado fabricar un mandoble de Arandur!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de metal vivo...",
          "me_espadon", "*¡Has logrado fabricar un mandoble de metal vivo!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mandoble de hierro enardecido...",
          "meteo_espadon", "*¡Has logrado fabricar un mandoble de hierro enardecido!*",
          320, 3000, "contenedor_yunque5");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          SetLocked(OBJECT_SELF, FALSE);
          return;
      }
  }

  // ESCUDO GRANDE
  else if(sTagMolde == "molde_escudogra")
  {
      // Escudo grande de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de hierro...",
          "hr_escudog", "*¡Has logrado fabricar un escudo grande de hierro!*",
          103, 90);
      }

      // Escudo grande de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de cobre...",
          "co_escudog", "*¡Has logrado fabricar un escudo grande de cobre!*",
          160, 150);
      }

      // Escudo grande de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de acero...",
          "ac_escudog", "*¡Has logrado fabricar un escudo grande de acero!*",
          218, 240);
      }

      // Escudo grande de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de plata...",
          "pl_escudog", "*¡Has logrado fabricar un escudo grande de plata!*",
          275, 390);
      }

      // Escudo grande de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de hierrofrío...",
          "hf_escudog", "*¡Has logrado fabricar un escudo grande de hierrofrío!*",
          333, 630);
      }

      // Escudo grande de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de oro...",
          "or_escudog", "*¡Has logrado fabricar un escudo grande de oro!*",
          390, 1020);
      }

      // Escudo grande de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de mithril...",
          "mi_escudog", "*¡Has logrado fabricar un escudo grande de mithril!*",
          448, 3250);
      }

      // Escudo grande de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de adamantita...",
          "ad_escudog", "*¡Has logrado fabricar un escudo grande de adamantita!*",
          505, 6000);
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de dlarun...",
          "dl_escudog", "*¡Has logrado fabricar un escudo grande de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de Hizagkuur...",
          "hi_escudog", "*¡Has logrado fabricar un escudo grande de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de Aceroscuro...",
          "aco_escudog", "*¡Has logrado fabricar un escudo grande de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de Platino...",
          "platino_escudog", "*¡Has logrado fabricar un escudo grande de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de Arandur...",
          "ar_escudog", "*¡Has logrado fabricar un escudo grande de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de metal vivo...",
          "me_escudog", "*¡Has logrado fabricar un escudo grande de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo grande de hierro enardecido...",
          "meteo_escudog", "*¡Has logrado fabricar un escudo grande de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          SetLocked(OBJECT_SELF, FALSE);
          return;
      }
  }

  // HACHA DOBLE
  else if(sTagMolde == "molde_axadoble")
  {
      // Hacha doble de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de hierro...",
          "hr_hacha2", "*¡Has logrado fabricar un hacha doble de hierro!*",
          160, 90, "contenedor_yunque2");
      }

      // Hacha doble de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de cobre...",
          "co_hacha2", "*¡Has logrado fabricar un hacha doble de cobre!*",
          103, 150, "contenedor_yunque2");
      }

      // Hacha doble de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de acero...",
          "ac_hacha2", "*¡Has logrado fabricar un hacha doble de acero!*",
          218, 240, "contenedor_yunque2");
      }

      // Hacha doble de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de plata...",
          "pl_hacha2", "*¡Has logrado fabricar un hacha doble de plata!*",
          275, 390, "contenedor_yunque2");
      }

      // Hacha doble de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de hierrofrío...",
          "hf_hacha2", "*¡Has logrado fabricar un hacha doble de hierrofrío!*",
          333, 630, "contenedor_yunque2");
      }

      // Hacha doble de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de oro...",
          "or_hacha2", "*¡Has logrado fabricar un hacha doble de oro!*",
          390, 1020, "contenedor_yunque2");
      }

      // Hacha doble de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de mithril...",
          "mi_hacha2", "*¡Has logrado fabricar un hacha doble de mithril!*",
          448, 3250, "contenedor_yunque2");
      }

      // Hacha doble de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de adamantita...",
          "ad_hacha2", "*¡Has logrado fabricar un hacha doble de adamantita!*",
          505, 6000, "contenedor_yunque2");
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de dlarun...",
          "dl_hacha2", "*¡Has logrado fabricar un hacha doble de dlarun!*",
          160, 3000, "contenedor_yunque5");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de Hizagkuur...",
          "hi_hacha2", "*¡Has logrado fabricar un hacha doble de Hizagkuur!*",
          200, 3000, "contenedor_yunque5");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de Aceroscuro...",
          "aco_hacha2", "*¡Has logrado fabricar un hacha doble de Aceroscuro!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de Platino...",
          "platino_hacha2", "*¡Has logrado fabricar un hacha doble de Platino!*",
          360, 3000, "contenedor_yunque5");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de Arandur...",
          "ar_hacha2", "*¡Has logrado fabricar un hacha doble de Arandur!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de metal vivo...",
          "me_hacha2", "*¡Has logrado fabricar un hacha doble de metal vivo!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha doble de hierro enardecido...",
          "meteo_hacha2", "*¡Has logrado fabricar un hacha doble de hierro enardecido!*",
          320, 3000, "contenedor_yunque5");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          SetLocked(OBJECT_SELF, FALSE);
          return;
      }
  }

  // GUADANYA
  else if(sTagMolde == "molde_guadanya")
  {
      // Guadanya de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una guadaña de hierro...",
          "hr_guadagna", "*¡Has logrado fabricar una guadaña de hierro!*",
          160, 90, "contenedor_yunque2");
      }

      // Guadanya de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una guadaña de cobre...",
          "co_guadagna", "*¡Has logrado fabricar una guadaña de cobre!*",
          103, 150, "contenedor_yunque2");
      }

      // Guadanya de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una guadaña de acero...",
          "ac_guadagna", "*¡Has logrado fabricar una guadaña de acero!*",
          218, 240, "contenedor_yunque2");
      }

      // Guadanya de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una guadaña de plata...",
          "pl_guadagna", "*¡Has logrado fabricar una guadaña de plata!*",
          275, 390, "contenedor_yunque2");
      }

      // Guadanya de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una guadaña de hierrofrío...",
          "hf_guadagna", "*¡Has logrado fabricar una guadaña de hierrofrío!*",
          333, 630, "contenedor_yunque2");
      }

      // Guadanya de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una guadaña de oro...",
          "or_guadagna", "*¡Has logrado fabricar una guadaña de oro!*",
          390, 1020, "contenedor_yunque2");
      }

      // Guadanya de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una guadaña de mithril...",
          "mi_guadagna", "*¡Has logrado fabricar una guadaña de mithril!*",
          448, 3250, "contenedor_yunque2");
      }

      // Guadanya de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una guadaña de adamantita...",
          "ad_guadagna", "*¡Has logrado fabricar una guadaña de adamantita!*",
          505, 6000, "contenedor_yunque2");
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un guadaña de dlarun...",
          "dl_guadagna", "*¡Has logrado fabricar un guadaña de dlarun!*",
          160, 3000, "contenedor_yunque5");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un guadaña de Hizagkuur...",
          "hi_guadagna", "*¡Has logrado fabricar un guadaña de Hizagkuur!*",
          200, 3000, "contenedor_yunque5");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un guadaña de Aceroscuro...",
          "aco_guadagna", "*¡Has logrado fabricar un guadaña de Aceroscuro!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un guadaña de Platino...",
          "platino_guadagna", "*¡Has logrado fabricar un guadaña de Platino!*",
          360, 3000, "contenedor_yunque5");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un guadaña de Arandur...",
          "ar_guadagna", "*¡Has logrado fabricar un guadaña de Arandur!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un guadaña de metal vivo...",
          "me_guadagna", "*¡Has logrado fabricar un guadaña de metal vivo!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un guadaña de hierro enardecido...",
          "meteo_guadagna", "*¡Has logrado fabricar un guadaña de hierro enardecido!*",
          320, 3000, "contenedor_yunque5");
      }


      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // GRAN HACHA
  else if(sTagMolde == "molde_granaxa")
  {
      // Gran hacha de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de hierro...",
          "hr_granh", "*¡Has logrado fabricar un gran hacha de hierro!*",
          160, 90, "contenedor_yunque2");
      }

      // Gran hacha de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de cobre...",
          "co_granh", "*¡Has logrado fabricar un gran hacha de cobre!*",
          103, 150, "contenedor_yunque2");
      }

      // Gran hacha de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de acero...",
          "ac_granh", "*¡Has logrado fabricar un gran hacha de acero!*",
          218, 240, "contenedor_yunque2");
      }

      // Gran hacha de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de plata...",
          "pl_granh", "*¡Has logrado fabricar un gran hacha de plata!*",
          275, 390, "contenedor_yunque2");
      }

      // Gran hacha de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de hierrofrío...",
          "hf_granh", "*¡Has logrado fabricar un gran hacha de hierrofrío!*",
          333, 630, "contenedor_yunque2");
      }

      // Gran hacha de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de oro...",
          "or_granh", "*¡Has logrado fabricar un gran hacha de oro!*",
          390, 1020, "contenedor_yunque2");
      }

      // Gran hacha de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de mithril...",
          "mi_granh", "*¡Has logrado fabricar un gran hacha de mithril!*",
          448, 3250, "contenedor_yunque2");
      }

      // Gran hacha de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de adamantita...",
          "ad_granh", "*¡Has logrado fabricar un gran hacha de adamantita!*",
          505, 6000, "contenedor_yunque2");
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de dlarun...",
          "dl_granh", "*¡Has logrado fabricar un gran hacha de dlarun!*",
          160, 3000, "contenedor_yunque5");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de Hizagkuur...",
          "hi_granh", "*¡Has logrado fabricar un gran hacha de Hizagkuur!*",
          200, 3000, "contenedor_yunque5");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de Aceroscuro...",
          "aco_granh", "*¡Has logrado fabricar un gran hacha de Aceroscuro!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de Platino...",
          "platino_granh", "*¡Has logrado fabricar un gran hacha de Platino!*",
          360, 3000, "contenedor_yunque5");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de Arandur...",
          "ar_granh", "*¡Has logrado fabricar un gran hacha de Arandur!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de metal vivo...",
          "me_granh", "*¡Has logrado fabricar un gran hacha de metal vivo!*",
          505, 3000, "contenedor_yunque5");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un gran hacha de hierro enardecido...",
          "meteo_granh", "*¡Has logrado fabricar un gran hacha de hierro enardecido!*",
          320, 3000, "contenedor_yunque5");
      }


      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // MANGUAL PESADO
  else if(sTagMolde == "molde_mangpes")
  {
      // Mangual pesado de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de hierro...",
          "hr_mangualp", "*¡Has logrado fabricar un mangual pesado de hierro!*",
          160, 90, "contenedor_yunque3");
      }

      // Mangual pesado de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de cobre...",
          "co_mangualp", "*¡Has logrado fabricar un mangual pesado de cobre!*",
          103, 150, "contenedor_yunque3");
      }

      // Mangual pesado de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de acero...",
          "ac_mangualp", "*¡Has logrado fabricar un mangual pesado de acero!*",
          218, 240, "contenedor_yunque3");
      }

      // Mangual pesado de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de plata...",
          "pl_mangualp", "*¡Has logrado fabricar un mangual pesado de plata!*",
          275, 390, "contenedor_yunque3");
      }

      // Mangual pesado de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de hierrofrío...",
          "hf_mangualp", "*¡Has logrado fabricar un mangual pesado de hierrofrío!*",
          333, 630, "contenedor_yunque3");
      }

      // Mangual pesado de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de oro...",
          "or_mangualp", "*¡Has logrado fabricar un mangual pesado de oro!*",
          390, 1020, "contenedor_yunque3");
      }

      // Mangual pesado de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de mithril...",
          "mi_mangualp", "*¡Has logrado fabricar un mangual pesado de mithril!*",
          448, 3250, "contenedor_yunque3");
      }

      // Mangual pesado de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando mangual pesado de adamantita...",
          "ad_mangualp", "*¡Has logrado fabricar mangual pesado de adamantita!*",
          505, 6000, "contenedor_yunque3");
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de dlarun...",
          "dl_mangualp", "*¡Has logrado fabricar un mangual pesado de dlarun!*",
          160, 3000, "contenedor_yunque3");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de Hizagkuur...",
          "hi_mangualp", "*¡Has logrado fabricar un mangual pesado de Hizagkuur!*",
          200, 3000, "contenedor_yunque3");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de Aceroscuro...",
          "aco_mangualp", "*¡Has logrado fabricar un mangual pesado de Aceroscuro!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de Platino...",
          "platino_mangualp", "*¡Has logrado fabricar un mangual pesado de Platino!*",
          360, 3000, "contenedor_yunque3");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de Arandur...",
          "ar_mangualp", "*¡Has logrado fabricar un mangual pesado de Arandur!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de metal vivo...",
          "me_mangualp", "*¡Has logrado fabricar un mangual pesado de metal vivo!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mangual pesado de hierro enardecido...",
          "meteo_mangualp", "*¡Has logrado fabricar un mangual pesado de hierro enardecido!*",
          320, 3000, "contenedor_yunque3");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // TRIDENTE
  else if(sTagMolde == "molde_tridente")
  {
      // Tridente de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de hierro...",
          "hr_tridente", "*¡Has logrado fabricar un tridente de hierro!*",
          160, 90, "contenedor_yunque3");
      }

      // Tridente de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de cobre...",
          "co_tridente", "*¡Has logrado fabricar un tridente de cobre!*",
          103, 150, "contenedor_yunque3");
      }

      // Tridente de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de acero...",
          "ac_tridente", "*¡Has logrado fabricar un tridente de acero!*",
          218, 240, "contenedor_yunque3");
      }

      // Tridente de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de plata...",
          "pl_tridente", "*¡Has logrado fabricar un tridente de plata!*",
          275, 390, "contenedor_yunque3");
      }

      // Tridente de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de hierrofrío...",
          "hf_tridente", "*¡Has logrado fabricar un tridente de hierrofrío!*",
          333, 630, "contenedor_yunque3");
      }

      // Tridente de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de oro...",
          "or_tridente", "*¡Has logrado fabricar un tridente de oro!*",
          390, 1020, "contenedor_yunque3");
      }

      // Tridente de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de mithril...",
          "mi_tridente", "*¡Has logrado fabricar un tridente de mithril!*",
          448, 3250, "contenedor_yunque3");
      }

      // Tridente de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de adamantita...",
          "ad_tridente", "*¡Has logrado fabricar un tridente de adamantita!*",
          505, 6000, "contenedor_yunque3");
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de dlarun...",
          "dl_tridente", "*¡Has logrado fabricar un tridente de dlarun!*",
          160, 3000, "contenedor_yunque3");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de Hizagkuur...",
          "hi_tridente", "*¡Has logrado fabricar un tridente de Hizagkuur!*",
          200, 3000, "contenedor_yunque3");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de Aceroscuro...",
          "aco_tridente", "*¡Has logrado fabricar un tridente de Aceroscuro!*",
          505, 3000, "contenedor_yunque3");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de Platino...",
          "platino_tridente", "*¡Has logrado fabricar un tridente de Platino!*",
          360, 3000, "contenedor_yunque3");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de Arandur...",
          "ar_tridente", "*¡Has logrado fabricar un tridente de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de metal vivo...",
          "me_tridente", "*¡Has logrado fabricar un tridente de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un tridente de hierro enardecido...",
          "meteo_tridente", "*¡Has logrado fabricar un tridente de hierro enardecido!*",
          320, 3000, "contenedor_yunque3");
      }


      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // MAZA TERRIBLE
  else if(sTagMolde == "molde_mazaterr")
  {
      // Maza terrible de hierro (1)
      if(iLingotesHierro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de hierro...",
          "hr_mazater", "*¡Has logrado fabricar una maza terrible de hierro!*",
          160, 90, "contenedor_yunque3");
      }

      // Maza terrible de cobre (2)
      else if(iLingotesCobre == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de cobre...",
          "co_mazater", "*¡Has logrado fabricar una maza terrible de cobre!*",
          103, 150, "contenedor_yunque3");
      }

      // Maza terrible de acero (3)
      else if(iLingotesAcero == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de acero...",
          "ac_mazater", "*¡Has logrado fabricar una maza terrible de acero!*",
          218, 240, "contenedor_yunque3");
      }

      // Maza terrible de plata (4)
      else if(iLingotesPlata == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de plata...",
          "pl_mazater", "*¡Has logrado fabricar una maza terrible de plata!*",
          275, 390, "contenedor_yunque3");
      }

      // Maza terrible de hierrofrio (5)
      else if(iLingotesHierrofrio == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de hierrofrío...",
          "hf_mazater", "*¡Has logrado fabricar una maza terrible de hierrofrío!*",
          333, 630, "contenedor_yunque3");
      }

      // Maza terrible de oro (6)
      else if(iLingotesOro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de oro...",
          "or_mazater", "*¡Has logrado fabricar una maza terrible de oro!*",
          390, 1020, "contenedor_yunque3");
      }

      // Maza terrible de mithril (7)
      else if(iLingotesMithril == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de mithril...",
          "mi_mazater", "*¡Has logrado fabricar una maza terrible de mithril!*",
          448, 3250, "contenedor_yunque3");
      }

      // Maza terrible de adamantita (8)
      else if(iLingotesAdamantita == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de adamantita...",
          "ad_mazater", "*¡Has logrado fabricar una maza terrible de adamantita!*",
          505, 6000, "contenedor_yunque3");
      }

      else if(iLingotesDlarun == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de dlarun...",
          "dl_mazater", "*¡Has logrado fabricar una maza terrible de dlarun!*",
          160, 3000, "contenedor_yunque3");
      }

      else if(iLingotesHizagkuur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de Hizagkuur...",
          "hi_mazater", "*¡Has logrado fabricar una maza terrible de Hizagkuur!*",
          200, 3000, "contenedor_yunque3");
      }

      else if(iLingotesAceroscuro == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de Aceroscuro...",
          "aco_mazater", "*¡Has logrado fabricar una maza terrible de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de Platino...",
          "platino_mazater", "*¡Has logrado fabricar una maza terrible de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de Arandur...",
          "ar_mazater", "*¡Has logrado fabricar una maza terrible de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de metal vivo...",
          "me_mazater", "*¡Has logrado fabricar una maza terrible de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 3)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de hierro enardecido...",
          "meteo_mazater", "*¡Has logrado fabricar una maza terrible de hierro enardecido!*",
          320, 3000, "contenedor_yunque3");
      }


      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // ESCUDO PAVES
  else if(sTagMolde == "molde_escudopav")
  {
      // RECETA UNICA: Escudo de matadragones
      if(iEstatuillaDragon == 1 && iLingotesAcero == 8 &&
              iGlandulaSeda == 5 && iCalaveraGargola == 5 && iSangreDragon == 10)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo de matadragones...",
          "matadragones2", "*¡Has logrado fabricar un escudo de matadragones!*",
          460, 10000, "contenedor_yunque3");
      }

      // Escudo paves de hierro (1)
      else if(iLingotesHierro == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pavés de hierro...",
          "hr_escudopv", "*¡Has logrado fabricar un escudo pavés de hierro!*",
          172, 200);
      }

      // Escudo paves de cobre (2)
      else if(iLingotesCobre == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pavés de cobre...",
          "co_escudopv", "*¡Has logrado fabricar un escudo pavés de cobre!*",
          114, 120);
      }

      // Escudo paves de acero (3)
      else if(iLingotesAcero == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pavés de acero...",
          "ac_escudopv", "*¡Has logrado fabricar un escudo pavés de acero!*",
          229, 320);
      }

      // Escudo paves de plata (4)
      else if(iLingotesPlata == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pavés de plata...",
          "pl_escudopv", "*¡Has logrado fabricar un escudo pavés de plata!*",
          287, 520);
      }

      // Escudo paves de hierrofrio (5)
      else if(iLingotesHierrofrio == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pavés de hierrofrío...",
          "hf_escudopv", "*¡Has logrado fabricar un escudo pavés de hierrofrío!*",
          344, 840);
      }

      // Escudo paves de oro (6)
      else if(iLingotesOro == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pavés de oro...",
          "or_escudopv", "*¡Has logrado fabricar un escudo pavés de oro!*",
          402, 1360);
      }

      // Escudo paves de mithril (7)
      else if(iLingotesMithril == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pavés de mithril...",
          "mi_escudopv", "*¡Has logrado fabricar un escudo pavés de mithril!*",
          459, 3900);
      }

      // Escudo paves de adamantita (8)
      else if(iLingotesAdamantita == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un escudo pavés de adamantita...",
          "ad_escudopv", "*¡Has logrado fabricar un escudo pavés de adamantita!*",
          517, 8000);
      }

          else if(iLingotesDlarun == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de dlarun...",
          "dl_escudopv", "*¡Has logrado fabricar una maza terrible de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de Hizagkuur...",
          "hi_escudopv", "*¡Has logrado fabricar una maza terrible de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de Aceroscuro...",
          "aco_escudopv", "*¡Has logrado fabricar una maza terrible de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de Platino...",
          "platino_escudopv", "*¡Has logrado fabricar una maza terrible de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de Arandur...",
          "ar_escudopv", "*¡Has logrado fabricar una maza terrible de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de metal vivo...",
          "me_escudopv", "*¡Has logrado fabricar una maza terrible de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 4)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza terrible de hierro enardecido...",
          "meteo_escudopv", "*¡Has logrado fabricar una maza terrible de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // HACHA DE MANO
  else if(sTagMolde == "molde_axamano")
  {
      // Hacha de mano de hierro (1)
      if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de hierro...",
          "hr_hacham", "*¡Has logrado fabricar un hacha de mano de hierro!*",
          137, 30);
      }

      // Hacha de mano de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de cobre...",
          "co_hacham", "*¡Has logrado fabricar un hacha de mano de cobre!*",
          80, 50);
      }

      // Hacha de mano de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de acero...",
          "ac_hacham", "*¡Has logrado fabricar un hacha de mano de acero!*",
          195, 80);
      }

      // Hacha de mano de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de plata...",
          "pl_hacham", "*¡Has logrado fabricar un hacha de mano de plata!*",
          252, 130);
      }

      // Hacha de mano de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de hierrofrío...",
          "hf_hacham", "*¡Has logrado fabricar un hacha de mano de hierrofrío!*",
          310, 210);
      }

      // Hacha de mano de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de oro...",
          "or_hacham", "*¡Has logrado fabricar un hacha de mano de oro!*",
          367, 340);
      }

      // Hacha de mano de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de mithril...",
          "mi_hacham", "*¡Has logrado fabricar un hacha de mano de mithril!*",
          425, 1300);
      }

      // Hacha de mano de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de adamantita...",
          "ad_hacham", "*¡Has logrado fabricar un hacha de mano de adamantita!*",
          482, 2000);
      }

      else if(iLingotesDlarun == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de dlarun...",
          "dl_hacham", "*¡Has logrado fabricar un hacha de mano de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de Hizagkuur...",
          "hi_hacham", "*¡Has logrado fabricar un hacha de mano de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de Aceroscuro...",
          "aco_hacham", "*¡Has logrado fabricar un hacha de mano de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de Platino...",
          "platino_hacham", "*¡Has logrado fabricar un hacha de mano de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de Arandur...",
          "ar_hacham", "*¡Has logrado fabricar un hacha de mano de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de metal vivo...",
          "me_hacham", "*¡Has logrado fabricar un hacha de mano de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un hacha de mano de hierro enardecido...",
          "meteo_hacham", "*¡Has logrado fabricar un hacha de mano de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }
      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // KAMA
  else if(sTagMolde == "molde_kama")
  {
      // RECETA UNICA: Kama de la paz eterna
      if(iLingotesAcero == 2 && iLingotesPlata == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de la paz eterna...",
          "kama_paz", "*¡Has logrado fabricar un kama de la paz eterna!*",
          280, 500, "contenedor_yunque3");
      }

      // Kama de hierro (1)
      else if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de hierro...",
          "hr_kama", "*¡Has logrado fabricar un kama de hierro!*",
          137, 30);
      }

      // Kama de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de cobre...",
          "co_kama", "*¡Has logrado fabricar un kama de cobre!*",
          80, 50);
      }

      // Kama de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de acero...",
          "ac_kama", "*¡Has logrado fabricar un kama de acero!*",
          195, 80);
      }

      // Kama de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de plata...",
          "pl_kama", "*¡Has logrado fabricar un kama de plata!*",
          252, 130);
      }

      // Kama de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de hierrofrío...",
          "hf_kama", "*¡Has logrado fabricar un kama de hierrofrío!*",
          310, 210);
      }

      // Kama de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de oro...",
          "or_kama", "*¡Has logrado fabricar un kama de oro!*",
          367, 340);
      }

      // Kama de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de mithril...",
          "mi_kama", "*¡Has logrado fabricar un kama de mithril!*",
          425, 1300);
      }

      // Kama de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de adamantita...",
          "ad_kama", "*¡Has logrado fabricar un kama de adamantita!*",
          482, 2000);
      }

      else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de dlarun...",
          "dl_kama", "*¡Has logrado fabricar un kama de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de Hizagkuur...",
          "hi_kama", "*¡Has logrado fabricar un kama de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de Aceroscuro...",
          "aco_kama", "*¡Has logrado fabricar un kama de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de Platino...",
          "platino_kama", "*¡Has logrado fabricar un kama de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de Arandur...",
          "ar_kama", "*¡Has logrado fabricar un kama de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de metal vivo...",
          "me_kama", "*¡Has logrado fabricar un kama de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kama de hierro enardecido...",
          "meteo_kama", "*¡Has logrado fabricar un kama de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }


      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // MARTILLO LIGERO
  else if(sTagMolde == "molde_martligero")
  {
      // Martillo ligero de hierro (1)
      if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de hierro...",
          "hr_martil", "*¡Has logrado fabricar un martillo ligero de hierro!*",
          137, 30);
      }

      // Martillo ligero de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de cobre...",
          "co_martil", "*¡Has logrado fabricar un martillo ligero de cobre!*",
          80, 50);
      }

      // Martillo ligero de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de acero...",
          "ac_martil", "*¡Has logrado fabricar un martillo ligero de acero!*",
          195, 80);
      }

      // Martillo ligero de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de plata...",
          "pl_martil", "*¡Has logrado fabricar un martillo ligero de plata!*",
          252, 130);
      }

      // Martillo ligero de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de hierrofrío...",
          "hf_martil", "*¡Has logrado fabricar un martillo ligero de hierrofrío!*",
          310, 210);
      }

      // Martillo ligero de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de oro...",
          "or_martil", "*¡Has logrado fabricar un martillo ligero de oro!*",
          367, 340);
      }

      // Martillo ligero de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de mithril...",
          "mi_martil", "*¡Has logrado fabricar un martillo ligero de mithril!*",
          425, 1300);
      }

      // Martillo ligero de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de adamantita...",
          "ad_martil", "*¡Has logrado fabricar un martillo ligero de adamantita!*",
          482, 2000);
      }

      else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de dlarun...",
          "dl_martil", "*¡Has logrado fabricar un martillo ligero de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de Hizagkuur...",
          "hi_martil", "*¡Has logrado fabricar un martillo ligero de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de Aceroscuro...",
          "aco_martil", "*¡Has logrado fabricar un martillo ligero de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de Platino...",
          "platino_martil", "*¡Has logrado fabricar un martillo ligero de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de Arandur...",
          "ar_martil", "*¡Has logrado fabricar un martillo ligero de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de metal vivo...",
          "me_martil", "*¡Has logrado fabricar un martillo ligero de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de hierro enardecido...",
          "meteo_martil", "*¡Has logrado fabricar un martillo ligero de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // KUKRI
  else if(sTagMolde == "molde_kukri")
  {
      // Kukri de hierro (1)
      if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de hierro...",
          "hr_kukri", "*¡Has logrado fabricar un kukri de hierro!*",
          137, 30);
      }

      // Kukri de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de cobre...",
          "co_kukri", "*¡Has logrado fabricar un kukri de cobre!*",
          80, 50);
      }

      // Kukri de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de acero...",
          "ac_kukri", "*¡Has logrado fabricar un kukri de acero!*",
          195, 80);
      }

      // Kukri de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de plata...",
          "pl_kukri", "*¡Has logrado fabricar un kukri de plata!*",
          252, 130);
      }

      // Kukri de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de hierrofrío...",
          "hf_kukri", "*¡Has logrado fabricar un kukri de hierrofrío!*",
          310, 210);
      }

      // Kukri de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de oro...",
          "or_kukri", "*¡Has logrado fabricar un kukri de oro!*",
          367, 340);
      }

      // Kukri de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de mithril...",
          "mi_kukri", "*¡Has logrado fabricar un kukri de mithril!*",
          425, 1300);
      }

      // Kukri de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de adamantita...",
          "ad_kukri", "*¡Has logrado fabricar un kukri de adamantita!*",
          482, 2000);
      }

      else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de dlarun...",
          "dl_kukri", "*¡Has logrado fabricar un kukri de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de Hizagkuur...",
          "hi_kukri", "*¡Has logrado fabricar un kukri de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de Aceroscuro...",
          "aco_kukri", "*¡Has logrado fabricar un kukri de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de Platino...",
          "platino_kukri", "*¡Has logrado fabricar un kukri de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de Arandur...",
          "ar_kukri", "*¡Has logrado fabricar un kukri de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de metal vivo...",
          "me_kukri", "*¡Has logrado fabricar un kukri de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un kukri de hierro enardecido...",
          "meteo_kukri", "*¡Has logrado fabricar un kukri de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // MAZA
  else if(sTagMolde == "molde_maza")
  {
      // Maza de hierro (1)
      if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de hierro...",
          "hr_maza", "*¡Has logrado fabricar una maza de hierro!*",
          137, 30);
      }

      // Maza de cobre (2)
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de cobre...",
          "co_maza", "*¡Has logrado fabricar una maza de cobre!*",
          80, 50);
      }

      // Maza de acero (3)
      else if(iLingotesAcero == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de acero...",
          "ac_maza", "*¡Has logrado fabricar una maza de acero!*",
          195, 80);
      }

      // Maza de plata (4)
      else if(iLingotesPlata == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de plata...",
          "pl_maza", "*¡Has logrado fabricar una maza de plata!*",
          252, 130);
      }

      // Maza de hierrofrio (5)
      else if(iLingotesHierrofrio == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de hierrofrío...",
          "hf_maza", "*¡Has logrado fabricar una maza de hierrofrío!*",
          310, 210);
      }

      // Maza de oro (6)
      else if(iLingotesOro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de oro...",
          "or_maza", "*¡Has logrado fabricar una maza de oro!*",
          367, 340);
      }

      // Maza de mithril (7)
      else if(iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de mithril...",
          "mi_maza", "*¡Has logrado fabricar una maza de mithril!*",
          425, 1300);
      }

      // Maza de adamantita (8)
      else if(iLingotesAdamantita == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de adamantita...",
          "ad_maza", "*¡Has logrado fabricar una maza de adamantita!*",
          482, 2000);
      }

      else if(iLingotesDlarun == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de dlarun...",
          "dl_maza", "*¡Has logrado fabricar una maza de dlarun!*",
          160, 3000, "contenedor_yunque4");
      }

      else if(iLingotesHizagkuur == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de Hizagkuur...",
          "hi_maza", "*¡Has logrado fabricar una maza de Hizagkuur!*",
          200, 3000, "contenedor_yunque4");
      }

      else if(iLingotesAceroscuro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de Aceroscuro...",
          "aco_maza", "*¡Has logrado fabricar una maza de Aceroscuro!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesPlatino == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de Platino...",
          "platino_maza", "*¡Has logrado fabricar una maza de Platino!*",
          360, 3000, "contenedor_yunque4");
      }

      else if(iLingotesArandur == 1) // NO ESTÁ CREADO 23-12
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de Arandur...",
          "ar_maza", "*¡Has logrado fabricar una maza de Arandur!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesMetalvivo == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de metal vivo...",
          "me_maza", "*¡Has logrado fabricar una maza de metal vivo!*",
          505, 3000, "contenedor_yunque4");
      }

      else if(iLingotesDerretido == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una maza de hierro enardecido...",
          "meteo_maza", "*¡Has logrado fabricar una maza de hierro enardecido!*",
          320, 3000, "contenedor_yunque4");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // HERRAMIENTAS DE HERRERO
  else if(sTagMolde == "molde_herrero")
  {
      // RECETA UNICA: Martillo del maestro herrero
      if(iLingotesCobre == 1 &&
         iLingotesAcero == 1 &&
         iLingotesPlata == 1 &&
         iLingotesHierrofrio == 1 &&
         iLingotesOro == 1 &&
         iLingotesMithril == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo del maestro herrero...",
          "martillo_herrero3", "*¡Has logrado fabricar un martillo del maestro herrero!*",
          490, 2000, "contenedor_yunque3");
      }

      // Mazo de minero
      else if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un mazo de minero...",
          "mazodeminero", "*¡Has logrado fabricar un mazo de minero!*",
          150, 50, "contenedor_yunque3");
      }

      // Pico de minero
      else if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un pico de minero...",
          "picodeminero", "*¡Has logrado fabricar un pico de minero!*",
          160, 60, "contenedor_yunque3");
      }

      // Martillo ligero de herrero
      else if(iLingotesCobre == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo ligero de herrero...",
          "martillo_herrero", "*¡Has logrado fabricar un martillo ligero de herrero!*",
          90, 30, "contenedor_yunque3");
      }

      // Martillo pesado de herrero
      else if(iLingotesAcero == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un martillo pesado de herrero...",
          "martillo_herrero2", "*¡Has logrado fabricar un martillo pesado de herrero!*",
          250, 160, "contenedor_yunque3");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // HERRAMIENTAS DE HERBOLERO
  else if(sTagMolde == "molde_herb")
  {
      // Cuchillo de recolector
      if(iLingotesHierro == 1)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando un cuchillo de recolector...",
          "cuchillorecolector", "*¡Has logrado fabricar un cuchillo de recolector!*",
          130, 60, "contenedor_yunque3");
      }

      // Hoz de recolector
      else if(iLingotesHierro == 2)
      {
          CrearArmasYelmosEscudos(oPC, "Fabricando una hoz de recolector...",
          "hozrecolector", "*¡Has logrado fabricar una hoz de recolector!*",
          90, 30, "contenedor_yunque3");
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // No hay molde?
  else
  {
      FloatingTextStringOnCreature("ERROR: Este mensaje no debería salir nunca, por favor informa a Darth sobre esto", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }
}
