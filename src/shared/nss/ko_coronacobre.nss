void main()
{
string sEtiqueta = GetLocalString (OBJECT_SELF,"ETIQUETA_PUERTA");//La variable es la etiqueta de la puerta que abre.
object oPuerta = GetObjectByTag (sEtiqueta);
int iEstado = GetLocked (oPuerta);
object oPC = GetLastUsedBy();

if (iEstado == TRUE)
    {
    PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    SetLocked (oPuerta, FALSE);
    SendMessageToPC(oPC, "<c  ó>*La entrada al cuarto está abierta a cualquiera*</c>");
    }
else{
    SetLocked (oPuerta, TRUE);
    PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
    SendMessageToPC(oPC, "<c  ó>*La entrada al cuarto no está abierta a cualquiera*</c>");
    }
}
