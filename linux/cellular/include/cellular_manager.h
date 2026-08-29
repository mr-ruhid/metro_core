#ifndef CELLULAR_MANAGER_H
#define CELLULAR_MANAGER_H

#ifdef __cplusplus
extern "C" {
#endif

// SIM Functions
const char* get_sim_status();
const char* get_phone_number();
const char* get_imei();
const char* get_operator_name();

// Network Functions
const char* get_network_type();
int get_signal_strength();
const char* get_network_operators();
bool set_preferred_network(const char* type);

// Data Functions
bool set_mobile_data(bool enabled);
bool is_mobile_data_enabled();
const char* get_data_usage();

// Roaming Functions
bool set_roaming(bool enabled);
bool is_roaming_enabled();

// Reset
bool reset_network_settings();

#ifdef __cplusplus
}
#endif

#endif // CELLULAR_MANAGER_H
