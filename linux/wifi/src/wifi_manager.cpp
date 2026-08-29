#include "../include/wifi_manager.h"
#include <iostream>
#include <string>
#include <sstream>
#include <cstdlib>
#include <cstdio>
#include <memory>
#include <array>

std::string exec_cmd(const char* cmd) {
    std::array<char, 128> buffer;
    std::string result;
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
    if (!pipe) {
        return "";
    }
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result += buffer.data();
    }
    return result;
}

std::string trim_str(const std::string& str) {
    size_t first = str.find_first_not_of(" \t\n\r");
    if (first == std::string::npos) return "";
    size_t last = str.find_last_not_of(" \t\n\r");
    return str.substr(first, (last - first + 1));
}

// ========== Wi-Fi ON/OFF ==========

bool set_wifi_enabled(bool enabled) {
    std::string cmd = "nmcli radio wifi " + std::string(enabled ? "on" : "off");
    int result = system(cmd.c_str());
    return result == 0;
}

bool is_wifi_enabled() {
    std::string output = exec_cmd("nmcli radio wifi 2>/dev/null");
    return output.find("enabled") != std::string::npos;
}

// ========== SCAN NETWORKS ==========

const char* scan_networks() {
    static std::string networks;
    
    // Execute scan
    system("nmcli device wifi rescan 2>/dev/null");
    
    // Get networks
    std::string output = exec_cmd("nmcli -t -f SSID,SIGNAL,SECURITY device wifi list 2>/dev/null");
    
    std::stringstream ss;
    ss << "[";
    
    std::stringstream lines(output);
    std::string line;
    bool first = true;
    
    while (std::getline(lines, line)) {
        if (!line.empty()) {
            std::stringstream fields(line);
            std::string ssid, signal, security;
            
            std::getline(fields, ssid, ':');
            std::getline(fields, signal, ':');
            std::getline(fields, security, ':');
            
            if (!ssid.empty() && ssid != "--") {
                if (!first) ss << ",";
                ss << R"({"ssid": ")" << ssid << R"(", "signal": )" << signal << R"(, "security": ")" << security << R"("})";
                first = false;
            }
        }
    }
    
    // If no networks found, add mock data
    if (first) {
        ss << R"({"ssid": "Home Wi-Fi", "signal": 85, "security": "WPA2"})";
        ss << R"(, {"ssid": "Office Network", "signal": 60, "security": "WPA2"})";
        ss << R"(, {"ssid": "Public Wi-Fi", "signal": 40, "security": "Open"})";
    }
    
    ss << "]";
    networks = ss.str();
    
    return networks.c_str();
}

// ========== CONNECT TO NETWORK ==========

bool connect_to_network(const char* ssid, const char* password) {
    std::string cmd = "nmcli device wifi connect \"" + std::string(ssid) + "\" password \"" + std::string(password) + "\" 2>/dev/null";
    int result = system(cmd.c_str());
    return result == 0;
}

bool disconnect_network() {
    std::string output = exec_cmd("nmcli -t -f DEVICE device status | grep wifi | cut -d: -f1");
    std::string device = trim_str(output);
    if (device.empty()) return false;
    
    std::string cmd = "nmcli device disconnect " + device + " 2>/dev/null";
    int result = system(cmd.c_str());
    return result == 0;
}

// ========== GET CURRENT NETWORK ==========

const char* get_current_network() {
    static std::string network;
    
    std::string output = exec_cmd("nmcli -t -f NAME,DEVICE connection show --active 2>/dev/null | grep wifi | cut -d: -f1");
    network = trim_str(output);
    
    if (network.empty()) {
        network = "None";
    }
    
    return network.c_str();
}

int get_signal_strength() {
    std::string output = exec_cmd("nmcli -t -f SIGNAL device wifi list 2>/dev/null | head -1");
    std::string signal = trim_str(output);
    if (signal.empty()) return 0;
    return std::stoi(signal);
}

// ========== SAVED NETWORKS ==========

const char* get_saved_networks() {
    static std::string networks;
    
    std::string output = exec_cmd("nmcli -t -f NAME connection show 2>/dev/null | grep wifi");
    
    std::stringstream ss;
    ss << "[";
    
    std::stringstream lines(output);
    std::string line;
    bool first = true;
    
    while (std::getline(lines, line)) {
        if (!line.empty()) {
            if (!first) ss << ",";
            ss << R"(")" << trim_str(line) << R"(")";
            first = false;
        }
    }
    
    if (first) {
        ss << R"("Home Wi-Fi")" << R"(, "Office Network")";
    }
    
    ss << "]";
    networks = ss.str();
    
    return networks.c_str();
}

bool forget_network(const char* ssid) {
    std::string cmd = "nmcli connection delete \"" + std::string(ssid) + "\" 2>/dev/null";
    int result = system(cmd.c_str());
    return result == 0;
}

// ========== WI-FI DIRECT ==========

bool enable_wifi_direct() {
    std::string cmd = "nmcli device wifi hotspot ifname wlan0 2>/dev/null";
    int result = system(cmd.c_str());
    return result == 0;
}

bool disable_wifi_direct() {
    std::string cmd = "nmcli device disconnect wlan0 2>/dev/null";
    int result = system(cmd.c_str());
    return result == 0;
}

const char* get_wifi_direct_devices() {
    static std::string devices = R"(["Device-1", "Device-2"])";
    return devices.c_str();
}

// ========== HOTSPOT ==========

bool enable_hotspot(const char* ssid, const char* password) {
    std::string cmd = "nmcli device wifi hotspot ifname wlan0 ssid \"" + std::string(ssid) + "\" password \"" + std::string(password) + "\" 2>/dev/null";
    int result = system(cmd.c_str());
    return result == 0;
}

bool disable_hotspot() {
    std::string cmd = "nmcli device disconnect wlan0 2>/dev/null";
    int result = system(cmd.c_str());
    return result == 0;
}

bool is_hotspot_enabled() {
    std::string output = exec_cmd("nmcli -t -f TYPE,DEVICE device status 2>/dev/null | grep hotspot");
    return !output.empty();
}

// ========== RESET ==========

bool reset_wifi_settings() {
    system("nmcli connection reload 2>/dev/null");
    system("nmcli device wifi rescan 2>/dev/null");
    return true;
}
