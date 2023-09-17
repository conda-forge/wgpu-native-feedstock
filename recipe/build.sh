set -ex
export WGPU_NATIVE_VERSION=v${PKG_VERSION}
export CARGO_PKG_VERSION=${PKG_VERSION}
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

cp ${PREFIX}/include/webgpu.h ffi/webgpu-headers/webgpu.h

CARGO_TARGET="${HOST}"
CARGO_TARGET="$(echo -n ${CARGO_TARGET} | sed "s/conda/unknown/")"
CARGO_TARGET="$(echo -n ${CARGO_TARGET} | sed "s/darwin.*/darwin/")"
CARGO_TARGET="$(echo -n ${CARGO_TARGET} | sed "s/arm64/aarch64/")"

cargo build \
    --release \
    --all-features \
    --target ${CARGO_TARGET}

rm target/CACHEDIR.TAG
rm -rf target/release
cp target/*/release/libwgpu_native${SHLIB_EXT} ${PREFIX}/lib/libwgpu_native${SHLIB_EXT}

mkdir -p ${PREFIX}/include

cp ffi/wgpu.h ${PREFIX}/include/wgpu.h
