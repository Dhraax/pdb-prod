void main()
{
string sEtiquetaLlave = GetLockKeyTag(OBJECT_SELF);
object oPortal = GetNearestObjectByTag("ib_base_sancta_balizaport");
object oPC = GetLastUsedBy();
int iVariable = GetLocalInt(oPortal, "ibbaseport");

if(iVariable == 6)
{
effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
ApplyEffectToObject(DURATION_TYPE_INSTANT,eSummon,oPC);

if(GetItemPossessedBy(oPC, sEtiquetaLlave) == OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "<cþ<<>* Tu alma no parece resistir el proceso *</c>");
          return;
      }
else  {
          SendMessageToPC(oPC, "<c´þd>* Tu alma resiste el proceso *</c>");
          object oPortal2 = GetNearestObjectByTag("ko_banitas_supersala_salida");
          DelayCommand(2.0,AssignCommand(oPC,ActionJumpToObject(oPortal2)));
      }


effect eDamage = EffectDamage(d10(2),DAMAGE_TYPE_NEGATIVE);
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oPC));
effect eLimpiar = EffectDispelMagicAll(20);


    object oEspejo1 = GetObjectByTag("ib_base_condensador_01");
    object oEspejo2 = GetObjectByTag("ib_base_condensador_02");
    object oEspejo3 = GetObjectByTag("ib_base_condensador_03");
    object oEspejo4 = GetObjectByTag("ib_base_condensador_04");
    object oEspejo5 = GetObjectByTag("ib_base_condensador_05");

DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo1));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo2));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo3));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo4));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,oEspejo5));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLimpiar,OBJECT_SELF));
            SetLocalInt(oPortal,"ibbaseport",1);
}

}
