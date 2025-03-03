import socket
import pickle

# Basic logging configuration
import logging
logging.basicConfig(format='\r[%(levelname)s: line %(lineno)d] %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)


# Packet class
class Packet:
    def __init__(self, data: str) -> None:
        self.data = data


# UDP receiver class
class UDP_Receiver:
    def __init__(self, receiver_ip: str, receiver_port: int, data_file: str, timeout: float, receive_buffer_size: int) -> None:

        self.receive_buffer_size = receive_buffer_size

        # Create a UDP socket
        self.sock = # === YOUR CODE HERE ===

        # bind the socket to the receiver IP and port
        # === YOUR CODE HERE ===

        # Set timeout
        self.sock.settimeout(timeout)

        # Open data file (overwrite existing file)
        self.data_file = open(data_file, 'w')

    def rdt_recv(self) -> Packet:
        # Receive packet
        rcvpkt, addr = # === YOUR CODE HERE ===
        logger.info('Received packet')
        # unpickle packet
        rcvpkt = pickle.loads(rcvpkt)
        # Return packet
        return rcvpkt

    def extract(self, rcvpkt: Packet) -> str:
        # Extract data
        data = rcvpkt.data
        # Return data
        return data

    def deliver_data(self, data: str) -> None:
        # Write data to file
        self.data_file.write(data)


    def run(self) -> None:
        # Receive data
        logger.info('############## Receiving data ##############')
        while True:
            try:
                # Receive packet using rdt_recv()
                rcvpkt = self.rdt_recv()

            # If timeout, break
            except socket.timeout:
                logger.info('Timeout')
                break

            # Extract data from received packet
            data = self.extract(rcvpkt)

            # check if data is EOT
            if data == 'EOT':
                logger.info('############## Received EOT packet ##############')
                break

            # Write data to file using deliver_data()
            self.deliver_data(data)

        # Close data file
        self.data_file.close()

        # Close socket
        self.sock.close()

if __name__ == '__main__':

    # Constants
    RECEIVER_IP = # === YOUR CODE HERE ===
    RECEIVER_PORT = # === YOUR CODE HERE ===
    DATA_FILE = 'data.txt'
    TIMEOUT = 10.0
    RECEIVE_BUFFER_SIZE = 1024

    # Create UDP receiver
    udp_receiver = # === YOUR CODE HERE ===

    # Run UDP receiver
    # === YOUR CODE HERE ===
