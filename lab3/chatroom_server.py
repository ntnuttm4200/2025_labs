import socket
import select
import sys

# Basic logging configuration
import logging
logging.basicConfig(format='\r[%(levelname)s: line %(lineno)d] %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

class ChatRoomServer:

    #__init__ is the constructor of the class
    def __init__(self, ServerIP: str, ServerPort: int, ReceiveBufferSize: int = 2048, MaxClients: int = 10):
        #server address and port
        self.ServerIP = ServerIP
        self.ServerPort = ServerPort
        #maximum amount of data to be received at once
        self.ReceiveBufferSize = ReceiveBufferSize
        # create a TCP socket
        self.server_socket = # === YOUR CODE HERE ===
        # set socket options to reuse the IP address (protocol level is socket, binding to the address is on)
        # === YOUR CODE HERE ===
        # bind the socket to the server address and port
        # === YOUR CODE HERE ===
        # set the maximum number of clients that can connect to the server with listen() function
        # === YOUR CODE HERE ===
        # list of socket descriptors, used as a read list for select()
        self.list_of_sockets = [self.server_socket]
        self.clients = {} # {socket: (name, ip)}

    #broadcast the message to all clients except the source client
    def broadcast(self, message: bytes, source_socket: socket.socket):
        for socket in self.clients.keys():
            if socket != source_socket:
                try:
                    # send the message to all the "other" clients
                    # === YOUR CODE HERE ===
                except Exception as err:
                    logger.error("Unable to send message to client. Error message : %s" % err)
                    socket.close()
                    self.remove(socket)

    def remove(self, socket: socket.socket):
        if socket in self.list_of_sockets:
            self.list_of_sockets.remove(socket)
            self.clients.pop(socket)


    def run(self):
        logger.info("Server started on IP: %s, Port: %s" % (self.ServerIP, self.ServerPort))
        while True:
            read_sockets, write_sockets, error_sockets = select.select(self.list_of_sockets, [], [])
            for sock in read_sockets:

                # New connection
                if sock == self.server_socket:
                    # Handle the case in which there is a new connection accepted through server_socket
                    sockfd, addr = # === YOUR CODE HERE ===
                    welcome_message = "Welcome to this chatroom! Type your username and press enter to continue: "
                    welcome_message = welcome_message.encode()

                    # Get the username
                    try:
                        # Send the welcome_message to the client
                        # === YOUR CODE HERE ===
                        # Receive the username from the client
                        username = # === YOUR CODE HERE ===
                        username = username.decode().strip()

                        # check if the username is valid: not empty and not too long, does not contain spaces   
                        if not username or len(username) > 20 or " " in username:
                            invalid_username_message = "Invalid username. Please try again.".encode()
                            # send the invalid username message to the client
                            # === YOUR CODE HERE ===
                            sockfd.close()
                            continue

                        # Check if the username is already taken
                        if any(username == client_details[0] for client_details in self.clients.values()):
                            username_already_taken_message = "Username already taken. Please try again.".encode()
                            # send the username already taken message to the client
                            # === YOUR CODE HERE ===
                            sockfd.close()
                            continue

                        # Username is valid, send a confirmation message
                        confirmation_message = ("Your username (%s) is valid. You can start chatting now." % username).encode()
                        # send the confirmation message to the client
                        # === YOUR CODE HERE ===

                        
                    except Exception as err:
                        logger.error("Unable to get username from client. Error message : %s" % err)
                        sockfd.close()
                        continue

                    # Add new socket descriptor to the list of readable connections
                    self.list_of_sockets.append(sockfd)
                    # Add new client to the list of clients
                    client_details = (username, addr[0])
                    self.clients[sockfd] = client_details
                    # Broadcast new client's details to all other clients
                    broadcast_message = "%s (IP: %s): connected" % client_details
                    print("New client connected: %s" % broadcast_message)
                    broadcast_message = broadcast_message.encode()
                    # broadcast the new client's details to all other clients with broadcast() function
                    # === YOUR CODE HERE ===
                    
                # Some incoming message from a client
                else:
                    # get the client details using the socket object that sent the message
                    client_details = self.clients[sock]
                    # receive data from the socket
                    data = # === YOUR CODE HERE ===

                    # if data is not empty, broadcast it to all other clients
                    if data:
                        broadcast_message = "%s (IP: %s) says: %s" % (client_details[0], client_details[1], data.decode())
                        print("Broadcast message from client: %s" % broadcast_message)
                        broadcast_message = broadcast_message.encode()
                        # broadcast the message to all other clients with broadcast() function
                        # === YOUR CODE HERE ===

                    # if data is empty, the client closed the connection
                    else:
                        broadcast_message = "%s (IP: %s): is offline" % client_details
                        print ("Client disconnected: %s" % broadcast_message)
                        broadcast_message = broadcast_message.encode()
                        # broadcast the client's disconnection to all other clients with broadcast() function
                        # === YOUR CODE HERE ===
                        sock.close()
                        self.remove(sock)

        self.server_socket.close()


if __name__ == "__main__":
    # Get the server IP address using hostname (DO NOT WRITE THE IP ADDRESS DIRECTLY)
    ServerIP = # === YOUR CODE HERE ===
    # Select a port number that the server will listen on (should be > 1024)
    ServerPort = # === YOUR CODE HERE ===
    ReceiveBufferSize = 2048
    MaxClients = 10
    # Create a new ChatRoomServer object using the above parameters
    server = # === YOUR CODE HERE ===
    # run the server
    # === YOUR CODE HERE ===
