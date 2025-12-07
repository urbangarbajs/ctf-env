# HealthyClinic CTF Environment

A self-contained vulnerable lab on 10.10.10.0/24, covering discovery, enumeration, web vulns, hash cracking, privesc, and lateral movement. All services live on a single Docker bridge with fixed IPs. Flag format: `HC-CTF{...}`.

## Topology & Network

| Host/IP | Role | Ports/Services | Intentional clues / vulns |
| --- | --- | --- | --- |
| gw-hc `10.10.10.1` | Gateway placeholder | – | Present for host count only |
| srv-emr-web `10.10.10.10` | Apache/PHP EMR | 22, 80, 443 | Banner `Apache/2.4.49` (CVE-2021-41773), SQLi login bypass, reflected XSS |
| srv-emr-db `10.10.10.20` | MariaDB | 3306 | MRN record, backup hash, staff + mail data |
| srv-filesmb `10.10.10.30` | Samba | 139, 445 | Guest share `HR$`, banner `Samba 4.5.16` (CVE-2017-7494 hint) |
| srv-ftp-imaging `10.10.10.40` | vsftpd | 21 | Anonymous FTP, banner `vsftpd 2.3.4` (CVE-2011-2523 hint), `emr_backup_2025-10-01.sql.gz` |
| srv-mail `10.10.10.50` | Postfix + Dovecot | 25, 110, 143, 587 | Mailbox `nurse.ana@healthyclinic.local / Nurse123!`, flag in inbox |
| srv-backup `10.10.10.60` | SSH/rsync backup | 22, 873 | User `backup/HealthyBackup2025!`, sudo NOPASSWD, GPG vault (passphrase `MRN-2025-CTF-01!`) |
| client-mgmt `10.10.10.70` | RDP workstation | 3389 | User `HC-ADMIN/Adm1nHC!2025`, desktop flag |

## Run the Lab

Requirements: Docker Engine + compose plugin; user in `docker` group.

```bash
make up      # build + start (no host ports published by default)
make down    # stop + cleanup
make rebuild # rebuild all images
```

For local access, uncomment `ports:` for web/RDP in `docker-compose.yml` if needed.

## Intentional Vulnerabilities / Clues

- **EMR (web-emr)**: SQLi in `login.php` → `panel.php` shows SQLi flag and MRN; `search.php` reflects input and embeds `xssFlag`; Apache banner forced to 2.4.49.
- **DB (db-emr)**: seed MRN `MRN-2025-CTF-01`; `users.backup` SHA-256 hash `929a9c...6962b`; staff `nurse.ana`; mail contents.
- **FTP (ftp-imaging)**: anonymous enabled; root has `emr_backup_2025-10-01.sql.gz` + `.sql`; banner vsftpd 2.3.4 (CVE-2011-2523).
- **Mail (mail-server)**: IMAP/POP3 login `nurse.ana@healthyclinic.local / Nurse123!` with subject `HC-CTF{EMAIL_LEAK}`.
- **SMB (smb-file)**: hidden share `HR$` guest read-only with `flag_hr.txt` (`HC-CTF{SMB_DATA_EXFIL}`); banner Samba 4.5.16 (CVE-2017-7494).
- **Backup (backup-host)**: SSH/rsync, sudo NOPASSWD for `backup`; user flag `/home/backup/user_flag.txt`, root flag `/root/root_flag.txt`; `/root/passwords.gpg` (passphrase MRN-2025-CTF-01!) reveals `Adm1nHC!2025`.
- **RDP (client-mgmt)**: RDP login `HC-ADMIN/Adm1nHC!2025`, desktop `final_flag.txt` (`HC-CTF{DOMAIN_COMPROMISED}`).

## Tasks, Questions, and Flags

1) Discover 10.10.0.0/16, find the active /24.  
   - Flag 1.1: `10.10.10.0/24`
2) Count active IPs in the target /24.  
   - Flag 2.1: `8` (10.10.10.1, .10, .20, .30, .40, .50, .60, .70)
3) Scan all ports/services.  
   - Flag 3.1: `13` unique TCP ports (21, 22, 25, 80, 110, 139, 143, 443, 445, 587, 873, 3306, 3389)
4) Find the EMR portal.  
   - Flag 4.1: `10.10.10.10`
5) Identify web server version and CVE.  
   - Flag 5.1: `CVE-2021-41773` (Apache/2.4.49 banner)
6) Find the FTP server and CVE.  
   - Flag 6.1: `CVE-2011-2523` (vsftpd 2.3.4 backdoor)
7) Find the SMB server and CVE.  
   - Flag 7.1: `CVE-2017-7494` (SambaCry, banner 4.5.16)
8) Find the mail server (SMTP/POP3/IMAP).  
   - Flag 8.1: `10.10.10.50`
9) Find the backup host (SSH + rsync).  
   - Flag 9.1: `10.10.10.60`
10) SQLi on EMR login to enter the panel.  
    - Flag 10.1: `HC-CTF{MRN-2025-CTF-01}`
11) In the panel, find the CTF patient.  
    - Flag 11.1: `MRN-2025-CTF-01`
12) SQLi dump `users`, hash for `backup`.  
    - Flag 12.1: `929a9ca8774d3d05f5882bb2619473b5c5026618832affcaeb6cf70fd196962b`
13) Reflected XSS on `search.php`, print `xssFlag`.  
    - Flag 13.1: `HC-CTF{XSS_EXECUTED}`
14) Anonymous FTP, find the EMR backup.  
    - Flag 14.1: `emr_backup_2025-10-01.sql.gz`
15) From backup/DB read `staff` for `nurse.ana`.  
    - Flag 15.1: `nurse.ana@healthyclinic.local`
16) Same record, nurse password.  
    - Flag 16.1: `Nurse123!`
17) Login to mail with nurse creds, read mailbox.  
    - Flag 17.1: `HC-CTF{EMAIL_LEAK}`
18) Enumerate SMB shares, find HR share.  
    - Flag 18.1: `HR$`
19) Mount HR share, read HR flag.  
    - Flag 19.1: `HC-CTF{SMB_DATA_EXFIL}`
20) Crack the SHA-256 hash from task 12.  
    - Flag 20.1: `HealthyBackup2025!`
21) SSH to backup with the cracked password; find user flag.  
    - Flag 21.1: `HC-CTF{SSH_USER_PWNED}`
22) Sudo privesc on backup; find root flag.  
    - Flag 22.1: `HC-CTF{ROOT_ON_BACKUP}`
23) As root on backup, decrypt `/root/passwords.gpg` (passphrase MRN-2025-CTF-01!).  
    - Flag 23.1: `Adm1nHC!2025`
24) Find RDP host, login with domain creds, read desktop flag.  
    - Flag 24.1: `HC-CTF{DOMAIN_COMPROMISED}`

## Quick Tips for Players

1. Start with `nmap -sn 10.10.0.0/16`, then full port scan on 10.10.10.0/24.  
2. Banner grab for CVEs (Apache 2.4.49, vsftpd 2.3.4, Samba 4.5.16).  
3. Web: SQLi on login (`' OR '1'='1`), panel shows MRN/XSS hint; XSS on `search.php?term=`.  
4. FTP: anonymous `ls`, fetch `emr_backup_2025-10-01.sql.gz`.  
5. SMB: `smbclient -L //10.10.10.30 -N`, share `HR$`, file `flag_hr.txt`.  
6. Mail: IMAP/POP with `nurse.ana@healthyclinic.local / Nurse123!`.  
7. Hash cracking: SHA-256 for `backup` → `HealthyBackup2025!`.  
8. SSH to 10.10.10.60, `sudo -i`, decrypt `/root/passwords.gpg`.  
9. RDP to 10.10.10.70 with `HC-ADMIN/Adm1nHC!2025`, read `final_flag.txt`.
