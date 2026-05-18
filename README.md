# NovaPress Slovenija – Recon & Internal Services CTF

Kratek, lokalen CTF laboratorij za zasebno etično-hackersko delavnico. Okolje predstavlja izmišljeno slovensko medijsko podjetje **NovaPress Slovenija** in namerno ranljivo interno omrežje.

**Opozorilo:** okolje je namenoma ranljivo. Nikoli ga ne izpostavljajte javnemu internetu, ne objavljajte portov na host sistem in ga uporabljajte samo v nadzorovanem laboratoriju.

## Osnovna pravila

- Dovoljeno je skeniranje in testiranje samo v `10.10.0.0/16`.
- Prepovedan je DoS in rušenje storitev.
- Ne uporabljajte napadov izven laboratorija.
- Vse zastavice oddajte v `.txt` datoteki z oštevilčenimi odgovori.
- Večina zastavic je oblike `NP2-CTF{...}`.
- Nekateri odgovori so realni podatki, npr. IP naslov, število hostov ali mrežni naslov.

## Zagon

Zahteve: Docker Engine in Docker Compose plugin.

```bash
make up
make down
make rebuild
make logs
```

Privzeto `docker-compose.yml` ne objavi nobenega porta na host. Containerji niso privilegirani in ne montirajo Docker host datotečnega sistema.

## Topologija

Docker network:

- ime: `news_ctf_net`
- subnet: `10.10.20.0/24`
- bridge: `br-news-ctf`

| Host | IP | Services | Namen |
|---|---:|---|---|
| gw-news | 10.10.20.1 | - | gateway placeholder |
| srv-news-web | 10.10.20.11 | 80 | javni portal NovaPress |
| srv-news-db | 10.10.20.21 | 3306 | podatki portala |
| srv-news-smb | 10.10.20.31 | 139,445 | datotečne mape uredništva |
| srv-news-api | 10.10.20.61 | 8080 | notranji uredniški API |
| srv-news-editor | 10.10.20.71 | HTTP client | simulirana uredniška delovna postaja |
| srv-news-monitor | 10.10.20.81 | 161/udp, 8081 | monitoring in status |

Za inštruktorje je na voljo tudi opcijski `attacker-helper` profil za razhroščevanje zajema prometa v istem Docker omrežju:

```bash
docker compose --profile attacker up -d attacker-helper
```

Primarna pot za udeležence ostaja uporaba lastnega orodja v laboratorijskem segmentu.

## Zgodba

NovaPress Slovenija pripravlja nov uredniški delovni tok po več letih hitre rasti. Javni portal je za obiskovalce videti običajno, v ozadju pa se uredništvo zanaša na več notranjih storitev, starejše datotečne mape, monitoring skripte in majhen uredniški API, ki ga novinarji uporabljajo pri pripravi člankov pred objavo.

V zadnjem tednu je IT ekipa opazila nenavaden dostop do metapodatkov neobjavljenih člankov in čudno sejno aktivnost ene uredniške delovne postaje. Vodstvo je naročilo nadzorovan varnostni pregled pred zagonom novega procesa. Cilj je ugotoviti, ali bi napadalec v istem laboratorijskem omrežju lahko mapiral okolje, odkril izpostavljene interne vire, prestregel nezaščiten promet in dostopal do neobjavljenega uredniškega gradiva.

## Naloge

### Naloga 1

Znotraj dovoljenega prostora `10.10.0.0/16` poišči aktivno omrežje NovaPress.

Zastavica 1.1. Kakšen je mrežni naslov /24?

### Naloga 2

V ciljnem omrežju odkrij in preštej aktivne IP naslove.

Zastavica 2.1. Koliko aktivnih IP naslovov najdeš?

### Naloga 3

Poišči javni spletni portal NovaPress.

Zastavica 3.1. Kakšen je IP naslov spletnega strežnika?

### Naloga 4

Z orodjem Nikto, OWASP ZAP ali ročnim pregledom poišči izpostavljene varnostne kopije oziroma konfiguracijske datoteke na spletnem strežniku.

Zastavica 4.1. Kakšna zastavica je zapisana v izpostavljeni deploy konfiguraciji?

### Naloga 5

V izpostavljenih datotekah poišči staro proxy konfiguracijo.

Zastavica 5.1. Kakšna zastavica je zapisana v stari proxy konfiguraciji?

### Naloga 6

Na portalu preveri, ali lahko z ugibanjem oziroma spreminjanjem identifikatorjev dostopaš do neobjavljenih novinarskih oziroma uredniških podatkov.

Zastavica 6.1. Kakšna je zastavica iz neobjavljenega press pass zapisa?

### Naloga 7

Preveri funkcijo za predogled zunanjih virov. Ugotovi, ali lahko prek nje dosežeš notranjo storitev.

Zastavica 7.1. Kakšna je zastavica, ki jo vrne notranji status endpoint?

### Naloga 8

Poišči SMB strežnik in enumeriraj deljene mape z Nmap NSE, enum4linux ali smbclient.

Zastavica 8.1. Kakšna je zastavica v javni SMB deljeni mapi?

### Naloga 9

Preglej uredniško SMB deljeno mapo.

Zastavica 9.1. Kakšna je zastavica v uredniški deljeni mapi?

### Naloga 10

Preveri, ali je katera SMB deljena mapa zapisljiva. Ustvari neškodljivo testno datoteko in jo naloži v ustrezen share.

Zastavica 10.1. Kakšna je zastavica za potrjeno zapisljivost SMB share-a?

### Naloga 11

Iz izpostavljene konfiguracije pridobi API ključ in preveri notranji uredniški API. Nato preveri, ali lahko dostopaš do osnutka, ki ni prikazan na seznamu navadnih osnutkov.

Zastavica 11.1. Kakšna je zastavica iz zaupnega osnutka?

### Naloga 12

Poišči monitoring napravo in preveri, ali razkriva informacije prek SNMP.

Zastavica 12.1. Kakšna je zastavica iz SNMP odgovora?

### Naloga 13

Z Wiresharkom, tcpdumpom ali on-path napadom prestrezi promet uredniške delovne postaje. Poišči HTTP prijavo ali sejo, ki potuje v nešifrirani obliki.

Zastavica 13.1. Kakšna je zastavica, ki jo najdeš po zajemu HTTP seje?

### Naloga 14

Na monitoring hostu poišči nestandardno storitev. S Scapyjem pošlji ustrezen TCP paket oziroma payload in preberi odgovor.

Zastavica 14.1. Kakšna je zastavica iz custom probe odgovora?

### Naloga 15

Sestavi kratek tehnični povzetek ugotovitev: aktivni hosti, izpostavljene storitve, najdene ranljivosti, možen vpliv in priporočila za odpravo.

Zastavica 15.1. Za zaključek oddaj zastavico iz navodil za poročilo.

## Namigi

```bash
nmap -sn 10.10.0.0/16
nmap -sC -sV -p- 10.10.20.0/24
nikto -h http://10.10.20.11
enum4linux -a 10.10.20.31
smbclient -L //10.10.20.31 -N
smbclient //10.10.20.31/public -N
snmpwalk -v2c -c public 10.10.20.81
tcpdump -i <iface> -s 0 -w novapress.pcap
wireshark novapress.pcap
ettercap -T -q -i <iface> --write mitm.pcap --mitm arp /10.10.20.71// /10.10.20.11//
```

Nekatere storitve odgovorijo šele, ko prejmejo točno določen payload.
