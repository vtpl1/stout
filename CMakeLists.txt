# *****************************************************
#    Copyright 2022 Videonetics Technology Pvt Ltd
# *****************************************************
cmake_minimum_required(VERSION 3.21)
project(stout)
message(STATUS "VCPKG_INSTALLED_DIR " ${VCPKG_INSTALLED_DIR})

set(CMAKE_CXX_STANDARD 17)

find_package(boost REQUIRED functional get_pointer lexical_cast variant)
find_package(glog REQUIRED)
# find_package(picojson REQUIRED)
find_package(RapidJSON REQUIRED)
find_package(CURL CONFIG REQUIRED)
find_path(PICOJSON_INCLUDE_DIRS "picojson.h")
find_package(GTest REQUIRED)
find_package(gflags REQUIRED)

file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS include/stout/*.hpp)

set(PICOJSON_INCLUDE_DIRS ${PICOJSON_INCLUDE_DIRS}/picojson)
message(STATUS PICOJSON_INCLUDE_DIRS ${PICOJSON_INCLUDE_DIRS})

add_library(stout
    ${SOURCE_FILES}
    a.cpp
)

target_compile_definitions(stout
    PUBLIC UNICODE
    PUBLIC _UNICODE
)

target_compile_features(stout PUBLIC cxx_std_17)

if(WIN32)
    target_compile_definitions(stout
        PUBLIC NOMINMAX
        PUBLIC __WINDOWS__
    )
endif(WIN32)

target_include_directories(stout
    PUBLIC include
    PUBLIC ${PICOJSON_INCLUDE_DIRS}
)

target_link_libraries(stout
    PUBLIC Boost::boost
    PUBLIC CURL::libcurl
    PUBLIC glog::glog
    PUBLIC gflags::gflags
    PUBLIC rapidjson
)

if(WIN32)
    target_link_libraries(stout
        PUBLIC Advapi32
        PUBLIC UserEnv
        PUBLIC bcrypt
        PUBLIC ws2_32
        PUBLIC iphlpapi
        PUBLIC mswsock
        PUBLIC secur32
    )
endif(WIN32)

set_property(TARGET stout PROPERTY
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

# list(APPEND TEST_SOURCE_EXCLUDE_FILES
#     svn_tests.cpp
#     protobuf_tests.cpp
#     archiver_tests.cpp
#     os/systems_tests.cpp
#     os/signals_tests.cpp
# )

file(GLOB_RECURSE TEST_SOURCE_FILES
    CONFIGURE_DEPENDS
    tests/*.cpp
    tests/os/*.cpp
)

# list(REMOVE_ITEM TEST_SOURCE_FILES
#     svn_tests.cpp
#     protobuf_tests.cpp
#     archiver_tests.cpp
#     os/systems_tests.cppa
#     os/signals_tests.cpp
# )

list(FILTER TEST_SOURCE_FILES
    EXCLUDE REGEX
    ".*archiver_tests\\.cpp$"
)

list(FILTER TEST_SOURCE_FILES
    EXCLUDE REGEX
    ".*svn_tests\\.cpp$"
)

list(FILTER TEST_SOURCE_FILES
    EXCLUDE REGEX
    ".*protobuf_tests\\.cpp$"
)

list(FILTER TEST_SOURCE_FILES
    EXCLUDE REGEX
    ".*proc_tests\\.cpp$"
)

list(FILTER TEST_SOURCE_FILES
    EXCLUDE REGEX
    ".*systems_tests\\.cpp$"
)

list(FILTER TEST_SOURCE_FILES
    EXCLUDE REGEX
    ".*signals_tests\\.cpp$"
)

message(STATUS "ppppppppp" ${TEST_SOURCE_FILES})

add_executable(stout_test
    # tests/main.cpp
    # tests/adaptor_tests.cpp
    ${TEST_SOURCE_FILES}
)

target_link_libraries(stout_test
    PUBLIC GTest::gmock
    PUBLIC GTest::gtest
    PUBLIC stout
)

set_property(TARGET stout_test PROPERTY
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
