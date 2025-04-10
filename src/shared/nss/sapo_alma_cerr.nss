#include "sapo_cons_alma"
#include "mti_libreria"

void main()
{
  object oUbicado=OBJECT_SELF;
  object oItem = GetFirstItemInInventory();

  while(GetIsObjectValid(oItem))
  {
      DestroyObject(oItem, 0.0);

      oItem = GetNextItemInInventory();
  }

  // Marca el baul visible para poder ser usado
  object oChest = GetLocalObject(OBJECT_SELF, "chest_use");
  SetLocalInt(oChest, "abierto", 0);

  // Destruye el objeto invisible
  DestroyObject(OBJECT_SELF, 0.0);
}
