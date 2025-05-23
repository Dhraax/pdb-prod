void main()
{
    object oPj = GetEnteringObject();
    int idVeneno = GetLocalInt(OBJECT_SELF, "idVeneno");
    effect eVenom = EffectPoison(idVeneno);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVenom, oPj);
}
