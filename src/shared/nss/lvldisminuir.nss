void main()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   int iNivel = GetLocalInt(oContenedor, "iNivel");
   if(iNivel<=0)
   {
   SpeakString("Límite mínimo alcanzado!");
   }
   else
   {
  SetLocalInt(oContenedor, "iNivel", iNivel-1);
  }

}
