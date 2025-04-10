#include "f_vampire_defs"
#include "f_vampire_spls_h"

void Vampire_NPC_hide(object oNPC)
{
    int Num = 2;
    object oTarget = GetNearestObject(OBJECT_TYPE_DOOR, oNPC);
    while(GetIsObjectValid(oTarget))
        {
        if(GetIsObjectValid(GetTransitionTarget(oTarget)))
            {
            if(GetLocked(oTarget))
                {
                if(!GetPlotFlag(oTarget) && !GetImmortal(oTarget))
                    {
                    ClearAllActions(TRUE);
                    ActionMoveToObject(oTarget, TRUE);
                    ActionAttack(oTarget);
                    ActionJumpToObject(GetTransitionTarget(oTarget));
                    return;
                    }
                }
            else
                {
                ClearAllActions(TRUE);
                ActionMoveToObject(oTarget, TRUE);
                ActionJumpToObject(GetTransitionTarget(oTarget));
                return;
                }
            }
        oTarget = GetNearestObject(OBJECT_TYPE_DOOR, oNPC, Num);
        Num++;
        }
    Num = 2;
    oTarget = GetNearestObject(OBJECT_TYPE_TRIGGER, oNPC);
    while(GetIsObjectValid(oTarget))
        {
        if(GetIsObjectValid(GetTransitionTarget(oTarget)))
            {
            ClearAllActions(TRUE);
            ActionMoveToObject(oTarget, TRUE);
            ActionJumpToObject(GetTransitionTarget(oTarget));
            return;
            }
        oTarget = GetNearestObject(OBJECT_TYPE_TRIGGER, oNPC, Num);
        Num++;
        }
}

void ApplySunDamage(object oWho)
{
    int bOutDoors = GetLocalInt(oWho, "FALLEN_VAMPIRE_OUTDOORS");
    //SendMessageToPC(oWho, "DEBUG: Entrando en ApplySunDamage");

    // Verificar si el vampiro sigue en el exterior y es de día
    if (!GetIsNight() && bOutDoors && GetWeather(GetArea(oWho)) == WEATHER_CLEAR)
    {
        //SendMessageToPC(oWho, "DEBUG: Aplicando daño solar");
        effect eDamage, eDamage2, eVisual;
        int iDamage = 60 + Random(SunDamage);
        int iDamage2 = 60 + Random(SunDamage);

        eVisual = EffectVisualEffect(VFX_DUR_INFERNO);
        eDamage = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
        eDamage2 = EffectDamage(iDamage2, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oWho);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage2, oWho);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oWho, RoundsToSeconds(5));

        // Resetear la advertencia después de aplicar el daño
        SetLocalInt(oWho, "VAMPIRE_WARNING", 0);
    }
    else
    {
        //SendMessageToPC(oWho, "DEBUG: No se aplica daño solar, reseteando advertencia");
        // Resetear la advertencia si ya no está en el exterior o es de noche
        SetLocalInt(oWho, "VAMPIRE_WARNING", 0);
    }
}

void Vampire_Heartbeat(int bFirstTime = TRUE)
{
    object oWho = OBJECT_SELF;
    int bOutDoors = GetLocalInt(oWho, "FALLEN_VAMPIRE_OUTDOORS");

    //SendMessageToPC(oWho, "DEBUG: Entrando en Vampire_Heartbeat");

    //El_Vara añadido: comando para DM: dm_vampsafe. Hace que en el área en el que está el DM, el script de arder no funcione.
    if(GetLocalInt(GetArea(oWho), "dm_vampsafe") == 1 || GetLocalInt(oWho, "dm_vampsafe") == 1)
    {
        SetLocalInt(oWho, "VAMPIRE_WARNING", 0); // Resetear advertencia al estar a cubierto
        return;
    }

    if (GetIsNight() || !bOutDoors)
    {
        //SendMessageToPC(oWho, "DEBUG: Es de noche o no está al aire libre, saliendo de Vampire_Heartbeat");
        SetLocalInt(oWho, "VAMPIRE_WARNING", 0); // Resetear advertencia al estar a cubierto
        return;
    }

    if (bOutDoors && !DamageInBadWeather && GetWeather(GetArea(OBJECT_SELF)) != WEATHER_CLEAR)
    {
        //SendMessageToPC(oWho, "DEBUG: Clima no está despejado, saliendo de Vampire_Heartbeat");
        DelayCommand(30.0, Vampire_Heartbeat(TRUE));
        SetLocalInt(oWho, "VAMPIRE_WARNING", 0); // Resetear advertencia al estar a cubierto
        return;
    }

    if (GetIsPC(oWho))
    {
        if (bFirstTime)
        {
            //SendMessageToPC(oWho, "DEBUG: Primer aviso de advertencia solar");
            FloatingTextStringOnCreature("¡¡La luz solar te abrasa, ponte a cubierto!!", oWho, FALSE);
            SendMessageToPC(oWho, "<c´$$>¡¡La luz solar te abrasa, ponte a cubierto!!</c>");
            SetLocalInt(oWho, "VAMPIRE_WARNING", 1); // Establecer la advertencia
            DelayCommand(10.0, Vampire_Heartbeat(FALSE)); // Esperar 10 segundos antes de revisar de nuevo
        }
        else if (GetLocalInt(oWho, "VAMPIRE_WARNING") == 1)
        {
            //SendMessageToPC(oWho, "DEBUG: Aplicando daño después de la advertencia");
            ApplySunDamage(oWho); // Aplicar daño si la advertencia está activa
        }
    }
    else
    {
        Vampire_NPC_hide(oWho);
    }

    DelayCommand(30.0, Vampire_Heartbeat(FALSE));
}


void main()
{
    Vampire_Heartbeat(TRUE);
}
