void main()
{
//::////////////////////////////////////////////////////////////////////////:://
//Modifica aqui los segundos que durara la resistencia en el jugador
float fSegundos1 = 500.0;

//Modifica aqui los segundos que tardara en volver a funcionar la estatua
float fSegundos2 = 500.0;
//NOTA: Estos segundos los he puesto iguales para que en el momento de que se
//te vaya la fuerza ya puedas tocar la estatua. Se puede modificar obviamente.

//Modifica el mensaje que le saldra al jugador despues de tocar la estatua
//cuando esta en funcionamiento
string sMensaje1 = "¡Mystra ha aumentado tu resistencia mágica increiblemente!";

//Modifica el mensaje que le saldra al jugador despues de tocar la estatua
//cuando no esta en funcionamiento
string sMensaje2 = "No puedes invocar tan seguidamente los poderes mágicos"
                 + " de Mystra";
//::////////////////////////////////////////////////////////////////////////:://

//Definimos el objeto
object oPC = GetLastUsedBy();
//Definimos los efectos
effect eEfecto1 = SupernaturalEffect(EffectSpellResistanceIncrease(20 + GetHitDice(oPC)));
effect eEfecto2 = SupernaturalEffect(EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE));
effect eEfecto3 = EffectVisualEffect(VFX_FNF_DISPEL_GREATER );

if(GetLocalInt (oPC, "ESTATUAMYSTRA") == 0)
    {
     SetLocalInt(oPC, "ESTATUAMYSTRA", 1);
     DelayCommand(fSegundos2, DeleteLocalInt(oPC, "ESTATUAMYSTRA"));

     FloatingTextStringOnCreature(sMensaje1, oPC);
     DelayCommand(fSegundos1, FloatingTextStringOnCreature("Mystra te ha abandonado", oPC));

     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto1, oPC, fSegundos1);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto2, oPC, fSegundos1);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC);
    }
else
    {
     FloatingTextStringOnCreature(sMensaje2, oPC);
    }
}
