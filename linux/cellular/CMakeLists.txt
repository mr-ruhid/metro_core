cmake_minimum_required(VERSION 3.10)
project(cellular_manager VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(SOURCES
    src/cellular_manager.cpp
)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

add_library(cellular_manager SHARED ${SOURCES})

target_link_libraries(cellular_manager
    ${CMAKE_DL_LIBS}
    pthread
)
