
int StartingConditional()
{

string sIdioma = GetLocalString (OBJECT_SELF, "IDIOMA");
string sPlacaElfo = "En esta vieja y polvorienta placa reza en algún idioma un texto con cuidadas letras esculpidas en ella";
string sPlacaDrow = "Arañada en la base de la estatua hay escrito algo. Sin embargo la lectura es casi ilegible, tanto por el tiempo que lleva inscrito como por la torpeza o dificultad de quien lo grabó. Sin duda con algún objeto punzante capaz de arañar la obsidiana de la estatua";

if (sIdioma=="hlslang_1")
    {
    SetCustomToken (7001, sPlacaElfo);
    }
else{
    SetCustomToken (7001, sPlacaDrow);
    }
return TRUE;

}
