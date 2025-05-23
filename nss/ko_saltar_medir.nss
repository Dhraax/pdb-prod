
int StartingConditional()
{

string sEtiquetaDestino = GetLocalString (OBJECT_SELF, "DESTINO");
object oDestino = GetNearestObjectByTag (sEtiquetaDestino, OBJECT_SELF);
float fDistanciaFloat = GetDistanceBetween (OBJECT_SELF, oDestino);
int iDistanciaInt = FloatToInt(fDistanciaFloat)*3;
string sDistanciaString = IntToString(iDistanciaInt);

SetCustomToken (7000, sDistanciaString);
SetLocalInt (OBJECT_SELF, "DISTANCIA", iDistanciaInt);

return TRUE;
}
