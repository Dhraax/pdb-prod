// modified by: Dhraax
#include "mti_libreria"

void main()
{
      //Especificamos de que es la cantera.
      string TipoCantera = GetLocalString (OBJECT_SELF, "CANTERA");
      string TipoMineral = GetLocalString (OBJECT_SELF, "MINERAL");

      //Efectos de sonido
      effect ePiedras = EffectVisualEffect(353);
      string sSonidoPiedrasAleatorio;
      int iTiradaSonidoPiedras = d6();
      if(iTiradaSonidoPiedras == 1) sSonidoPiedrasAleatorio = "as_na_x2iccrmb7";
      else if(iTiradaSonidoPiedras == 2) sSonidoPiedrasAleatorio = "as_na_x2iccrmb6";
      else if(iTiradaSonidoPiedras == 3) sSonidoPiedrasAleatorio = "as_na_x2iccrmb5";
      else if(iTiradaSonidoPiedras == 4) sSonidoPiedrasAleatorio = "as_na_x2iccrmb4";
      else if(iTiradaSonidoPiedras == 5) sSonidoPiedrasAleatorio = "as_na_x2iccrmb3";
      else sSonidoPiedrasAleatorio = "as_na_x2iccrmb2";
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePiedras, OBJECT_SELF));
      DelayCommand(0.5, PlaySound(sSonidoPiedrasAleatorio));

      //Se crea de nuevo la beta
      CreateObject(OBJECT_TYPE_PLACEABLE,TipoCantera,GetLocation(OBJECT_SELF),FALSE);

      //Comprobamos si tiene el equipo de minero
      object oPC = GetLastAttacker();
      string sPico = GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
      if(sPico != "mazodeminero" && sPico != "picodeminero")
     {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.3, FloatingTextStringOnCreature("<c  ó>*No tienes la herramienta necesaria para moler*</c>", oPC));
      return;
      }

      // Si no eres minero, es mas dificil conseguir el barril (10%)
     int iNivelMineria = ObtenerIntPersistente(oPC, "NIVELMINERIA");
     if(iNivelMineria == 0)
    {
      int id20 = d20();
      if (id20 == 20)
      {
      object oGranito = CreateItemOnObject(TipoMineral,GetLastAttacker()); //damos el barrilete
      }

      return;
    }
      //Si eres minero, es mas sencillo conseguirlo (10%)
      int id10= d10 ();
      if (id10 == 10)
      {
      object oGranito = CreateItemOnObject(TipoMineral,GetLastAttacker()); //damos el barrilete
      }
      return;

}
