// PAPALERA, SE ELIMINA CUALQUIER OBJETO QUE SE META EN SU INVENTARIO
void main()
{
  object oTrash = GetInventoryDisturbItem();
  DestroyObject(oTrash);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), OBJECT_SELF );
}
