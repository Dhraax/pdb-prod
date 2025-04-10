void main()
{
object oPC = GetLastUsedBy();

if(!GetIsPC(oPC)) return;
if(GetItemPossessedBy(oPC, "Simboloimperiobanita")== OBJECT_INVALID)
   {
   return;
   }
else
   {
   object punto1 = GetWaypointByTag("ib_base_puntoruta_sanctafuera");
   object punto2 = GetNearestObjectByTag("Arcania_finescudriamiento");
   location lpunto1 = GetLocation(punto1);
   location lpunto2 = GetLocation(punto2);
   effect oculto1 = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);

   DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,oculto1,oPC,245.0);
   DelayCommand(5.0, AssignCommand(oPC, ActionJumpToLocation(lpunto1)));
   DelayCommand(245.0, AssignCommand(oPC, ActionJumpToLocation(lpunto2)));
   }
}
