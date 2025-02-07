import socket
import select
import sys
import json

# Basic logging configuration
import logging
logging.basicConfig(format='\r[%(levelname)s: line %(lineno)d] %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)


class ChatRoomP2PClient:

    def __init__(self, ServerIP: str, ServerPort: int, ClientIP: str, P2PPort: int, ReceiveBufferSize: int = 2048):
        self.ServerIP = ServerIP
        self.ServerPort = ServerPort
        self.ClientIP = ClientIP
        self.P2PPort = P2PPort
        self.ReceiveBufferSize = ReceiveBufferSize
        # Create TCP and UDP sockets
        self.client_socket_TCP= # === YOUR CODE HERE ===
        self.client_socket_TCP.settimeout(2)
        self.client_socket_UDP = # === YOUR CODE HERE ===
        self.client_socket_UDP.settimeout(2)
        # bind the UDP socket to the client's IP and P2P port
        # === YOUR CODE HERE ===
        # set the UDP socket to reuse the address
        # === YOUR CODE HERE ===
        self.list_of_sockets = [sys.stdin, self.client_socket_TCP, self.client_socket_UDP]
        self.p2p_peers = {} # {name: ip}
    
        # Connect to the chat server using the TCP socket
        try:
            # === YOUR CODE HERE ===
        except Exception as err:
            logger.error("Unable to connect to the server. Error message : %s" % err)
            sys.exit()

        logger.info("Connected to the chat server. IP: %s, Port: %s.\n To exit the chatroom type ':q'\n To list all online users type ':l'\n To send a p2p message type '@username: message' " % (self.ServerIP, self.ServerPort))

    # function to change the list of peers received from the server to the dictionary
    def update_peers(self, peers):
        self.p2p_peers = {peer[0]: peer[1] for peer in peers}


    def run(self):
        while True:
            read_sockets, write_sockets, error_sockets = select.select(self.list_of_sockets, [], [])
            for sock in read_sockets:

                # Incoming message from remote server
                if sock == self.client_socket_TCP:
                    # Receive data from the server
                    data = # === YOUR CODE HERE ===
                    # empty string means the server has closed the connection
                    if not data:
                        logger.info("Disconnected from chat server")
                        sys.exit()
                    else:
                        data = data.decode()
                        # check if the data is json
                        data = data.strip()
                        if data[0] == '[':
                            data = json.loads(data)
                            # update the list of peers using the update_peers() function
                            # === YOUR CODE HERE ===

                        else:
                            print("\r[Server] " + data )
                            print ("\r[Me]", end = " ", flush = True)

                # Incoming message from UDP socket
                elif sock == self.client_socket_UDP:
                    # Receive data from a peer (p2p)
                    data, addr = # === YOUR CODE HERE ===
                    data = data.decode()
                    peer_IP_address = addr[0]
                    peer_username = [username for username, ip in self.p2p_peers.items() if ip == peer_IP_address][0]
                    print ("\r[P2P] %s (IP: %s) says: %s" % (peer_username, peer_IP_address, data))
                    print ("\r[Me]", end = " ", flush = True)

                # User entered a message
                else:
                    msg = sys.stdin.readline()
                    msg = msg.strip()
                    # check if empty message
                    if not msg:
                        print ("\r[Me]", end = " ", flush = True)
                        continue
                    # check if the user wants to exit
                    elif msg == ':q':
                        self.client_socket_TCP.close()
                        sys.exit()
                    elif msg == ':l':
                        peers = list(self.p2p_peers.keys())
                        print ("\rOnline peers: %s" % peers)
                    # check if the user wants to send a p2p message
                    elif msg[0] == '@':
                        username = msg[1:msg.find(':')]
                        msg = msg[msg.find(':')+1:]
                        if username in self.p2p_peers.keys():
                            peer_IP_address = self.p2p_peers[username]
                            try:
                                # send the message to the peer (p2p)
                                # === YOUR CODE HERE ===
                            except Exception as err:
                                logger.error("Unable to send p2p message to %s. Error message : %s" % (username, err))
                        else:
                            print ("\rUser (%s) not found" % username)

                    # broadcast message to all connected clients (through the server) 
                    else:
                        try:
                            msg = msg.encode()
                            # send the message to the server
                            # === YOUR CODE HERE ===
                        except Exception as err:
                            logger.error("Unable to send message to the server. Error message : %s" % err)
                            sys.exit()

                    print("\r[Me]", end = " ", flush = True)


if __name__ == "__main__":
    # get the server IP address (DO NOT WRITE THE IP ADDRESS DIRECTLY IN THE CODE)
    ServerIP = # === YOUR CODE HERE ===
    ServerPort = # === YOUR CODE HERE ===
    MaxReceiveBufferSize = 2048
   # get the client IP address (DO NOT WRITE THE IP ADDRESS DIRECTLY IN THE CODE)
    ClientIP = # === YOUR CODE HERE ===
    # set the client's P2P port
    P2PPort = # === YOUR CODE HERE ===

    client = # === YOUR CODE HERE ===
    # run the client
    # === YOUR CODE HERE ===
