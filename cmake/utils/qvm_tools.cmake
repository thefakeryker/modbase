
include_guard(GLOBAL)

if(NOT BUILD_GAME_QVMS)
    return()
endif()

# Require user to set QVM_TOOLS_PATH
if(NOT DEFINED QVM_TOOLS_PATH OR QVM_TOOLS_PATH STREQUAL "OFF")
    message(FATAL_ERROR "QVM_TOOLS_PATH must be set to the directory containing your Quake Virtual Machine tools.")
endif()

if(CMAKE_BUILD_TYPE)
    set(BUILD_TYPE_ARG -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})
endif()

set(Q3LCC ${QVM_TOOLS_PATH}/q3lcc)
set(Q3ASM ${QVM_TOOLS_PATH}/q3asm)

function(add_qvm MODULE_NAME)
    list(REMOVE_AT ARGV 0)
    cmake_parse_arguments(ARG "" "" "DEFINITIONS;OUTPUT_NAME;OUTPUT_DIRECTORY;SOURCES" ${ARGV})

    set(QVM_OUTPUT_DIR ${CMAKE_BINARY_DIR}/$<CONFIG>)
    if(ARG_OUTPUT_DIRECTORY)
        set(QVM_OUTPUT_DIR ${QVM_OUTPUT_DIR}/${ARG_OUTPUT_DIRECTORY})
    endif()
    add_custom_command(
        OUTPUT ${QVM_OUTPUT_DIR}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${QVM_OUTPUT_DIR})

    if(ARG_OUTPUT_NAME)
        set(QVM_FILE ${QVM_OUTPUT_DIR}/${ARG_OUTPUT_NAME}.qvm)
    else()
        set(QVM_FILE ${QVM_OUTPUT_DIR}/${MODULE_NAME}.qvm)
    endif()

    set(QVM_ASM_DIR ${CMAKE_BINARY_DIR}/qvm.dir/${MODULE_NAME})
    file(MAKE_DIRECTORY ${QVM_ASM_DIR})

    set(LCC_FLAGS "")
    foreach(DEFINITION IN LISTS ARG_DEFINITIONS)
        list(APPEND LCC_FLAGS "-D${DEFINITION}")
    endforeach()

    set(ASM_FILES "")
    foreach(SOURCE ${ARG_SOURCES})
        if(${SOURCE} MATCHES "\\.asm$")
            list(APPEND ASM_FILES ${SOURCE})
            continue()
        endif()

        get_filename_component(BASE_FILE ${SOURCE} NAME_WE)
        set(ASM_FILE ${QVM_ASM_DIR}/${BASE_FILE}.asm)
        string(REPLACE "${CMAKE_BINARY_DIR}/" "" ASM_FILE_COMMENT ${ASM_FILE})


        add_custom_command(
            OUTPUT ${ASM_FILE}
            COMMAND ${Q3LCC} ${LCC_FLAGS} -o ${ASM_FILE} ${SOURCE}
            DEPENDS ${SOURCE} ${Q3LCC}
            COMMENT "Building C object ${ASM_FILE_COMMENT}")

        list(APPEND ASM_FILES ${ASM_FILE})
    endforeach()

    string(REPLACE "${CMAKE_BINARY_DIR}/" "" QVM_FILE_COMMENT ${QVM_FILE})

    add_custom_command(
        OUTPUT ${QVM_FILE}
        COMMAND ${Q3ASM} -o ${QVM_FILE} ${ASM_FILES}
        DEPENDS ${ASM_FILES} ${Q3ASM}
        COMMENT "Linking C QVM library ${QVM_FILE_COMMENT}")

    string(REGEX REPLACE "[^A-Za-z0-9]" "_" TARGET_NAME ${MODULE_NAME})
    add_custom_target(${TARGET_NAME} ALL DEPENDS ${QVM_FILE})

    if(ARG_OUTPUT_DIRECTORY)
        install(FILES ${QVM_FILE} DESTINATION ${ARG_OUTPUT_DIRECTORY})
    endif()
endfunction()
