void main()
{
object oPortal = GetNearestObjectByTag("cripnigroport");
object oPC = GetLastUsedBy();
int iVariable = GetLocalInt(oPortal, "criptanigro");

if(iVariable == 9)
{
effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
ApplyEffectToObject(DURATION_TYPE_INSTANT,eSummon,oPC);
object oPortal2 = GetNearestObjectByTag("vorticenigro2");
DelayCommand(2.0,AssignCommand(oPC,ActionJumpToObject(oPortal2)));
effect eDamage = EffectDamage(d10(2),DAMAGE_TYPE_NEGATIVE);
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oPC));
effect eLimpiar = EffectDispelMagicAll(20);


    object oEspejo1 = GetObjectByTag("esp_refrac_01");
    object oEspejo2 = GetObjectByTag("esp_refrac_02");
    object oEspejo3 = GetObjectByTag("esp_refrac_03");
    object oEspejo4 = GetObjectByTag("esp_refrac_04");
    object oEspejo5 = GetObjectByTag("esp_refrac_05");
    object oEspejo6 = GetObjectByTag("esp_refrac_06");
    object oEspejo7 = GetObjectByTag("esp_refrac_07");
    object oEspejo8 = GetObjectByTag("esp_refrac_08");

DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo1));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo2));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo3));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo4));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo5));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo6));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo7));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo8));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,OBJECT_SELF));
            SetLocalInt(oPortal,"criptanigro",1);
}

}
