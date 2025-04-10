void main()
{
object oGnomo = GetObjectByTag("Gnomo_genio_esmel");
DelayCommand(1.0, AssignCommand(oGnomo, SpeakString("¡¡¡Venid a la Botella del Genio!!!")));
DelayCommand(4.0, AssignCommand(oGnomo, SpeakString("¡¡¡¡La mejor posada de la ciudad!!!")));
DelayCommand(7.0, AssignCommand(oGnomo, SpeakString("¡¡¡Encontrarás buena bebida, objetos y grata compañía!!!")));
}
