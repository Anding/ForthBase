#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>

#pragma comment(lib, "ws2_32.lib")

void send_wol_packet(const char *mac_address) {
    WSADATA wsa;
    SOCKET s;
    struct sockaddr_in addr;
    unsigned char packet[102];
    unsigned char mac[6];
    int i;

    // Initialize Winsock
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        printf("Failed to initialize Winsock. Error Code: %d\n", WSAGetLastError());
        return;
    }

    // Create socket
    if ((s = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == INVALID_SOCKET) {
        printf("Could not create socket. Error Code: %d\n", WSAGetLastError());
        WSACleanup();
        return;
    }

    // Set socket options
    int opt = 1;
    if (setsockopt(s, SOL_SOCKET, SO_BROADCAST, (char *)&opt, sizeof(opt)) < 0) {
        printf("Failed to set socket options. Error Code: %d\n", WSAGetLastError());
        closesocket(s);
        WSACleanup();
        return;
    }

    // Convert MAC address to bytes
    sscanf(mac_address, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", &mac[0], &mac[1], &mac[2], &mac[3], &mac[4], &mac[5]);

    // Construct the magic packet
    memset(packet, 0xFF, 6); // 6 bytes of 0xFF
    for (i = 1; i <= 16; i++) {
        memcpy(&packet[i * 6], mac, 6); // 16 repetitions of the MAC address
    }

    // Set up the broadcast address
    addr.sin_family = AF_INET;
    addr.sin_port = htons(9); // WOL uses port 9
    addr.sin_addr.s_addr = INADDR_BROADCAST;

    // Send the packet
    if (sendto(s, (char *)packet, sizeof(packet), 0, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        printf("Failed to send packet. Error Code: %d\n", WSAGetLastError());
    } else {
        printf("Magic packet sent successfully.\n");
    }

    // Clean up
    closesocket(s);
    WSACleanup();
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <MAC Address>\n", argv[0]);
        return 1;
    }

    send_wol_packet(argv[1]);
    return 0;
}
