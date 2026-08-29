# ========== WIFI LIBRARY ==========
add_subdirectory(wifi)

# Link libraries
target_link_libraries(metro_core PRIVATE
  flutter_managed
  cellular_manager
  wifi_manager
  ${CMAKE_DL_LIBS}
)
