// modified by: Dhraax
#include "f_vampire_area_h"
#include "mti_libreria"
#include "dominios_inc"
//#include "idiomas_inc"
#include "pb_objilegales"
#include "nostack_inc"


void main()
{


  object oPC = GetEnteringObject();
  //Scripts para añadir los pnj del área.
  ExecuteScript ("z0_area_onenter", oPC);
  // DIARIO
  AddJournalQuestEntry("diario1", 1, oPC, FALSE);
  AddJournalQuestEntry("diario2", 1, oPC, FALSE);
  AddJournalQuestEntry("diario3", 1, oPC, FALSE);
  AddJournalQuestEntry("diario4", 1, oPC, FALSE);
  AddJournalQuestEntry("diario5", 1, oPC, FALSE);
  AddJournalQuestEntry("diario6", 1, oPC, FALSE);

  // MANDAR MENSAJEs AL JUGADOR AL ENTRAR EN EL SERVIDOR
  //string sContrasenya = ObtenerStringPersistente(oPC, "SEGCONTRASENYA");
  DelayCommand(2.0, SendMessageToPC(oPC, "<c þþ>¡Bienvenidos al servidor de Puerta de Baldur! Visítanos en www.puertadebaldur.com para más información.</c>"));
  ///if(sContrasenya != "") DelayCommand(3.0, SendMessageToPC(oPC, "<c¢þþ>Recuerda tu contraseña de PJ: "+sContrasenya+".</c>"));

  if(GetHasFeat(1109, oPC) == FALSE) DelayCommand(4.0, SendMessageToPC(oPC, "<cö-->Tu PJ no está configurado correctamente ya que te lo has creado sin que los haks del servidor hayan cargado correctamente. Consulta el foro sobre cómo debes crearte el PJ para que puedas jugar sin errores, o pregunta a algún DM para que pueda ayudarte.</c>"));

  if(!GetIsDM(oPC))
  {
      // Los muertos al Plano de Fuga
      if(ObtenerIntPersistente(oPC, "ESTOY_EN_PLANOFUGA") > 0)
      {
          if(GetLocalInt(oPC, "SEG_OCUPADO")) return;

          FadeToBlack(oPC);
          SetCutsceneMode(oPC, TRUE);
          DelayCommand(3.0, AssignCommand(oPC, ActionStartConversation(oPC, "pg_muerto", TRUE)));
          DelayCommand(3.0, FadeFromBlack(oPC));
          return;
      }

      // Dominios de clérigo, dar o quitar objetos según sea el caso
      ConjurosDominios(oPC);

      // Idiomas cláseos, dar o quitar objetos según sea el caso
      //IdiomasAutomaticosClaseos(oPC);

      // Anti-Colchon XP: Si estas en un bloqueo y tienes mas del 25% del nivel siguiente, se elimina esa parte
      int iXP = GetXP(oPC);
      int iNivel = GetHitDice(oPC);
      /*if(iNivel == 5  && iXP > 16500)  SetXP(oPC, 16500);
      else if(iNivel == 10 && iXP > 57750)  SetXP(oPC, 57750);
      else if(iNivel == 15 && iXP > 124000) SetXP(oPC, 124000);
      else if(iNivel == 20 && iXP > 215250) SetXP(oPC, 215250);
      else if(iNivel == 25 && iXP > 331500) SetXP(oPC, 331500);  */
      if(iNivel == 8  && iXP > 36900)  SetXP(oPC, 36900);
      else if(iNivel == 12 && iXP > 79950)  SetXP(oPC, 79950);
      else if(iNivel == 16 && iXP > 139400) SetXP(oPC, 139400);
      else if(iNivel == 20 && iXP > 215250) SetXP(oPC, 215250);
      else if(iNivel == 21 && iXP > 236775) SetXP(oPC, 236775);
      else if(iNivel == 23 && iXP > 282900) SetXP(oPC, 282900);
      else if(iNivel == 25 && iXP > 331500) SetXP(oPC, 331500);
  }

  //DUPLICAR EL TAMAÑO DE ALGUNOS UBICADOS
  object oUbicado1 = GetObjectByTag("pb_guardianplanar04");
  object oUbicado2 = GetObjectByTag("pb_guardianplanar03");
  SetObjectVisualTransform(oUbicado1,OBJECT_VISUAL_TRANSFORM_SCALE,2.5);
  SetObjectVisualTransform(oUbicado2,OBJECT_VISUAL_TRANSFORM_SCALE,2.0);
  /*object oPeana1 = GetObjectByTag("pb_peanasolar1");
  object oPeana2 = GetObjectByTag("pb_peanasolar2");
  object oPeana3 = GetObjectByTag("pb_peanasolar3");
  object oPeana4 = GetObjectByTag("pb_peanasolar4");
  object oPeana5 = GetObjectByTag("pb_peanasolar5");
  SetObjectVisualTransform(oPeana1,OBJECT_VISUAL_TRANSFORM_SCALE,2.00);
  SetObjectVisualTransform(oPeana2,OBJECT_VISUAL_TRANSFORM_SCALE,2.05);
  SetObjectVisualTransform(oPeana3,OBJECT_VISUAL_TRANSFORM_SCALE,2.15);
  SetObjectVisualTransform(oPeana4,OBJECT_VISUAL_TRANSFORM_SCALE,1.95);
  SetObjectVisualTransform(oPeana5,OBJECT_VISUAL_TRANSFORM_SCALE,1.75);  */
  object oLogo = GetObjectByTag("pb_logobaldur");
  location lLogo =GetLocation(oLogo);
  SetObjectVisualTransform(oLogo,OBJECT_VISUAL_TRANSFORM_SCALE,2.80);
  SetLocalLocation(oLogo, "POS_LOGO", lLogo);

  object oMod= GetModule();
  int nSolar = GetLocalInt(oMod, "iSolar");
  if (nSolar==0)
  {
      int iD6 = d6();
      object oSolar=GetObjectByTag("pb_solar");
      location lSolar =GetLocation(oSolar);
      string sSolar="pb_solar1";
      DestroyObject(oSolar);
      switch(iD6)
      {
        case 0: sSolar = "pb_solar1"; break;
        case 1: sSolar = "pb_solar1"; break;
        case 2: sSolar = "pb_solar1"; break;
        case 3: sSolar = "pb_solar2"; break;
        case 4: sSolar = "pb_solar3"; break;
        case 5: sSolar = "pb_solar4"; break;
        case 6: sSolar = "pb_solar1"; break;
        default: sSolar = "pb_solar1"; break;
     }
     oSolar = CreateObject(OBJECT_TYPE_PLACEABLE,sSolar,lSolar,FALSE,"pb_solar");
     SetLocalInt (oMod, "iSolar", 1);
  }

 //COMPROBAR CUANTOS OBJETOS DE LOS POSIBLES ILEGALES TIENES.
 int iMax=0, iCont1=0, iCont2=0, iCont3=0, iTotal=0, iAux=0;
 iMax=10;
 iCont1 = ContarItem(BASE_ITEM_MAGICWAND, oPC);
 iCont2 = ContarItem(BASE_ITEM_ENCHANTED_WAND, oPC);
 iTotal = iCont1+iCont2;
 if (iTotal>0)
 {
    SendMessageToPC(oPC, "<cÿ‹>Varitas Totales: " + IntToString(iTotal) + " Varitas de Loteos: " + IntToString(iCont1) + " Varitas de Crafteos: " + IntToString(iCont2) +  ". Te recordamos que no puedes tener más de " + IntToString(iMax) + " varitas de crafteo.</c>");
    /*if (iTotal>iMax)
    {
           LimpiarTipoItem(oPC, iMax, iTotal, 1);

    } */
 }
 iMax=50;
 iCont1 = ContarItem(BASE_ITEM_SPELLSCROLL, oPC);
 iCont2 = ContarItem(BASE_ITEM_ENCHANTED_SCROLL, oPC);
 iTotal = iCont1+iCont2;
 if (iTotal>0)
 {
    SendMessageToPC(oPC, "<cÿ‹>Pegaminos Totales: " + IntToString(iTotal) + " Pergaminos de Loteos: " + IntToString(iCont1) + " Pergaminos de Crafteos: " + IntToString(iCont2) +  ". Te recordamos que no puedes tener más de " + IntToString(iMax) + " pergaminos de crafteo.</c>");
    /*if (iTotal>iMax)
    {
         LimpiarTipoItem(oPC, iMax, iTotal, 2);

    } */
 }/*
 iMax=50;
 iCont1 = ContarItem(BASE_ITEM_POTIONS, oPC);
 iCont2 = ContarItem(BASE_ITEM_ENCHANTED_POTION, oPC);
 iTotal = iCont1+iCont2;
 if (iTotal>0)
 {
    SendMessageToPC(oPC, "<cÿ‹>Pociones Totales: " + IntToString(iTotal) + " Pociones de Loteos: " + IntToString(iCont1) + " Pociones de Crafteos: " + IntToString(iCont2) +  ". Te recordamos que no puedes tener más de " + IntToString(iMax) + " pociones de crafteo.</c>");
    /*if (iTotal>iMax)
    {
         LimpiarTipoItem(oPC, iMax, iTotal, 3);

    }
 }    */

  // EXECUTES
  ExecuteScript("hc_innroom_ente4", OBJECT_SELF);
}
