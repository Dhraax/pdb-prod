//Se coloca en el OnDeath de la criatura

void main()
{
int iDadoProbabilidad = d4();

if (iDadoProbabilidad ==1)
    {
    string sResref = GetLocalString (OBJECT_SELF, "CRIATURA");
    object oJugador = GetLastKiller();
    object oPnjCaido = OBJECT_SELF;
    string sNombreJugador = GetName (oJugador);
    location lZonaAparicion = GetLocation(OBJECT_SELF);
    effect eEfectoVisual1 = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eEfectoVisual2 = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
    AssignCommand(oPnjCaido, SpeakString("<c!}þ>*El cuerpo del trasgo abatido por "+sNombreJugador+" comienza a contorsionarse entre convulsiones y espasmos, mientras va mutando hasta convertirse en una criatura lobuna*</c>"));
    ApplyEffectAtLocation (DURATION_TYPE_INSTANT, eEfectoVisual1,lZonaAparicion);
    ApplyEffectAtLocation (DURATION_TYPE_INSTANT, eEfectoVisual2,lZonaAparicion);
    object oBarghest = CreateObject(OBJECT_TYPE_CREATURE,sResref,lZonaAparicion,FALSE);
    DelayCommand (2.0, ApplyEffectToObject (DURATION_TYPE_INSTANT,eEfectoVisual2,oBarghest));
    AssignCommand(oBarghest, SetFacingPoint(GetPosition(oJugador)));//para que no salga dando el culo al atacante
    DestroyObject (OBJECT_SELF);
    }
else
ExecuteScript ("nw_c2_default7",OBJECT_SELF);
}
