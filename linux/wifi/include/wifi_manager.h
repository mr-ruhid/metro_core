#ifndef WIFI_MANAGER_H
#define WIFI_MANAGER_H

#include <string>
#include <vector>

#ifdef __cplusplus
extern "C" {
#endif

// Wi-Fi ON/OFF
bool set_wifi_enabled(bool enabled);
bool is_wifi_enabled();

// Scan networks
const char* scan_networks();

// Connect to network
bool connect_to_network(const char* ssid, const char* password);
bool disconnect_network();

// Get current network info
const char* get_current_network();
int get_signal_strength();

// Saved networks
const char* get_saved_networks();
bool forget_network(const char* ssid);

// Wi-Fi Direct
bool enable_wifi_direct();
bool disable_wifi_direct();
const char* get_wifi_direct_devices();

// Hotspot
bool enable_hotspot(const char* ssid, const char* password);
bool disable_hotspot();
bool is_hotspot_enabled();

// Reset
bool reset_wifi_settings();

#ifdef __cplusplus
}
#endif

#endif // WIFI_MANAGER_H
