void main()
{
  object oPC = GetLastDisturbed();
  object oObjeto = GetInventoryDisturbItem();

  if(GetLocalInt(oObjeto, "OROVENTAC") > 0)
  {
      if(GetBaseItemType(oObjeto) == BASE_ITEM_BOLT ||
         GetBaseItemType(oObjeto) == BASE_ITEM_ARROW)
      {
          if(GetItemStackSize(oObjeto) == 99)
          {
              int iOroVenta = GetLocalInt(oObjeto, "OROVENTAC");
              GiveGoldToCreature(oPC, iOroVenta);
              FloatingTextStringOnCreature("*Has vendido el objeto por " + IntToString(iOroVenta) + " po*", oPC, FALSE);
              DestroyObject(oObjeto);
              return;
          }
          else
          {
              CopyObject(oObjeto, GetLocation(OBJECT_SELF), oPC);
              DestroyObject(oObjeto);
              FloatingTextStringOnCreature("¡Las flechas y virotes se venden de 99 en 99!", oPC, FALSE);
          }
      }

      else
      {
          int iOroVenta = GetLocalInt(oObjeto, "OROVENTAC");
          GiveGoldToCreature(oPC, iOroVenta);
          FloatingTextStringOnCreature("*Has vendido el objeto por " + IntToString(iOroVenta) + " po*", oPC, FALSE);
          DestroyObject(oObjeto);
          return;
      }
  }

  else
  {
      CopyObject(oObjeto, GetLocation(OBJECT_SELF), oPC);
      DestroyObject(oObjeto);
      FloatingTextStringOnCreature("¡No puedes vender este objeto aquí!", oPC, FALSE);
  }
}
