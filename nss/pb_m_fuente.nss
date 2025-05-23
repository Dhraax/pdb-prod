#include "lib_race"

void main()
{
    object oPC = GetLastUsedBy();

    int iCuracion = d10(6) + 15; // Por defecto lo he dejado en 6 dados de 10 caras + 15
    float fSegundos = 600.0;
    string sTexto1 = "*El agua bendita te recupera parcialmente*";
    string sTexto2 = "Esta agua bendita no parece funcionar en tu cuerpo tan seguidamente...";
    effect eEfecto1 = EffectVisualEffect(VFX_IMP_HEALING_X); //Sanar
    effect eEfecto2 = EffectHeal(iCuracion); // Sanar aleatoriamente
    effect eEfecto3 = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);

    // Si la variable FUENTEBIENMAL se encuentra a 0..
    if(GetLocalInt(oPC, "FUENTEBIENMAL") == 0)
    {
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC);
        SetLocalInt(oPC, "FUENTEBIENMAL", 1);
        DelayCommand(fSegundos, DeleteLocalInt(oPC, "FUENTEBIENMAL"));
        FloatingTextStringOnCreature(sTexto1, oPC);
    }

    // En cambio, si se encuentra a 1
    else
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC);
        FloatingTextStringOnCreature(sTexto2, oPC);
    }
}
