# portfile.cmake

# 1. Fetch the Bitloop source from GitHub
vcpkg_from_github(
    OUT_SOURCE_PATH  SOURCE_PATH
    REPO             bitloop-dev/bitloop
    REF              v${VERSION}
    SHA512           6b5f3e8ed78ffe6465bcc2654c0be3d53f42cad0aea08821efd63c5497c5993715a4bf777ac8ad9e508a5b85ae2121ea8e0eaa51418df33471d35b91729be6e2
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
