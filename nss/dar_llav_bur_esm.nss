//::///////////////////////////////////////////////
//:: FileName dar_llav_bur_esm
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 01/01/2006 3:46:32
//:://////////////////////////////////////////////
void main()
{
    // Dar los objetos al que habla
    CreateItemOnObject("llave_burd_esmel", GetPCSpeaker(), 1);


    // Quitar algo de oro al jugador
    TakeGoldFromCreature(100, GetPCSpeaker(), TRUE);
}
