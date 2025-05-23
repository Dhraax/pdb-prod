void main()
{
object oPJ = GetLastUsedBy();
object oTrampilla_cloak = GetObjectByTag("trampilla_subida_puerto");
object oTrampilla_gatos = GetObjectByTag("Trampilla_gatos_puerto");
location lLugar = GetLocation(GetWaypointByTag("hacia_casa_gatos"));
int iVariable1 = GetLocalInt(oTrampilla_cloak, "TRAMPILLA_CASA_GATOS");
int iVariable2 = GetLocalInt(oTrampilla_gatos, "TRAMPILLA_CASA_GATOS");


if(iVariable1 == 1 || iVariable2 == 1)
   {
    FloatingTextStringOnCreature("*La trampilla de piedra está abierta y te introduces en ella*", oPJ);
    DelayCommand(1.5, AssignCommand(oPJ, ActionJumpToLocation(lLugar)));
   }

if(iVariable1 != 1 || iVariable2 != 1)
   {
    if((GetAbilityScore(oPJ, ABILITY_STRENGTH) >= 30))
   {
    DelayCommand(0.0, SetLocalInt(oTrampilla_cloak, "TRAMPILLA_CASA_GATOS", 1));
    DelayCommand(0.0, SetLocalInt(oTrampilla_gatos, "TRAMPILLA_CASA_GATOS", 1));
    DelayCommand(2.0, FloatingTextStringOnCreature("*¡¡¡Trepas por la enredadera!!!*", oPJ));
    DelayCommand(5.0, FloatingTextStringOnCreature("*¡¡¡ÉXITO!!!*", oPJ));
    DelayCommand(7.0, FloatingTextStringOnCreature("*Subes por la enredadera y abres la trampilla", oPJ));
    DelayCommand(8.0, AssignCommand(oTrampilla_cloak, PlayAnimation(ANIMATION_PLACEABLE_OPEN)));
    DelayCommand(8.0, AssignCommand(oTrampilla_gatos, PlayAnimation(ANIMATION_PLACEABLE_OPEN)));
    DelayCommand(20.0, AssignCommand(oTrampilla_cloak, SpeakString("*¡La tapa de la trampilla se baja un poco debido a su peso!*")));
    DelayCommand(20.0, AssignCommand(oTrampilla_gatos, SpeakString("*¡La tapa de la trampilla se baja un poco debido a su peso!*")));
    DelayCommand(40.0, AssignCommand(oTrampilla_cloak, SpeakString("*¡La trampilla está a punto de cerrarse!*")));
    DelayCommand(40.0, AssignCommand(oTrampilla_gatos, SpeakString("*¡La trampilla está a punto de cerrarse!*")));
    DelayCommand(60.0, AssignCommand(oTrampilla_cloak, SpeakString("*¡La tapa de piedra ha cedido por el peso y la trampilla se ha cerrado!*")));
    DelayCommand(60.0, AssignCommand(oTrampilla_gatos, SpeakString("*¡La tapa de piedra ha cedido por el peso y la trampilla se ha cerrado!*")));
    DelayCommand(60.0, AssignCommand(oTrampilla_cloak, PlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
    DelayCommand(60.0, AssignCommand(oTrampilla_gatos, PlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
    DelayCommand(60.0, DeleteLocalInt(oTrampilla_cloak, "TRAMPILLA_CASA_GATOS"));
    DelayCommand(60.0, DeleteLocalInt(oTrampilla_gatos, "TRAMPILLA_CASA_GATOS"));
   }
    else
        {
         DelayCommand(0.0,PlaySound("as_dr_locked2"));
         DelayCommand(1.0, FloatingTextStringOnCreature("*¡¡¡Subes por la enredadera y tiras fuerte de la trampilla!!!*", oPJ));
         DelayCommand(3.0, FloatingTextStringOnCreature("*¡¡¡FRACASO!!!*", oPJ));
         DelayCommand(4.0, FloatingTextStringOnCreature("*Intentas levantar la trampilla de piedra, pero no tienes suficiente fuerza*", oPJ));
        }
       }
}
