void main()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   int iAc = GetLocalInt(oContenedor,"iAc");
   if(iAc>=20){
   SpeakString("¡Límite máximo alcanzado!");
   }
   else
   {
   SetLocalInt(oContenedor,"iAc",iAc+1);
   }
}
