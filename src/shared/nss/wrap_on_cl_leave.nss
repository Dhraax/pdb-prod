//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  wrap_on_clnt_leave                                //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ON_CLIENT_ENTER PARA EL SERVIDOR PUERTA DE BALDUR              //:://
//:: Creado por Monti                                                     //:://
//::////////////////////////////////////////////////////////////////////////////

#include "f_vampire_clexit"
#include "tj_inc"
#include "nwnx_chat"
#include "x0_i0_spells"
#include "pb_constantes"
#include "inc_sum_golem"
#include "lib_disguise"

void main()
{
    object oPC = GetExitingObject();
    SetLocalInt(oPC, "PJ_SALIO", 1);

    // PUESTO DE VENTA DEL JUGADOR, ELIMINAR UBICADOS
    EliminarUbicadosTJ(oPC);

    // ELIMINAR LOS SERVICIOS DE LOS AYUDANTES
    /* object oAyudante1 = GetHenchman(oPC, 1);
    object oAyudante2 = GetHenchman(oPC, 2);
    object oAyudante3 = GetHenchman(oPC, 3);
    object oAyudante4 = GetHenchman(oPC, 4);
    if(oAyudante1 != OBJECT_INVALID) RemoveHenchman(oPC, oAyudante1); AssignCommand(oAyudante1, SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oAyudante1, 0.5);
    if(oAyudante2 != OBJECT_INVALID) RemoveHenchman(oPC, oAyudante2); AssignCommand(oAyudante2, SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oAyudante2, 0.5);
    if(oAyudante3 != OBJECT_INVALID) RemoveHenchman(oPC, oAyudante3); AssignCommand(oAyudante3, SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oAyudante3, 0.5);
    if(oAyudante4 != OBJECT_INVALID) RemoveHenchman(oPC, oAyudante4); AssignCommand(oAyudante4, SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oAyudante4, 0.5);   */

    if (GetSubRace(oPC) != "")
    {
        if (GetIsVampire(oPC))
        {
            // SUBRAZA VAMPIROS
            Vampire_Client_Exit(oPC);
        }
    }
    //Golem System
    SaveAndDestroyActiveGolem(oPC);
    // PERSISTENCIA EN CIERTOS LUGARES DEL SERVIDOR
    int iColis = GetLocalInt(oPC, "ESTOYENELCOLISEO");
    int iTorre = GetLocalInt(oPC, "NIVELTORRE");
    int iThor1 = GetLocalInt(oPC, "ESTOYENTHORMALLEM");
    int iThor2 = GetLocalInt(oPC, "ESTOYENTHORMALLEM2");
    int iZapSune = GetLocalInt(oPC, "ESTOYENZAPSUNE");

    if(iColis > 0 || iTorre > 0 || iThor1 > 0 || iThor2 > 0 || iZapSune > 0) ExecuteScript("persist_lug_srv2", OBJECT_SELF);

    // GUARDAR VIDA PERSISTENTE (no se guarda si estas introduciendo la contrasenya de seguridad)
    if(GetLocalInt(oPC, "SEG_OCUPADO") == FALSE)
    {
        int VidaAGuardar;
        string sNombrePJ=GetName(oPC)+ GetPCPlayerName(oPC);
        if(GetTag(GetArea(oPC)) == "arena") {VidaAGuardar = GetMaxHitPoints(oPC);}
        else {VidaAGuardar = GetCurrentHitPoints(oPC);}

        SetCampaignInt(ObjectToString(GetModule()), sNombrePJ, VidaAGuardar);
    }

    //GUARDAR EL NOMBRE DEL PJ PARA SCRIPTS DE DISFRAZ
    string sNombre = GetName(oPC, TRUE);
    string sNombreExiste = GetCampaignString(ObjectToString(GetModule()), sNombre);
    if(sNombreExiste != "Existo") SetCampaignString(ObjectToString(GetModule()), sNombre , "Existo");

    // Limpieza de variables
    DeleteLocalInt(oPC, "DERRIBADO");
    DeleteLocalInt(oPC, "AOE_" + IntToString(AOE_PER_WARLOCK_WALLFIRE));
    DeleteLocalInt(oPC, "CLS_ING_SPELLUSADO");  //Variable del Artífice: Identifica el spell usado para no dejar usar otro diferente.
    DeleteLocalInt(oPC, "CLS_ING_TSPELLUSADO"); //Variable del Artífice: Ayuda a saltar el mensaje de poder usar otro spell.
    DeleteLocalInt(oPC, "CLS_ING_PROTECTOR");   //Variable del Artífice: Controla el uso de la invocación protector.
    DeleteLocalInt(oPC, "CLS_ING_CIBORG");      //Variable del Artífice: Controla el uso de la invocación ciborg.
    DeleteLocalInt(oPC, "CLS_ING_GOMA");        //Variable del Artífice: Controla el uso de la invocación goma viscosa.
    DeleteLocalInt(oPC, "CLS_ING_ELIXIRCON");   //Variable del Artífice: Controla el uso de la invocación elixir de conocimiento.
    DeleteLocalInt(oPC, "CLS_ING_ELIXIRBERS");  //Variable del Artífice: Controla el uso de la invocación elixir de berserker.
    DeleteLocalInt(oPC, "CLS_ING_POTENCIACION");//Variable del Artífice: Controla el uso de la invocación elixir de potenciación.

    //SISTEMA DE MENSAJES DE ENTRADA Y SALIDA PARA QUE LA GENTE VEA SI ENTRAS O SALES.
    MensajeEntradaoSalida (oPC, 2);
}
