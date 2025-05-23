void main()
{
  object oPC = GetLastDisturbed();
  object oObjeto = GetInventoryDisturbItem();

  if(GetLocalInt(oObjeto, "OROVENTAO") > 0)
  {
          int iOroVenta = GetLocalInt(oObjeto, "OROVENTAO");
          GiveGoldToCreature(oPC, iOroVenta);
          FloatingTextStringOnCreature("*Has vendido el objeto por " + IntToString(iOroVenta) + " po*", oPC, FALSE);
          DestroyObject(oObjeto);
          return;
  }

  else
  {
      CopyObject(oObjeto, GetLocation(OBJECT_SELF), oPC);
      DestroyObject(oObjeto);
      FloatingTextStringOnCreature("¡No puedes vender este objeto aquí!", oPC, FALSE);
  }
}
