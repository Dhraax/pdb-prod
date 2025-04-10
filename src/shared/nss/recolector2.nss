#include "nw_i0_2q4luskan"

void main()
{
    //A las 12 horas, creamos una copia del ubicado actual.
    string sTagUbicado = GetTag(OBJECT_SELF);
    location lLugarActual = GetLocation(OBJECT_SELF);
    DelayCommand(2280.0, CreateObjectVoid(OBJECT_TYPE_PLACEABLE, sTagUbicado, lLugarActual, FALSE));
}
