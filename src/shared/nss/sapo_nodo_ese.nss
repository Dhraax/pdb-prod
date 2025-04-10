//::///////////////////////////////////////////////
//:: OFICIO DE ESENCIACION, ON USED
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
  Script conservado por herencia. Por ahora te da acceso a unos
  cuantos objetos que se usan en peletería.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 19 de Agosto de 2013
//:://////////////////////////////////////////////

#include "mti_libreria"

void main()
{
  object oPC = GetLastUsedBy();
  object oUbicado = OBJECT_SELF;

  // Anti-Spam
  int iSpam = GetLocalInt(oUbicado, "NO_SPAM");
  if(iSpam == TRUE) return;

  SetLocalInt(oUbicado, "NO_SPAM", TRUE);
  DelayCommand(6.0, DeleteLocalInt(oUbicado, "NO_SPAM"));

  // Variables del ubicado
  int iEsencias = GetLocalInt(oUbicado, "Esencias");
  int iTipoEsen = GetLocalInt(oUbicado, "Tipo");
  string sEsInfra  = GetLocalString(oUbicado, "EsInfra");

  // Sin usos, no se sigue
  if(iEsencias == 0)
  {
      if(sEsInfra == "S") SendMessageToPC(oPC, "<cþ<<>El nodo de tierra está agotado.</c>");
      else SendMessageToPC(oPC, "<cþ<<>La fuente de esencia está agotada.</c>");
      return;
  }

 // Tirada de Supervivencia, CD 15
  if(GetIsSkillSuccessful(oPC, 36, 15))
  {
       int iTipo = d20();
       string sEsencia="";

       if(iTipo == 1) sEsencia = "caracoldetierra";
       if(iTipo == 2) sEsencia = "dientetiburon";
       if(iTipo == 3) sEsencia = "Guadelaventurero";
       if(iTipo == 4) sEsencia = "estatuasirena";
       if(iTipo == 5) sEsencia = "basura_concha";
       if(iTipo == 6) sEsencia = "nw_it_creitem201"; // Pluma de gaviota
       if(iTipo == 7) sEsencia = "espejodemano";
       if(iTipo == 8) sEsencia = "shandon";
       if(iTipo == 9) sEsencia = "diopsidoestrella";
	      if(iTipo == 10) sEsencia = "sapo_esencia_adi";
       if(iTipo == 11) sEsencia = "sapo_esencia_ilu";
       if(iTipo == 12) sEsencia = "sapo_esencia_con";
       if(iTipo == 13) sEsencia = "sapo_esencia_tra";
       if(iTipo == 14) sEsencia = "sapo_esencia_evo";
       if(iTipo == 15) sEsencia = "sapo_esencia_nig";
       if(iTipo == 16) sEsencia = "sapo_esencia_enc";
	      if(iTipo == 17) sEsencia = "RaizdeNara";
	      if(iTipo == 18) sEsencia = "FoodRation";
	      if(iTipo == 19) sEsencia = "_una";
	      if(iTipo == 20) sEsencia = "crpi_ashes";

       // Creacion de objeto y mensaje
       FloatingTextStringOnCreature("<c´þd>¡Encuentras algo interesante!</c>", oPC, FALSE);
       CreateItemOnObject(sEsencia, oPC);
  }
  else FloatingTextStringOnCreature("<cþ<<>No parece haber nada interesante.</c>", oPC, FALSE);

  // Restamos un uso y Regeneración en tal caso
  SetLocalInt(oUbicado, "Esencias", iEsencias - 1);
  if((iEsencias - 1) == 0) DelayCommand(1800.0, SetLocalInt(oUbicado, "Esencias", 4));
}
