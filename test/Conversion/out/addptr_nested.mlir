#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @kernel(%arg0: memref<*xbf16>, %arg1: i32, %arg2: i32, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32) {
    %c15 = arith.constant 15 : index
    %c10 = arith.constant 10 : index
    %c5 = arith.constant 5 : index
    %0 = arith.index_cast %arg1 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%0], sizes: [4, 256], strides: [1, %c5] : memref<*xbf16> to memref<4x256xbf16, strided<[1, ?], offset: ?>>
    %alloc = memref.alloc() : memref<4x256xbf16>
    memref.copy %reinterpret_cast, %alloc : memref<4x256xbf16, strided<[1, ?], offset: ?>> to memref<4x256xbf16>
    %1 = bufferization.to_tensor %alloc restrict writable : memref<4x256xbf16>
    %2 = arith.index_cast %arg1 : i32 to index
    %3 = arith.addi %0, %2 : index
    %reinterpret_cast_0 = memref.reinterpret_cast %arg0 to offset: [%3], sizes: [4, 256], strides: [2, %c10] : memref<*xbf16> to memref<4x256xbf16, strided<[2, ?], offset: ?>>
    %alloc_1 = memref.alloc() : memref<4x256xbf16>
    memref.copy %reinterpret_cast_0, %alloc_1 : memref<4x256xbf16, strided<[2, ?], offset: ?>> to memref<4x256xbf16>
    %4 = bufferization.to_tensor %alloc_1 restrict writable : memref<4x256xbf16>
    %5 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%1, %4 : tensor<4x256xbf16>, tensor<4x256xbf16>) outs(%1 : tensor<4x256xbf16>) {
    ^bb0(%in: bf16, %in_3: bf16, %out: bf16):
      %8 = arith.addf %in, %in_3 : bf16
      linalg.yield %8 : bf16
    } -> tensor<4x256xbf16>
    %6 = arith.index_cast %arg1 : i32 to index
    %7 = arith.addi %3, %6 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [%7], sizes: [4, 256], strides: [3, %c15] : memref<*xbf16> to memref<4x256xbf16, strided<[3, ?], offset: ?>>
    bufferization.materialize_in_destination %5 in writable %reinterpret_cast_2 : (tensor<4x256xbf16>, memref<4x256xbf16, strided<[3, ?], offset: ?>>) -> ()
    return
  }
}

