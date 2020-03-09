# FS19_Nightlight3
![Nightlight3 Logo](https://github.com/BlackyBPG/FS19_Nightlight3/blob/master/logo_Nightlight3.png "Nightlight3 Logo")

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
Ab Version 1.9.0.3 ist einer der Demo-Neubaublöcke mit dem Verweis zu einer XML-Konfiguration (beiliegend) versehen,
die Konfigurations-XML befindet sich im gleichen Ordner und nennt sich nightlight3_Sample.xml.

------------

### Karteneinbau und Beschreibung

**ModDesc.xml Eintragungen**
Es wird nur ein Eintrag in der ModDesc.xml benötigt, und zwar wird in der <extraSourceFiles> Sektion folgender Eintrag hinzugefügt:

    <sourceFile filename="{DeinScriptPfad}/Nightlight3.lua" />


**UserAttribute und Erklärung**

- onCreate
- - Standardwert: NA
- - Typ: ScriptCallback
- - modOnCreate.Nightlight3 um das Objekt an dieNightlight3 Funktionen zu binden

- classicLight
- - Standardwert: true
- - Typ: Boolean
- - gibt an ob es beleuchtete Objekte sind (EmmissiveMap)(classic=true) oder nach LS19 Standard Shader-gesteuerte Objekte

- ignoreNight
- - Standardwert: false
- - Typ: Boolean
- - gibt an ob das Licht auch bei Tageslicht aktivert werden kann
- - ist diese Option aktiv ist die Option "onlyNight" irrelevant

- onlyNight
- - Standardwert: true
- - Typ: Boolean
- - gibt an ob das Licht nur Nachts eingeschaltet werden soll (true) oder auch bei Regen (false)

- onChance
- - Standardwert: 33
- - Typ: Float oder Integer
- - gibt in Prozent an wie hoch die Wahrscheinlichkeit ist das dieses Licht an geschaltet wird

- lightIntensity
- - Standardwert: 1.0
- - Typ: Float
- - gibt an wie hell das Licht im Spiel erscheinen soll, nur relevant bei classic=false sprich neuem Shader-gesteuertem System

- changeTimer
- - Standardwert: 60
- - Typ: Integer
- - gibt das Intervall in Minuten an nach denen eine Umschaltung erfolgen kann

- isGroup
- - Standardwert: false
- - Typ: Boolean
- - gibt an ob das Objekt welches das Script startet (den onCreate Aufruf enthält) zu steuernde Unterobjekte enthält

- groupAsSingle
- - Voraussetzung: isGroup = true
- - Standardwert: false
- - Typ: Boolean
- - gibt an ob die Objekte in einer Gruppe einzelnt (groupAsSingle=false) geprüft werden sollen oder alle den gleichen Status (groupAsSingle=true) haben sollen

- xmlFile
- - Standardwert: NA
- - Typ: String
- - gibt die XML-Datei mit Pfad IN dem Mod zu der Konfigurations-XML an

- configName
- - Voraussetzung: xmlFile ~= NIL
- - Standardwert: Name des aufrufenden Objektes
- - Typ: String
- - gibt den Namen der Konfiguration innerhalb der Konfigurations-XML an unter dem die Einstellungen für dieses Objekt zu finden sind


#### WICHTIG:

Die Zuweisung einer Konfigurations-XML hat den höchsten Stellenwert im Script. Ist ale eine XML-Datei zugewiesen so werden die Einstellungen
aus eben dieser genutzt, fehlt ein Wert in der XML wird versucht ihn aus den UserAttributen des aufrufenden Objektes zu laden, schlägt dies
fehl so wird ein Standardwert angenommen. Ist die XML-Datei NICHT vorhanden werden die UserAttribute des aufrufenden Objektes abgefragt,
schlägt dies fehl so wird wieder ein Standardwert angenommen.

Beispiel einer Konfigurations-XML:

    <?xml version="1.0" encoding="utf-8" standalone="no" ?>
    <nightlights>
	    <nightlight name="wohnzimmer">
		    <isClassic>true</isClassic>
		    <ignoreNight>false</ignoreNight>
		    <onlyNight>false</onlyNight>
		    <isGroup>true</isGroup>
		    <groupAsSingle>false</groupAsSingle>
		    <onChance>30</onChance>
		    <changeTimer>39</changeTimer>
		    <lightIntensity>1.0</lightIntensity>
		    <hourFactors
			    <h0>0.45</h0>
			    <h1>0.3</h1>
			    <h2>0.1</h2>
			    <h3>0.25</h3>
			    <h4>0.5</h4>
			    <h5>1</h5>
			    <h6>1</h6>
			    <h7>1</h7>
			    <h8>1</h8>
			    <h9>1</h9>
			    <h10>1</h10>
			    <h11>1</h11>
			    <h12>1</h12>
			    <h13>1</h13>
			    <h14>1</h14>
			    <h15>1</h15>
			    <h16>1</h16>
			    <h17>1</h17>
			    <h18>1</h18>
			    <h19>1</h19>
			    <h20>1.5</h20>
			    <h21>1.2</h21>
			    <h22>0.9</h22>
			    <h23>0.6</h23>
		    </hourFactors>
	    </nightlight>
    </nightlights>



**Hinweise**

- ~~Das Objekt welches geschaltet wird ist immer das Objekt welches den onCreate Aufruf enthält.~~

- Wenn das aufrufende Objekt ein zu steuernde Unterobjekte enthält werden diese geschaltet, andernfalls wird das aufrufende Objekt geschaltet.

- Selbst wenn bei "onChance" 100 eingestellt wird bedeutet es nicht daß dieses Lichtobjekt zu 100% angeschaltet wird da eine weitere Chancenanpassung im Script oder der XML-Konfiguration vorgenommen wird, je nach aktueller InGame Uhrzeit

- Beim klassischem System wird das angesteuerte Objekt sichtbar (Beleuchtung an) bzw unsichtbar (Beleuchtung aus) geschaltet, das RealLight wird nicht extra angesteuert, sollte also von vornherein in den Attributen sichtbar gesetzt werden

- Beim neuen Shader-gesteuerten System der LS19 Beleuchtung wird das RealLight sichtbar (Beleuchtung an) bzw unsichtbar (Beleuchtung aus) geschaltet, das angesteuerte Objekt selbst wird lediglich über die gesetzten ShaderParameter gesteuert

- Die scriptgesetzten Chancenvariationen sehen wie folgt aus:
- - 05:00 - 19:00 Uhr - 100% des onChance Wertes
- - 20:00 Uhr - 150% des onChance Wertes
- - 21:00 Uhr - 120% des onChance Wertes
- - 22:00 Uhr - 90% des onChance Wertes
- - 23:00 Uhr - 60% des onChance Wertes
- - 00:00 Uhr - 45% des onChance Wertes
- - 01:00 Uhr - 30% des onChance Wertes
- - 02:00 Uhr - 10% des onChance Wertes
- - 03:00 Uhr - 25% des onChance Wertes
- - 04:00 Uhr - 50% des onChance Wertes

- Sollte das neue Shader-gesteuerte System verwendet werden ist IMMER das erste Objekt in der Hierachie IN der Gruppe des geschalteten Objektes das RealLight
- BEISPIEL:
- - Fensterscheibe_beleuchtet
- - \_ RealLight
- - 
- - Fensterscheibe_beleuchtet2
- - \_ Transformgruppe_RealLights
- - \_ RealLight1
- - \_ RealLight2
- Dies gilt auch bei gruppierten Objekten

------------

![Nightlight3 Ingame](https://github.com/BlackyBPG/FS19_Nightlight3/blob/master/Nightlight3.gif "Nightlight3")

------------

------------

#### CHANGELOG:

- ##### Version 1.9.0.4 (09.03.2020)
- - add ignoreNight attribute to force light on daylight

- ##### Version 1.9.0.3 (29.02.2020)
- - remove hour change time and add minute change time
- - add xml file functionality
- - add light group functionality

- ##### Version 1.9.0.2 (05.12.2019)
- - update for new shader based window lights

- ##### Version 1.9.0.1 (04.12.2019)
- - Initial Release for Fs19
