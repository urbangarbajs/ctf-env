# NovaPress Slovenija CTF Environment

Kratek, lokalen CTF laboratorij za zasebno etično-hackersko delavnico. Okolje predstavlja izmišljeno slovensko medijsko podjetje **NovaPress Slovenija** in javni novičarski portal z namernimi ranljivostmi.

Lab teče v Docker Compose na ločenem bridge omrežju `10.10.20.0/24`. Privzeto ni objavljenih portov na host sistem. Okolja ne izpostavljajte internetu.

## Varnostne Opombe

- To je namerno ranljivo okolje za učenje v nadzorovanem laboratoriju.
- Ne objavljajte portov na javnih vmesnikih.
- Containerji niso privilegirani in ne montirajo Docker host datotečnega sistema.
- Simuliran FTP backdoor odpre shell samo znotraj FTP containerja.
- Vsak "root shell" je root samo v containerju, nikoli na Docker hostu.

## Topologija

Docker network:

- ime: `news_ctf_net`
- subnet: `10.10.20.0/24`
- bridge: `br-news-ctf`

| Host | IP | Services | Purpose |
|---|---:|---|---|
| gw-news | 10.10.20.1 | - | Gateway placeholder |
| srv-news-web | 10.10.20.11 | 80 | News portal, SQLi, stored XSS |
| srv-news-db | 10.10.20.21 | 3306 | News, employees, hashes, business data |
| srv-news-ftp | 10.10.20.41 | 21, 6200 | Anonymous FTP, vsftpd 2.3.4 backdoor |
| srv-news-mail | 10.10.20.51 | 25,110,143,587 | Mailbox with flag |

## Zagon

Zahteve: Docker Engine in Docker Compose plugin.

```bash
make up
make down
make rebuild
```

Privzeto `docker-compose.yml` ne objavi nobenega porta na host. Če potrebujete lokalno razhroščevanje portala v brskalniku, lahko začasno odkomentirate primer `ports:` pri `srv-news-web`.

## Zgodba

NovaPress Slovenija je izmišljena medijska hiša z javnim portalom, starim FTP arhivom, notranjo podatkovno bazo in poštnim strežnikom. Portal vsebuje novice po rubrikah, komentarje bralcev, vreme, iskanje in lažno prijavo na e-novice. Uredništvo uporablja staro infrastrukturo, zato so v okolju namerno prisotne učne ranljivosti:

- SQL injection v iskalniku novic.
- Stored XSS v komentarjih člankov in uredniškem pregledu komentarjev.
- Anonymous FTP z javno zastavico.
- Simuliran vsftpd 2.3.4 backdoor, ki odpre shell na TCP 6200 znotraj FTP containerja.
- Mailbox zaposlenega, dostopen po razbitju hasha.

## Naloge

### Naloga 1

Znotraj dovoljenega prostora `10.10.0.0/16` poišči aktivno omrežje NovaPress.

Flag 1.1: Kakšen je mrežni naslov /24?

### Naloga 2

V ciljnem omrežju preštej aktivne IP naslove, vključno z gateway placeholderjem.

Flag 2.1: Koliko aktivnih IP naslovov najdeš?

### Naloga 3

Poišči spletni novičarski portal.

Flag 3.1: Kakšen je IP naslov spletnega strežnika?

### Naloga 4

Na portalu poišči možnost komentiranja novic. Preveri, ali komentarji omogočajo stored XSS. S pomočjo XSS prikaži skrito JavaScript zastavico.

Flag 4.1: Kakšen je XSS flag?

### Naloga 5

Na iskalniku novic preveri SQL injection. S pomočjo SQLi pridobi podatke iz tabele zaposlenih.

Flag 5.1: Kakšna je zastavica pri zaposlenem `matic.kovac`?

### Naloga 6

Iz baze pridobi SHA-256 hash uporabnika `matic.kovac`.

Flag 6.1: Kakšen je celoten SHA-256 hash?

### Naloga 7

Uporabi namig o dolžini in obliki gesla. Razbij hash z orodjem hashcat ali john.

Flag 7.1: Kakšno je plaintext geslo?

### Naloga 8

Preveri FTP strežnik in anonymous dostop. Poišči javno dostopno FTP zastavico.

Flag 8.1: Kakšna je FTP zastavica?

### Naloga 9

S pridobljenim geslom se prijavi v mailbox zaposlenega `matic.kovac`. Preberi posebno e-poštno sporočilo.

Flag 9.1: Kakšna je e-poštna zastavica?

### Naloga 10

Identificiraj FTP verzijo in javno znano ranljivost.

Flag 10.1: Kakšna je oznaka CVE za vsftpd 2.3.4 backdoor?

### Naloga 11

Izkoristi simulirano vsftpd 2.3.4 backdoor ranljivost. Pridobi shell na FTP containerju in preberi `/root/flag_ftp_shell.txt`.

Flag 11.1: Kakšna je zastavica iz FTP shell dostopa?

### Naloga 12

Na istem FTP containerju poišči neobjavljene osnutke novic.

Flag 12.1: Kakšna je končna zastavica iz neobjavljenega osnutka?

## Quick Tips

```bash
nmap -sn 10.10.0.0/16
nmap -sC -sV -p- 10.10.20.0/24
curl 'http://10.10.20.11/search.php?q=test'
```

Iskalnik ima namig v HTML komentarju. Začni z odkrivanjem števila stolpcev, na primer z `ORDER BY`, nato preveri `UNION SELECT`.

```bash
hashcat -m 1400 hash.txt wordlist.txt
ftp 10.10.20.41
nc 10.10.20.41 6200
nc 10.10.20.51 143
```

IMAP prijava uporablja poln e-poštni naslov kot username.

## Flags

Za oddajo se uporabljajo vrednosti iz nalog. Vse CTF zastavice uporabljajo format `NP-CTF{...}`.
