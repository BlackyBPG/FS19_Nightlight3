
====================================
****        NIGHTLIGHT 3        ****
====================================


Nightlight3 (Nachtlicht 3te Generation) ist ein kleines nicht synchronisiertes Ambiente-Addon für Kartenbauer.
Es kann nicht ohne direkten Einbau in eine Karte genutzt werden.

Nightlight3 sorgt dafür das die Lichtquellen, in der Regel beleuchtete Fensterscheiben der Häuser,
per Zufallsprinzip und je nach Uhrzeit in der Anzahl und Reihenfolge willkürlich angeschaltet werden.
Dies soll lediglich ein "bewohnte" Atmosphäre schaffen, mehr nicht.


Dem Archiv liegt im Ordner "DEMO" eine I3D-Datei mit Objekten bei (danke an Andi für die erlaubte Verwendung des Plattenbaues)
in dem sowohl das alte Lichtsystem sowie auch ein Haus des neuen Lichtsystemes aus LS19 beiligt. Das Haus mitsamt Fenstern von
LS19 hat keine Einzelfenster da ich momentan kein Maya installiert habe und aus dem Grund die Fenster nicht voneinader trennen
konnte, der Plattenbau hat jedoch jedes Fenster separiert welche mit eigener Lichtquelle versehen sind. Diese können zu Testzwecken
in die Karte eingebaut werden. Sollte der Plattenbau Verwendung finden bitte an AndiScania wenden für die Freigabe!


	ModDesc.xml Eintragungen
================================================================
	<extraSourceFiles>
		<sourceFile filename="scripts/Nightlight3.lua" />
	</extraSourceFiles>



	UserAttribute und Erklärung
================================================================
	onCreate			Standardwert: NA		modOnCreate.Nightlight3 um das Objekt an dieNightlight3 Funktionen zu binden
	classicLight		Standardwert: true		gibt an ob es beleuchtete Objekte sind (EmmissiveMap)(classic=true) oder nach LS19 Standard Shader-gesteuerte Objekte
	onlyNight			Standardwert: true		gibt an ob das Licht nur Nachts eingeschaltet werden soll (true) oder auch bei Regen (false)
	onChance			Standardwert: 33		gibt in Prozent an wie hoch die Wahrscheinlichkeit ist das dieses Licht an geschaltet wird
	lightIntensity		Standardwert: 1.0		gibt an wie hell das Licht im Spiel erscheinen soll, nur relevant bei classic=false sprich neuem Shader-gesteuertem System


* Das Objekt welches geschaltet wird ist immer das Objekt welches den onCreate Aufruf enthält.
* Selbst wenn bei "onChance" 100 eingestellt wird bedeutet es nicht daß dieses Lichtobjekt zu 100% angeschaltet wird
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
  das angesteuerte Objekt selbst wird lediglich über die gesetzten ShaderParameter gesteuert
* Sollte das neue Shader-gesteuerte System verwendet werden ist IMMER das erste Objekt in der Hierachie IN der Gruppe des geschalteten Objektes das RealLight
	Beispiel:
		Fensterscheibe_beleuchtet
		\_ RealLight
				
		Fensterscheibe_beleuchtet2
		\_ Transformgruppe_RealLights
		   \_ RealLight1
		   \_ RealLight2