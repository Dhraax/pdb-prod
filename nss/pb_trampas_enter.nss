//::////////////////////////////////////////////////////////////////////////////
//:: TRAMPAS ALEATORIAS
//:: Copyright (c) www.puertadebaldur.net
//::////////////////////////////////////////////////////////////////////////////
/*
  Este script se pone en el OnEnter del area.
*/
//::////////////////////////////////////////////////////////////////////////////
//:: Creado por: Monti
//:: Creado el: 7 de Enero de 2013
//:: Evento: OnEnter del area
//::////////////////////////////////////////////////////////////////////////////

#include "pb_trampas_inc"

void main()
{

  object oPC = GetEnteringObject();

  object oArea = OBJECT_SELF;

  // Solo Jugadores (ni DM, ni PNJ ni nah)
  if(!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

  // Por si es un area de interior o exterior (vampis)
  if(GetIsAreaInterior(oArea)) ExecuteScript("fvex_area_inside", OBJECT_SELF);
  else ExecuteScript("fvex_area_outsid", OBJECT_SELF);

  // No hay Regeneracion por ahora
  if(GetLocalInt(oArea, "PB_TRAMPAS_REG")) return;

  PBEliminarTrampasDelArea();
  DelayCommand(5.0, PBTrampasColocarTrampasEnElArea());
}
