ROOT_DIR := $(shell git rev-parse --show-toplevel)/../..

num_cores         := $(shell nproc)
num_cores_half    := $(shell echo "$$(($(num_cores) / 2))")
num_cores_quarter := $(shell echo "$$(($(num_cores) / 4))")

INSTALL_PREFIX          ?= install
INSTALL_DIR             ?= ${ROOT_DIR}/${INSTALL_PREFIX}
LLVM_INSTALL_DIR        ?= ${INSTALL_DIR}/riscv-llvm
ONNX_INSTALL_DIR        ?= ${INSTALL_DIR}/onnx-mlir
PROTOC_INSTALL_DIR      ?= ${INSTALL_DIR}/protoc
CMAKE_INSTALL_DIR       ?= ${INSTALL_DIR}/cmake
MLIR_DIR                ?= ${LLVM_INSTALL_DIR}/lib/cmake/mlir
PROTOC_DIR              ?= ${PROTOC_INSTALL_DIR}/bin
export PATH             := $(PROTOC_DIR):$(PATH) 
CC  := clang
CXX := clang++

CMAKE ?=  cmake

CLANG_INSTALL_DIR ?= ${INSTALL_DIR}/riscv-clang
CLANG_BUILD_DIR   ?= ${ROOT_DIR}/toolchain/riscv-llvm/build-clang

riscv-clang-config:
	mkdir -p $(CLANG_BUILD_DIR)
	mkdir -p $(CLANG_INSTALL_DIR)

	$(CMAKE) -S llvm -B $(CLANG_BUILD_DIR) \
		-DCMAKE_INSTALL_PREFIX=$(CLANG_INSTALL_DIR) \
		-DCMAKE_BUILD_TYPE="Debug" \
		-DCMAKE_C_COMPILER=$(CC) \
		-DCMAKE_CXX_COMPILER=$(CXX) \
		-DLLVM_ENABLE_PROJECTS="clang" \
		-DLLVM_TARGETS_TO_BUILD="RISCV" \
		-DLLVM_DEFAULT_TARGET_TRIPLE=riscv32-unknown-elf \
		-DLLVM_ENABLE_ASSERTIONS=ON \
		-DLLVM_ENABLE_RTTI=OFF \
		-DLLVM_DISTRIBUTION_COMPONENTS="clang;clang-resource-headers"

## build riscv compiler
riscv-clang: riscv-clang-config
	$(CMAKE) --build $(CLANG_BUILD_DIR) \
		--target install-distribution \
		-j$(num_cores_half)

## clean-up riscv build artefacts
riscv-clang-clean: 
	rm -rf $(CLANG_BUILD_DIR)
	mkdir -p $(CLANG_BUILD_DIR)

include $(ROOT_DIR)/common.mk