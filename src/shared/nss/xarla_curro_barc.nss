void main()
{
object oCurrante_1 = GetObjectByTag("TrabajadordelPuerto_1");
object oCurrante_2 = GetObjectByTag("TrabajadordelPuerto_2");
object oCurrante_3 = GetObjectByTag("TrabajadordelPuerto_3");
object oCurrante_4 = GetObjectByTag("TrabajadordelPuerto_4");
object oCurrante_5 = GetObjectByTag("TrabajadordelPuerto_5");
object oFuego = GetNearestObjectByTag("basura_esmel");
DelayCommand(1.0, AssignCommand(oCurrante_3, SetFacingPoint(GetPosition(oFuego))));
DelayCommand(1.0, AssignCommand(oCurrante_4, SetFacingPoint(GetPosition(oFuego))));
DelayCommand(3.0, AssignCommand(oCurrante_1, SpeakString("¡Pásame las maderas, las de tu izquierda!")));
DelayCommand(5.0, AssignCommand(oCurrante_2, SpeakString("¡Ahora te las paso!")));
DelayCommand(6.0, AssignCommand(oCurrante_5, SpeakString("¡¡Venga a trabajar!!")));
}
