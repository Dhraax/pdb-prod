#include "dote_comp_armas"

void LimpiarInventario(object oPC)
{
     object oItem;
     oItem = GetFirstItemInInventory(oPC); //Sin equipar
     while(GetIsObjectValid(oItem))
     {
        EliminarPropiedadesTemporales(oItem);
        oItem = GetNextItemInInventory(oPC);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//Equipado
     {
        oItem = GetItemInSlot(i, oPC);
        EliminarPropiedadesTemporales(oItem);
     }
}

void ApplyAutoFrenzy(object oPC, object oArmor)
{
     IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void main()
{
  object oPC = GetExitingObject();
  //Scripts para eliminar los pnj del área.
  ExecuteScript ("z0_area_onexit", oPC);
  if(GetIsObjectValid(oPC) != TRUE) return;

  // Eliminacion propiedades temporales de objetos equipados
  if(GetIsPC(oPC))LimpiarInventario(oPC);

    //Bersekers no deben perder la propiedad de su armadura que le hace meterse en frénesi.
    if(GetLevelByClass(CLASS_TYPE_BERSERKER, oPC) > 0 )
    {
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        if (GetIsObjectValid(oArmor))
        {
            ApplyAutoFrenzy(oPC, oArmor);
        }
    }
}

