void main()
{
   if(GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
   {

  object oObjeto = GetInventoryDisturbItem();
  object oPC = GetLastDisturbed();
  object oPolvo = GetObjectByTag("polvoantiluz");

if(GetItemPossessedBy(oPC,"polvoantiluz")== OBJECT_INVALID)
  {
  FloatingTextStringOnCreature("¡Necesitas tener polvo de antiluz!",oPC);
  return;
  }
  itemproperty ePropiedad = GetFirstItemProperty(oObjeto);

DestroyObject(oPolvo,1.0);


if(GetItemHasItemProperty(oObjeto,44) == FALSE)
    {
    FloatingTextStringOnCreature("El objeto no tenía luz...",oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), OBJECT_SELF );
    return;
    }

  while(GetIsItemPropertyValid(ePropiedad))
  {
      if(GetItemPropertyType(ePropiedad) == 44)
      {
          RemoveItemProperty(oObjeto, ePropiedad);
      }
      ePropiedad = GetNextItemProperty(oObjeto);
  }

    effect e1 = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);
    effect e2 = EffectVisualEffect(VFX_IMP_BREACH);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,e1,OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,e2,OBJECT_SELF);

       }
 }



