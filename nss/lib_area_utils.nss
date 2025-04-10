// Función utilizada para buscar un objeto mediante el tag dentro de un área específica
// oArea - Área en el que buscar
// sTag - Tag a buscar
object GetObjectByTagInArea(object oArea, string sTag);

object GetObjectByTagInArea(object oArea, string sTag) {
    object oObject = GetObjectByTag(sTag);
    int i = 0;

    while(GetIsObjectValid(oObject))
    {
        if (GetArea(oObject) == oArea) return oObject;
        oObject = GetObjectByTag(sTag, ++i);
    }

    return OBJECT_INVALID;
}
