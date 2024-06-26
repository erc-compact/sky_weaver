IF (PSRDADA_INCLUDE_DIR)
    SET(PSRDADA_INC_DIR ${PSRDADA_INCLUDE_DIR})
    UNSET(PSRDADA_INCLUDE_DIR)
ENDIF (PSRDADA_INCLUDE_DIR)

FIND_PATH(PSRDADA_INCLUDE_DIR dada_def.h
    PATHS ${PSRDADA_INC_DIR}
    ${PSRDADA_INSTALL_DIR}/include
    /usr/local/include/psrdada
    /usr/local/include
    /usr/include )

SET(PSRDADA_NAMES psrdada)
FOREACH( lib ${PSRDADA_NAMES} )
    FIND_LIBRARY(PSRDADA_LIBRARY_${lib}
        NAMES ${lib}
        PATHS ${PSRDADA_LIBRARY_DIR} ${PSRDADA_INSTALL_DIR} ${PSRDADA_INSTALL_DIR}/lib /usr/local/lib /usr/lib
        )
    LIST(APPEND PSRDADA_LIBRARIES ${PSRDADA_LIBRARY_${lib}})
ENDFOREACH(lib)

# handle the QUIETLY and REQUIRED arguments and set PSRDADA_FOUND to TRUE if.
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PSRDADA DEFAULT_MSG PSRDADA_LIBRARIES PSRDADA_INCLUDE_DIR)

IF(NOT PSRDADA_FOUND)
    SET( PSRDADA_LIBRARIES )
    SET( PSRDADA_TEST_LIBRARIES )
ELSE(NOT PSRDADA_FOUND)
    # -- add dependecies
    LIST(APPEND PSRDADA_LIBRARIES ${CUDA_curand_LIBRARY})
ENDIF(NOT PSRDADA_FOUND)

LIST(APPEND PSRDADA_INCLUDE_DIR "${PSRDADA_INCLUDE_DIR}")

MARK_AS_ADVANCED(PSRDADA_LIBRARIES PSRDADA_TEST_LIBRARIES PSRDADA_INCLUDE_DIR)
