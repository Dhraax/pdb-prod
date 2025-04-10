// Función para recuperar la distancia a la que se encuentran dos objetos teniendo en cuenta su área actual.
float PB_Object_GetDistanceBetween(object oObject1, object oObject2);

// Función para comprobar si un objeto se encuentra en el mismo área y a una distancia específica en relación a otro objeto.
int PB_Object_IsWithinRange(object oObject1, object oObject2, float fMinDistance, float fMaxDistance);

float PB_Object_GetDistanceBetween(object oObject1, object oObject2) {
    if (GetArea(oObject1) != GetArea(oObject2)) return 0.0;
    else return GetDistanceBetween(oObject1, oObject2);
}

int PB_Object_IsWithinRange(object oObject1, object oObject2, float fMinDistance, float fMaxDistance) {
    float fDistance = PB_Object_GetDistanceBetween(oObject1, oObject2);

    return (fDistance >= fMinDistance && fDistance <= fMaxDistance);
}
