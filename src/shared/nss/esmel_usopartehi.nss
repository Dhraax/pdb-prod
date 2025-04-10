void main()
{
    object oEscalera = GetNearestObjectByTag("escaleravariable");
    object oReja = GetNearestObjectByTag("esme_barrotes");
    DelayCommand(1.0,DestroyObject(oReja));
    SetLocalString(oEscalera,"Niveldeagua","4");

}
