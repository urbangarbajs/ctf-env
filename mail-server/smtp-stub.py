#!/usr/bin/env python3
import socket
import threading

BANNER = "NovaPress Mail (Postfix)"


def send(conn, line):
    conn.sendall((line + "\r\n").encode())


def handle(conn):
    with conn:
        send(conn, f"220 {BANNER}")
        while True:
            data = conn.recv(2048)
            if not data:
                return
            line = data.decode(errors="ignore").strip()
            command = line.split(" ", 1)[0].upper()
            if command in {"EHLO", "HELO"}:
                send(conn, "250-srv-news-mail.novapress.local")
                send(conn, "250-PIPELINING")
                send(conn, "250-8BITMIME")
                send(conn, "250 OK")
            elif command == "QUIT":
                send(conn, "221 Bye")
                return
            elif command == "NOOP":
                send(conn, "250 OK")
            elif command == "RSET":
                send(conn, "250 OK")
            elif command in {"MAIL", "RCPT"}:
                send(conn, "250 OK")
            elif command == "DATA":
                send(conn, "354 End data with <CR><LF>.<CR><LF>")
            elif line == ".":
                send(conn, "250 Queued for lab delivery")
            else:
                send(conn, "502 Command not implemented in lab stub")


def serve(port):
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(("0.0.0.0", port))
    server.listen(20)
    while True:
        conn, _ = server.accept()
        threading.Thread(target=handle, args=(conn,), daemon=True).start()


def main():
    for port in (25, 587):
        threading.Thread(target=serve, args=(port,), daemon=True).start()
    threading.Event().wait()


if __name__ == "__main__":
    main()
