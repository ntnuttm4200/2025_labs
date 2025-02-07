import socket
import select
import sys
import json
import time

# Basic logging configuration
import logging
logging.basicConfig(format='\r[%(levelname)s: line %(lineno)d] %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)


class ChatRoomP2PServer:

    def __init__(self, ServerIP: str, ServerPort: int, ReceiveBufferSize: int = 2048, MaxClients: int = 10):
        self.ServerIP = ServerIP
        self.ServerPort = ServerPort
        self.ReceiveBufferSize = ReceiveBufferSize
        # create a TCP socket
        self.server_socket = # === YOUR CODE HERE ===
        # set socket options to reuse the IP address (protocol level is socket, binding to the address is on)
        # === YOUR CODE HERE ===
        # bind the socket to the server address and port
        # === YOUR CODE HERE ===
        # set the maximum number of accepted connections to the server with listen() function
        # === YOUR CODE HERE ===
        # list of socket descriptors, used as a read list for select()
        self.list_of_sockets = [self.server_socket]
        self.clients = {} # {socket: (name, ip)}

    def broadcast(self, message: bytes, source_socket: socket.socket):
        for socket in self.clients.keys():
            if socket != source_socket:
                try:
                    # send the message to the client
                    # === YOUR CODE HERE ===
                except Exception as err:
                    logger.error("Unable to send message to client. Error message : %s" % err)
                    socket.close()
                    self.remove(socket)

    def remove(self, socket: socket.socket):
        if socket in self.list_of_sockets:
            self.list_of_sockets.remove(socket)
            self.clients.pop(socket)

    # function to broadcast list of clients to all connected clients 
    def broadcast_list_of_clients(self):
        # create a list of clients
        list_of_clients = list(self.clients.values())
        # convert the list of clients to json string
        list_of_clients = json.dumps(list_of_clients) 
        #sleep for 0.5 seconds to make sure the client has received the welcome message. This is to avoid concatenating the welcome message with the list of clients.
        time.sleep(0.5)
        # broadcast the encoded list of clients to all connected clients
        # the source_socket is the server_socket: the server is sending the list
        #use the broadcast() function
        # === YOUR CODE HERE ===


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
                        # send the welcome message to the client
                        # === YOUR CODE HERE ===
                        # receive the username from the client
                        username = # === YOUR CODE HERE ===
                        username = username.decode().strip()

                        # check if the username is valid: not empty and not too long, does not contain spaces   
                        if not username or len(username) > 20 or " " in username:
                            invalid_username_message = "Invalid username. Please try again. ".encode()
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
                    # broadcast new client's details to all other clients
                    broadcast_message = "%s (IP: %s) connected" % client_details
                    print("New client connected: %s" % broadcast_message)
                    broadcast_message = broadcast_message.encode()
                    # broadcast the message to all clients except the new client with the broadcast() function
                    # === YOUR CODE HERE ===
                    # Broadcast updated list of clients to all clients with the broadcast_list_of_clients() function
                    # === YOUR CODE HERE ===
                    
                # Some incoming message from a client
                else:
                    # get the client details using the socket object that sent the message
                    client_details = self.clients[sock]
                    # receive data from the socket
                    data = # === YOUR CODE HERE ===

                    # if data is not empty, broadcast it to all other clients
                    if data:
                        broadcast_message = "%s (IP: %s) said: %s" % (client_details[0], client_details[1], data.decode())
                        print ("Broadcasting message from client: %s" % broadcast_message)
                        broadcast_message = broadcast_message.encode()
                        # broadcast the message to all clients except the client that sent the message
                        # === YOUR CODE HERE ===

                    # if data is empty, the client closed the connection
                    else:
                        broadcast_message = "%s (IP: %s) is offline" % client_details
                        print ("Client disconnected: %s" % broadcast_message)
                        broadcast_message = broadcast_message.encode()
                        # broadcast the message to all clients
                        # === YOUR CODE HERE ===
                        sock.close()
                        self.remove(sock)
                        # update the list of clients to all clients with the broadcast_list_of_clients() function
                        # === YOUR CODE HERE ===

        self.server_socket.close()


if __name__ == "__main__":
    # Get the server IP address
    ServerIP = # === YOUR CODE HERE ===
    ServerPort = # === YOUR CODE HERE ===
    ReceiveBufferSize = 2048
    MaxClients = 10
    server = # === YOUR CODE HERE ===
    # run the server
    # === YOUR CODE HERE ===
