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


# UDP sender class
class UDP_Sender:
    def __init__(self, sender_ip: str, sender_port: int, receiver_ip: str, receiver_port: int, data_file: str, timeout: float) -> None:

        self.receiver_ip = receiver_ip
        self.receiver_port = receiver_port
        self.data_file = data_file

        # Create a UDP socket
        self.sock = # === YOUR CODE HERE ===

        # bind the socket to the sender IP and port
        # === YOUR CODE HERE ===

        # Set timeout
        self.sock.settimeout(timeout)

        # Read data file line by line into a buffer (list)
        with open(self.data_file, 'r') as f:
            self.data_buffer = f.readlines()


    def udt_send(self, sndpkt: Packet) -> None:
        # Serialize packet (for sending packet object)
        sndpkt = pickle.dumps(sndpkt)
        # Send packet to the receiver
        # === YOUR CODE HERE ===
        logger.info('Sent pkt')


    def make_pkt(self, data: str) -> Packet:
        # Create packet
        pkt = Packet(data)
        # Return packet
        return pkt

    def run(self) -> None:
        logger.info('############## Sending data ##############')
        # loop through data buffer, make packet from each line, and send packet
        for data in self.data_buffer:
            # Create packet from data
            sndpkt = self.make_pkt(data)
            # Send packet to receiver, using udt_send()
            self.udt_send(sndpkt)

        # After sending all data, send EOT packet
        data = 'EOT'
        # Create packet from data
        sndpkt = self.make_pkt(data)
        # Send packet to receiver, using udt_send()
        self.udt_send(sndpkt)
        logger.info('############## Sent EOT Packet ##############')

        # Close socket
        self.sock.close()

if __name__ == '__main__':

    # Constants
    SENDER_IP = # === YOUR CODE HERE ===
    SENDER_PORT = # === YOUR CODE HERE ===
    RECEIVER_IP = # === YOUR CODE HERE ===
    RECEIVER_PORT = # === YOUR CODE HERE ===
    DATA_FILE = '/home/ttm4200/work_dir/data.txt'
    TIMEOUT = 1.0

    # Create UDP sender
    udp_sender = # === YOUR CODE HERE ===

    # Run UDP sender
    # === YOUR CODE HERE ===
