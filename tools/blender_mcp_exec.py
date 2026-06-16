import argparse
import json
import socket
import sys
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("script", type=Path, nargs="?")
    parser.add_argument("--code", help="Inline Python code to execute instead of a script file.")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=9876)
    args = parser.parse_args()

    if args.code is not None:
        code = args.code
    elif args.script is not None:
        code = args.script.read_text(encoding="utf-8")
    else:
        parser.error("provide a script path or --code")
    payload = json.dumps({"type": "execute", "code": code, "strict_json": True}).encode("utf-8") + b"\0"
    with socket.create_connection((args.host, args.port), timeout=10) as sock:
        sock.sendall(payload)
        chunks = []
        while True:
            data = sock.recv(65536)
            if not data:
                break
            if b"\0" in data:
                before, _sep, _after = data.partition(b"\0")
                chunks.append(before)
                break
            chunks.append(data)
    print(b"".join(chunks).decode("utf-8"))
    return 0


if __name__ == "__main__":
    sys.exit(main())
