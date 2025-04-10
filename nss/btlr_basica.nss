void main()
{
     object oPC = GetPCSpeaker();
     string sSubraza = GetStringLowerCase(GetSubRace(oPC));
     if (sSubraza=="drow")
     {
       SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, 0.97);
     }
     else
     {
        SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, 1.0);
     }
}
