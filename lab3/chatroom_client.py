import socket
import select
import sys

# Basic logging configuration
import logging
logging.basicConfig(format='\r[%(levelname)s: line %(lineno)d] %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)


class ChatRoomClient:

    def __init__(self, ServerIP: str, ServerPort: int, ReceiveBufferSize: int = 2048):
        #server address and port
        self.ServerIP = ServerIP
        self.ServerPort = ServerPort
        self.ReceiveBufferSize = ReceiveBufferSize
        # Create a TCP socket
        self.client_socket = # === YOUR CODE HERE === 
        self.client_socket.settimeout(2)
        self.list_of_sockets = [sys.stdin, self.client_socket]
        # Connect to remote server
        try:
            # connect to the server
            # === YOUR CODE HERE ===
        except Exception as err:
            logger.error("Unable to connect to the server. Error message : %s " % err)
            sys.exit()
        logger.info("Connected to the chat server. IP: %s, Port: %s.\n To exit the chatroom type ':q'" % (self.ServerIP, self.ServerPort))

    def run(self):
        while True:
            read_sockets, write_sockets, error_sockets = select.select(self.list_of_sockets, [], [])
            for sock in read_sockets:

                # Incoming message from remote server
                if sock == self.client_socket:
                    # receive data from the server
                    data = # === YOUR CODE HERE ===
                    # empty string means the server has closed the connection
                    if not data:
                        logger.info("Disconnected from chat server")
                        sys.exit()
                    else:
                        print ("\r[Server] " + data.decode())
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
                    elif msg == ":q":
                        self.client_socket.close()
                        sys.exit()
                    # try to send the message
                    else:
                        try:
                            msg = msg.encode()
                            # send the message to the server
                            # === YOUR CODE HERE ===
                        except Exception as err:
                            logger.error("Unable to send message to the server. Error message : %s " % err)
                            sys.exit() 
                    print ("\r[Me]", end = " ", flush = True)



if __name__ == "__main__":
    # Get the server IP address using domain name of your team (e.g., team30.com): DO NOT WRITE THE IP ADDRESS DIRECTLY
    ServerIP = # === YOUR CODE HERE ===
    # write the port number that the server is listening on.
    ServerPort = # === YOUR CODE HERE === 
    MaxReceiveBufferSize = 2048
    # Create a ChatRoomClient object using the above parameters
    client = # === YOUR CODE HERE ===
    # run the client
    # === YOUR CODE HERE ===
