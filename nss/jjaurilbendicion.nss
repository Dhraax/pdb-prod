///modificado por jj para el templo abandonado de auril
void main()
{
//:://////////////////////[ESTATUA DIOSA AURIL, ONUSED]/////////////////////:://
/*CONFIGURADOR*/
//Modifica aqui los segundos que durara la proteccion en el jugador
float fSegundos1 = 500.0;

//Modifica aqui los segundos que tardara en volver a funcionar la estatua
float fSegundos2 = 500.0;
//NOTA: Estos segundos los he puesto iguales para que en el momento de que se
//te vaya la proteccion ya puedas tocar la estatua. Se puede modificar obviamente.

//Modifica el oro que te costara usar la estatua
int iOro = 0;

//Modifica el mensaje cuando no tienes suficiente oro para usar la estatua
string sMensaje6 = "No parece suceder nada";

//Modifica el mensaje que le saldra al jugador despues de tocar la estatua
//cuando esta en funcionamiento

/*modificado por jj*/ /* string sMensaje4 = "Has donado " + IntToString(iOro) + " monedas de oro al templo"; */
string sMensaje4 = "Has tocado el altar";
string sMensaje1 = "Auril te ha transmitido su poder";
string sMensaje3 = "La bendicion gelida te abraza";

//Modifica aqui el mensaje que te saldra cuando la immunidad se haya ido
string sMensaje5 = "Auril te ha abandonado";

//Modifica el mensaje que le saldra al jugador despues de tocar la estatua
//cuando no esta en funcionamiento
string sMensaje2 = "No puedes invocar tan seguidamente los poderes de la diosa"
                 + " del invierno Auril";
//::////////////////////////////////////////////////////////////////////////:://

//Definimos el objeto
object oPC = GetLastUsedBy();
//Definimos los efectos
effect eEfecto1 = ExtraordinaryEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50));
effect eEfecto2 = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));
effect eEfecto3 = EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL);


if(GetGold(oPC) >= 0)
   {
    if(GetLocalInt (oPC, "ESTATUARIEL") == 0)
        {
         SetLocalInt(oPC, "ESTATUARIEL", 1);
         DelayCommand(fSegundos2, DeleteLocalInt(oPC, "ESTATUARIEL"));

         AssignCommand(oPC, TakeGoldFromCreature(iOro, oPC, TRUE));

         FloatingTextStringOnCreature(sMensaje4, oPC);
         DelayCommand(1.2, FloatingTextStringOnCreature(sMensaje1, oPC));
         DelayCommand(2.0, FloatingTextStringOnCreature(sMensaje3, oPC));
         DelayCommand(fSegundos1, FloatingTextStringOnCreature(sMensaje5, oPC));

         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto1, oPC, fSegundos1);
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto2, oPC, fSegundos1);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC);
        }
    else
        {
         FloatingTextStringOnCreature(sMensaje2, oPC);
        }
    }
else
    {
     FloatingTextStringOnCreature(sMensaje6, oPC);
    }
}
