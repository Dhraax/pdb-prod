//Poner en un objeto golpeable
//Se activa al atacarlo

#include "sapo_nucleo"

void main()
{
  object oPJ=GetLastAttacker();
  object oUbicado=OBJECT_SELF;

  SetLocalObject(oUbicado,"fnPJ",oPJ);

  if(GetHasInventory(oUbicado)==TRUE)
  {
      if(CargarFormula(oPJ, oUbicado)==TRUE) Fabricar(oPJ, oUbicado);
      else
      {
          int iNoDarPistas=GetLocalInt(oUbicado,"NoDarPistas");
          if(iNoDarPistas==1) SendMessageToPC(oPJ,"*No sabes que hacer con estos materiales. Afortunadamente no se han perdido*");
          else MostrarPistas(oUbicado);
      }
  }
  else Fabricar(oPJ, oUbicado);

  DeleteLocalObject(oUbicado,"fnPJ");

  //Una vez fabricado limpiamos las variables locales de la mesa de procesado que se hayan podido utilizar
  DeleteLocalInt(oUbicado,"NivelPJMinimo");
  DeleteLocalInt(oUbicado,"OroGastar");
  DeleteLocalInt(oUbicado,"XpGastar");
  DeleteLocalObject(oUbicado, "ObjetoCreado");
  DeleteLocalInt(oUbicado,"NivelPJMinimo");
  DeleteLocalInt(oUbicado,"OROVENTA");
  DeleteLocalInt(oUbicado,"Dificultad");
  DeleteLocalString(oUbicado,"RecetaCrear");

  int x;
  for(x=0; x < 10; x++)
  {
      DeleteLocalInt(oUbicado,"Habilidad" + IntToString(x));
      DeleteLocalInt(oUbicado,"HabilidadRango" + IntToString(x));
      DeleteLocalInt(oUbicado,"Talento" + IntToString(x));
      DeleteLocalInt(oUbicado,"Clase" + IntToString(x));
      DeleteLocalInt(oUbicado,"ClaseRango" + IntToString(x));
      DeleteLocalInt(oUbicado,"BonoAtributo" + IntToString(x));
      DeleteLocalInt(oUbicado,"BonoRacial" + IntToString(x));
      DeleteLocalString(oUbicado,"BonoRacial" + IntToString(x));
  }
}
