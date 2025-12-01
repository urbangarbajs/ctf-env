# CTF Target Environment

This repo defines a simple vulnerable lab:

- PHP web app with SQL injection (`web_emr`)
- MySQL database (`db_emr`)
- Samba file share with world-readable backups (`smb_file`)
- Linux host with sudo misconfig for privilege escalation (`vuln_host`)

## Requirements

- Ubuntu Server
- Docker Engine + docker compose plugin
- User `ctf` in `docker` group

## Usage

```bash
git clone <this-repo-url> ctf-target-env
cd ctf-target-env
make up
