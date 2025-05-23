void main()
{
    int nGender = GetGender(OBJECT_SELF);
    switch(nGender)
    {
        case GENDER_MALE:
            SetCustomToken(100, "him");
        break;
        case GENDER_FEMALE:
            SetCustomToken(100, "her");
        break;
    }
}
