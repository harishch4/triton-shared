// RUN: triton-shared-opt --split-input-file --triton-to-structured --canonicalize --triton-arith-to-linalg --structured-to-memref %s | FileCheck %s

module {
  tt.func public @_layer_norm_fwd_fused_0123456789(%arg0: !tt.ptr<f32>, %arg1: !tt.ptr<f32>, %arg2: !tt.ptr<f32>, %arg3: !tt.ptr<f32>, %arg4: !tt.ptr<f32>, %arg5: !tt.ptr<f32>, %arg6: i32, %arg7: i32, %arg8: f32) {
    %c256_i32 = arith.constant 256 : i32
    %c0_i32 = arith.constant 0 : i32
    %cst = arith.constant 1.000000e+00 : f32
    %cst_0 = arith.constant 0.000000e+00 : f32
    %0 = tt.get_program_id x : i32
    %1 = arith.muli %0, %arg6 : i32
    %2 = tt.addptr %arg1, %1 : !tt.ptr<f32>, i32
    %3 = tt.addptr %arg0, %1 : !tt.ptr<f32>, i32
    %4 = tt.splat %cst_0 : (f32) -> tensor<256xf32>
    %5 = tt.make_range {end = 256 : i32, start = 0 : i32} : tensor<256xi32>
    %6 = tt.splat %arg7 : (i32) -> tensor<256xi32>
    %7 = tt.splat %3 : (!tt.ptr<f32>) -> tensor<256x!tt.ptr<f32>>
    %8 = scf.for %arg9 = %c0_i32 to %arg7 step %c256_i32 iter_args(%arg10 = %4) -> (tensor<256xf32>)  : i32 {
      %32 = tt.splat %arg9 : (i32) -> tensor<256xi32>
      %33 = arith.addi %32, %5 : tensor<256xi32>
      %34 = arith.cmpi slt, %33, %6 : tensor<256xi32>
      %35 = tt.addptr %7, %33 : tensor<256x!tt.ptr<f32>>, tensor<256xi32>
      %36 = tt.load %35, %34, %4 {cache = 1 : i32, evict = 1 : i32, isVolatile = false} : tensor<256xf32>
      %37 = arith.addf %arg10, %36 : tensor<256xf32>
      scf.yield %37 : tensor<256xf32>
    }
    %9 = "tt.reduce"(%8) ({
    ^bb0(%arg9: f32, %arg10: f32):
      %32 = arith.addf %arg9, %arg10 : f32
      tt.reduce.return %32 : f32
    }) {axis = 0 : i32} : (tensor<256xf32>) -> f32
    %10 = arith.sitofp %arg7 : i32 to f32
    %11 = arith.divf %9, %10 : f32
    %12 = tt.make_range {end = 256 : i32, start = 0 : i32} : tensor<256xi32>
    %13 = tt.splat %arg7 : (i32) -> tensor<256xi32>
    %14 = tt.splat %3 : (!tt.ptr<f32>) -> tensor<256x!tt.ptr<f32>>
    %15 = tt.splat %11 : (f32) -> tensor<256xf32>
    %16 = scf.for %arg9 = %c0_i32 to %arg7 step %c256_i32 iter_args(%arg10 = %4) -> (tensor<256xf32>)  : i32 {
      %32 = tt.splat %arg9 : (i32) -> tensor<256xi32>
      %33 = arith.addi %32, %12 : tensor<256xi32>
      %34 = arith.cmpi slt, %33, %13 : tensor<256xi32>
      %35 = tt.addptr %14, %33 : tensor<256x!tt.ptr<f32>>, tensor<256xi32>
      %36 = tt.load %35, %34, %4 {cache = 1 : i32, evict = 1 : i32, isVolatile = false} : tensor<256xf32>
      %37 = arith.subf %36, %15 : tensor<256xf32>
      %38 = arith.select %34, %37, %4 : tensor<256xi1>, tensor<256xf32>
      %39 = arith.mulf %38, %38 : tensor<256xf32>
      %40 = arith.addf %arg10, %39 : tensor<256xf32>
      scf.yield %40 : tensor<256xf32>
    }
    %17 = "tt.reduce"(%16) ({
    ^bb0(%arg9: f32, %arg10: f32):
      %32 = arith.addf %arg9, %arg10 : f32
      tt.reduce.return %32 : f32
    }) {axis = 0 : i32} : (tensor<256xf32>) -> f32
    %18 = arith.divf %17, %10 : f32
    %19 = arith.addf %18, %arg8 : f32
    %20 = math.sqrt %19 : f32
    %21 = arith.divf %cst, %20 : f32
    %22 = tt.addptr %arg4, %0 : !tt.ptr<f32>, i32
    tt.store %22, %11 {cache = 1 : i32, evict = 1 : i32} : f32
    %23 = tt.addptr %arg5, %0 : !tt.ptr<f32>, i32
    tt.store %23, %21 {cache = 1 : i32, evict = 1 : i32} : f32
    %24 = tt.make_range {end = 256 : i32, start = 0 : i32} : tensor<256xi32>
    %25 = tt.splat %arg7 : (i32) -> tensor<256xi32>
    %26 = tt.splat %arg2 : (!tt.ptr<f32>) -> tensor<256x!tt.ptr<f32>>
    %27 = tt.splat %arg3 : (!tt.ptr<f32>) -> tensor<256x!tt.ptr<f32>>
    %28 = tt.splat %3 : (!tt.ptr<f32>) -> tensor<256x!tt.ptr<f32>>
    %29 = tt.splat %11 : (f32) -> tensor<256xf32>
    %30 = tt.splat %21 : (f32) -> tensor<256xf32>
    %31 = tt.splat %2 : (!tt.ptr<f32>) -> tensor<256x!tt.ptr<f32>>
    scf.for %arg9 = %c0_i32 to %arg7 step %c256_i32  : i32 {
      %32 = tt.splat %arg9 : (i32) -> tensor<256xi32>
      %33 = arith.addi %32, %24 : tensor<256xi32>
      %34 = arith.cmpi slt, %33, %25 : tensor<256xi32>
      %35 = tt.addptr %26, %33 : tensor<256x!tt.ptr<f32>>, tensor<256xi32>
      %36 = tt.load %35, %34 {cache = 1 : i32, evict = 1 : i32, isVolatile = false} : tensor<256xf32>
      %37 = tt.addptr %27, %33 : tensor<256x!tt.ptr<f32>>, tensor<256xi32>
      %38 = tt.load %37, %34 {cache = 1 : i32, evict = 1 : i32, isVolatile = false} : tensor<256xf32>
      %39 = tt.addptr %28, %33 : tensor<256x!tt.ptr<f32>>, tensor<256xi32>
      %40 = tt.load %39, %34, %4 {cache = 1 : i32, evict = 1 : i32, isVolatile = false} : tensor<256xf32>
      %41 = arith.subf %40, %29 : tensor<256xf32>
      %42 = arith.mulf %41, %30 : tensor<256xf32>
      %43 = arith.mulf %42, %36 : tensor<256xf32>
      %44 = arith.addf %43, %38 : tensor<256xf32>
      %45 = tt.addptr %31, %33 : tensor<256x!tt.ptr<f32>>, tensor<256xi32>
      tt.store %45, %44, %34 {cache = 1 : i32, evict = 1 : i32} : tensor<256xf32>
    }
    tt.return
  }
}

// mlir2FileCheck.py
// CHECK-DAG:   [[MAP_0_:#.+]] = affine_map<(d0) -> (d0)>
// CHECK-LABEL:  func.func @_layer_norm_fwd_fused_0123456789
// CHECK-SAME:   ([[PARAM_0_:%.+]]: memref<*xf32>, [[PARAM_1_:%.+]]: memref<*xf32>, [[PARAM_2_:%.+]]: memref<*xf32>, [[PARAM_3_:%.+]]: memref<*xf32>, [[PARAM_4_:%.+]]: memref<*xf32>, [[PARAM_5_:%.+]]: memref<*xf32>, [[PARAM_6_:%.+]]: i32, [[PARAM_7_:%.+]]: i32, [[PARAM_8_:%.+]]: f32, [[PARAM_9_:%.+]]: i32, [[PARAM_10_:%.+]]: i32, [[PARAM_11_:%.+]]: i32, [[PARAM_12_:%.+]]: i32, [[PARAM_13_:%.+]]: i32, [[PARAM_14_:%.+]]: i32) {
// CHECK-DAG:       [[CST_1_dot_000000_:%.+]] = arith.constant 1.000000e+00 : f32
// CHECK-DAG:       [[CST_0_:%.+]] = arith.constant 0 : i32
// CHECK-DAG:       [[CST_256_:%.+]] = arith.constant 256 : i32
// CHECK-DAG:       [[CST_256_1_:%.+]] = arith.constant 256 : index
// CHECK-DAG:       [[CST_0_dot_000000_:%.+]] = arith.constant 0.000000e+00 : f32
// CHECK-DAG:       [[VAR_reinterpret_cast_:%.+]] = memref.reinterpret_cast [[PARAM_5_]] to offset: [0], sizes: [1], strides: [1] : memref<*xf32> to memref<1xf32>
// CHECK-DAG:       [[VAR_reinterpret_cast_1_:%.+]] = memref.reinterpret_cast [[PARAM_4_]] to offset: [0], sizes: [1], strides: [1] : memref<*xf32> to memref<1xf32>
// CHECK-DAG:       [[VAR_0_:%.+]] = tensor.empty() : tensor<256xf32>
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:       [[VAR_1_:%.+]] = linalg.fill ins([[CST_0_dot_000000_]] : f32) outs([[VAR_0_]] : tensor<256xf32>) -> tensor<256xf32>
// CHECK-DAG:       [[VAR_2_:%.+]] = arith.muli [[PARAM_12_]], [[PARAM_6_]] : i32
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:       [[VAR_3_:%.+]] = arith.index_cast [[VAR_2_]] : i32 to index
// CHECK-DAG:       [[VAR_4_:%.+]] = arith.index_cast [[VAR_2_]] : i32 to index
// CHECK-DAG:       [[VAR_5_:%.+]] = scf.for [[VAR_arg15_:%.+]] = [[CST_0_]] to [[PARAM_7_]] step [[CST_256_]] iter_args([[VAR_arg16_:%.+]] = [[VAR_1_]]) -> (tensor<256xf32>)  : i32 {
// CHECK-DAG:         [[VAR_27_:%.+]] = arith.index_cast [[VAR_arg15_]] : i32 to index
// CHECK:             [[VAR_28_:%.+]] = arith.addi [[VAR_3_]], [[VAR_27_]] : index
// CHECK-DAG:         [[VAR_reinterpret_cast_11_:%.+]] = memref.reinterpret_cast [[PARAM_0_]] to offset: {{.}}[[VAR_28_]]{{.}}, sizes: [256], strides: [1] : memref<*xf32> to memref<256xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_29_:%.+]] = arith.index_cast [[VAR_arg15_]] : i32 to index
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:         [[VAR_30_:%.+]] = arith.addi [[VAR_29_]], [[CST_256_1_]] : index
// CHECK-DAG:         [[VAR_31_:%.+]] = arith.index_cast [[PARAM_7_]] : i32 to index
// CHECK:             [[VAR_32_:%.+]] = arith.minsi [[VAR_30_]], [[VAR_31_]] : index
// CHECK-DAG:         [[VAR_33_:%.+]] = arith.subi [[VAR_32_]], [[VAR_29_]] : index
// CHECK-DAG:         [[RES_:%.+]] = memref.alloc() : memref<256xf32>
// CHECK:             [[VAR_34_:%.+]] = arith.cmpi slt, [[VAR_33_]], [[CST_256_1_]] : index
// CHECK:             scf.if [[VAR_34_]] {
// CHECK:               linalg.fill ins([[CST_0_dot_000000_]] : f32) outs([[RES_]] : memref<256xf32>)
// CHECK:             }
// CHECK-DAG:         [[VAR_subview_:%.+]] = memref.subview [[VAR_reinterpret_cast_11_]][0] {{.}}[[VAR_33_]]{{.}} [1] : memref<256xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_subview_12_:%.+]] = memref.subview [[RES_]][0] {{.}}[[VAR_33_]]{{.}} [1] : memref<256xf32> to memref<?xf32, strided<[1]>>
// CHECK:             memref.copy [[VAR_subview_]], [[VAR_subview_12_]] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1]>>
// CHECK:             [[VAR_35_:%.+]] = bufferization.to_tensor [[RES_]] restrict writable : memref<256xf32>
// CHECK:             [[VAR_36_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_arg16_]], [[VAR_35_]] : tensor<256xf32>, tensor<256xf32>) outs([[VAR_arg16_]] : tensor<256xf32>) {
// CHECK:             ^bb0([[IN_0_:%.+]]: f32, [[IN_1_:%.+]]: f32, [[IN_2_:%.+]]: f32):
// CHECK:               [[VAR_37_:%.+]] = arith.addf [[IN_0_]], [[IN_1_]] : f32
// CHECK:               linalg.yield [[VAR_37_]] : f32
// CHECK:             } -> tensor<256xf32>
// CHECK:             scf.yield [[VAR_36_]] : tensor<256xf32>
// CHECK:           }
// CHECK:           [[VAR_6_:%.+]] = bufferization.alloc_tensor() : tensor<f32>
// CHECK:           [[VAR_inserted_:%.+]] = tensor.insert [[CST_0_dot_000000_]] into [[VAR_6_]][] : tensor<f32>
// CHECK:           [[VAR_reduced_:%.+]] = linalg.reduce ins([[VAR_5_]] : tensor<256xf32>) outs([[VAR_inserted_]] : tensor<f32>) dimensions = [0]
// CHECK:             ([[IN_0_:%.+]]: f32, [[init_:%.+]]: f32) {
// CHECK:               [[VAR_27_1_:%.+]] = arith.addf [[IN_0_]], [[init_]] : f32
// CHECK:               linalg.yield [[VAR_27_1_]] : f32
// CHECK:             }
// CHECK-DAG:       [[VAR_extracted_:%.+]] = tensor.extract [[VAR_reduced_]][] : tensor<f32>
// CHECK-DAG:       [[VAR_7_:%.+]] = arith.sitofp [[PARAM_7_]] : i32 to f32
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:       [[VAR_8_:%.+]] = arith.divf [[VAR_extracted_]], [[VAR_7_]] : f32
// CHECK-DAG:       [[VAR_9_:%.+]] = tensor.empty() : tensor<256xi32>
// CHECK:           [[VAR_10_:%.+]] = linalg.generic {indexing_maps = [#map], iterator_types = ["parallel"]} outs([[VAR_9_]] : tensor<256xi32>) {
// CHECK:           ^bb0([[IN_3_:%.+]]: i32):
// CHECK:             [[VAR_27_2_:%.+]] = linalg.index 0 : index
// CHECK:             [[VAR_28_1_:%.+]] = arith.index_cast [[VAR_27_2_]] : index to i32
// CHECK:             linalg.yield [[VAR_28_1_]] : i32
// CHECK:           } -> tensor<256xi32>
// CHECK:           [[VAR_11_:%.+]] = tensor.empty() : tensor<256xi32>
// CHECK-DAG:       [[VAR_12_:%.+]] = linalg.fill ins([[PARAM_7_]] : i32) outs([[VAR_11_]] : tensor<256xi32>) -> tensor<256xi32>
// CHECK-DAG:       [[VAR_13_:%.+]] = tensor.empty() : tensor<256xf32>
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:       [[VAR_14_:%.+]] = linalg.fill ins([[VAR_8_]] : f32) outs([[VAR_13_]] : tensor<256xf32>) -> tensor<256xf32>
// CHECK-DAG:       [[VAR_15_:%.+]] = scf.for [[VAR_arg15_1_:%.+]] = [[CST_0_]] to [[PARAM_7_]] step [[CST_256_]] iter_args([[VAR_arg16_1_:%.+]] = [[VAR_1_]]) -> (tensor<256xf32>)  : i32 {
// CHECK-DAG:         [[VAR_27_3_:%.+]] = tensor.empty() : tensor<256xi32>
// CHECK:             [[VAR_28_2_:%.+]] = linalg.fill ins([[VAR_arg15_1_]] : i32) outs([[VAR_27_3_]] : tensor<256xi32>) -> tensor<256xi32>
// CHECK:             [[VAR_29_1_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_28_2_]], [[VAR_10_]] : tensor<256xi32>, tensor<256xi32>) outs([[VAR_28_2_]] : tensor<256xi32>) {
// CHECK:             ^bb0([[IN_4_:%.+]]: i32, [[IN_5_:%.+]]: i32, [[IN_6_:%.+]]: i32):
// CHECK:               [[VAR_45_:%.+]] = arith.addi [[IN_4_]], [[IN_5_]] : i32
// CHECK:               linalg.yield [[VAR_45_]] : i32
// CHECK:             } -> tensor<256xi32>
// CHECK:             [[VAR_30_1_:%.+]] = tensor.empty() : tensor<256xi1>
// CHECK:             [[VAR_31_1_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_29_1_]], [[VAR_12_]] : tensor<256xi32>, tensor<256xi32>) outs([[VAR_30_1_]] : tensor<256xi1>) {
// CHECK:             ^bb0([[IN_7_:%.+]]: i32, [[IN_8_:%.+]]: i32, [[IN_9_:%.+]]: i1):
// CHECK:               [[VAR_45_1_:%.+]] = arith.cmpi slt, [[IN_7_]], [[IN_8_]] : i32
// CHECK:               linalg.yield [[VAR_45_1_]] : i1
// CHECK:             } -> tensor<256xi1>
// CHECK:             [[VAR_32_1_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK:             [[VAR_33_1_:%.+]] = arith.addi [[VAR_3_]], [[VAR_32_1_]] : index
// CHECK-DAG:         [[VAR_reinterpret_cast_11_1_:%.+]] = memref.reinterpret_cast [[PARAM_0_]] to offset: {{.}}[[VAR_33_1_]]{{.}}, sizes: [256], strides: [1] : memref<*xf32> to memref<256xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_34_1_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:         [[VAR_35_1_:%.+]] = arith.addi [[VAR_34_1_]], [[CST_256_1_]] : index
// CHECK-DAG:         [[VAR_36_1_:%.+]] = arith.index_cast [[PARAM_7_]] : i32 to index
// CHECK:             [[VAR_37_1_:%.+]] = arith.minsi [[VAR_35_1_]], [[VAR_36_1_]] : index
// CHECK-DAG:         [[VAR_38_:%.+]] = arith.subi [[VAR_37_1_]], [[VAR_34_1_]] : index
// CHECK-DAG:         [[RES_1_:%.+]] = memref.alloc() : memref<256xf32>
// CHECK:             [[VAR_39_:%.+]] = arith.cmpi slt, [[VAR_38_]], [[CST_256_1_]] : index
// CHECK:             scf.if [[VAR_39_]] {
// CHECK:               linalg.fill ins([[CST_0_dot_000000_]] : f32) outs([[RES_1_]] : memref<256xf32>)
// CHECK:             }
// CHECK-DAG:         [[VAR_subview_1_:%.+]] = memref.subview [[VAR_reinterpret_cast_11_1_]][0] {{.}}[[VAR_38_]]{{.}} [1] : memref<256xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_subview_12_1_:%.+]] = memref.subview [[RES_1_]][0] {{.}}[[VAR_38_]]{{.}} [1] : memref<256xf32> to memref<?xf32, strided<[1]>>
// CHECK:             memref.copy [[VAR_subview_1_]], [[VAR_subview_12_1_]] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1]>>
// CHECK:             [[VAR_40_:%.+]] = bufferization.to_tensor [[RES_1_]] restrict writable : memref<256xf32>
// CHECK:             [[VAR_41_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_40_]], [[VAR_14_]] : tensor<256xf32>, tensor<256xf32>) outs([[VAR_40_]] : tensor<256xf32>) {
// CHECK:             ^bb0([[IN_10_:%.+]]: f32, [[IN_11_:%.+]]: f32, [[IN_12_:%.+]]: f32):
// CHECK:               [[VAR_45_2_:%.+]] = arith.subf [[IN_10_]], [[IN_11_]] : f32
// CHECK:               linalg.yield [[VAR_45_2_]] : f32
// CHECK:             } -> tensor<256xf32>
// CHECK:             [[VAR_42_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_31_1_]], [[VAR_41_]], [[VAR_1_]] : tensor<256xi1>, tensor<256xf32>, tensor<256xf32>) outs([[VAR_41_]] : tensor<256xf32>) {
// CHECK:             ^bb0([[IN_13_:%.+]]: i1, [[IN_14_:%.+]]: f32, [[IN_15_:%.+]]: f32, [[IN_16_:%.+]]: f32):
// CHECK:               [[VAR_45_3_:%.+]] = arith.select [[IN_13_]], [[IN_14_]], [[IN_15_]] : f32
// CHECK:               linalg.yield [[VAR_45_3_]] : f32
// CHECK:             } -> tensor<256xf32>
// CHECK:             [[VAR_43_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_42_]], [[VAR_42_]] : tensor<256xf32>, tensor<256xf32>) outs([[VAR_42_]] : tensor<256xf32>) {
// CHECK:             ^bb0([[IN_17_:%.+]]: f32, [[IN_18_:%.+]]: f32, [[IN_19_:%.+]]: f32):
// CHECK:               [[VAR_45_4_:%.+]] = arith.mulf [[IN_17_]], [[IN_18_]] : f32
// CHECK:               linalg.yield [[VAR_45_4_]] : f32
// CHECK:             } -> tensor<256xf32>
// CHECK:             [[VAR_44_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_arg16_1_]], [[VAR_43_]] : tensor<256xf32>, tensor<256xf32>) outs([[VAR_arg16_1_]] : tensor<256xf32>) {
// CHECK:             ^bb0([[IN_20_:%.+]]: f32, [[IN_21_:%.+]]: f32, [[IN_22_:%.+]]: f32):
// CHECK:               [[VAR_45_5_:%.+]] = arith.addf [[IN_20_]], [[IN_21_]] : f32
// CHECK:               linalg.yield [[VAR_45_5_]] : f32
// CHECK:             } -> tensor<256xf32>
// CHECK:             scf.yield [[VAR_44_]] : tensor<256xf32>
// CHECK:           }
// CHECK:           [[VAR_16_:%.+]] = bufferization.alloc_tensor() : tensor<f32>
// CHECK:           [[VAR_inserted_2_:%.+]] = tensor.insert [[CST_0_dot_000000_]] into [[VAR_16_]][] : tensor<f32>
// CHECK:           [[VAR_reduced_3_:%.+]] = linalg.reduce ins([[VAR_15_]] : tensor<256xf32>) outs([[VAR_inserted_2_]] : tensor<f32>) dimensions = [0]
// CHECK:             ([[IN_20_:%.+]]: f32, [[init_:%.+]]: f32) {
// CHECK:               [[VAR_27_4_:%.+]] = arith.addf [[IN_20_]], [[init_]] : f32
// CHECK:               linalg.yield [[VAR_27_4_]] : f32
// CHECK:             }
// CHECK:           [[VAR_extracted_4_:%.+]] = tensor.extract [[VAR_reduced_3_]][] : tensor<f32>
// CHECK:           [[VAR_17_:%.+]] = arith.divf [[VAR_extracted_4_]], [[VAR_7_]] : f32
// CHECK:           [[VAR_18_:%.+]] = arith.addf [[VAR_17_]], [[PARAM_8_]] : f32
// CHECK:           [[VAR_19_:%.+]] = math.sqrt [[VAR_18_]] : f32
// CHECK-DAG:       [[VAR_20_:%.+]] = arith.divf [[CST_1_dot_000000_]], [[VAR_19_]] : f32
// CHECK-DAG:       [[VAR_21_:%.+]] = arith.index_cast [[PARAM_12_]] : i32 to index
// CHECK:           [[base_buffer_:%.+]], [[offset_:%.+]], [[sizes_:%.+]], [[VAR_strides_:%.+]] = memref.extract_strided_metadata [[VAR_reinterpret_cast_1_]] : memref<1xf32> -> memref<f32>, index, index, index
// CHECK:           [[VAR_reinterpret_cast_5_:%.+]] = memref.reinterpret_cast [[base_buffer_]] to offset: {{.}}[[VAR_21_]]{{.}}, sizes: [1], strides: [1] : memref<f32> to memref<1xf32, strided<[1], offset: ?>>
// CHECK:           affine.store [[VAR_8_]], [[VAR_reinterpret_cast_5_]][0] : memref<1xf32, strided<[1], offset: ?>>
// CHECK:           [[VAR_22_:%.+]] = arith.index_cast [[PARAM_12_]] : i32 to index
// CHECK:           [[base_buffer_6_:%.+]], [[offset_7_:%.+]], [[sizes_8_:%.+]], [[VAR_strides_9_:%.+]] = memref.extract_strided_metadata [[VAR_reinterpret_cast_]] : memref<1xf32> -> memref<f32>, index, index, index
// CHECK:           [[VAR_reinterpret_cast_10_:%.+]] = memref.reinterpret_cast [[base_buffer_6_]] to offset: {{.}}[[VAR_22_]]{{.}}, sizes: [1], strides: [1] : memref<f32> to memref<1xf32, strided<[1], offset: ?>>
// CHECK:           affine.store [[VAR_20_]], [[VAR_reinterpret_cast_10_]][0] : memref<1xf32, strided<[1], offset: ?>>
// CHECK:           [[VAR_23_:%.+]] = tensor.empty() : tensor<256xf32>
// CHECK-DAG:       [[VAR_24_:%.+]] = linalg.fill ins([[VAR_8_]] : f32) outs([[VAR_23_]] : tensor<256xf32>) -> tensor<256xf32>
// CHECK-DAG:       [[VAR_25_:%.+]] = tensor.empty() : tensor<256xf32>
// CHECK:           [[VAR_26_:%.+]] = linalg.fill ins([[VAR_20_]] : f32) outs([[VAR_25_]] : tensor<256xf32>) -> tensor<256xf32>
// CHECK:           scf.for [[VAR_arg15_1_:%.+]] = [[CST_0_]] to [[PARAM_7_]] step [[CST_256_]]  : i32 {
// CHECK:             [[VAR_27_5_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK-DAG:         [[VAR_reinterpret_cast_11_2_:%.+]] = memref.reinterpret_cast [[PARAM_2_]] to offset: {{.}}[[VAR_27_5_]]{{.}}, sizes: [256], strides: [1] : memref<*xf32> to memref<256xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_28_3_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:         [[VAR_29_2_:%.+]] = arith.addi [[VAR_28_3_]], [[CST_256_1_]] : index
// CHECK-DAG:         [[VAR_30_2_:%.+]] = arith.index_cast [[PARAM_7_]] : i32 to index
// CHECK:             [[VAR_31_2_:%.+]] = arith.minsi [[VAR_29_2_]], [[VAR_30_2_]] : index
// CHECK-DAG:         [[VAR_32_2_:%.+]] = arith.subi [[VAR_31_2_]], [[VAR_28_3_]] : index
// CHECK-DAG:         [[RES_2_:%.+]] = memref.alloc() : memref<256xf32>
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:         [[VAR_subview_2_:%.+]] = memref.subview [[VAR_reinterpret_cast_11_2_]][0] {{.}}[[VAR_32_2_]]{{.}} [1] : memref<256xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_subview_12_2_:%.+]] = memref.subview [[RES_2_]][0] {{.}}[[VAR_32_2_]]{{.}} [1] : memref<256xf32> to memref<?xf32, strided<[1]>>
// CHECK:             memref.copy [[VAR_subview_2_]], [[VAR_subview_12_2_]] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1]>>
// CHECK-DAG:         [[VAR_33_2_:%.+]] = bufferization.to_tensor [[RES_2_]] restrict writable : memref<256xf32>
// CHECK-DAG:         [[VAR_34_2_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:         [[VAR_reinterpret_cast_13_:%.+]] = memref.reinterpret_cast [[PARAM_3_]] to offset: {{.}}[[VAR_34_2_]]{{.}}, sizes: [256], strides: [1] : memref<*xf32> to memref<256xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_35_2_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:         [[VAR_36_2_:%.+]] = arith.addi [[VAR_35_2_]], [[CST_256_1_]] : index
// CHECK-DAG:         [[VAR_37_2_:%.+]] = arith.index_cast [[PARAM_7_]] : i32 to index
// CHECK:             [[VAR_38_1_:%.+]] = arith.minsi [[VAR_36_2_]], [[VAR_37_2_]] : index
// CHECK-DAG:         [[VAR_39_1_:%.+]] = arith.subi [[VAR_38_1_]], [[VAR_35_2_]] : index
// CHECK-DAG:         [[RES_3_:%.+]] = memref.alloc() : memref<256xf32>
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:         [[VAR_subview_15_:%.+]] = memref.subview [[VAR_reinterpret_cast_13_]][0] {{.}}[[VAR_39_1_]]{{.}} [1] : memref<256xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_subview_16_:%.+]] = memref.subview [[RES_3_]][0] {{.}}[[VAR_39_1_]]{{.}} [1] : memref<256xf32> to memref<?xf32, strided<[1]>>
// CHECK:             memref.copy [[VAR_subview_15_]], [[VAR_subview_16_]] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1]>>
// CHECK-DAG:         [[VAR_40_1_:%.+]] = bufferization.to_tensor [[RES_3_]] restrict writable : memref<256xf32>
// CHECK-DAG:         [[VAR_41_1_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK:             [[VAR_42_1_:%.+]] = arith.addi [[VAR_3_]], [[VAR_41_1_]] : index
// CHECK-DAG:         [[VAR_reinterpret_cast_17_:%.+]] = memref.reinterpret_cast [[PARAM_0_]] to offset: {{.}}[[VAR_42_1_]]{{.}}, sizes: [256], strides: [1] : memref<*xf32> to memref<256xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_43_1_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:         [[VAR_44_1_:%.+]] = arith.addi [[VAR_43_1_]], [[CST_256_1_]] : index
// CHECK-DAG:         [[VAR_45_6_:%.+]] = arith.index_cast [[PARAM_7_]] : i32 to index
// CHECK:             [[VAR_46_:%.+]] = arith.minsi [[VAR_44_1_]], [[VAR_45_6_]] : index
// CHECK-DAG:         [[VAR_47_:%.+]] = arith.subi [[VAR_46_]], [[VAR_43_1_]] : index
// CHECK-DAG:         [[RES_4_:%.+]] = memref.alloc() : memref<256xf32>
// CHECK:             [[VAR_48_:%.+]] = arith.cmpi slt, [[VAR_47_]], [[CST_256_1_]] : index
// CHECK:             scf.if [[VAR_48_]] {
// CHECK:               linalg.fill ins([[CST_0_dot_000000_]] : f32) outs([[RES_4_]] : memref<256xf32>)
// CHECK:             }
// CHECK-DAG:         [[VAR_subview_19_:%.+]] = memref.subview [[VAR_reinterpret_cast_17_]][0] {{.}}[[VAR_47_]]{{.}} [1] : memref<256xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_subview_20_:%.+]] = memref.subview [[RES_4_]][0] {{.}}[[VAR_47_]]{{.}} [1] : memref<256xf32> to memref<?xf32, strided<[1]>>
// CHECK:             memref.copy [[VAR_subview_19_]], [[VAR_subview_20_]] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1]>>
// CHECK:             [[VAR_49_:%.+]] = bufferization.to_tensor [[RES_4_]] restrict writable : memref<256xf32>
// CHECK:             [[VAR_50_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_49_]], [[VAR_24_]] : tensor<256xf32>, tensor<256xf32>) outs([[VAR_49_]] : tensor<256xf32>) {
// CHECK:             ^bb0([[IN_23_:%.+]]: f32, [[IN_24_:%.+]]: f32, [[IN_25_:%.+]]: f32):
// CHECK:               [[VAR_61_:%.+]] = arith.subf [[IN_23_]], [[IN_24_]] : f32
// CHECK:               linalg.yield [[VAR_61_]] : f32
// CHECK:             } -> tensor<256xf32>
// CHECK:             [[VAR_51_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_50_]], [[VAR_26_]] : tensor<256xf32>, tensor<256xf32>) outs([[VAR_50_]] : tensor<256xf32>) {
// CHECK:             ^bb0([[IN_26_:%.+]]: f32, [[IN_27_:%.+]]: f32, [[IN_28_:%.+]]: f32):
// CHECK:               [[VAR_61_1_:%.+]] = arith.mulf [[IN_26_]], [[IN_27_]] : f32
// CHECK:               linalg.yield [[VAR_61_1_]] : f32
// CHECK:             } -> tensor<256xf32>
// CHECK:             [[VAR_52_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_51_]], [[VAR_33_2_]] : tensor<256xf32>, tensor<256xf32>) outs([[VAR_51_]] : tensor<256xf32>) {
// CHECK:             ^bb0([[IN_29_:%.+]]: f32, [[IN_30_:%.+]]: f32, [[IN_31_:%.+]]: f32):
// CHECK:               [[VAR_61_2_:%.+]] = arith.mulf [[IN_29_]], [[IN_30_]] : f32
// CHECK:               linalg.yield [[VAR_61_2_]] : f32
// CHECK:             } -> tensor<256xf32>
// CHECK:             [[VAR_53_:%.+]] = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins([[VAR_52_]], [[VAR_40_1_]] : tensor<256xf32>, tensor<256xf32>) outs([[VAR_52_]] : tensor<256xf32>) {
// CHECK:             ^bb0([[IN_32_:%.+]]: f32, [[IN_33_:%.+]]: f32, [[IN_34_:%.+]]: f32):
// CHECK:               [[VAR_61_3_:%.+]] = arith.addf [[IN_32_]], [[IN_33_]] : f32
// CHECK:               linalg.yield [[VAR_61_3_]] : f32
// CHECK:             } -> tensor<256xf32>
// CHECK:             [[VAR_54_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK:             [[VAR_55_:%.+]] = arith.addi [[VAR_4_]], [[VAR_54_]] : index
// CHECK-DAG:         [[VAR_reinterpret_cast_21_:%.+]] = memref.reinterpret_cast [[PARAM_1_]] to offset: {{.}}[[VAR_55_]]{{.}}, sizes: [256], strides: [1] : memref<*xf32> to memref<256xf32, strided<[1], offset: ?>>
// CHECK-DAG:         [[VAR_56_:%.+]] = arith.index_cast [[VAR_arg15_1_]] : i32 to index
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:         [[VAR_57_:%.+]] = arith.addi [[VAR_56_]], [[CST_256_1_]] : index
// CHECK-DAG:         [[VAR_58_:%.+]] = arith.index_cast [[PARAM_7_]] : i32 to index
// CHECK:             [[VAR_59_:%.+]] = arith.minsi [[VAR_57_]], [[VAR_58_]] : index
// CHECK:             [[VAR_60_:%.+]] = arith.subi [[VAR_59_]], [[VAR_56_]] : index
// CHECK-DAG:         [[VAR_extracted_slice_:%.+]] = tensor.extract_slice [[VAR_53_]][0] {{.}}[[VAR_60_]]{{.}} [1] : tensor<256xf32> to tensor<?xf32>
// CHECK-DAG:         [[VAR_subview_22_:%.+]] = memref.subview [[VAR_reinterpret_cast_21_]][0] {{.}}[[VAR_60_]]{{.}} [1] : memref<256xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
// CHECK:             bufferization.materialize_in_destination [[VAR_extracted_slice_]] in writable [[VAR_subview_22_]] : (tensor<?xf32>, memref<?xf32, strided<[1], offset: ?>>) -> ()
// CHECK:           }
// CHECK:           return
// CHECK:         }