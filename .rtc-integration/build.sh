#!/bin/bash
# Build CasADi of the rtc-integration branch for the Python of the rtc-integration environment
# (PYTHON, default the uv-managed CPython 3.11 in <integration>/python; rtc-tools needs 3.11), with what the rtc-tools
# routes need: FMI 3 import (fmi-ls-dae), the ONNX translator (GraphBuilder, for lacemodelica)
# and the solvers of the examples (IPOPT with MUMPS, HiGHS, Bonmin, CBC, CLP).
# Install: <worktree>/install; put it on sys.path (a .pth file) instead of a casadi wheel.
#
# usage: .rtc-integration/build.sh   (CLEAN=1 for a fresh build directory, JOBS=n)
set -euxo pipefail
WT=$(cd "$(dirname "$0")/.." && pwd)
SWIG=${SWIG:-/home/yacoda/programs/swig/install/bin/swig3.0}
PYTHON=${PYTHON:-$(cd "$WT/.." && pwd)/python/cpython-3.11-linux-x86_64-gnu/bin/python3.11}
${CLEAN:+rm -rf "$WT/build"}
cmake -S "$WT" -B "$WT/build" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$WT/install" \
  -DWITH_SELFCONTAINED=ON -DWITH_PYTHON=ON -DWITH_PYTHON3=ON -DPYTHON_EXECUTABLE="$PYTHON" -DPython3_EXECUTABLE="$PYTHON" \
  -DSWIG_EXECUTABLE="$SWIG" -DWITH_DEEPBIND=ON -DWITH_DL=ON -DWITH_SO_VERSION=ON \
  -DWITH_IPOPT=ON -DWITH_BUILD_IPOPT=ON -DWITH_MUMPS=ON -DWITH_BUILD_MUMPS=ON -DWITH_BUILD_METIS=ON \
  -DWITH_HIGHS=ON -DWITH_BUILD_HIGHS=ON -DWITH_BONMIN=ON -DWITH_BUILD_BONMIN=ON \
  -DWITH_CBC=ON -DWITH_BUILD_CBC=ON -DWITH_CLP=ON -DWITH_BUILD_CLP=ON \
  -DWITH_CSPARSE=ON -DWITH_BUILD_CSPARSE=ON -DWITH_SUNDIALS=ON -DWITH_BUILD_SUNDIALS=ON \
  -DWITH_TINYXML=ON -DWITH_BUILD_TINYXML=ON -DWITH_LIBZIP=ON -DWITH_BUILD_LIBZIP=ON \
  -DWITH_ZLIB=ON -DWITH_BUILD_ZLIB=ON -DWITH_GHC_FILESYSTEM=ON -DWITH_BUILD_GHC_FILESYSTEM=ON \
  -DWITH_ONNX=ON -DWITH_BUILD_ONNX=ON -DWITH_BUILD_PROTOBUF=ON
cmake --build "$WT/build" --parallel "${JOBS:-16}" --target install
