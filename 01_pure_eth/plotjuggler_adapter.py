import socket
import time
import json
import math
import random

UDP_IP = "127.0.0.1"
UDP_PORT = 9870

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def generate_data(t):
    return {
        "signals": [
            {"name": "sin_wave", "value": math.sin(t)},
            {"name": "cos_wave", "value": math.cos(t)},
            {"name": "random_noise", "value": random.uniform(-1, 1)},
        ]
    }

def main():
    t = 0.0
    dt = 0.05  # 20 Hz

    print(f"Streaming UDP data to {UDP_IP}:{UDP_PORT}")
    while True:
        data = generate_data(t)
        json_data = json.dumps(data)
        sock.sendto(json_data.encode('utf-8'), (UDP_IP, UDP_PORT))
        time.sleep(dt)
        t += dt

if __name__ == "__main__":
    main()
