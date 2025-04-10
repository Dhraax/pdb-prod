void main()
{
object oPC = GetLastDisturbed();
object oObjeto = GetInventoryDisturbItem();
int iTipoDisturbio = GetInventoryDisturbType();

string sIdentidad = GetName(oPC, TRUE) + GetPCPublicCDKey(oPC);
string sVariable = GetLocalString(OBJECT_SELF, "TJIDENTIDAD");

if(iTipoDisturbio == INVENTORY_DISTURB_TYPE_ADDED)
{
     if(sVariable == sIdentidad)
     {
         int iNumeroObjetos = 0;
         object oCuenta = GetFirstItemInInventory();
         while(GetIsObjectValid(oCuenta))
         {
             iNumeroObjetos++;
             oCuenta = GetNextItemInInventory();
         }

         if(iNumeroObjetos > 75)
         {
             CopyObject(oObjeto, GetLocation(OBJECT_SELF), oPC);
             DestroyObject(oObjeto);
             FloatingTextStringOnCreature("*¡No puedes meter más de 75 objetos en el mostrador!*", oPC);
             return;
         }

         if(GetLocalInt(oObjeto, "TJNOMOSTRADOR") == 1)
         {
             FloatingTextStringOnCreature("*¡No puedes meter este objeto en el mostrador!*", oPC, FALSE);
             CopyObject(oObjeto, GetLocation(oPC), oPC);
             DestroyObject(oObjeto);
             return;
         }

         if(GetBaseItemType(oObjeto) == BASE_ITEM_ARROW ||
            GetBaseItemType(oObjeto) == BASE_ITEM_BOLT ||
            GetBaseItemType(oObjeto) == BASE_ITEM_BULLET ||
            GetBaseItemType(oObjeto) == BASE_ITEM_DART ||
            GetBaseItemType(oObjeto) == BASE_ITEM_GEM ||
            GetBaseItemType(oObjeto) == BASE_ITEM_GOLD ||
            GetBaseItemType(oObjeto) == BASE_ITEM_HEALERSKIT ||
            GetBaseItemType(oObjeto) == BASE_ITEM_POTIONS ||
            GetBaseItemType(oObjeto) == BASE_ITEM_SCROLL ||
            GetBaseItemType(oObjeto) == BASE_ITEM_THIEVESTOOLS ||
            GetBaseItemType(oObjeto) == BASE_ITEM_SHURIKEN ||
            //GetBaseItemType(oObjeto) == BASE_ITEM_LARGEBOX ||
            GetBaseItemType(oObjeto) == BASE_ITEM_GRENADE ||
            GetBaseItemType(oObjeto) == BASE_ITEM_ENCHANTED_POTION ||
            GetBaseItemType(oObjeto) == BASE_ITEM_ENCHANTED_SCROLL ||
            GetBaseItemType(oObjeto) == BASE_ITEM_SPELLSCROLL ||
            GetBaseItemType(oObjeto) == BASE_ITEM_THROWINGAXE)
         {
             FloatingTextStringOnCreature("*¡No puedes meter objetos acumulables en el mostrador!*", oPC, FALSE);
             CopyObject(oObjeto, GetLocation(oPC), oPC);
             DestroyObject(oObjeto);
             return;
         }

         if(GetLocalString(OBJECT_SELF, GetName(oObjeto) + GetName(oPC,TRUE)) == GetName(oObjeto))
         {
             FloatingTextStringOnCreature("*¡Ya has metido un objeto con el mismo nombre!*", oPC, FALSE);
             CopyObject(oObjeto, GetLocation(oPC), oPC);
             DestroyObject(oObjeto);
             return;
         }

         /*if(GetLocalInt(oObjeto, "TJNOMASCOPIAS") == 1)
         {
             FloatingTextStringOnCreature("*¡Ya has metido ese objeto en el mostrador!*", oPC, FALSE);
             CopyObject(oObjeto, GetLocation(oPC), oPC);
             DestroyObject(oObjeto);
             return;
         }*/

         object oCopiaObjeto = CopyObject(oObjeto, GetLocation(oPC), oPC);
         SetLocalString(OBJECT_SELF, GetName(oObjeto) + GetName(oPC,TRUE), GetName(oObjeto));
         SetPlotFlag(oObjeto, TRUE);
         SetStolenFlag(oObjeto, TRUE);
         return;
     }
     else
     {
         FloatingTextStringOnCreature("*¡No puedes añadir objetos en este mostrador!*", oPC, FALSE);
         CopyObject(oObjeto, GetLocation(oPC), oPC);
         DestroyObject(oObjeto);
         return;
     }
}

if(iTipoDisturbio == INVENTORY_DISTURB_TYPE_REMOVED)
{
     if(sVariable == sIdentidad)
     {
         SendMessageToPC(oPC, "<cúP(>No puedes quitar los objetos del mostrador directamente. Tendrás que vaciar todo el inventario a través de la conversación del cartel.</c>");
         CopyObject(oObjeto, GetLocation(oPC), OBJECT_SELF);
         DestroyObject(oObjeto);
         return;
     }
     else
     {
         FloatingTextStringOnCreature("*¡Eso no es tuyo!*", oPC, FALSE);
         CopyObject(oObjeto, GetLocation(oPC), OBJECT_SELF);
         DestroyObject(oObjeto);
         return;
     }
}
}
