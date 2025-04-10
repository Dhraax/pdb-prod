 void main()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   object oNPC = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
   int iNivel = GetLocalInt(oContenedor, "iNivel");
   int iClass = GetClassByPosition(1,oNPC);
   int iLevel = GetHitDice(oNPC);

   if(iLevel>=40)
   {
   SpeakString("Límite de nivel máximo!");
   }
   else
   {
   LevelUpHenchman(oNPC,iClass,FALSE);
   SetLocalInt(oContenedor, "iNivel", GetHitDice(oNPC));
  }
}
