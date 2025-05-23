void main()
{
if(GetIsNight()) SetEncounterActive(TRUE, OBJECT_SELF);
else SetEncounterActive(FALSE, OBJECT_SELF);
}
