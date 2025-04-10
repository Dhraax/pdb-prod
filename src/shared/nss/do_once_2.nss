//PUT THIS ON ACTION TAKEN OF THE SAME LINE

void main()
{
object oPC=GetPCSpeaker();

string sTag=GetTag(OBJECT_SELF);

SetLocalInt(oPC, sTag, 1);
}

