// SALIDA DEL PLANO DE LA FUGA, TELETRANSPORTE A INICIO

#include "mti_libreria"
#include "dominios_inc"

void Penalizar(object oPC)
{
    int iTotalExp = GetXP(oPC);
    int iPenalizacion = (4*iTotalExp)/100;
    int iNuevaExp = iTotalExp - iPenalizacion;

    if(iNuevaExp > 1000) SetXP(oPC, iNuevaExp);
    else SetXP(oPC, 1000);

    int iOroPenalizacion = GetGold(oPC)/2;
    AssignCommand(oPC, TakeGoldFromCreature(iOroPenalizacion, oPC, TRUE));
}

void main()
{
    object oPC = GetPCSpeaker();

    // Destruimos el cadaver nuestro que haya por el mundo
    object oNuestroCadaver = GetLocalObject(GetModule(), "CAD_" + GetName(oPC));
    if(GetIsObjectValid(oNuestroCadaver) == TRUE)
    {
        object oPoseedorCadaver = GetItemPossessor(oNuestroCadaver);
        if(GetIsObjectValid(oPoseedorCadaver) == TRUE) SendMessageToPC(oPoseedorCadaver, "<c þ >¡" + GetName(oPC) + " ha resucitado! Su cadáver te es eliminado.</c>");
        DestroyObject(oNuestroCadaver);
    }

    // PENALIZACION
    Penalizar(oPC);

    int iOro = ContarItemsInventario(oPC, "NW_IT_GOLD001");
    // Sistema antibugueros de vara, que meten en contenedores oro para no ser penalizados.
    if(iOro > 0 || GetIsObjectValid(GetItemPossessedBy(oPC, "NW_IT_GOLD001")))
    {
        DestruirItemsInventario(oPC, "NW_IT_GOLD001",3);
        SendMessageToAllDMs("KELEMVOR AVISO: El jugador "+GetPCPlayerName(oPC)+", con su personaje "+GetName(oPC,TRUE)+", ha intentado evitar pagar el oro en Kelemvor, metiendo el oro dentro de contenedores, cantidad: "+IntToString(iOro)+".");
        WriteTimestampedLogEntry("KELEMVOR AVISO: El jugador "+GetPCPlayerName(oPC)+", con su personaje "+GetName(oPC,TRUE)+", ha intentado evitar pagar el oro en Kelemvor, metiendo el oro dentro de contenedores, cantidad: "+IntToString(iOro)+".");
        SendMessageToPC(oPC,"<c´$$>Varacho te ha cazado: Ha quedado registrado en el log, y avisado en el canal DM, tu intento de evitar el pago por muerte metiendo oro en contenedores, el monto intentado estafar es de "+IntToString(iOro)+".");
    }

    // Dominios de clerigo, dar o quitar objetos  segun sea el caso
    ConjurosDominios(oPC);

    // Reaplicar efectos
    ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);

    // Evitar abuso resurreccion por deidad
    GuardarIntPersistente(oPC, "NORESDEIDAD", 0);

    // Animaciones y teleport
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), GetLocation(oPC));
    DelayCommand(1.4, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(1.5, AssignCommand(oPC, ActionJumpToLocation(GetStartingLocation())));
}
