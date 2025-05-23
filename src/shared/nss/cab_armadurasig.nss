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
      if(iAparienciaCaballo == 508) iAparienciaCaballoSiguiente = 552;
      else if(iAparienciaCaballo == 552) iAparienciaCaballoSiguiente = 556;
      else if(iAparienciaCaballo == 556) iAparienciaCaballoSiguiente = 561;
      else if(iAparienciaCaballo == 561) iAparienciaCaballoSiguiente = 496;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  // Caballo gris 1.69
  else if(sResRefCaballo == "cab_gris169")
  {
      if(iAparienciaCaballo == 521) iAparienciaCaballoSiguiente = 551;
      else if(iAparienciaCaballo == 551) iAparienciaCaballoSiguiente = 557;
      else if(iAparienciaCaballo == 557) iAparienciaCaballoSiguiente = 560;
      else if(iAparienciaCaballo == 560) iAparienciaCaballoSiguiente = 509;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  // Caballo negro 1.69
  else if(sResRefCaballo == "cab_negro169")
  {
      if(iAparienciaCaballo == 547) iAparienciaCaballoSiguiente = 553;
      else if(iAparienciaCaballo == 553) iAparienciaCaballoSiguiente = 555;
      else if(iAparienciaCaballo == 555) iAparienciaCaballoSiguiente = 559;
      else if(iAparienciaCaballo == 559) iAparienciaCaballoSiguiente = 535;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  // Caballo moteado 1.69
  else if(sResRefCaballo == "cab_moteado169")
  {
      if(iAparienciaCaballo == 534) iAparienciaCaballoSiguiente = 554;
      else if(iAparienciaCaballo == 554) iAparienciaCaballoSiguiente = 558;
      else if(iAparienciaCaballo == 558) iAparienciaCaballoSiguiente = 522;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  // Caballo pesadilla 1.69
  else if(sResRefCaballo == "cab_pesadilla169")
  {
      if(iAparienciaCaballo == 550) iAparienciaCaballoSiguiente = 548;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  // Uniconio blanco CEP
  else if(sResRefCaballo == "cab_uniblancocep")
  {
      if(iAparienciaCaballo == 3589) iAparienciaCaballoSiguiente = 3577;  //2588-2576
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  // Unicornio negro CEP
  else if(sResRefCaballo == "cab_uninegrocep")
  {
      if(iAparienciaCaballo == 3531) iAparienciaCaballoSiguiente = 3519; //2530-2518
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  // Caballo blanco CEP
  else if(sResRefCaballo == "cab_blanco169")
  {
      if(iAparienciaCaballo == 3596) iAparienciaCaballoSiguiente = 3590; //2595-2589
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  // Caballo muerto viviente CEP
  else if(sResRefCaballo == "cab_muertoviv")
  {
      if(iAparienciaCaballo == 1059) iAparienciaCaballoSiguiente = 1057; //4904-4902 3903-3901
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  // Grifo CEP
  else if(sResRefCaballo == "cab_grifo")
  {
      if(iAparienciaCaballo == 4914) iAparienciaCaballoSiguiente = 4912; //3913-3911
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }
  // Grifo PROJECT Q
  else if(sResRefCaballo == "cab_grifo2")
  {
      if(iAparienciaCaballo == 1163) iAparienciaCaballoSiguiente = 1161;
      else iAparienciaCaballoSiguiente = iAparienciaCaballo;
  }

  // Hipogrifo CEP
  else if(sResRefCaballo == "cab_hipogrifo")
  {
      if(iAparienciaCaballo == 4917) iAparienciaCaballoSiguiente = 4915;  //3916-3914
      else iAparienciaCaballoSiguiente = iAparienciaCaballo + 1;
  }

  AplicarArmaduraMontura(oPC, iAparienciaCaballoSiguiente);
  SetCreatureAppearanceType(OBJECT_SELF, iAparienciaCaballoSiguiente);
}
