#include "cab_inc"
int StartingConditional()
{
  if(VerSiEsMonturaAntigua() == TRUE) return FALSE;

  string sResrefMontura = GetResRef(OBJECT_SELF);
  if(sResrefMontura == "cab_uniblancocl1"   ||
     sResrefMontura == "cab_uniblancocl2"   ||
     sResrefMontura == "cab_jabalired"      ||
     sResrefMontura == "cab_jabalired2"     ||
     sResrefMontura == "cab_jabaligrey"     ||
     sResrefMontura == "cab_jabaligrey2"    ||
     sResrefMontura == "cab_jabalinegro"    ||
     sResrefMontura == "cab_jabalinegro2"   ||
     sResrefMontura == "cab_leon"           ||
     sResrefMontura == "cab_leona"          ||
     sResrefMontura == "cab_perro"          ||
     sResrefMontura == "cab_leopardo"       ||
     sResrefMontura == "cab_lagartoverde"   ||
     sResrefMontura == "cab_lagartonaran"   ||
     sResrefMontura == "cab_loboterr"       ||
     sResrefMontura == "cab_huargo"         ||
     sResrefMontura == "cab_jarilith"       ||
     sResrefMontura == "cab_pegasoblanco"   ||
     sResrefMontura == "cab_pegasonegro"    ||
     sResrefMontura == "cab_pegasomarron"   ||
     sResrefMontura == "cab_cabranegra"     ||
     sResrefMontura == "cab_cabramarron"    ||
     sResrefMontura == "cab_cabramoteada"   ||
     sResrefMontura == "cab_cabrablanca"    ||
     sResrefMontura == "cab_osopolar"       ||
     sResrefMontura == "cab_osomarron"      ||
     sResrefMontura == "cab_osonegro"       ||
     sResrefMontura == "cab_oso"            ||
     sResrefMontura == "cab_ciervo") return FALSE;

  return TRUE;
}

