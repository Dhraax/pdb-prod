void main()
{
int id10 = d10 ();

object oTerraron = GetObjectByTag("GofTerraron");

if (id10 > 8)

    {
    object oCaparazon = CreateItemOnObject("gofcosaterraron",oTerraron);
    object oCostillar = CreateItemOnObject("chuletonterraron",oTerraron);
    }

else {
    if (id10 > 4)
        {
        object oCostillar = CreateItemOnObject("chuletonterraron",oTerraron);
        }
    return;
        }
    }
