import socket
import threading

HOST = "0.0.0.0"
PORT = 8081
EXPECTED = b"NP-PROBE:2026"
DEFAULT = b"NovaPress monitor endpoint. Custom probe required.\n"
FLAG = b"NP2-CTF{SCAPY_CUSTOM_PROBE}\n"


def handle_client(conn, addr):
    with conn:
        conn.settimeout(4)
        try:
            data = conn.recv(1024).strip()
        except socket.timeout:
            data = b""
        if data == EXPECTED:
            conn.sendall(FLAG)
        else:
            conn.sendall(DEFAULT)


def main():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind((HOST, PORT))
        sock.listen(20)
        while True:
            conn, addr = sock.accept()
            thread = threading.Thread(target=handle_client, args=(conn, addr), daemon=True)
            thread.start()


if __name__ == "__main__":
    main()
