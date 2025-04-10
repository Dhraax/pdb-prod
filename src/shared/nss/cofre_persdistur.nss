//::///////////////////////////////////////////////
//:: Secure Persistent Chest System v2.0
//:: spcs_disturb
//:://////////////////////////////////////////////
/*
This is the OnDisturb event script for the SPCS.  It will fire anytime an object
is placed within the chest.  It also performs basic counting functions and can
be used to limit the size of the DB and the number of object that can be placed
into the chest by a player.
*/
//:://////////////////////////////////////////////
//:: Created By: Ophidios
//:: Created On: 8/8/2005
//:://////////////////////////////////////////////

void main()
{

int iCheck = 0; // Integer used to check the number of objects in the chest
int iMax = 125;  // Integer used to determine the maximum number of objects that can be placed into the chest

// Defines the player object and also determines the item being added to or
// taken from the chest.
object oPC = GetLastDisturbed();
object oItem = GetInventoryDisturbItem();

// Runs a check to ensure that the item being placed into the storage chest is
// not a Bag of Holding or any other container.
object oTest = GetFirstItemInInventory(oItem);
if (GetIsObjectValid(oTest))
    {
    FloatingTextStringOnCreature("*¡No puedes guardar un recipiente dentro de otro!*", oPC, FALSE);
    while (GetIsObjectValid(oTest))
        {
        CopyItem(oTest, oPC);
        DestroyObject(oTest, 0.0);
        oTest = GetNextItemInInventory(oItem);
        }
    CreateItemOnObject("it_contain002", oPC, 1);
    DestroyObject(oItem, 0.0);
    return;
    }


// A quick counting function.  It merely counts the number of objects for later
// checks and use.
object oCount = GetFirstItemInInventory();
while (GetIsObjectValid(oCount))
    {
    iCheck++;
    oCount = GetNextItemInInventory();
    }

// This will merely check the total number of items, and if it exceeds the iMax
// setting it will return the object back to the player.
if(iCheck > iMax)
    {
    //ActionGiveItem(oItem, oPC);

    if(GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
       {
        object oInv = GetFirstItemInInventory();
        oInv = GetNextItemInInventory();

        if(GetIsObjectValid(oInv) == TRUE)
           {
            CopyObject(oInv, GetLocation(OBJECT_SELF), oPC);
            DestroyObject(oInv);
           }
        }

    FloatingTextStringOnCreature("*¡No puedes guardar más de " + IntToString(iMax) + " objetos en la caja fuerte!*", oPC);
    iCheck = iMax;
    }

// Returns to the player the number of objects stored in the chest currently.
// This will fire when an object is placed into or taken out of the chest.
string sCheck = IntToString(iCheck);
SendMessageToPC(oPC, "Tienes " + sCheck + " objetos guardados.");
}
