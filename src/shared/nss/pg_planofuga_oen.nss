//::////////////////////////////////////////////////////////////////////////////
//:: On Enter Plano de Fuga                                               //:://
//::////////////////////////////////////////////////////////////////////////////
#include "HC_Inc_HTF"
//::////////////////////////////////////////////////////////////////////////////
void main()
{
    object oPC = GetEnteringObject();
    //Scripts para eliminar los pnj del área.
    ExecuteScript ("z0_area_onenter", oPC);
    // Solo los jugadores activan este script
    if(!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

    // Funciones generales
    SetImmortal(oPC, TRUE);
    ExploreAreaForPlayer(GetArea(oPC), oPC);

    // Reseteamos sistema de hambre/sed/cansancio
    ResetHTFLevels(oPC);

    // Destruir todos los cadaveres del inventario (si tuviera)
    object oCadaver = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oCadaver) == TRUE)
    {
        if(GetStringLeft(GetTag(oCadaver), 10) == "pg_cadaver") DestroyObject(oCadaver);

        oCadaver = GetNextItemInInventory(oPC);
    }

    // Decorar el area (solo una vez)
    object oMod = GetModule();
    int iUnaVez = GetLocalInt(oMod, "DECORAR_PLANO_FUGA");
    if(iUnaVez == FALSE)
    {
        SetLocalInt(oMod, "DECORAR_PLANO_FUGA", TRUE);

        object oMuro = GetFirstObjectInArea(OBJECT_SELF);
        while(GetIsObjectValid(oMuro) == TRUE)
        {
            if(GetObjectType(oMuro) == OBJECT_TYPE_PLACEABLE)
            {
                if(GetTag(oMuro) == "pg_muro") ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_PULSE_GREEN_BLACK), oMuro);
            }

            oMuro = GetNextObjectInArea(OBJECT_SELF);
        }

        object oKelemvor = GetNearestObjectByTag("pg_kelemvor", oPC);
        object oYergal = GetNearestObjectByTag("pg_yergal", oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_WHITE), oKelemvor);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_WHITE), oYergal);
    }

    // No quema el sol para vampiros
    ExecuteScript("fvex_area_inside",OBJECT_SELF);

    // Reajuste de facciones
    ExecuteScript("facciones",OBJECT_SELF);

    // Si esta introduciendo la contrasenya de seguridad, se salta la animacion
    if(GetLocalInt(oPC, "SEG_OCUPADO"))
    {
        // Efectos visuales de fantasma al PJ
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GHOST_SMOKE_2), oPC));
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GHOST_TRANSPARENT), oPC));
        return;
    }
}
