void main()
{
int iGender = GetGender(GetPCSpeaker());
if (iGender == GENDER_MALE)
    PlaySound( "as_pl_yawningm1");
else
    PlaySound( "as_pl_yawningf1");
}
