# *****************************************************
#    Copyright 2022 Videonetics Technology Pvt Ltd
# *****************************************************
cmake_minimum_required(VERSION 3.21)
project(stout)
message(STATUS "VCPKG_INSTALLED_DIR " ${VCPKG_INSTALLED_DIR})

find_package(Boost REQUIRED)
find_package(glog REQUIRED)
find_package(RapidJSON REQUIRED)
find_package(gflags REQUIRED)
find_package(elfio REQUIRED)
find_package(LibArchive REQUIRED)

find_package(CURL CONFIG REQUIRED)
find_package(GTest REQUIRED)
find_package(Protobuf REQUIRED COMPONENTS libprotobuf protoc)
find_path(PICOJSON_INCLUDE_DIRS "picojson/picojson.h")
set(PICOJSON_INCLUDE_DIRS ${PICOJSON_INCLUDE_DIRS}/picojson)

file(GLOB SOURCE_FILES CONFIGURE_DEPENDS include/stout/*.hpp)

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
    PUBLIC ${LibArchive_INCLUDE_DIRS}
)

target_link_libraries(stout
    PUBLIC Boost::boost
    PUBLIC CURL::libcurl
    PUBLIC glog::glog
    PUBLIC gflags::gflags
    PUBLIC rapidjson
    PUBLIC protobuf::libprotobuf
    PUBLIC elfio::elfio
    PUBLIC ${LibArchive_LIBRARIES}
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
else()
    target_link_libraries(stout
        PUBLIC rt
    )
endif(WIN32)

set_property(TARGET stout PROPERTY
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

file(GLOB_RECURSE TEST_SOURCE_FILES
    CONFIGURE_DEPENDS
    tests/*.cpp
    tests/os/*.cpp
)
list(FILTER TEST_SOURCE_FILES
    EXCLUDE REGEX
    ".*svn_tests\\.cpp$"
)

if(WIN32)
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
endif(WIN32)


message(STATUS "ppppppppp: " ${TEST_SOURCE_FILES})

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

protobuf_generate(
    LANGUAGE cpp
    TARGET stout_test
    PROTOS ${CMAKE_SOURCE_DIR}/tests/protobuf_tests.proto
)
target_include_directories(stout_test
    PUBLIC ${CMAKE_CURRENT_BINARY_DIR}
    PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/tests
)
set_property(TARGET stout_test PROPERTY
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
