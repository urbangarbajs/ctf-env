# HealthyClinic CTF Environment

This repository builds a self-contained vulnerable lab that mirrors the **HealthyClinic** story (10.10.10.0/24) with 22 chained flags. All hosts live on one Docker bridge network with fixed IPs.

## Topology

| Host/IP | Role | Key Services | Intentional issues / flags |
| --- | --- | --- | --- |
| gw-hc `10.10.10.1` | Gateway placeholder | – | Only routing presence |
| srv-emr-web `10.10.10.10` | Apache/PHP EMR | 80, 443 | Apache banner `2.4.49` (CVE-2021-41773 lookalike), SQLi login bypass, reflected XSS search |
| srv-emr-db `10.10.10.20` | MariaDB | 3306 | Holds users, patient MRN, backup hash, mail data |
| srv-filesmb `10.10.10.30` | Samba | 445, 139 | Guest-hidden share `HR$`, flag file, Samba banner `4.5.16` (CVE-2017-7494 identification) |
| srv-ftp-imaging `10.10.10.40` | vsftpd | 21 | Anonymous FTP, banner `vsftpd 2.3.4` (CVE-2011-2523 identification), backup dump `.sql.gz` |
| srv-mail `10.10.10.50` | Postfix + Dovecot | 25, 110, 143, 587 | Mailbox `nurse.ana@healthyclinic.local / Nurse123!`, message `HC-CTF{EMAIL_LEAK}` |
| srv-backup `10.10.10.60` | SSH/rsync backup | 22, 873 | User `backup/HealthyBackup2025!`, sudo NOPASSWD, user/root flags, GPG vault (passphrase `MRN-2025-CTF-01!`) |
| client-mgmt `10.10.10.70` | RDP workstation | 3389 | User `HC-ADMIN/Adm1nHC!2025`, desktop `final_flag.txt` |

Flag format everywhere: `HC-CTF{value}`.

## Running the lab

Requirements:
- Docker Engine + compose plugin
- User in `docker` group

Commands:
```bash
make up      # build and start everything (no host ports published by default)
make down    # stop and remove
make rebuild # rebuild images
```

Optional for local interaction: uncomment `ports:` lines in `docker-compose.yml` for web/rdp if needed.

## Service notes / intended exploits

- **Apache/EMR** (`web-emr`): vulnerable SQL login (`login.php`), panel reveals patient MRN flag, reflected XSS on `search.php`. Apache banner fakes 2.4.49 for CVE-2021-41773 identification.
- **DB** (`db-emr`): seeds MRN `MRN-2025-CTF-01`, user `backup` hash `929a9c...6962b`, staff email `nurse.ana@healthyclinic.local`.
- **FTP** (`ftp-imaging`): anonymous access, find `emr_backup_2025-10-01.sql.gz` (contains staff creds + backup hash).
- **Mail** (`mail-server`): IMAP/POP login with `nurse.ana / Nurse123!` shows subject `HC-CTF{EMAIL_LEAK}`.
- **Backup** (`backup-host`): SSH with `backup/HealthyBackup2025!`, sudo NOPASSWD, user flag at `/home/backup/user_flag.txt`, root flag at `/root/root_flag.txt`, GPG vault `/root/passwords.gpg` decrypts to `Adm1nHC!2025`.
- **Samba** (`smb-file`): guest hidden share `HR$` contains `flag_hr.txt` with `HC-CTF{SMB_DATA_EXFIL}`; banner hints at CVE-2017-7494.
- **RDP** (`client-mgmt`): login with `HC-ADMIN/Adm1nHC!2025`, desktop `final_flag.txt` holds `HC-CTF{DOMAIN_COMPROMISED}`.

Match the sample tasks from the scenario (network discovery, service inventory, CVE identification, SQLi, XSS, hash cracking, FTP/SMB exfil, SSH privesc, GPG, RDP lateral move).
