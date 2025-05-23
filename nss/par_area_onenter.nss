void main()
{
  object oPC = GetEnteringObject();

  // Funciones generales
  ExploreAreaForPlayer(GetArea(oPC), oPC);

  // Decorar el area (solo una vez)
  object oMod = GetModule();
  int iUnaVez = GetLocalInt(oMod, "DECORAR_PARAMOS");
  if(iUnaVez == FALSE)
  {
      SetLocalInt(oMod, "DECORAR_PARAMOS", TRUE);

      object oArbol = GetFirstObjectInArea(OBJECT_SELF);
      while(GetIsObjectValid(oArbol) == TRUE)
      {
          if(GetObjectType(oArbol) == OBJECT_TYPE_PLACEABLE)
          {
              if(GetTag(oArbol) == "par_arbolnodo") ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(514), oArbol);
          }

          oArbol = GetNextObjectInArea(OBJECT_SELF);
      }
  }

  // Quema el sol para vampiros
  ExecuteScript("fvex_area_outside",OBJECT_SELF);
}
