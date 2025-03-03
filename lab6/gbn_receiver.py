import socket
import pickle
import sys
import binascii

# Basic logging configuration
import logging
logging.basicConfig(format='\r[%(levelname)s: line %(lineno)d] %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)


# Packet class
class Packet:
    def __init__(self, seq_num: int, data: str, checksum: int) -> None:
        self.seq_num = seq_num
        self.data = data
        self.checksum = checksum


# GBN receiver class
class GBN_Receiver:
    def __init__(self, server_ip: str, server_port: int, receiver_ip: str, receiver_port: int, window_size: int, timeout: float,  data_file: str, receive_buffer_size: int) -> None:
        self.server_ip = server_ip
        self.server_port = server_port
        self.window_size = window_size
        self.timeout = timeout
        self.receive_buffer_size = receive_buffer_size

        # Create a UDP socket
        self.sock = # === YOUR CODE HERE ===

        # bind the socket to the receiver's IP and port
        # === YOUR CODE HERE ===

        # Set the socket timeout
        self.sock.settimeout(self.timeout)


        # Open data file (overwrites existing file)
        self.data_file = open(data_file, 'w')


    def rdt_rcv(self) -> Packet:
        # Receive packet from the sender
        rcvpkt, addr = # === YOUR CODE HERE ===
        rcvpkt = pickle.loads(rcvpkt)
        logger.info('rcv pkt%d', rcvpkt.seq_num)
        return rcvpkt

    def udt_send(self, sndpkt: Packet) -> None:
        logger.info('send ACK%d', sndpkt.seq_num)
        # serialize packet (necessary for sending packet object over socket)
        sndpkt = pickle.dumps(sndpkt)
        # Send packet (ACK) to the sender
        # === YOUR CODE HERE ===

    def make_pkt(self, seqnum: int, ACK: str, checksum: int) -> Packet:
        # Create packet
        pkt = Packet(seqnum, ACK, checksum)
        # Return packet
        return pkt

    def notcorrupt(self, rcvpkt: Packet) -> bool:
        # Check if packet is corrupted
        checksum = self.compute_checksum(rcvpkt.seq_num, rcvpkt.data)
        return checksum == rcvpkt.checksum

    def extract(self, rcvpkt: Packet) -> str:
        # Return data
        return rcvpkt.data

    def hasseqnum(self, rcvpkt: Packet, expectedseqnum: int) -> bool:
        # Check if packet has expected sequence number
        return rcvpkt.seq_num == expectedseqnum


    def deliver_data(self, data: str) -> None:
        # Write data to file
        self.data_file.write(data)

    def compute_checksum(self, seqnum: int, data: str) -> int:
        # Compute checksum
        checksum = binascii.crc32((str(seqnum) + data).encode())
        return checksum

    def run(self) -> None:
        logger.info('############## Receiving data ##############')

        # Initialize variables
        # FIGURE 2, CIRCLE 1: INITIAL STATE OF GBN RECEIVER
        # Start with 0 to be compatible with python (0 based indexing)
        expectedseqnum = 0
        # initialize ACK: start with -1 to indicate that you haven't received packet 0 yet
        ACK = 'ACK'
        checksum = self.compute_checksum(-1, ACK)
        sndpkt = self.make_pkt(-1, ACK, checksum)

        while True:
            try:
                # Receive packet using rdt_rcv()
                rcvpkt = # === YOUR CODE HERE ===

            # Timeout
            except socket.timeout:
                logger.info('########## Timeout ##########')
                break

            # FIGURE 2, CIRCLE 2: rdt_rcv() && notcorrupt() && hasseqnum(rcvpkt, expectedseqnum)
            if self.notcorrupt(rcvpkt) and self.hasseqnum(rcvpkt, expectedseqnum):
                # Extract data using extract()
                data = # === YOUR CODE HERE ===
                if data == 'EOT':
                    # End of transmission
                    logger.info('########## Received EOT Packet ##########')
                    break
                # Deliver data using deliver_data()
                # === YOUR CODE HERE ===

                checksum = self.compute_checksum(expectedseqnum, ACK)
                # make ACK packet using make_pkt()
                sndpkt = # === YOUR CODE HERE ===
                # send ACK packet using udt_send()
                # === YOUR CODE HERE ===
                # Increment expected sequence number
                # === YOUR CODE HERE ===

            # FIGURE 2, CIRCLE 3: default: send ACK of last correctly received packet
            else:
                # Send sndpkt using udt_send()
                # === YOUR CODE HERE ===


        # Close data file
        self.data_file.close()

        # Close socket
        self.sock.close()

if __name__ == '__main__':

    # Constants
    SERVER_IP = # === YOUR CODE HERE ===
    SERVER_PORT = # === YOUR CODE HERE ===
    RECEIVER_IP = #
    RECEIVER_PORT = # === YOUR CODE HERE ===
    WINDOW_SIZE = # === YOUR CODE HERE ===
    TIMEOUT = 10.0
    DATA_FILE = 'data.txt'
    RECEIVE_BUFFER_SIZE = 1024

    # Create GBN receiver
    gbn_receiver = # === YOUR CODE HERE === , Use higher timeout value than the sender

    # Run GBN receiver
    # === YOUR CODE HERE ===
