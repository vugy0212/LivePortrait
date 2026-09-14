# LivePortrait: Korisnički vodič i detaljne upute za rad

> **Sustav:** LivePortrait (Efficient Portrait Animation with Stitching and Retargeting Control)  
> **Optimizirano za:** NVIDIA GeForce RTX 4060 (8 GB VRAM), CUDA 12.1, Windows 11  
> **Pripremljene izvršne datoteke:** [`Pokreni_LivePortrait.bat`](file:///c:/Users/PC/Desktop/LivePortrait/LivePortrait/Pokreni_LivePortrait.bat) & [`Pokreni_LivePortrait_Zivotinje.bat`](file:///c:/Users/PC/Desktop/LivePortrait/LivePortrait/Pokreni_LivePortrait_Zivotinje.bat)  
> **Google Docs / Word format:** [`LivePortrait_Upute_za_koristenje.docx`](file:///c:/Users/PC/Desktop/LivePortrait/LivePortrait/LivePortrait_Upute_za_koristenje.docx)

---

## 1. Pregled sustava i arhitekture

LivePortrait je najnapredniji model otvorenog koda za animaciju statičnih portretnih fotografija (ljudi i kućnih ljubimaca) pomoću upravljačkog videa (*driving video*) ili predloška pokreta (*motion template*).

Za razliku od starijih difuzijskih ili GAN modela, LivePortrait ne generira cijelu sliku ispočetka nego koristi implicitne 3D ključne točke i modularne neuralne mreže:
1. **Appearance Feature Extractor ($F$):** Izvlači 3D geometriju, boju i teksturu s početne slike lica.
2. **Motion Extractor ($M$):** U stvarnom vremenu detektira pokrete glave, rotaciju i facijalnu mimiku iz upravljačkog videa.
3. **Warping Module ($W$):** Izračunava deformacijsku mapu i mapu okluzije (sjenčanja i prekrivanja) između početne i ciljane poze.
4. **SPADE Generator ($G$):** Sintetizira konačni fotorealistični portret (512×512 piksela).
5. **Stitching & Retargeting Module ($S$):** Omogućuje prirodno spajanje vrata i tijela bez vidljivih šavova te zasebnu kontrolu očiju, zjenica i usana.

---

## 2. Brzo pokretanje (1-klik pokretanje)

U mapi projekta pripremljene su izvršne skripte:

| Datoteka | Namjena | Web adresa |
| :--- | :--- | :--- |
| **`Pokreni_LivePortrait.bat`** *(ili `run_app.bat`)* | Glavno sučelje za animaciju **ljudskih portreta** | [http://127.0.0.1:8890](http://127.0.0.1:8890) |
| **`Pokreni_LivePortrait_Zivotinje.bat`** | Specijalizirano sučelje za **kućne ljubimce (mačke i psi)** | [http://127.0.0.1:8891](http://127.0.0.1:8891) |

> **Napomena:** Skripte automatski aktiviraju virtualno okruženje (`.venv`), učitavaju CUDA knjižnice i otvaraju vaš zadani web preglednik.

---

## 3. Korak-po-korak vodič kroz Web sučelje (Gradio)

### Korak 1: Učitavanje izvornog portreta (*Source*)
* U lijevom panelu učitajte sliku lica (JPG, PNG ili WEBP).
* **Zlatno pravilo:** Koristite oštru fotografiju visoke rezolucije s neutralnim izrazom lica i licem okrenutim prema naprijed.
* **Opcija `do crop (source)`:** Uvijek ostavite uključeno kako bi algoritam automatski prepoznao lice i optimalno ga centrirao.

### Korak 2: Učitavanje upravljačkog pokreta (*Driving*)
U središnjem panelu odaberite jedan od 3 načina upravljanja:
1. **Video kartica:** Učitajte video s mimikom ili govorom. Pripazite da prva sličica videa prikazuje neutralno lice kako animacija ne bi naglo trzala na početku.
2. **Image kartica:** Koristite drugu fotografiju s ciljanom ekspresijom (npr. nasmijano lice) kako biste promijenili izraz na izvornoj slici.
3. **Driving Pickle (`.pkl`):** Ako ste neki video već jednom obradili, LivePortrait je u mapi videa spremio `.pkl` predložak. Učitavanjem te datoteke **štedite 6–8 sekundi** jer se analiza lica ne mora ponavljati.

### Korak 3: Prilagodba postavki animacije (*Animation Options*)
* **`relative motion` (Uključeno - preporučeno):** Prenosi samo relativne pomake umjesto apsolutnog oblika lica vozača. Time se u potpunosti čuva identitet i struktura lica izvorne osobe.
* **`stitching` (Uključeno):** Algoritam besprijekorno stapa konture lica, kose i vrata tako da se prijelaz ne vidi.
* **`paste-back` (Uključeno):** Vraća generirani portret natrag u originalnu sliku/pozadinu visoke rezolucije.
* **`driving multiplier`:** Intenzitet ekspresije (vrijednost `1.0` je prirodna; postavite na `1.2`–`1.4` za izraženiju mimiku ili `< 1.0` za smireniju).
* **`animation region`:** Možete izolirati pokret samo na određene regije:
  * `all` — cjelokupna glava i lice.
  * `lip` — samo pokreti usana (idealno za sinkronizaciju govora).
  * `eyes` — samo pokreti očiju i treptanje.
  * `pose` — samo naginjanje i okretanje glave.

### Korak 4: Generiranje
* Kliknite na dugme **`🚀 Animate`**.
* Na vašoj **RTX 4060** video u trajanju od 10 sekundi generira se za **oko 30 do 35 sekundi**.
* Gotov video se odmah prikazuje u desnom panelu i možete ga preuzeti.

---

## 4. Interaktivno fino podešavanje (Retargeting Sliders)

Na dnu web sučelja nalazi se panel sa slajderima koji omogućuju izravno mijenjanje izraza lica i kuta glave na slici:

* **Rotacija glave:**
  * `Head Pitch` — nagib glave gore/dolje.
  * `Head Yaw` — okretanje glave lijevo/desno.
  * `Head Roll` — naginjanje glave prema ramenu.
* **Translacijski pomaci:** `Mov X`, `Mov Y`, `Mov Z` (udaljavanje ili približavanje).
* **Ekspresije i mimika:**
  * `Smile` — dodavanje osmijeha.
  * `Wink` — namigivanje.
  * `Eyebrow` — podizanje ili mrštenje obrva.
  * `Eyeball direction X/Y` — usmjeravanje pogleda zjenica.
  * `Lip variations` — kontrola otvorenosti i oblika usana.

---

## 5. Animacija kućnih ljubimaca (Animals Mode)

Pokretanjem skripte **`Pokreni_LivePortrait_Zivotinje.bat`** otvara se sučelje na portu `8891`:
* Koristi prilagođeni model `xpose` treniran na anatomiji mačaka i pasa.
* Kao driving izvor možete koristiti video čovjeka (npr. otvaranje usta i naginjanje glave) ili gotove životinjske predloške iz mape `assets/examples/driving/`.
* Preporuka: Isključite `flag_stitching` ako životinja ima dugu dlaku ili nagle pokrete glave radi bolje stabilnosti.

---

## 6. Savjeti za rješavanje problema (Troubleshooting)

1. **Video trza na početku:**
   * Uvjerite se da na prvoj sličici driving videa osoba ima neutralan pogled i zatvorena usta.
2. **Pojavljuju se crni okviri na slici:**
   * Ovo se može dogoditi ako GPU naiđe na problem s FP16 polovičnom preciznošću. Rješenje: pokrenite s opcijom `--flag_use_half_precision False`.
3. **Web stranica se ne otvara:**
   * Provjerite je li uključen VPN ili proxy koji blokira lokalne adrese (`127.0.0.1`). U skripti `run_app.bat` to je već automatski podešeno putem varijable `NO_PROXY=localhost,127.0.0.1`.
