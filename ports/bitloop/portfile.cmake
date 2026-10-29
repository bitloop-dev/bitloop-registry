# portfile.cmake

# 1. Fetch the Bitloop source from GitHub
vcpkg_from_github(
    OUT_SOURCE_PATH  SOURCE_PATH
    REPO             bitloop-dev/bitloop
    REF              v${VERSION}
    SHA512           370e4f48dd9444528f2ae3adebd1947e58253789f9d64c612b8e9c13fa890e442e1d753240da5e8c24bcb40eff6b198a483bf59b6ca10868a9250b1a057bee47
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTS
    FEATURES
        ffmpeg       BITLOOP_WITH_FFMPEG
        ffmpeg-x265  BITLOOP_WITH_FFMPEG_X265
        webgpu       BITLOOP_WITH_WEBGPU
)

# If ffmpeg-x265 is selected, also force BITLOOP_WITH_FFMPEG=ON
if(BITLOOP_WITH_FFMPEG_X265)
    list(APPEND FEATURE_OPTS -DBITLOOP_WITH_FFMPEG=ON)
endif()

# 3. Configure your Bitloop
vcpkg_configure_cmake(
  SOURCE_PATH    "${SOURCE_PATH}"
  PREFER_NINJA
  OPTIONS
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    ${FEATURE_OPTS}
)

# 4. Install it into vcpkg’s staging area
vcpkg_install_cmake()

# 5. Export the targets so find_package(bitloop) works
vcpkg_fixup_cmake_targets(CONFIG_PATH share/bitloop)
