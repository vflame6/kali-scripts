from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # print the request in raw format
        request_line = self.raw_requestline.decode('utf-8', errors='replace')
        print(request_line)
        headers = self.headers.as_string()
        print(headers)
        
        # reply to the client
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"200 OK")

    def do_POST(self):
        # print the request in raw format
        request_line = self.raw_requestline.decode('utf-8', errors='replace')
        print(request_line)
        headers = self.headers.as_string()
        print(headers)
        
        # read the request body
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length)
        print(body.decode('utf-8', errors='replace'))
        
        # reply to the client
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"200 OK")

def run(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler):
    # listen port 443
    server_address = ('', 443)
    httpd = server_class(server_address, handler_class)

    # creating a SSL context
    ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ssl_context.load_cert_chain(certfile="certificate.pem", keyfile="key.pem")
    
    # wrap http-server socket
    httpd.socket = ssl_context.wrap_socket(httpd.socket, server_side=True)

    print("Starting HTTPS server on port 443...")
    httpd.serve_forever()

if __name__ == '__main__':
    run()
