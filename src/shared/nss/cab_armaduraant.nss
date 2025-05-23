#include "cab_inc"

void main()
{
  object oPC = GetPCSpeaker();
  string sResRefCaballo = GetResRef(OBJECT_SELF);
  int iAparienciaCaballo = GetAppearanceType(OBJECT_SELF);
  int iAparienciaCaballoSiguiente;

  // Caballo marron 1.69
  if(sResRefCaballo == "cab_marron169")
  {
      if(iAparienciaCaballo == 496) iAparienciaCaballoSiguiente = 561;
      else if(iAparienciaCaballo == 561) iAparienciaCaballoSiguiente = 556;
      else if(iAparienciaCaballo == 556) iAparienciaCaballoSiguiente = 552;
      else if(iAparienciaCaballo == 552) iAparienciaCaballoSiguiente = 508;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  // Caballo gris 1.69
  else if(sResRefCaballo == "cab_gris169")
  {
      if(iAparienciaCaballo == 509) iAparienciaCaballoSiguiente = 560;
      else if(iAparienciaCaballo == 560) iAparienciaCaballoSiguiente = 557;
      else if(iAparienciaCaballo == 557) iAparienciaCaballoSiguiente = 551;
      else if(iAparienciaCaballo == 551) iAparienciaCaballoSiguiente = 521;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  // Caballo negro 1.69
  else if(sResRefCaballo == "cab_negro169")
  {
      if(iAparienciaCaballo == 535) iAparienciaCaballoSiguiente = 559;
      else if(iAparienciaCaballo == 559) iAparienciaCaballoSiguiente = 555;
      else if(iAparienciaCaballo == 555) iAparienciaCaballoSiguiente = 553;
      else if(iAparienciaCaballo == 553) iAparienciaCaballoSiguiente = 547;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  // Caballo moteado 1.69
  else if(sResRefCaballo == "cab_moteado169")
  {
      if(iAparienciaCaballo == 522) iAparienciaCaballoSiguiente = 558;
      else if(iAparienciaCaballo == 558) iAparienciaCaballoSiguiente = 554;
      else if(iAparienciaCaballo == 554) iAparienciaCaballoSiguiente = 534;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  // Caballo pesadilla 1.69
  else if(sResRefCaballo == "cab_pesadilla169")
  {
      if(iAparienciaCaballo == 548) iAparienciaCaballoSiguiente = 540;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  // Uniconio blanco CEP
  else if(sResRefCaballo == "cab_uniblancocep")
  {
      if(iAparienciaCaballo == 3577) iAparienciaCaballoSiguiente = 3589;  //2576-2588
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  // Unicornio negro CEP
  else if(sResRefCaballo == "cab_uninegrocep")
  {
      if(iAparienciaCaballo == 3519) iAparienciaCaballoSiguiente = 3531; //2518-2530
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  // Caballo blanco CEP
  else if(sResRefCaballo == "cab_blanco169")
  {
      if(iAparienciaCaballo == 3590) iAparienciaCaballoSiguiente = 3596; //2589-2595
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  // Caballo muerto viviente CEP
  else if(sResRefCaballo == "cab_muertoviv")
  {
      if(iAparienciaCaballo == 1057) iAparienciaCaballoSiguiente = 1059; //4902-4904 3901-3903
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  // Grifo CEP
  else if(sResRefCaballo == "cab_grifo")
  {
      if(iAparienciaCaballo == 4912) iAparienciaCaballoSiguiente = 4914; //3911-3913
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }
  // Grifo PROJECT Q
  else if(sResRefCaballo == "cab_grifo2")
  {
      if(iAparienciaCaballo == 1161) iAparienciaCaballoSiguiente = 1163;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo;
  }

  // Hipogrifo CEP
  else if(sResRefCaballo == "cab_hipogrifo")
  {
      if(iAparienciaCaballo == 4915) iAparienciaCaballoSiguiente = 4917; //3914-3916
      else iAparienciaCaballoSiguiente = iAparienciaCaballo - 1;
  }

  AplicarArmaduraMontura(oPC, iAparienciaCaballoSiguiente);
  SetCreatureAppearanceType(OBJECT_SELF, iAparienciaCaballoSiguiente);
}
