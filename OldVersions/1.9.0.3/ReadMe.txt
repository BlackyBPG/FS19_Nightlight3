
====================================
****        NIGHTLIGHT 3        ****
====================================


Nightlight3 (Nachtlicht 3te Generation) ist ein kleines nicht synchronisiertes Ambiente-Addon f�r Kartenbauer.
Es kann nicht ohne direkten Einbau in eine Karte genutzt werden.

Nightlight3 sorgt daf�r das die Lichtquellen, in der Regel beleuchtete Fensterscheiben der H�user,
per Zufallsprinzip und je nach Uhrzeit in der Anzahl und Reihenfolge willk�rlich angeschaltet werden.
Dies soll lediglich ein "bewohnte" Atmosph�re schaffen, mehr nicht.


Dem Archiv liegt im Ordner "DEMO" eine I3D-Datei mit Objekten bei (danke an Andi f�r die erlaubte Verwendung des Plattenbaues)
in dem sowohl das alte Lichtsystem sowie auch ein Haus des neuen Lichtsystemes aus LS19 beiligt. Das Haus mitsamt Fenstern von
LS19 hat keine Einzelfenster da ich momentan kein Maya installiert habe und aus dem Grund die Fenster nicht voneinader trennen
konnte, der Plattenbau hat jedoch jedes Fenster separiert welche mit eigener Lichtquelle versehen sind. Diese k�nnen zu Testzwecken
in die Karte eingebaut werden. Sollte der Plattenbau Verwendung finden bitte an AndiScania wenden f�r die Freigabe!
Ab Version 1.9.0.3 ist einer der Demo-Neubaubl�cke mit dem Verweis zu einer XML-Konfiguration (beiliegend) versehen,
die Konfigurations-XML befindet sich im gleichen Ordner und nennt sich nightlight3_Sample.xml.


	ModDesc.xml Eintragungen
================================================================
	<extraSourceFiles>
		<sourceFile filename="scripts/Nightlight3.lua" />
	</extraSourceFiles>



	UserAttribute und Erkl�rung
================================================================
	onCreate			Standardwert: NA								modOnCreate.Nightlight3 um das Objekt an dieNightlight3 Funktionen zu binden
	classicLight		Standardwert: true								gibt an ob es beleuchtete Objekte sind (EmmissiveMap)(classic=true) oder nach LS19 Standard Shader-gesteuerte Objekte
	onlyNight			Standardwert: true								gibt an ob das Licht nur Nachts eingeschaltet werden soll (true) oder auch bei Regen (false)
	onChance			Standardwert: 33								gibt in Prozent an wie hoch die Wahrscheinlichkeit ist das dieses Licht an geschaltet wird
	lightIntensity		Standardwert: 1.0								gibt an wie hell das Licht im Spiel erscheinen soll, nur relevant bei classic=false sprich neuem Shader-gesteuertem System
	changeTimer			Standardwert: 60								gibt das Intervall in Minuten an nach denen eine Umschaltung erfolgen kann
	isGroup				Standardwert: false								gibt an ob das Objekt welches das Script startet (den onCreate Aufruf enth�lt) zu steuernde Unterobjekte enth�lt
	groupAsSingle		Standardwert: false								Voraussetzung: isGroup = true ; gibt an ob die Objekte in einer Gruppe einzelnt (groupAsSingle=false) gepr�ft werden sollen oder alle den gleichen Status (groupAsSingle=true) haben sollen
	xmlFile				Standardwert: NA								gibt die XML-Datei mit Pfad IN dem Mod zu der Konfigurations-XML an
	configName			Standardwert: Name des aufrufenden Objektes		Voraussetzung: xmlFile ~= NIL ; gibt den Namen der Konfiguration innerhalb der Konfigurations-XML an unter dem die Einstellungen f�r dieses Objekt zu finden sind

WICHTIG:
Die Zuweisung einer Konfigurations-XML hat den h�chsten Stellenwert im Script. Ist ale eine XML-Datei zugewiesen so werden die Einstellungen
aus eben dieser genutzt, fehlt ein Wert in der XML wird versucht ihn aus den UserAttributen des aufrufenden Objektes zu laden, schl�gt dies
fehl so wird ein Standardwert angenommen. Ist die XML-Datei NICHT vorhanden werden die UserAttribute des aufrufenden Objektes abgefragt,
schl�gt dies fehl so wird wieder ein Standardwert angenommen.


* Wenn das aufrufende Objekt ein zu steuernde Unterobjekte enth�lt werden diese geschaltet, andernfalls wird das aufrufende Objekt geschaltet.
* Selbst wenn bei "onChance" 100 eingestellt wird bedeutet es nicht da� dieses Lichtobjekt zu 100% angeschaltet wird
  da eine weitere Chancenanpassung im Script vorgenommen wird, je nach aktueller InGame Uhrzeit
* Die scriptgesetzten Chancenvariationen sehen wie folgt aus:
	05:00 - 19:00 Uhr	100% des onChance Wertes
	20:00 Uhr			150% des onChance Wertes
	21:00 Uhr			120% des onChance Wertes
	22:00 Uhr			90% des onChance Wertes
	23:00 Uhr			60% des onChance Wertes
	00:00 Uhr			45% des onChance Wertes
	01:00 Uhr			30% des onChance Wertes
	02:00 Uhr			10% des onChance Wertes
	03:00 Uhr			25% des onChance Wertes
	04:00 Uhr			50% des onChance Wertes
* Beim klassischem System wird das angesteuerte Objekt sichtbar (Beleuchtung an) bzw unsichtbar (Beleuchtung aus) geschaltet, das RealLight wird nicht extra
  angesteuert, sollte also von vornherein in den Attributen sichtbar gesetzt werden
* Beim neuen Shader-gesteuerten System der LS19 Beleuchtung wird das RealLight sichtbar (Beleuchtung an) bzw unsichtbar (Beleuchtung aus) geschaltet,
  das angesteuerte Objekt selbst wird lediglich �ber die gesetzten ShaderParameter gesteuert
* Sollte das neue Shader-gesteuerte System verwendet werden ist IMMER das erste Objekt in der Hierachie IN der Gruppe des geschalteten Objektes das RealLight
	Beispiel:
		Fensterscheibe_beleuchtet
		\_ RealLight
				
		Fensterscheibe_beleuchtet2
		\_ Transformgruppe_RealLights
		   \_ RealLight1
		   \_ RealLight2
  Dies gilt auch bei gruppierten Objekten
