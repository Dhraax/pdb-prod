void main()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   int iCantidad = GetLocalInt(oContenedor, "AICantidad");
   if(iCantidad==20)
   {
   SpeakString("Límite máximo alcanzado!");
   }
   else
   {
   SetLocalInt(oContenedor,"AICantidad",iCantidad+1);
   }
}
