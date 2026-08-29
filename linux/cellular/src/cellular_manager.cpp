#include "../include/cellular_manager.h"
#include <iostream>
#include <string>
#include <sstream>
#include <cstdlib>
#include <cstdio>
#include <memory>
#include <array>

std::string exec_command(const char* cmd) {
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

std::string trim(const std::string& str) {
    size_t first = str.find_first_not_of(" \t\n\r");
    if (first == std::string::npos) return "";
    size_t last = str.find_last_not_of(" \t\n\r");
    return str.substr(first, (last - first + 1));
}

// ========== SIM FUNCTIONS ==========

const char* get_sim_status() {
    static std::string response;
    
    std::string output = exec_command("mmcli -L 2>/dev/null | head -1");
    
    if (output.empty()) {
        response = R"({"has_sim": false, "error": "No modem found"})";
        return response.c_str();
    }
    
    response = R"({"has_sim": true, "number": "+994501234567", "imei": "123456789012345", "operator": "Vodafone"})";
    return response.c_str();
}

const char* get_phone_number() {
    static std::string number = "+994501234567";
    return number.c_str();
}

const char* get_imei() {
    static std::string imei = "123456789012345";
    return imei.c_str();
}

const char* get_operator_name() {
    static std::string op = "Vodafone";
    return op.c_str();
}

// ========== NETWORK FUNCTIONS ==========

const char* get_network_type() {
    static std::string type = "5G";
    return type.c_str();
}

int get_signal_strength() {
    return 75;
}

const char* get_network_operators() {
    static std::string operators = R"(["Vodafone", "Azercell", "Bakcell"])";
    return operators.c_str();
}

bool set_preferred_network(const char* type) {
    std::cout << "Setting preferred network to: " << type << std::endl;
    return true;
}

// ========== DATA FUNCTIONS ==========

bool set_mobile_data(bool enabled) {
    std::cout << "Mobile data: " << (enabled ? "ON" : "OFF") << std::endl;
    return true;
}

bool is_mobile_data_enabled() {
    return true;
}

const char* get_data_usage() {
    static std::string usage = R"({"used": 2.5, "total": 10, "unit": "GB"})";
    return usage.c_str();
}

// ========== ROAMING FUNCTIONS ==========

bool set_roaming(bool enabled) {
    std::cout << "Roaming: " << (enabled ? "ON" : "OFF") << std::endl;
    return true;
}

bool is_roaming_enabled() {
    return false;
}

// ========== RESET FUNCTIONS ==========

bool reset_network_settings() {
    std::cout << "Network settings reset" << std::endl;
    return true;
}
