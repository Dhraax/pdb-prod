void main()
{
    object oPC = GetPCSpeaker();
    if(GetXP(oPC) < 45000)
      {
         if (GetXP(oPC) < 10000)
         {
          GiveXPToCreature(GetPCSpeaker(), 100);
         }
         else
         GiveXPToCreature(GetPCSpeaker(), 50);
      }
}
