#
#  Using options ENABLE_SYSTEM_CMD_SOUND, ENABLE_PORTAUDIO and
#  ENABLE_SNDFILE sets:
#
#     HAVE_SYSTEM_CMD_SOUND - build SystemCmdSound backend
#     SYSTEM_SOUND_CMD      - CLI command used by SystemCmdSound.
#     HAVE_PORTAUDIO        - build portaudio backend.
#     HAVE_SNDFILE          - build libsndfile support for portaudio.

find_program(APLAY aplay)
find_program(AFPLAY afplay)
set(SYSTEM_SOUND_CMD "\"\"")
if (APLAY)
  SET(SYSTEM_SOUND_CMD "\"aplay %s\"")
elseif (AFPLAY)
  SET(SYSTEM_SOUND_CMD "\"afplay %s\"")
elseif (WIN32)
  SET(SYSTEM_SOUND_CMD
    "\"PowerShell (New-Object Media.SoundPlayer \\\\\\\"%s\\\\\\\").PlaySync();\"")
endif ()

set(HAVE_SYSTEM_CMD_SOUND "")
if (NOT (ENABLE_SYSTEM_CMD_SOUND MATCHES OFF))
  if (APLAY OR AFPLAY OR WIN32)
    set(HAVE_SYSTEM_CMD_SOUND 1)
  elseif (ENABLE_SYSTEM_CMD_SOUND MATCHES "ON")
      message(STATUS "ENABLE_SYSTEM_CMD_SOUND is set"
                     " but I cannot find aplay(1) or afplay(1)")
    set(HAVE_SYSTEM_CMD_SOUND "")
  endif ()
endif ()

set(HAVE_PORTAUDIO "")
if (NOT ENABLE_PORTAUDIO MATCHES OFF)
  if (PORTAUDIO_FOUND)
    message(STATUS "Portaudio Found")
    include_directories(${PORTAUDIO_INCLUDE_DIRS})
    set(LATE_LIBS ${LATE_LIBS} ${PORTAUDIO_LIBRARIES})
    add_definitions(${PORTAUDIO_DEFINITIONS})
    set(HAVE_PORTAUDIO 1)
  elseif (ENABLE_PORTAUDIO MATCHES ON)
      message(STATUS "ENABLE_PORTAUDIO is set but I cannot find portaudio")
    set(HAVE_PORTAUDIO "")
  endif ()
endif ()

set(HAVE_SNDFILE "")
if (NOT ENABLE_SNDFILE MATCHES OFF)
  if (LIBSNDFILE_FOUND)
    message(STATUS "libsndfile Found")
    include_directories(${LIBSNDFILE_INCLUDE_DIRS})
    set(LATE_LIBS ${LATE_LIBS} ${LIBSNDFILE_LIBRARIES})
    set(HAVE_SNDFILE 1)
  elseif (ENABLE_SNDFILE MATCHES ON)
    message(WARNING "ENABLE_LIBSNDFILE is set but I cannot find libsndfile")
  endif ()
endif ()
