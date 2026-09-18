import socket
import json
import urllib.request
import re
import os

BREVO_API_KEY = os.environ.get("BREVO_API_KEY", "VOTRE_CLE_API_XKEYSIB")

def parse_smtp_payload(raw_data):
    data_str = raw_data.decode('utf-8', errors='ignore')
    
    mail_from_match = re.search(r'MAIL FROM:<([^>]+)>', data_str, re.IGNORECASE)
    rcpt_to_matches = re.findall(r'RCPT TO:<([^>]+)>', data_str, re.IGNORECASE)
    
    mail_from = mail_from_match.group(1) if mail_from_match else "gophish@domain.com"
    rcpt_tos = rcpt_to_matches if rcpt_to_matches else []
    
    subject_match = re.search(r'^Subject:\s*(.*)$', data_str, re.MULTILINE | re.IGNORECASE)
    subject = subject_match.group(1).strip() if subject_match else "No Subject"
    
    html_content = data_str
    if "\r\n\r\n" in data_str:
        html_content = data_str.split("\r\n\r\n", 1)[1]
        
    return mail_from, rcpt_tos, subject, html_content

def send_via_brevo_api(mail_from, rcpt_tos, subject, html_content):
    url = "https://api.brevo.com/v3/smtp/email"
    payload = {
        "sender": {"email": mail_from},
        "to": [{"email": email} for email in rcpt_tos],
        "subject": subject,
        "htmlContent": html_content
    }
    
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode('utf-8'),
        headers={
            "accept": "application/json",
            "api-key": BREVO_API_KEY,
            "content-type": "application/json"
        },
        method="POST"
    )
    
    try:
        with urllib.request.urlopen(req) as response:
            print(f"[RELAIS SUCCESS] Mail envoyé via API Brevo à {rcpt_tos} (Status {response.status})")
            return True
    except Exception as e:
        print(f"[RELAIS ERREUR] Échec envoi API Brevo: {e}")
        return False

def start_smtp_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(('127.0.0.1', 1025))
    server.listen(5)
    print("[RELAIS] Relais SMTP-vers-API Brevo démarré sur 127.0.0.1:1025...")
    
    while True:
        client, addr = server.accept()
        client.send(b"220 gophish-relay SimpleSMTP\r\n")
        
        buffer = b""
        mail_from, rcpt_tos = "", []
        
        while True:
            data = client.recv(1024)
            if not data:
                break
            buffer += data
            
            if data.startswith(b"HELO") or data.startswith(b"EHLO"):
                client.send(b"250-Hello\r\n250-SIZE 10485760\r\n250 OK\r\n")
            elif data.upper().startswith(b"MAIL FROM:"):
                client.send(b"250 OK\r\n")
            elif data.upper().startswith(b"RCPT TO:"):
                client.send(b"250 OK\r\n")
            elif data.upper().startswith(b"DATA"):
                client.send(b"354 Start mail input; end with <CRLF>.<CRLF>\r\n")
            elif b"\r\n.\r\n" in buffer:
                mail_from, rcpt_tos, subject, html_content = parse_smtp_payload(buffer)
                send_via_brevo_api(mail_from, rcpt_tos, subject, html_content)
                client.send(b"250 OK : queued\r\n")
                break
            elif data.upper().startswith(b"QUIT"):
                client.send(b"221 Bye\r\n")
                break
        client.close()

if __name__ == "__main__":
    start_smtp_server()
