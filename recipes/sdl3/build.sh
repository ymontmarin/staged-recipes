#!/bin/sh

if [[ ${HOST} =~ .*darwin.* ]]; then
  # Adapt cflags for the sdk in use
  export CFLAGS="${CFLAGS} -isysroot ${SDKROOT:-$CONDA_BUILD_SYSROOT}"

  # Additional build option depending on target architecture
  if [[ "${target_platform}" == "osx-arm64" ]]; then
    export ADDITIONAL_OPTIONS="-DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"
  fi
  if [[ "${target_platform}" == "osx-x86_64" ]]; then
    export ADDITIONAL_OPTIONS="-DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"
  fi
fi

# Configure using the CMakeFiles
cmake -S . -B build ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      $ADDITIONAL_OPTIONS

# Build
cmake --build build --config Release

# Install
cmake --install build --config Release --prefix $PREFIX
