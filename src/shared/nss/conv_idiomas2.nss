#include "mti_libreria"

void LimpiarIdiomas (object oPC)
{
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if(GetStringLeft(GetTag(oItem), 8) == "hlslang_"){DestroyObject(oItem);}
        oItem = GetNextItemInInventory(oPC);
    }
}

void main()
{
    object oPC = GetPCSpeaker();
    string sTag = GetScriptParam("Tag");

    //Le retiramos todos los idiomas al PJ.
    LimpiarIdiomas (oPC);

    //Damos el idioma deseado.
    CreateItemOnObject(sTag, oPC);
    // DRUIDAS
    if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0)
    {
        // Dar idioma druida
        CreateItemOnObject("hlslang_79", oPC);
    }
    if(GetLevelByClass(CLASS_TYPE_ROGUE, oPC) > 0)
    {
        // Dar idioma argot de los ladrones
        CreateItemOnObject("hlslang_9", oPC);
    }
    //Seteamos los idiomas como aprendidos.
    GuardarIntPersistente(oPC, "ConvIdiomasBasicos", 1);
    BorrarIntPersistente(oPC, "ConvIdiomas");
}
