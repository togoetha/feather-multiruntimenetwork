; ModuleID = 'split_redirect_lh_ipv4_tc.c'
source_filename = "split_redirect_lh_ipv4_tc.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.anon.0 = type { ptr, ptr, ptr, ptr }
%struct.__sk_buff = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [5 x i32], i32, i32, i32, i32, i32, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, %union.anon, i64, i32, i32, %union.anon.1, i32, i8, [3 x i8], i64 }
%union.anon = type { ptr }
%union.anon.1 = type { ptr }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.lh_route = type { i32, i32, i32, i32, [6 x i8], [6 x i8] }

@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@tc_lh_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !13
@tc_lhaddr_map = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !44
@llvm.compiler.used = appending global [4 x ptr] [ptr @_license, ptr @tc_lh2split, ptr @tc_lh_map, ptr @tc_lhaddr_map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local noundef i32 @tc_lh2split(ptr noundef %0) #0 section "tc" !dbg !175 {
  %2 = alloca i32, align 4, !DIAssignID !181
  %3 = alloca i32, align 4, !DIAssignID !182
  %4 = alloca i32, align 4, !DIAssignID !183
  %5 = alloca i32, align 4, !DIAssignID !184
  %6 = alloca i32, align 4, !DIAssignID !185
  %7 = alloca i32, align 4, !DIAssignID !186
  %8 = alloca i32, align 4, !DIAssignID !187
  %9 = alloca i32, align 4, !DIAssignID !188
  %10 = alloca i32, align 4, !DIAssignID !189
  %11 = alloca i32, align 4, !DIAssignID !190
  %12 = alloca i32, align 4, !DIAssignID !191
  %13 = alloca i32, align 4, !DIAssignID !192
  tail call void @llvm.dbg.value(metadata ptr %0, metadata !179, metadata !DIExpression()), !dbg !193
  call void @llvm.dbg.value(metadata ptr %0, metadata !194, metadata !DIExpression()), !dbg !238
  %14 = getelementptr inbounds %struct.__sk_buff, ptr %0, i64 0, i32 16, !dbg !240
  %15 = load i32, ptr %14, align 8, !dbg !240, !tbaa !241
  %16 = zext i32 %15 to i64, !dbg !247
  %17 = inttoptr i64 %16 to ptr, !dbg !248
  call void @llvm.dbg.value(metadata ptr %17, metadata !197, metadata !DIExpression()), !dbg !238
  %18 = getelementptr inbounds %struct.__sk_buff, ptr %0, i64 0, i32 15, !dbg !249
  %19 = load i32, ptr %18, align 4, !dbg !249, !tbaa !250
  %20 = zext i32 %19 to i64, !dbg !251
  %21 = inttoptr i64 %20 to ptr, !dbg !252
  call void @llvm.dbg.value(metadata ptr %21, metadata !198, metadata !DIExpression()), !dbg !238
  call void @llvm.dbg.value(metadata ptr %21, metadata !199, metadata !DIExpression()), !dbg !238
  %22 = getelementptr inbounds %struct.ethhdr, ptr %21, i64 1, !dbg !253
  %23 = icmp ugt ptr %22, %17, !dbg !255
  call void @llvm.dbg.value(metadata ptr %22, metadata !207, metadata !DIExpression()), !dbg !238
  %24 = getelementptr inbounds %struct.ethhdr, ptr %21, i64 2, i32 1
  %25 = icmp ugt ptr %24, %17
  %26 = select i1 %23, i1 true, i1 %25, !dbg !256
  br i1 %26, label %795, label %27, !dbg !256

27:                                               ; preds = %1
  %28 = load i8, ptr %22, align 4, !dbg !257
  %29 = and i8 %28, -16, !dbg !259
  %30 = icmp eq i8 %29, 64, !dbg !259
  br i1 %30, label %31, label %795, !dbg !260

31:                                               ; preds = %27
  %32 = getelementptr inbounds %struct.ethhdr, ptr %21, i64 1, i32 2, !dbg !261
  %33 = getelementptr inbounds %struct.ethhdr, ptr %21, i64 2, i32 0, i64 2, !dbg !261
  %34 = load i32, ptr %33, align 4, !dbg !261, !tbaa !262
  call void @llvm.dbg.value(metadata i32 %34, metadata !235, metadata !DIExpression()), !dbg !238
  %35 = load i32, ptr %32, align 4, !dbg !263, !tbaa !262
  %36 = and i32 %35, 33554431, !dbg !264
  call void @llvm.dbg.value(metadata i32 %36, metadata !236, metadata !DIExpression()), !dbg !238
  call void @llvm.dbg.value(metadata i32 %35, metadata !237, metadata !DIExpression(DW_OP_constu, 18446744073592111103, DW_OP_and, DW_OP_stack_value)), !dbg !238
  %37 = icmp eq i32 %34, %36, !dbg !265
  br i1 %37, label %38, label %411, !dbg !267

38:                                               ; preds = %31
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %10)
  call void @llvm.dbg.assign(metadata i1 undef, metadata !268, metadata !DIExpression(), metadata !189, metadata ptr %10, metadata !DIExpression()), !dbg !283
  store i32 0, ptr %10, align 4, !tbaa !286, !DIAssignID !287
  call void @llvm.dbg.assign(metadata i32 0, metadata !268, metadata !DIExpression(), metadata !287, metadata ptr %10, metadata !DIExpression()), !dbg !283
  call void @llvm.dbg.value(metadata ptr %0, metadata !273, metadata !DIExpression()), !dbg !283
  %39 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lh_map, ptr noundef nonnull %10) #5, !dbg !288
  call void @llvm.dbg.value(metadata ptr %39, metadata !274, metadata !DIExpression()), !dbg !283
  %40 = icmp eq ptr %39, null, !dbg !289
  br i1 %40, label %131, label %41, !dbg !291

41:                                               ; preds = %38
  %42 = load i32, ptr %39, align 4, !dbg !292, !tbaa !293
  %43 = icmp eq i32 %42, 0, !dbg !295
  br i1 %43, label %131, label %44, !dbg !296

44:                                               ; preds = %41
  %45 = load i32, ptr %14, align 8, !dbg !297, !tbaa !241
  %46 = zext i32 %45 to i64, !dbg !298
  %47 = inttoptr i64 %46 to ptr, !dbg !299
  call void @llvm.dbg.value(metadata ptr %47, metadata !275, metadata !DIExpression()), !dbg !300
  %48 = load i32, ptr %18, align 4, !dbg !301, !tbaa !250
  %49 = zext i32 %48 to i64, !dbg !302
  %50 = inttoptr i64 %49 to ptr, !dbg !303
  call void @llvm.dbg.value(metadata ptr %50, metadata !278, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata ptr %50, metadata !279, metadata !DIExpression()), !dbg !300
  %51 = getelementptr inbounds %struct.ethhdr, ptr %50, i64 1, !dbg !304
  %52 = icmp ugt ptr %51, %47, !dbg !305
  call void @llvm.dbg.value(metadata ptr %51, metadata !280, metadata !DIExpression()), !dbg !306
  %53 = getelementptr inbounds %struct.ethhdr, ptr %50, i64 2, i32 1
  %54 = icmp ugt ptr %53, %47
  %55 = select i1 %52, i1 true, i1 %54, !dbg !307
  br i1 %55, label %131, label %56, !dbg !307

56:                                               ; preds = %44
  %57 = getelementptr inbounds %struct.ethhdr, ptr %50, i64 0, i32 1, !dbg !308
  %58 = getelementptr inbounds %struct.lh_route, ptr %39, i64 0, i32 4, !dbg !311
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %57, ptr noundef nonnull align 4 dereferenceable(6) %58, i64 6, i1 false), !dbg !312
  %59 = getelementptr inbounds %struct.lh_route, ptr %39, i64 0, i32 5, !dbg !313
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %50, ptr noundef nonnull align 2 dereferenceable(6) %59, i64 6, i1 false), !dbg !314
  %60 = getelementptr inbounds %struct.lh_route, ptr %39, i64 0, i32 3, !dbg !315
  %61 = load i32, ptr %60, align 4, !dbg !315, !tbaa !316
  %62 = call i32 @llvm.bswap.i32(i32 %61), !dbg !315
  %63 = getelementptr inbounds %struct.ethhdr, ptr %50, i64 1, i32 2, !dbg !317
  %64 = getelementptr inbounds %struct.ethhdr, ptr %50, i64 2, i32 0, i64 2, !dbg !317
  store i32 %62, ptr %64, align 4, !dbg !318, !tbaa !262
  %65 = getelementptr inbounds %struct.lh_route, ptr %39, i64 0, i32 2, !dbg !319
  %66 = load i32, ptr %65, align 4, !dbg !319, !tbaa !320
  %67 = call i32 @llvm.bswap.i32(i32 %66), !dbg !319
  store i32 %67, ptr %63, align 4, !dbg !321, !tbaa !262
  %68 = load i8, ptr %51, align 4, !dbg !322
  %69 = shl i8 %68, 2, !dbg !322
  %70 = and i8 %69, 60, !dbg !322
  tail call void @llvm.dbg.value(metadata ptr %51, metadata !323, metadata !DIExpression()), !dbg !336
  tail call void @llvm.dbg.value(metadata i8 %70, metadata !329, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !336
  tail call void @llvm.dbg.value(metadata ptr %47, metadata !330, metadata !DIExpression()), !dbg !336
  tail call void @llvm.dbg.value(metadata i32 0, metadata !331, metadata !DIExpression()), !dbg !336
  %71 = getelementptr inbounds %struct.ethhdr, ptr %50, i64 1, i32 1, i64 4, !dbg !338
  store i8 0, ptr %71, align 1, !dbg !339, !tbaa !262
  %72 = getelementptr inbounds %struct.ethhdr, ptr %50, i64 1, i32 1, i64 5, !dbg !340
  store i8 0, ptr %72, align 1, !dbg !341, !tbaa !262
  tail call void @llvm.dbg.value(metadata i32 0, metadata !332, metadata !DIExpression()), !dbg !342
  tail call void @llvm.dbg.value(metadata i32 0, metadata !331, metadata !DIExpression()), !dbg !336
  tail call void @llvm.dbg.value(metadata ptr %51, metadata !323, metadata !DIExpression()), !dbg !336
  tail call void @llvm.dbg.value(metadata i8 %70, metadata !329, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !336
  %73 = icmp eq i8 %70, 0, !dbg !343
  br i1 %73, label %121, label %74, !dbg !345

74:                                               ; preds = %56
  %75 = zext nneg i8 %70 to i16, !dbg !322
  tail call void @llvm.dbg.value(metadata i16 %75, metadata !329, metadata !DIExpression()), !dbg !336
  br label %78, !dbg !345

76:                                               ; preds = %94
  %77 = icmp eq i16 %96, 0, !dbg !346
  br i1 %77, label %108, label %101, !dbg !348

78:                                               ; preds = %74, %94
  %79 = phi i32 [ %97, %94 ], [ 0, %74 ]
  %80 = phi i32 [ %95, %94 ], [ 0, %74 ]
  %81 = phi ptr [ %83, %94 ], [ %51, %74 ]
  %82 = phi i16 [ %96, %94 ], [ %75, %74 ]
  tail call void @llvm.dbg.value(metadata i32 %79, metadata !332, metadata !DIExpression()), !dbg !342
  tail call void @llvm.dbg.value(metadata i32 %80, metadata !331, metadata !DIExpression()), !dbg !336
  tail call void @llvm.dbg.value(metadata ptr %81, metadata !323, metadata !DIExpression()), !dbg !336
  tail call void @llvm.dbg.value(metadata i16 %82, metadata !329, metadata !DIExpression()), !dbg !336
  %83 = getelementptr inbounds i8, ptr %81, i64 2, !dbg !349
  %84 = icmp ugt ptr %83, %47, !dbg !352
  br i1 %84, label %94, label %85, !dbg !353

85:                                               ; preds = %78
  %86 = load i8, ptr %81, align 1, !dbg !354, !tbaa !262
  %87 = zext i8 %86 to i32, !dbg !356
  %88 = shl nuw nsw i32 %87, 8, !dbg !357
  %89 = getelementptr inbounds i8, ptr %81, i64 1, !dbg !358
  %90 = load i8, ptr %89, align 1, !dbg !359, !tbaa !262
  %91 = zext i8 %90 to i32, !dbg !360
  %92 = or disjoint i32 %88, %91, !dbg !361
  %93 = add i32 %92, %80, !dbg !362
  tail call void @llvm.dbg.value(metadata i32 %93, metadata !331, metadata !DIExpression()), !dbg !336
  br label %94, !dbg !363

94:                                               ; preds = %85, %78
  %95 = phi i32 [ %93, %85 ], [ %80, %78 ], !dbg !336
  tail call void @llvm.dbg.value(metadata i32 %95, metadata !331, metadata !DIExpression()), !dbg !336
  tail call void @llvm.dbg.value(metadata ptr %83, metadata !323, metadata !DIExpression()), !dbg !336
  %96 = add nsw i16 %82, -2, !dbg !364
  tail call void @llvm.dbg.value(metadata i16 %96, metadata !329, metadata !DIExpression()), !dbg !336
  %97 = add nuw nsw i32 %79, 2, !dbg !365
  tail call void @llvm.dbg.value(metadata i32 %97, metadata !332, metadata !DIExpression()), !dbg !342
  %98 = icmp ult i32 %79, 58, !dbg !366
  %99 = icmp ne i16 %96, 0, !dbg !343
  %100 = select i1 %98, i1 %99, i1 false, !dbg !343
  br i1 %100, label %78, label %76, !dbg !345, !llvm.loop !367

101:                                              ; preds = %76
  %102 = getelementptr inbounds i8, ptr %81, i64 3, !dbg !370
  %103 = icmp ugt ptr %102, %47, !dbg !373
  br i1 %103, label %125, label %104, !dbg !374

104:                                              ; preds = %101
  %105 = load i8, ptr %83, align 1, !dbg !375, !tbaa !262
  %106 = zext i8 %105 to i32, !dbg !376
  %107 = add i32 %95, %106, !dbg !377
  tail call void @llvm.dbg.value(metadata i32 %107, metadata !331, metadata !DIExpression()), !dbg !336
  br label %108, !dbg !378

108:                                              ; preds = %104, %76
  %109 = phi i32 [ %107, %104 ], [ %95, %76 ], !dbg !336
  tail call void @llvm.dbg.value(metadata i32 %109, metadata !331, metadata !DIExpression()), !dbg !336
  tail call void @llvm.dbg.value(metadata i32 0, metadata !334, metadata !DIExpression()), !dbg !336
  %110 = icmp ugt i32 %109, 65535, !dbg !379
  br i1 %110, label %111, label %121, !dbg !380

111:                                              ; preds = %108, %111
  %112 = phi i32 [ %117, %111 ], [ 0, %108 ]
  %113 = phi i32 [ %116, %111 ], [ %109, %108 ]
  tail call void @llvm.dbg.value(metadata i32 %112, metadata !334, metadata !DIExpression()), !dbg !336
  tail call void @llvm.dbg.value(metadata i32 %113, metadata !331, metadata !DIExpression()), !dbg !336
  %114 = lshr i32 %113, 16, !dbg !379
  %115 = and i32 %113, 65535, !dbg !381
  %116 = add nuw nsw i32 %115, %114, !dbg !383
  tail call void @llvm.dbg.value(metadata i32 %116, metadata !331, metadata !DIExpression()), !dbg !336
  %117 = add nuw nsw i32 %112, 1, !dbg !384
  tail call void @llvm.dbg.value(metadata i32 %117, metadata !334, metadata !DIExpression()), !dbg !336
  %118 = icmp ugt i32 %116, 65535, !dbg !379
  %119 = icmp ult i32 %112, 15, !dbg !385
  %120 = select i1 %118, i1 %119, i1 false, !dbg !385
  br i1 %120, label %111, label %121, !dbg !380, !llvm.loop !386

121:                                              ; preds = %111, %56, %108
  %122 = phi i32 [ %109, %108 ], [ 0, %56 ], [ %116, %111 ], !dbg !336
  %123 = trunc i32 %122 to i16, !dbg !388
  %124 = xor i16 %123, -1, !dbg !388
  tail call void @llvm.dbg.value(metadata i16 %124, metadata !335, metadata !DIExpression()), !dbg !336
  br label %125

125:                                              ; preds = %101, %121
  %126 = phi i16 [ %124, %121 ], [ 0, %101 ], !dbg !336
  %127 = call i16 @llvm.bswap.i16(i16 %126), !dbg !322
  store i16 %127, ptr %71, align 2, !dbg !389, !tbaa !390
  %128 = getelementptr inbounds %struct.lh_route, ptr %39, i64 0, i32 1, !dbg !393
  %129 = load i32, ptr %128, align 4, !dbg !393, !tbaa !394
  %130 = call i64 inttoptr (i64 13 to ptr)(ptr noundef %0, i32 noundef %129, i64 noundef 0) #5, !dbg !395
  br label %131, !dbg !396

131:                                              ; preds = %38, %41, %44, %125
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %10), !dbg !397
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %11)
  call void @llvm.dbg.assign(metadata i1 undef, metadata !268, metadata !DIExpression(), metadata !190, metadata ptr %11, metadata !DIExpression()), !dbg !398
  store i32 1, ptr %11, align 4, !tbaa !286, !DIAssignID !400
  call void @llvm.dbg.assign(metadata i32 1, metadata !268, metadata !DIExpression(), metadata !400, metadata ptr %11, metadata !DIExpression()), !dbg !398
  call void @llvm.dbg.value(metadata ptr %0, metadata !273, metadata !DIExpression()), !dbg !398
  %132 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lh_map, ptr noundef nonnull %11) #5, !dbg !401
  call void @llvm.dbg.value(metadata ptr %132, metadata !274, metadata !DIExpression()), !dbg !398
  %133 = icmp eq ptr %132, null, !dbg !402
  br i1 %133, label %224, label %134, !dbg !403

134:                                              ; preds = %131
  %135 = load i32, ptr %132, align 4, !dbg !404, !tbaa !293
  %136 = icmp eq i32 %135, 0, !dbg !405
  br i1 %136, label %224, label %137, !dbg !406

137:                                              ; preds = %134
  %138 = load i32, ptr %14, align 8, !dbg !407, !tbaa !241
  %139 = zext i32 %138 to i64, !dbg !408
  %140 = inttoptr i64 %139 to ptr, !dbg !409
  call void @llvm.dbg.value(metadata ptr %140, metadata !275, metadata !DIExpression()), !dbg !410
  %141 = load i32, ptr %18, align 4, !dbg !411, !tbaa !250
  %142 = zext i32 %141 to i64, !dbg !412
  %143 = inttoptr i64 %142 to ptr, !dbg !413
  call void @llvm.dbg.value(metadata ptr %143, metadata !278, metadata !DIExpression()), !dbg !410
  call void @llvm.dbg.value(metadata ptr %143, metadata !279, metadata !DIExpression()), !dbg !410
  %144 = getelementptr inbounds %struct.ethhdr, ptr %143, i64 1, !dbg !414
  %145 = icmp ugt ptr %144, %140, !dbg !415
  call void @llvm.dbg.value(metadata ptr %144, metadata !280, metadata !DIExpression()), !dbg !416
  %146 = getelementptr inbounds %struct.ethhdr, ptr %143, i64 2, i32 1
  %147 = icmp ugt ptr %146, %140
  %148 = select i1 %145, i1 true, i1 %147, !dbg !417
  br i1 %148, label %224, label %149, !dbg !417

149:                                              ; preds = %137
  %150 = getelementptr inbounds %struct.ethhdr, ptr %143, i64 0, i32 1, !dbg !418
  %151 = getelementptr inbounds %struct.lh_route, ptr %132, i64 0, i32 4, !dbg !419
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %150, ptr noundef nonnull align 4 dereferenceable(6) %151, i64 6, i1 false), !dbg !420
  %152 = getelementptr inbounds %struct.lh_route, ptr %132, i64 0, i32 5, !dbg !421
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %143, ptr noundef nonnull align 2 dereferenceable(6) %152, i64 6, i1 false), !dbg !422
  %153 = getelementptr inbounds %struct.lh_route, ptr %132, i64 0, i32 3, !dbg !423
  %154 = load i32, ptr %153, align 4, !dbg !423, !tbaa !316
  %155 = call i32 @llvm.bswap.i32(i32 %154), !dbg !423
  %156 = getelementptr inbounds %struct.ethhdr, ptr %143, i64 1, i32 2, !dbg !424
  %157 = getelementptr inbounds %struct.ethhdr, ptr %143, i64 2, i32 0, i64 2, !dbg !424
  store i32 %155, ptr %157, align 4, !dbg !425, !tbaa !262
  %158 = getelementptr inbounds %struct.lh_route, ptr %132, i64 0, i32 2, !dbg !426
  %159 = load i32, ptr %158, align 4, !dbg !426, !tbaa !320
  %160 = call i32 @llvm.bswap.i32(i32 %159), !dbg !426
  store i32 %160, ptr %156, align 4, !dbg !427, !tbaa !262
  %161 = load i8, ptr %144, align 4, !dbg !428
  %162 = shl i8 %161, 2, !dbg !428
  %163 = and i8 %162, 60, !dbg !428
  tail call void @llvm.dbg.value(metadata ptr %144, metadata !323, metadata !DIExpression()), !dbg !429
  tail call void @llvm.dbg.value(metadata i8 %163, metadata !329, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !429
  tail call void @llvm.dbg.value(metadata ptr %140, metadata !330, metadata !DIExpression()), !dbg !429
  tail call void @llvm.dbg.value(metadata i32 0, metadata !331, metadata !DIExpression()), !dbg !429
  %164 = getelementptr inbounds %struct.ethhdr, ptr %143, i64 1, i32 1, i64 4, !dbg !431
  store i8 0, ptr %164, align 1, !dbg !432, !tbaa !262
  %165 = getelementptr inbounds %struct.ethhdr, ptr %143, i64 1, i32 1, i64 5, !dbg !433
  store i8 0, ptr %165, align 1, !dbg !434, !tbaa !262
  tail call void @llvm.dbg.value(metadata i32 0, metadata !332, metadata !DIExpression()), !dbg !435
  %166 = icmp eq i8 %163, 0, !dbg !436
  br i1 %166, label %214, label %167, !dbg !437

167:                                              ; preds = %149
  %168 = zext nneg i8 %163 to i16, !dbg !428
  tail call void @llvm.dbg.value(metadata i16 %168, metadata !329, metadata !DIExpression()), !dbg !429
  br label %171, !dbg !437

169:                                              ; preds = %187
  %170 = icmp eq i16 %189, 0, !dbg !438
  br i1 %170, label %201, label %194, !dbg !439

171:                                              ; preds = %167, %187
  %172 = phi i32 [ %190, %187 ], [ 0, %167 ]
  %173 = phi i32 [ %188, %187 ], [ 0, %167 ]
  %174 = phi ptr [ %176, %187 ], [ %144, %167 ]
  %175 = phi i16 [ %189, %187 ], [ %168, %167 ]
  tail call void @llvm.dbg.value(metadata i32 %172, metadata !332, metadata !DIExpression()), !dbg !435
  tail call void @llvm.dbg.value(metadata i32 %173, metadata !331, metadata !DIExpression()), !dbg !429
  tail call void @llvm.dbg.value(metadata ptr %174, metadata !323, metadata !DIExpression()), !dbg !429
  tail call void @llvm.dbg.value(metadata i16 %175, metadata !329, metadata !DIExpression()), !dbg !429
  %176 = getelementptr inbounds i8, ptr %174, i64 2, !dbg !440
  %177 = icmp ugt ptr %176, %140, !dbg !441
  br i1 %177, label %187, label %178, !dbg !442

178:                                              ; preds = %171
  %179 = load i8, ptr %174, align 1, !dbg !443, !tbaa !262
  %180 = zext i8 %179 to i32, !dbg !444
  %181 = shl nuw nsw i32 %180, 8, !dbg !445
  %182 = getelementptr inbounds i8, ptr %174, i64 1, !dbg !446
  %183 = load i8, ptr %182, align 1, !dbg !447, !tbaa !262
  %184 = zext i8 %183 to i32, !dbg !448
  %185 = or disjoint i32 %181, %184, !dbg !449
  %186 = add i32 %185, %173, !dbg !450
  tail call void @llvm.dbg.value(metadata i32 %186, metadata !331, metadata !DIExpression()), !dbg !429
  br label %187, !dbg !451

187:                                              ; preds = %178, %171
  %188 = phi i32 [ %186, %178 ], [ %173, %171 ], !dbg !429
  tail call void @llvm.dbg.value(metadata i32 %188, metadata !331, metadata !DIExpression()), !dbg !429
  tail call void @llvm.dbg.value(metadata ptr %176, metadata !323, metadata !DIExpression()), !dbg !429
  %189 = add nsw i16 %175, -2, !dbg !452
  tail call void @llvm.dbg.value(metadata i16 %189, metadata !329, metadata !DIExpression()), !dbg !429
  %190 = add nuw nsw i32 %172, 2, !dbg !453
  tail call void @llvm.dbg.value(metadata i32 %190, metadata !332, metadata !DIExpression()), !dbg !435
  %191 = icmp ult i32 %172, 58, !dbg !454
  %192 = icmp ne i16 %189, 0, !dbg !436
  %193 = select i1 %191, i1 %192, i1 false, !dbg !436
  br i1 %193, label %171, label %169, !dbg !437, !llvm.loop !455

194:                                              ; preds = %169
  %195 = getelementptr inbounds i8, ptr %174, i64 3, !dbg !457
  %196 = icmp ugt ptr %195, %140, !dbg !458
  br i1 %196, label %218, label %197, !dbg !459

197:                                              ; preds = %194
  %198 = load i8, ptr %176, align 1, !dbg !460, !tbaa !262
  %199 = zext i8 %198 to i32, !dbg !461
  %200 = add i32 %188, %199, !dbg !462
  tail call void @llvm.dbg.value(metadata i32 %200, metadata !331, metadata !DIExpression()), !dbg !429
  br label %201, !dbg !463

201:                                              ; preds = %197, %169
  %202 = phi i32 [ %200, %197 ], [ %188, %169 ], !dbg !429
  tail call void @llvm.dbg.value(metadata i32 %202, metadata !331, metadata !DIExpression()), !dbg !429
  tail call void @llvm.dbg.value(metadata i32 0, metadata !334, metadata !DIExpression()), !dbg !429
  %203 = icmp ugt i32 %202, 65535, !dbg !464
  br i1 %203, label %204, label %214, !dbg !465

204:                                              ; preds = %201, %204
  %205 = phi i32 [ %210, %204 ], [ 0, %201 ]
  %206 = phi i32 [ %209, %204 ], [ %202, %201 ]
  tail call void @llvm.dbg.value(metadata i32 %205, metadata !334, metadata !DIExpression()), !dbg !429
  tail call void @llvm.dbg.value(metadata i32 %206, metadata !331, metadata !DIExpression()), !dbg !429
  %207 = lshr i32 %206, 16, !dbg !464
  %208 = and i32 %206, 65535, !dbg !466
  %209 = add nuw nsw i32 %208, %207, !dbg !467
  tail call void @llvm.dbg.value(metadata i32 %209, metadata !331, metadata !DIExpression()), !dbg !429
  %210 = add nuw nsw i32 %205, 1, !dbg !468
  tail call void @llvm.dbg.value(metadata i32 %210, metadata !334, metadata !DIExpression()), !dbg !429
  %211 = icmp ugt i32 %209, 65535, !dbg !464
  %212 = icmp ult i32 %205, 15, !dbg !469
  %213 = select i1 %211, i1 %212, i1 false, !dbg !469
  br i1 %213, label %204, label %214, !dbg !465, !llvm.loop !470

214:                                              ; preds = %204, %149, %201
  %215 = phi i32 [ %202, %201 ], [ 0, %149 ], [ %209, %204 ], !dbg !429
  %216 = trunc i32 %215 to i16, !dbg !472
  %217 = xor i16 %216, -1, !dbg !472
  tail call void @llvm.dbg.value(metadata i16 %217, metadata !335, metadata !DIExpression()), !dbg !429
  br label %218

218:                                              ; preds = %194, %214
  %219 = phi i16 [ %217, %214 ], [ 0, %194 ], !dbg !429
  %220 = call i16 @llvm.bswap.i16(i16 %219), !dbg !428
  store i16 %220, ptr %164, align 2, !dbg !473, !tbaa !390
  %221 = getelementptr inbounds %struct.lh_route, ptr %132, i64 0, i32 1, !dbg !474
  %222 = load i32, ptr %221, align 4, !dbg !474, !tbaa !394
  %223 = call i64 inttoptr (i64 13 to ptr)(ptr noundef %0, i32 noundef %222, i64 noundef 0) #5, !dbg !475
  br label %224, !dbg !476

224:                                              ; preds = %131, %134, %137, %218
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %11), !dbg !477
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %12)
  call void @llvm.dbg.assign(metadata i1 undef, metadata !268, metadata !DIExpression(), metadata !191, metadata ptr %12, metadata !DIExpression()), !dbg !478
  store i32 2, ptr %12, align 4, !tbaa !286, !DIAssignID !480
  call void @llvm.dbg.assign(metadata i32 2, metadata !268, metadata !DIExpression(), metadata !480, metadata ptr %12, metadata !DIExpression()), !dbg !478
  call void @llvm.dbg.value(metadata ptr %0, metadata !273, metadata !DIExpression()), !dbg !478
  %225 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lh_map, ptr noundef nonnull %12) #5, !dbg !481
  call void @llvm.dbg.value(metadata ptr %225, metadata !274, metadata !DIExpression()), !dbg !478
  %226 = icmp eq ptr %225, null, !dbg !482
  br i1 %226, label %317, label %227, !dbg !483

227:                                              ; preds = %224
  %228 = load i32, ptr %225, align 4, !dbg !484, !tbaa !293
  %229 = icmp eq i32 %228, 0, !dbg !485
  br i1 %229, label %317, label %230, !dbg !486

230:                                              ; preds = %227
  %231 = load i32, ptr %14, align 8, !dbg !487, !tbaa !241
  %232 = zext i32 %231 to i64, !dbg !488
  %233 = inttoptr i64 %232 to ptr, !dbg !489
  call void @llvm.dbg.value(metadata ptr %233, metadata !275, metadata !DIExpression()), !dbg !490
  %234 = load i32, ptr %18, align 4, !dbg !491, !tbaa !250
  %235 = zext i32 %234 to i64, !dbg !492
  %236 = inttoptr i64 %235 to ptr, !dbg !493
  call void @llvm.dbg.value(metadata ptr %236, metadata !278, metadata !DIExpression()), !dbg !490
  call void @llvm.dbg.value(metadata ptr %236, metadata !279, metadata !DIExpression()), !dbg !490
  %237 = getelementptr inbounds %struct.ethhdr, ptr %236, i64 1, !dbg !494
  %238 = icmp ugt ptr %237, %233, !dbg !495
  call void @llvm.dbg.value(metadata ptr %237, metadata !280, metadata !DIExpression()), !dbg !496
  %239 = getelementptr inbounds %struct.ethhdr, ptr %236, i64 2, i32 1
  %240 = icmp ugt ptr %239, %233
  %241 = select i1 %238, i1 true, i1 %240, !dbg !497
  br i1 %241, label %317, label %242, !dbg !497

242:                                              ; preds = %230
  %243 = getelementptr inbounds %struct.ethhdr, ptr %236, i64 0, i32 1, !dbg !498
  %244 = getelementptr inbounds %struct.lh_route, ptr %225, i64 0, i32 4, !dbg !499
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %243, ptr noundef nonnull align 4 dereferenceable(6) %244, i64 6, i1 false), !dbg !500
  %245 = getelementptr inbounds %struct.lh_route, ptr %225, i64 0, i32 5, !dbg !501
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %236, ptr noundef nonnull align 2 dereferenceable(6) %245, i64 6, i1 false), !dbg !502
  %246 = getelementptr inbounds %struct.lh_route, ptr %225, i64 0, i32 3, !dbg !503
  %247 = load i32, ptr %246, align 4, !dbg !503, !tbaa !316
  %248 = call i32 @llvm.bswap.i32(i32 %247), !dbg !503
  %249 = getelementptr inbounds %struct.ethhdr, ptr %236, i64 1, i32 2, !dbg !504
  %250 = getelementptr inbounds %struct.ethhdr, ptr %236, i64 2, i32 0, i64 2, !dbg !504
  store i32 %248, ptr %250, align 4, !dbg !505, !tbaa !262
  %251 = getelementptr inbounds %struct.lh_route, ptr %225, i64 0, i32 2, !dbg !506
  %252 = load i32, ptr %251, align 4, !dbg !506, !tbaa !320
  %253 = call i32 @llvm.bswap.i32(i32 %252), !dbg !506
  store i32 %253, ptr %249, align 4, !dbg !507, !tbaa !262
  %254 = load i8, ptr %237, align 4, !dbg !508
  %255 = shl i8 %254, 2, !dbg !508
  %256 = and i8 %255, 60, !dbg !508
  tail call void @llvm.dbg.value(metadata ptr %237, metadata !323, metadata !DIExpression()), !dbg !509
  tail call void @llvm.dbg.value(metadata i8 %256, metadata !329, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !509
  tail call void @llvm.dbg.value(metadata ptr %233, metadata !330, metadata !DIExpression()), !dbg !509
  tail call void @llvm.dbg.value(metadata i32 0, metadata !331, metadata !DIExpression()), !dbg !509
  %257 = getelementptr inbounds %struct.ethhdr, ptr %236, i64 1, i32 1, i64 4, !dbg !511
  store i8 0, ptr %257, align 1, !dbg !512, !tbaa !262
  %258 = getelementptr inbounds %struct.ethhdr, ptr %236, i64 1, i32 1, i64 5, !dbg !513
  store i8 0, ptr %258, align 1, !dbg !514, !tbaa !262
  tail call void @llvm.dbg.value(metadata i32 0, metadata !332, metadata !DIExpression()), !dbg !515
  %259 = icmp eq i8 %256, 0, !dbg !516
  br i1 %259, label %307, label %260, !dbg !517

260:                                              ; preds = %242
  %261 = zext nneg i8 %256 to i16, !dbg !508
  tail call void @llvm.dbg.value(metadata i16 %261, metadata !329, metadata !DIExpression()), !dbg !509
  br label %264, !dbg !517

262:                                              ; preds = %280
  %263 = icmp eq i16 %282, 0, !dbg !518
  br i1 %263, label %294, label %287, !dbg !519

264:                                              ; preds = %260, %280
  %265 = phi i32 [ %283, %280 ], [ 0, %260 ]
  %266 = phi i32 [ %281, %280 ], [ 0, %260 ]
  %267 = phi ptr [ %269, %280 ], [ %237, %260 ]
  %268 = phi i16 [ %282, %280 ], [ %261, %260 ]
  tail call void @llvm.dbg.value(metadata i32 %265, metadata !332, metadata !DIExpression()), !dbg !515
  tail call void @llvm.dbg.value(metadata i32 %266, metadata !331, metadata !DIExpression()), !dbg !509
  tail call void @llvm.dbg.value(metadata ptr %267, metadata !323, metadata !DIExpression()), !dbg !509
  tail call void @llvm.dbg.value(metadata i16 %268, metadata !329, metadata !DIExpression()), !dbg !509
  %269 = getelementptr inbounds i8, ptr %267, i64 2, !dbg !520
  %270 = icmp ugt ptr %269, %233, !dbg !521
  br i1 %270, label %280, label %271, !dbg !522

271:                                              ; preds = %264
  %272 = load i8, ptr %267, align 1, !dbg !523, !tbaa !262
  %273 = zext i8 %272 to i32, !dbg !524
  %274 = shl nuw nsw i32 %273, 8, !dbg !525
  %275 = getelementptr inbounds i8, ptr %267, i64 1, !dbg !526
  %276 = load i8, ptr %275, align 1, !dbg !527, !tbaa !262
  %277 = zext i8 %276 to i32, !dbg !528
  %278 = or disjoint i32 %274, %277, !dbg !529
  %279 = add i32 %278, %266, !dbg !530
  tail call void @llvm.dbg.value(metadata i32 %279, metadata !331, metadata !DIExpression()), !dbg !509
  br label %280, !dbg !531

280:                                              ; preds = %271, %264
  %281 = phi i32 [ %279, %271 ], [ %266, %264 ], !dbg !509
  tail call void @llvm.dbg.value(metadata i32 %281, metadata !331, metadata !DIExpression()), !dbg !509
  tail call void @llvm.dbg.value(metadata ptr %269, metadata !323, metadata !DIExpression()), !dbg !509
  %282 = add nsw i16 %268, -2, !dbg !532
  tail call void @llvm.dbg.value(metadata i16 %282, metadata !329, metadata !DIExpression()), !dbg !509
  %283 = add nuw nsw i32 %265, 2, !dbg !533
  tail call void @llvm.dbg.value(metadata i32 %283, metadata !332, metadata !DIExpression()), !dbg !515
  %284 = icmp ult i32 %265, 58, !dbg !534
  %285 = icmp ne i16 %282, 0, !dbg !516
  %286 = select i1 %284, i1 %285, i1 false, !dbg !516
  br i1 %286, label %264, label %262, !dbg !517, !llvm.loop !535

287:                                              ; preds = %262
  %288 = getelementptr inbounds i8, ptr %267, i64 3, !dbg !537
  %289 = icmp ugt ptr %288, %233, !dbg !538
  br i1 %289, label %311, label %290, !dbg !539

290:                                              ; preds = %287
  %291 = load i8, ptr %269, align 1, !dbg !540, !tbaa !262
  %292 = zext i8 %291 to i32, !dbg !541
  %293 = add i32 %281, %292, !dbg !542
  tail call void @llvm.dbg.value(metadata i32 %293, metadata !331, metadata !DIExpression()), !dbg !509
  br label %294, !dbg !543

294:                                              ; preds = %290, %262
  %295 = phi i32 [ %293, %290 ], [ %281, %262 ], !dbg !509
  tail call void @llvm.dbg.value(metadata i32 %295, metadata !331, metadata !DIExpression()), !dbg !509
  tail call void @llvm.dbg.value(metadata i32 0, metadata !334, metadata !DIExpression()), !dbg !509
  %296 = icmp ugt i32 %295, 65535, !dbg !544
  br i1 %296, label %297, label %307, !dbg !545

297:                                              ; preds = %294, %297
  %298 = phi i32 [ %303, %297 ], [ 0, %294 ]
  %299 = phi i32 [ %302, %297 ], [ %295, %294 ]
  tail call void @llvm.dbg.value(metadata i32 %298, metadata !334, metadata !DIExpression()), !dbg !509
  tail call void @llvm.dbg.value(metadata i32 %299, metadata !331, metadata !DIExpression()), !dbg !509
  %300 = lshr i32 %299, 16, !dbg !544
  %301 = and i32 %299, 65535, !dbg !546
  %302 = add nuw nsw i32 %301, %300, !dbg !547
  tail call void @llvm.dbg.value(metadata i32 %302, metadata !331, metadata !DIExpression()), !dbg !509
  %303 = add nuw nsw i32 %298, 1, !dbg !548
  tail call void @llvm.dbg.value(metadata i32 %303, metadata !334, metadata !DIExpression()), !dbg !509
  %304 = icmp ugt i32 %302, 65535, !dbg !544
  %305 = icmp ult i32 %298, 15, !dbg !549
  %306 = select i1 %304, i1 %305, i1 false, !dbg !549
  br i1 %306, label %297, label %307, !dbg !545, !llvm.loop !550

307:                                              ; preds = %297, %242, %294
  %308 = phi i32 [ %295, %294 ], [ 0, %242 ], [ %302, %297 ], !dbg !509
  %309 = trunc i32 %308 to i16, !dbg !552
  %310 = xor i16 %309, -1, !dbg !552
  tail call void @llvm.dbg.value(metadata i16 %310, metadata !335, metadata !DIExpression()), !dbg !509
  br label %311

311:                                              ; preds = %287, %307
  %312 = phi i16 [ %310, %307 ], [ 0, %287 ], !dbg !509
  %313 = call i16 @llvm.bswap.i16(i16 %312), !dbg !508
  store i16 %313, ptr %257, align 2, !dbg !553, !tbaa !390
  %314 = getelementptr inbounds %struct.lh_route, ptr %225, i64 0, i32 1, !dbg !554
  %315 = load i32, ptr %314, align 4, !dbg !554, !tbaa !394
  %316 = call i64 inttoptr (i64 13 to ptr)(ptr noundef %0, i32 noundef %315, i64 noundef 0) #5, !dbg !555
  br label %317, !dbg !556

317:                                              ; preds = %224, %227, %230, %311
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %12), !dbg !557
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %13)
  call void @llvm.dbg.assign(metadata i1 undef, metadata !268, metadata !DIExpression(), metadata !192, metadata ptr %13, metadata !DIExpression()), !dbg !558
  store i32 3, ptr %13, align 4, !tbaa !286, !DIAssignID !560
  call void @llvm.dbg.assign(metadata i32 3, metadata !268, metadata !DIExpression(), metadata !560, metadata ptr %13, metadata !DIExpression()), !dbg !558
  call void @llvm.dbg.value(metadata ptr %0, metadata !273, metadata !DIExpression()), !dbg !558
  %318 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lh_map, ptr noundef nonnull %13) #5, !dbg !561
  call void @llvm.dbg.value(metadata ptr %318, metadata !274, metadata !DIExpression()), !dbg !558
  %319 = icmp eq ptr %318, null, !dbg !562
  br i1 %319, label %410, label %320, !dbg !563

320:                                              ; preds = %317
  %321 = load i32, ptr %318, align 4, !dbg !564, !tbaa !293
  %322 = icmp eq i32 %321, 0, !dbg !565
  br i1 %322, label %410, label %323, !dbg !566

323:                                              ; preds = %320
  %324 = load i32, ptr %14, align 8, !dbg !567, !tbaa !241
  %325 = zext i32 %324 to i64, !dbg !568
  %326 = inttoptr i64 %325 to ptr, !dbg !569
  call void @llvm.dbg.value(metadata ptr %326, metadata !275, metadata !DIExpression()), !dbg !570
  %327 = load i32, ptr %18, align 4, !dbg !571, !tbaa !250
  %328 = zext i32 %327 to i64, !dbg !572
  %329 = inttoptr i64 %328 to ptr, !dbg !573
  call void @llvm.dbg.value(metadata ptr %329, metadata !278, metadata !DIExpression()), !dbg !570
  call void @llvm.dbg.value(metadata ptr %329, metadata !279, metadata !DIExpression()), !dbg !570
  %330 = getelementptr inbounds %struct.ethhdr, ptr %329, i64 1, !dbg !574
  %331 = icmp ugt ptr %330, %326, !dbg !575
  call void @llvm.dbg.value(metadata ptr %330, metadata !280, metadata !DIExpression()), !dbg !576
  %332 = getelementptr inbounds %struct.ethhdr, ptr %329, i64 2, i32 1
  %333 = icmp ugt ptr %332, %326
  %334 = select i1 %331, i1 true, i1 %333, !dbg !577
  br i1 %334, label %410, label %335, !dbg !577

335:                                              ; preds = %323
  %336 = getelementptr inbounds %struct.ethhdr, ptr %329, i64 0, i32 1, !dbg !578
  %337 = getelementptr inbounds %struct.lh_route, ptr %318, i64 0, i32 4, !dbg !579
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %336, ptr noundef nonnull align 4 dereferenceable(6) %337, i64 6, i1 false), !dbg !580
  %338 = getelementptr inbounds %struct.lh_route, ptr %318, i64 0, i32 5, !dbg !581
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %329, ptr noundef nonnull align 2 dereferenceable(6) %338, i64 6, i1 false), !dbg !582
  %339 = getelementptr inbounds %struct.lh_route, ptr %318, i64 0, i32 3, !dbg !583
  %340 = load i32, ptr %339, align 4, !dbg !583, !tbaa !316
  %341 = call i32 @llvm.bswap.i32(i32 %340), !dbg !583
  %342 = getelementptr inbounds %struct.ethhdr, ptr %329, i64 1, i32 2, !dbg !584
  %343 = getelementptr inbounds %struct.ethhdr, ptr %329, i64 2, i32 0, i64 2, !dbg !584
  store i32 %341, ptr %343, align 4, !dbg !585, !tbaa !262
  %344 = getelementptr inbounds %struct.lh_route, ptr %318, i64 0, i32 2, !dbg !586
  %345 = load i32, ptr %344, align 4, !dbg !586, !tbaa !320
  %346 = call i32 @llvm.bswap.i32(i32 %345), !dbg !586
  store i32 %346, ptr %342, align 4, !dbg !587, !tbaa !262
  %347 = load i8, ptr %330, align 4, !dbg !588
  %348 = shl i8 %347, 2, !dbg !588
  %349 = and i8 %348, 60, !dbg !588
  tail call void @llvm.dbg.value(metadata ptr %330, metadata !323, metadata !DIExpression()), !dbg !589
  tail call void @llvm.dbg.value(metadata i8 %349, metadata !329, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !589
  tail call void @llvm.dbg.value(metadata ptr %326, metadata !330, metadata !DIExpression()), !dbg !589
  tail call void @llvm.dbg.value(metadata i32 0, metadata !331, metadata !DIExpression()), !dbg !589
  %350 = getelementptr inbounds %struct.ethhdr, ptr %329, i64 1, i32 1, i64 4, !dbg !591
  store i8 0, ptr %350, align 1, !dbg !592, !tbaa !262
  %351 = getelementptr inbounds %struct.ethhdr, ptr %329, i64 1, i32 1, i64 5, !dbg !593
  store i8 0, ptr %351, align 1, !dbg !594, !tbaa !262
  tail call void @llvm.dbg.value(metadata i32 0, metadata !332, metadata !DIExpression()), !dbg !595
  %352 = icmp eq i8 %349, 0, !dbg !596
  br i1 %352, label %400, label %353, !dbg !597

353:                                              ; preds = %335
  %354 = zext nneg i8 %349 to i16, !dbg !588
  tail call void @llvm.dbg.value(metadata i16 %354, metadata !329, metadata !DIExpression()), !dbg !589
  br label %357, !dbg !597

355:                                              ; preds = %373
  %356 = icmp eq i16 %375, 0, !dbg !598
  br i1 %356, label %387, label %380, !dbg !599

357:                                              ; preds = %353, %373
  %358 = phi i32 [ %376, %373 ], [ 0, %353 ]
  %359 = phi i32 [ %374, %373 ], [ 0, %353 ]
  %360 = phi ptr [ %362, %373 ], [ %330, %353 ]
  %361 = phi i16 [ %375, %373 ], [ %354, %353 ]
  tail call void @llvm.dbg.value(metadata i32 %358, metadata !332, metadata !DIExpression()), !dbg !595
  tail call void @llvm.dbg.value(metadata i32 %359, metadata !331, metadata !DIExpression()), !dbg !589
  tail call void @llvm.dbg.value(metadata ptr %360, metadata !323, metadata !DIExpression()), !dbg !589
  tail call void @llvm.dbg.value(metadata i16 %361, metadata !329, metadata !DIExpression()), !dbg !589
  %362 = getelementptr inbounds i8, ptr %360, i64 2, !dbg !600
  %363 = icmp ugt ptr %362, %326, !dbg !601
  br i1 %363, label %373, label %364, !dbg !602

364:                                              ; preds = %357
  %365 = load i8, ptr %360, align 1, !dbg !603, !tbaa !262
  %366 = zext i8 %365 to i32, !dbg !604
  %367 = shl nuw nsw i32 %366, 8, !dbg !605
  %368 = getelementptr inbounds i8, ptr %360, i64 1, !dbg !606
  %369 = load i8, ptr %368, align 1, !dbg !607, !tbaa !262
  %370 = zext i8 %369 to i32, !dbg !608
  %371 = or disjoint i32 %367, %370, !dbg !609
  %372 = add i32 %371, %359, !dbg !610
  tail call void @llvm.dbg.value(metadata i32 %372, metadata !331, metadata !DIExpression()), !dbg !589
  br label %373, !dbg !611

373:                                              ; preds = %364, %357
  %374 = phi i32 [ %372, %364 ], [ %359, %357 ], !dbg !589
  tail call void @llvm.dbg.value(metadata i32 %374, metadata !331, metadata !DIExpression()), !dbg !589
  tail call void @llvm.dbg.value(metadata ptr %362, metadata !323, metadata !DIExpression()), !dbg !589
  %375 = add nsw i16 %361, -2, !dbg !612
  tail call void @llvm.dbg.value(metadata i16 %375, metadata !329, metadata !DIExpression()), !dbg !589
  %376 = add nuw nsw i32 %358, 2, !dbg !613
  tail call void @llvm.dbg.value(metadata i32 %376, metadata !332, metadata !DIExpression()), !dbg !595
  %377 = icmp ult i32 %358, 58, !dbg !614
  %378 = icmp ne i16 %375, 0, !dbg !596
  %379 = select i1 %377, i1 %378, i1 false, !dbg !596
  br i1 %379, label %357, label %355, !dbg !597, !llvm.loop !615

380:                                              ; preds = %355
  %381 = getelementptr inbounds i8, ptr %360, i64 3, !dbg !617
  %382 = icmp ugt ptr %381, %326, !dbg !618
  br i1 %382, label %404, label %383, !dbg !619

383:                                              ; preds = %380
  %384 = load i8, ptr %362, align 1, !dbg !620, !tbaa !262
  %385 = zext i8 %384 to i32, !dbg !621
  %386 = add i32 %374, %385, !dbg !622
  tail call void @llvm.dbg.value(metadata i32 %386, metadata !331, metadata !DIExpression()), !dbg !589
  br label %387, !dbg !623

387:                                              ; preds = %383, %355
  %388 = phi i32 [ %386, %383 ], [ %374, %355 ], !dbg !589
  tail call void @llvm.dbg.value(metadata i32 %388, metadata !331, metadata !DIExpression()), !dbg !589
  tail call void @llvm.dbg.value(metadata i32 0, metadata !334, metadata !DIExpression()), !dbg !589
  %389 = icmp ugt i32 %388, 65535, !dbg !624
  br i1 %389, label %390, label %400, !dbg !625

390:                                              ; preds = %387, %390
  %391 = phi i32 [ %396, %390 ], [ 0, %387 ]
  %392 = phi i32 [ %395, %390 ], [ %388, %387 ]
  tail call void @llvm.dbg.value(metadata i32 %391, metadata !334, metadata !DIExpression()), !dbg !589
  tail call void @llvm.dbg.value(metadata i32 %392, metadata !331, metadata !DIExpression()), !dbg !589
  %393 = lshr i32 %392, 16, !dbg !624
  %394 = and i32 %392, 65535, !dbg !626
  %395 = add nuw nsw i32 %394, %393, !dbg !627
  tail call void @llvm.dbg.value(metadata i32 %395, metadata !331, metadata !DIExpression()), !dbg !589
  %396 = add nuw nsw i32 %391, 1, !dbg !628
  tail call void @llvm.dbg.value(metadata i32 %396, metadata !334, metadata !DIExpression()), !dbg !589
  %397 = icmp ugt i32 %395, 65535, !dbg !624
  %398 = icmp ult i32 %391, 15, !dbg !629
  %399 = select i1 %397, i1 %398, i1 false, !dbg !629
  br i1 %399, label %390, label %400, !dbg !625, !llvm.loop !630

400:                                              ; preds = %390, %335, %387
  %401 = phi i32 [ %388, %387 ], [ 0, %335 ], [ %395, %390 ], !dbg !589
  %402 = trunc i32 %401 to i16, !dbg !632
  %403 = xor i16 %402, -1, !dbg !632
  tail call void @llvm.dbg.value(metadata i16 %403, metadata !335, metadata !DIExpression()), !dbg !589
  br label %404

404:                                              ; preds = %380, %400
  %405 = phi i16 [ %403, %400 ], [ 0, %380 ], !dbg !589
  %406 = call i16 @llvm.bswap.i16(i16 %405), !dbg !588
  store i16 %406, ptr %350, align 2, !dbg !633, !tbaa !390
  %407 = getelementptr inbounds %struct.lh_route, ptr %318, i64 0, i32 1, !dbg !634
  %408 = load i32, ptr %407, align 4, !dbg !634, !tbaa !394
  %409 = call i64 inttoptr (i64 13 to ptr)(ptr noundef %0, i32 noundef %408, i64 noundef 0) #5, !dbg !635
  br label %410, !dbg !636

410:                                              ; preds = %317, %320, %323, %404
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %13), !dbg !637
  br label %795, !dbg !638

411:                                              ; preds = %31
  %412 = and i32 %35, -117440513, !dbg !639
  call void @llvm.dbg.value(metadata i32 %412, metadata !237, metadata !DIExpression()), !dbg !238
  %413 = icmp eq i32 %412, %34, !dbg !640
  br i1 %413, label %414, label %795, !dbg !643

414:                                              ; preds = %411
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2)
  call void @llvm.dbg.assign(metadata i1 undef, metadata !644, metadata !DIExpression(), metadata !181, metadata ptr %2, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.assign(metadata i1 undef, metadata !649, metadata !DIExpression(), metadata !182, metadata ptr %3, metadata !DIExpression()), !dbg !659
  store i32 0, ptr %2, align 4, !tbaa !286, !DIAssignID !662
  call void @llvm.dbg.assign(metadata i32 0, metadata !644, metadata !DIExpression(), metadata !662, metadata ptr %2, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.value(metadata ptr %0, metadata !647, metadata !DIExpression()), !dbg !659
  %415 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lh_map, ptr noundef nonnull %2) #5, !dbg !663
  call void @llvm.dbg.value(metadata ptr %415, metadata !648, metadata !DIExpression()), !dbg !659
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #5, !dbg !664
  store i32 0, ptr %3, align 4, !dbg !665, !tbaa !286, !DIAssignID !666
  call void @llvm.dbg.assign(metadata i32 0, metadata !649, metadata !DIExpression(), metadata !666, metadata ptr %3, metadata !DIExpression()), !dbg !659
  %416 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lhaddr_map, ptr noundef nonnull %3) #5, !dbg !667
  call void @llvm.dbg.value(metadata ptr %416, metadata !650, metadata !DIExpression()), !dbg !659
  %417 = icmp ne ptr %415, null, !dbg !668
  %418 = icmp ne ptr %416, null
  %419 = select i1 %417, i1 %418, i1 false, !dbg !669
  br i1 %419, label %420, label %509, !dbg !669

420:                                              ; preds = %414
  %421 = load i32, ptr %415, align 4, !dbg !670, !tbaa !293
  %422 = icmp eq i32 %421, 0, !dbg !671
  br i1 %422, label %509, label %423, !dbg !672

423:                                              ; preds = %420
  %424 = load i32, ptr %14, align 8, !dbg !673, !tbaa !241
  %425 = zext i32 %424 to i64, !dbg !674
  %426 = inttoptr i64 %425 to ptr, !dbg !675
  call void @llvm.dbg.value(metadata ptr %426, metadata !651, metadata !DIExpression()), !dbg !676
  %427 = load i32, ptr %18, align 4, !dbg !677, !tbaa !250
  %428 = zext i32 %427 to i64, !dbg !678
  %429 = inttoptr i64 %428 to ptr, !dbg !679
  call void @llvm.dbg.value(metadata ptr %429, metadata !654, metadata !DIExpression()), !dbg !676
  call void @llvm.dbg.value(metadata ptr %429, metadata !655, metadata !DIExpression()), !dbg !676
  %430 = getelementptr inbounds %struct.ethhdr, ptr %429, i64 1, !dbg !680
  %431 = icmp ugt ptr %430, %426, !dbg !681
  call void @llvm.dbg.value(metadata ptr %430, metadata !656, metadata !DIExpression()), !dbg !682
  %432 = getelementptr inbounds %struct.ethhdr, ptr %429, i64 2, i32 1
  %433 = icmp ugt ptr %432, %426
  %434 = select i1 %431, i1 true, i1 %433, !dbg !683
  br i1 %434, label %509, label %435, !dbg !683

435:                                              ; preds = %423
  %436 = getelementptr inbounds %struct.ethhdr, ptr %429, i64 0, i32 1, !dbg !684
  %437 = getelementptr inbounds %struct.lh_route, ptr %415, i64 0, i32 4, !dbg !687
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %436, ptr noundef nonnull align 4 dereferenceable(6) %437, i64 6, i1 false), !dbg !688
  %438 = getelementptr inbounds %struct.lh_route, ptr %415, i64 0, i32 5, !dbg !689
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %429, ptr noundef nonnull align 2 dereferenceable(6) %438, i64 6, i1 false), !dbg !690
  %439 = getelementptr inbounds %struct.lh_route, ptr %415, i64 0, i32 3, !dbg !691
  %440 = load i32, ptr %439, align 4, !dbg !691, !tbaa !316
  %441 = call i32 @llvm.bswap.i32(i32 %440), !dbg !691
  %442 = getelementptr inbounds %struct.ethhdr, ptr %429, i64 1, i32 2, !dbg !692
  %443 = getelementptr inbounds %struct.ethhdr, ptr %429, i64 2, i32 0, i64 2, !dbg !692
  store i32 %441, ptr %443, align 4, !dbg !693, !tbaa !262
  %444 = load i32, ptr %416, align 4, !dbg !694, !tbaa !286
  %445 = call i32 @llvm.bswap.i32(i32 %444), !dbg !694
  store i32 %445, ptr %442, align 4, !dbg !695, !tbaa !262
  %446 = load i8, ptr %430, align 4, !dbg !696
  %447 = shl i8 %446, 2, !dbg !696
  %448 = and i8 %447, 60, !dbg !696
  tail call void @llvm.dbg.value(metadata ptr %430, metadata !323, metadata !DIExpression()), !dbg !697
  tail call void @llvm.dbg.value(metadata i8 %448, metadata !329, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !697
  tail call void @llvm.dbg.value(metadata ptr %426, metadata !330, metadata !DIExpression()), !dbg !697
  tail call void @llvm.dbg.value(metadata i32 0, metadata !331, metadata !DIExpression()), !dbg !697
  %449 = getelementptr inbounds %struct.ethhdr, ptr %429, i64 1, i32 1, i64 4, !dbg !699
  store i8 0, ptr %449, align 1, !dbg !700, !tbaa !262
  %450 = getelementptr inbounds %struct.ethhdr, ptr %429, i64 1, i32 1, i64 5, !dbg !701
  store i8 0, ptr %450, align 1, !dbg !702, !tbaa !262
  tail call void @llvm.dbg.value(metadata i32 0, metadata !332, metadata !DIExpression()), !dbg !703
  %451 = icmp eq i8 %448, 0, !dbg !704
  br i1 %451, label %499, label %452, !dbg !705

452:                                              ; preds = %435
  %453 = zext nneg i8 %448 to i16, !dbg !696
  tail call void @llvm.dbg.value(metadata i16 %453, metadata !329, metadata !DIExpression()), !dbg !697
  br label %456, !dbg !705

454:                                              ; preds = %472
  %455 = icmp eq i16 %474, 0, !dbg !706
  br i1 %455, label %486, label %479, !dbg !707

456:                                              ; preds = %452, %472
  %457 = phi i32 [ %475, %472 ], [ 0, %452 ]
  %458 = phi i32 [ %473, %472 ], [ 0, %452 ]
  %459 = phi ptr [ %461, %472 ], [ %430, %452 ]
  %460 = phi i16 [ %474, %472 ], [ %453, %452 ]
  tail call void @llvm.dbg.value(metadata i32 %457, metadata !332, metadata !DIExpression()), !dbg !703
  tail call void @llvm.dbg.value(metadata i32 %458, metadata !331, metadata !DIExpression()), !dbg !697
  tail call void @llvm.dbg.value(metadata ptr %459, metadata !323, metadata !DIExpression()), !dbg !697
  tail call void @llvm.dbg.value(metadata i16 %460, metadata !329, metadata !DIExpression()), !dbg !697
  %461 = getelementptr inbounds i8, ptr %459, i64 2, !dbg !708
  %462 = icmp ugt ptr %461, %426, !dbg !709
  br i1 %462, label %472, label %463, !dbg !710

463:                                              ; preds = %456
  %464 = load i8, ptr %459, align 1, !dbg !711, !tbaa !262
  %465 = zext i8 %464 to i32, !dbg !712
  %466 = shl nuw nsw i32 %465, 8, !dbg !713
  %467 = getelementptr inbounds i8, ptr %459, i64 1, !dbg !714
  %468 = load i8, ptr %467, align 1, !dbg !715, !tbaa !262
  %469 = zext i8 %468 to i32, !dbg !716
  %470 = or disjoint i32 %466, %469, !dbg !717
  %471 = add i32 %470, %458, !dbg !718
  tail call void @llvm.dbg.value(metadata i32 %471, metadata !331, metadata !DIExpression()), !dbg !697
  br label %472, !dbg !719

472:                                              ; preds = %463, %456
  %473 = phi i32 [ %471, %463 ], [ %458, %456 ], !dbg !697
  tail call void @llvm.dbg.value(metadata i32 %473, metadata !331, metadata !DIExpression()), !dbg !697
  tail call void @llvm.dbg.value(metadata ptr %461, metadata !323, metadata !DIExpression()), !dbg !697
  %474 = add nsw i16 %460, -2, !dbg !720
  tail call void @llvm.dbg.value(metadata i16 %474, metadata !329, metadata !DIExpression()), !dbg !697
  %475 = add nuw nsw i32 %457, 2, !dbg !721
  tail call void @llvm.dbg.value(metadata i32 %475, metadata !332, metadata !DIExpression()), !dbg !703
  %476 = icmp ult i32 %457, 58, !dbg !722
  %477 = icmp ne i16 %474, 0, !dbg !704
  %478 = select i1 %476, i1 %477, i1 false, !dbg !704
  br i1 %478, label %456, label %454, !dbg !705, !llvm.loop !723

479:                                              ; preds = %454
  %480 = getelementptr inbounds i8, ptr %459, i64 3, !dbg !725
  %481 = icmp ugt ptr %480, %426, !dbg !726
  br i1 %481, label %503, label %482, !dbg !727

482:                                              ; preds = %479
  %483 = load i8, ptr %461, align 1, !dbg !728, !tbaa !262
  %484 = zext i8 %483 to i32, !dbg !729
  %485 = add i32 %473, %484, !dbg !730
  tail call void @llvm.dbg.value(metadata i32 %485, metadata !331, metadata !DIExpression()), !dbg !697
  br label %486, !dbg !731

486:                                              ; preds = %482, %454
  %487 = phi i32 [ %485, %482 ], [ %473, %454 ], !dbg !697
  tail call void @llvm.dbg.value(metadata i32 %487, metadata !331, metadata !DIExpression()), !dbg !697
  tail call void @llvm.dbg.value(metadata i32 0, metadata !334, metadata !DIExpression()), !dbg !697
  %488 = icmp ugt i32 %487, 65535, !dbg !732
  br i1 %488, label %489, label %499, !dbg !733

489:                                              ; preds = %486, %489
  %490 = phi i32 [ %495, %489 ], [ 0, %486 ]
  %491 = phi i32 [ %494, %489 ], [ %487, %486 ]
  tail call void @llvm.dbg.value(metadata i32 %490, metadata !334, metadata !DIExpression()), !dbg !697
  tail call void @llvm.dbg.value(metadata i32 %491, metadata !331, metadata !DIExpression()), !dbg !697
  %492 = lshr i32 %491, 16, !dbg !732
  %493 = and i32 %491, 65535, !dbg !734
  %494 = add nuw nsw i32 %493, %492, !dbg !735
  tail call void @llvm.dbg.value(metadata i32 %494, metadata !331, metadata !DIExpression()), !dbg !697
  %495 = add nuw nsw i32 %490, 1, !dbg !736
  tail call void @llvm.dbg.value(metadata i32 %495, metadata !334, metadata !DIExpression()), !dbg !697
  %496 = icmp ugt i32 %494, 65535, !dbg !732
  %497 = icmp ult i32 %490, 15, !dbg !737
  %498 = select i1 %496, i1 %497, i1 false, !dbg !737
  br i1 %498, label %489, label %499, !dbg !733, !llvm.loop !738

499:                                              ; preds = %489, %435, %486
  %500 = phi i32 [ %487, %486 ], [ 0, %435 ], [ %494, %489 ], !dbg !697
  %501 = trunc i32 %500 to i16, !dbg !740
  %502 = xor i16 %501, -1, !dbg !740
  tail call void @llvm.dbg.value(metadata i16 %502, metadata !335, metadata !DIExpression()), !dbg !697
  br label %503

503:                                              ; preds = %479, %499
  %504 = phi i16 [ %502, %499 ], [ 0, %479 ], !dbg !697
  %505 = call i16 @llvm.bswap.i16(i16 %504), !dbg !696
  store i16 %505, ptr %449, align 2, !dbg !741, !tbaa !390
  %506 = getelementptr inbounds %struct.lh_route, ptr %415, i64 0, i32 1, !dbg !742
  %507 = load i32, ptr %506, align 4, !dbg !742, !tbaa !394
  %508 = call i64 inttoptr (i64 13 to ptr)(ptr noundef %0, i32 noundef %507, i64 noundef 0) #5, !dbg !743
  br label %509, !dbg !744

509:                                              ; preds = %414, %420, %423, %503
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #5, !dbg !745
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2), !dbg !746
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4)
  call void @llvm.dbg.assign(metadata i1 undef, metadata !644, metadata !DIExpression(), metadata !183, metadata ptr %4, metadata !DIExpression()), !dbg !747
  call void @llvm.dbg.assign(metadata i1 undef, metadata !649, metadata !DIExpression(), metadata !184, metadata ptr %5, metadata !DIExpression()), !dbg !747
  store i32 1, ptr %4, align 4, !tbaa !286, !DIAssignID !749
  call void @llvm.dbg.assign(metadata i32 1, metadata !644, metadata !DIExpression(), metadata !749, metadata ptr %4, metadata !DIExpression()), !dbg !747
  call void @llvm.dbg.value(metadata ptr %0, metadata !647, metadata !DIExpression()), !dbg !747
  %510 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lh_map, ptr noundef nonnull %4) #5, !dbg !750
  call void @llvm.dbg.value(metadata ptr %510, metadata !648, metadata !DIExpression()), !dbg !747
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #5, !dbg !751
  store i32 0, ptr %5, align 4, !dbg !752, !tbaa !286, !DIAssignID !753
  call void @llvm.dbg.assign(metadata i32 0, metadata !649, metadata !DIExpression(), metadata !753, metadata ptr %5, metadata !DIExpression()), !dbg !747
  %511 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lhaddr_map, ptr noundef nonnull %5) #5, !dbg !754
  call void @llvm.dbg.value(metadata ptr %511, metadata !650, metadata !DIExpression()), !dbg !747
  %512 = icmp ne ptr %510, null, !dbg !755
  %513 = icmp ne ptr %511, null
  %514 = select i1 %512, i1 %513, i1 false, !dbg !756
  br i1 %514, label %515, label %604, !dbg !756

515:                                              ; preds = %509
  %516 = load i32, ptr %510, align 4, !dbg !757, !tbaa !293
  %517 = icmp eq i32 %516, 0, !dbg !758
  br i1 %517, label %604, label %518, !dbg !759

518:                                              ; preds = %515
  %519 = load i32, ptr %14, align 8, !dbg !760, !tbaa !241
  %520 = zext i32 %519 to i64, !dbg !761
  %521 = inttoptr i64 %520 to ptr, !dbg !762
  call void @llvm.dbg.value(metadata ptr %521, metadata !651, metadata !DIExpression()), !dbg !763
  %522 = load i32, ptr %18, align 4, !dbg !764, !tbaa !250
  %523 = zext i32 %522 to i64, !dbg !765
  %524 = inttoptr i64 %523 to ptr, !dbg !766
  call void @llvm.dbg.value(metadata ptr %524, metadata !654, metadata !DIExpression()), !dbg !763
  call void @llvm.dbg.value(metadata ptr %524, metadata !655, metadata !DIExpression()), !dbg !763
  %525 = getelementptr inbounds %struct.ethhdr, ptr %524, i64 1, !dbg !767
  %526 = icmp ugt ptr %525, %521, !dbg !768
  call void @llvm.dbg.value(metadata ptr %525, metadata !656, metadata !DIExpression()), !dbg !769
  %527 = getelementptr inbounds %struct.ethhdr, ptr %524, i64 2, i32 1
  %528 = icmp ugt ptr %527, %521
  %529 = select i1 %526, i1 true, i1 %528, !dbg !770
  br i1 %529, label %604, label %530, !dbg !770

530:                                              ; preds = %518
  %531 = getelementptr inbounds %struct.ethhdr, ptr %524, i64 0, i32 1, !dbg !771
  %532 = getelementptr inbounds %struct.lh_route, ptr %510, i64 0, i32 4, !dbg !772
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %531, ptr noundef nonnull align 4 dereferenceable(6) %532, i64 6, i1 false), !dbg !773
  %533 = getelementptr inbounds %struct.lh_route, ptr %510, i64 0, i32 5, !dbg !774
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %524, ptr noundef nonnull align 2 dereferenceable(6) %533, i64 6, i1 false), !dbg !775
  %534 = getelementptr inbounds %struct.lh_route, ptr %510, i64 0, i32 3, !dbg !776
  %535 = load i32, ptr %534, align 4, !dbg !776, !tbaa !316
  %536 = call i32 @llvm.bswap.i32(i32 %535), !dbg !776
  %537 = getelementptr inbounds %struct.ethhdr, ptr %524, i64 1, i32 2, !dbg !777
  %538 = getelementptr inbounds %struct.ethhdr, ptr %524, i64 2, i32 0, i64 2, !dbg !777
  store i32 %536, ptr %538, align 4, !dbg !778, !tbaa !262
  %539 = load i32, ptr %511, align 4, !dbg !779, !tbaa !286
  %540 = call i32 @llvm.bswap.i32(i32 %539), !dbg !779
  store i32 %540, ptr %537, align 4, !dbg !780, !tbaa !262
  %541 = load i8, ptr %525, align 4, !dbg !781
  %542 = shl i8 %541, 2, !dbg !781
  %543 = and i8 %542, 60, !dbg !781
  tail call void @llvm.dbg.value(metadata ptr %525, metadata !323, metadata !DIExpression()), !dbg !782
  tail call void @llvm.dbg.value(metadata i8 %543, metadata !329, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !782
  tail call void @llvm.dbg.value(metadata ptr %521, metadata !330, metadata !DIExpression()), !dbg !782
  tail call void @llvm.dbg.value(metadata i32 0, metadata !331, metadata !DIExpression()), !dbg !782
  %544 = getelementptr inbounds %struct.ethhdr, ptr %524, i64 1, i32 1, i64 4, !dbg !784
  store i8 0, ptr %544, align 1, !dbg !785, !tbaa !262
  %545 = getelementptr inbounds %struct.ethhdr, ptr %524, i64 1, i32 1, i64 5, !dbg !786
  store i8 0, ptr %545, align 1, !dbg !787, !tbaa !262
  tail call void @llvm.dbg.value(metadata i32 0, metadata !332, metadata !DIExpression()), !dbg !788
  %546 = icmp eq i8 %543, 0, !dbg !789
  br i1 %546, label %594, label %547, !dbg !790

547:                                              ; preds = %530
  %548 = zext nneg i8 %543 to i16, !dbg !781
  tail call void @llvm.dbg.value(metadata i16 %548, metadata !329, metadata !DIExpression()), !dbg !782
  br label %551, !dbg !790

549:                                              ; preds = %567
  %550 = icmp eq i16 %569, 0, !dbg !791
  br i1 %550, label %581, label %574, !dbg !792

551:                                              ; preds = %547, %567
  %552 = phi i32 [ %570, %567 ], [ 0, %547 ]
  %553 = phi i32 [ %568, %567 ], [ 0, %547 ]
  %554 = phi ptr [ %556, %567 ], [ %525, %547 ]
  %555 = phi i16 [ %569, %567 ], [ %548, %547 ]
  tail call void @llvm.dbg.value(metadata i32 %552, metadata !332, metadata !DIExpression()), !dbg !788
  tail call void @llvm.dbg.value(metadata i32 %553, metadata !331, metadata !DIExpression()), !dbg !782
  tail call void @llvm.dbg.value(metadata ptr %554, metadata !323, metadata !DIExpression()), !dbg !782
  tail call void @llvm.dbg.value(metadata i16 %555, metadata !329, metadata !DIExpression()), !dbg !782
  %556 = getelementptr inbounds i8, ptr %554, i64 2, !dbg !793
  %557 = icmp ugt ptr %556, %521, !dbg !794
  br i1 %557, label %567, label %558, !dbg !795

558:                                              ; preds = %551
  %559 = load i8, ptr %554, align 1, !dbg !796, !tbaa !262
  %560 = zext i8 %559 to i32, !dbg !797
  %561 = shl nuw nsw i32 %560, 8, !dbg !798
  %562 = getelementptr inbounds i8, ptr %554, i64 1, !dbg !799
  %563 = load i8, ptr %562, align 1, !dbg !800, !tbaa !262
  %564 = zext i8 %563 to i32, !dbg !801
  %565 = or disjoint i32 %561, %564, !dbg !802
  %566 = add i32 %565, %553, !dbg !803
  tail call void @llvm.dbg.value(metadata i32 %566, metadata !331, metadata !DIExpression()), !dbg !782
  br label %567, !dbg !804

567:                                              ; preds = %558, %551
  %568 = phi i32 [ %566, %558 ], [ %553, %551 ], !dbg !782
  tail call void @llvm.dbg.value(metadata i32 %568, metadata !331, metadata !DIExpression()), !dbg !782
  tail call void @llvm.dbg.value(metadata ptr %556, metadata !323, metadata !DIExpression()), !dbg !782
  %569 = add nsw i16 %555, -2, !dbg !805
  tail call void @llvm.dbg.value(metadata i16 %569, metadata !329, metadata !DIExpression()), !dbg !782
  %570 = add nuw nsw i32 %552, 2, !dbg !806
  tail call void @llvm.dbg.value(metadata i32 %570, metadata !332, metadata !DIExpression()), !dbg !788
  %571 = icmp ult i32 %552, 58, !dbg !807
  %572 = icmp ne i16 %569, 0, !dbg !789
  %573 = select i1 %571, i1 %572, i1 false, !dbg !789
  br i1 %573, label %551, label %549, !dbg !790, !llvm.loop !808

574:                                              ; preds = %549
  %575 = getelementptr inbounds i8, ptr %554, i64 3, !dbg !810
  %576 = icmp ugt ptr %575, %521, !dbg !811
  br i1 %576, label %598, label %577, !dbg !812

577:                                              ; preds = %574
  %578 = load i8, ptr %556, align 1, !dbg !813, !tbaa !262
  %579 = zext i8 %578 to i32, !dbg !814
  %580 = add i32 %568, %579, !dbg !815
  tail call void @llvm.dbg.value(metadata i32 %580, metadata !331, metadata !DIExpression()), !dbg !782
  br label %581, !dbg !816

581:                                              ; preds = %577, %549
  %582 = phi i32 [ %580, %577 ], [ %568, %549 ], !dbg !782
  tail call void @llvm.dbg.value(metadata i32 %582, metadata !331, metadata !DIExpression()), !dbg !782
  tail call void @llvm.dbg.value(metadata i32 0, metadata !334, metadata !DIExpression()), !dbg !782
  %583 = icmp ugt i32 %582, 65535, !dbg !817
  br i1 %583, label %584, label %594, !dbg !818

584:                                              ; preds = %581, %584
  %585 = phi i32 [ %590, %584 ], [ 0, %581 ]
  %586 = phi i32 [ %589, %584 ], [ %582, %581 ]
  tail call void @llvm.dbg.value(metadata i32 %585, metadata !334, metadata !DIExpression()), !dbg !782
  tail call void @llvm.dbg.value(metadata i32 %586, metadata !331, metadata !DIExpression()), !dbg !782
  %587 = lshr i32 %586, 16, !dbg !817
  %588 = and i32 %586, 65535, !dbg !819
  %589 = add nuw nsw i32 %588, %587, !dbg !820
  tail call void @llvm.dbg.value(metadata i32 %589, metadata !331, metadata !DIExpression()), !dbg !782
  %590 = add nuw nsw i32 %585, 1, !dbg !821
  tail call void @llvm.dbg.value(metadata i32 %590, metadata !334, metadata !DIExpression()), !dbg !782
  %591 = icmp ugt i32 %589, 65535, !dbg !817
  %592 = icmp ult i32 %585, 15, !dbg !822
  %593 = select i1 %591, i1 %592, i1 false, !dbg !822
  br i1 %593, label %584, label %594, !dbg !818, !llvm.loop !823

594:                                              ; preds = %584, %530, %581
  %595 = phi i32 [ %582, %581 ], [ 0, %530 ], [ %589, %584 ], !dbg !782
  %596 = trunc i32 %595 to i16, !dbg !825
  %597 = xor i16 %596, -1, !dbg !825
  tail call void @llvm.dbg.value(metadata i16 %597, metadata !335, metadata !DIExpression()), !dbg !782
  br label %598

598:                                              ; preds = %574, %594
  %599 = phi i16 [ %597, %594 ], [ 0, %574 ], !dbg !782
  %600 = call i16 @llvm.bswap.i16(i16 %599), !dbg !781
  store i16 %600, ptr %544, align 2, !dbg !826, !tbaa !390
  %601 = getelementptr inbounds %struct.lh_route, ptr %510, i64 0, i32 1, !dbg !827
  %602 = load i32, ptr %601, align 4, !dbg !827, !tbaa !394
  %603 = call i64 inttoptr (i64 13 to ptr)(ptr noundef %0, i32 noundef %602, i64 noundef 0) #5, !dbg !828
  br label %604, !dbg !829

604:                                              ; preds = %509, %515, %518, %598
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #5, !dbg !830
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4), !dbg !831
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6)
  call void @llvm.dbg.assign(metadata i1 undef, metadata !644, metadata !DIExpression(), metadata !185, metadata ptr %6, metadata !DIExpression()), !dbg !832
  call void @llvm.dbg.assign(metadata i1 undef, metadata !649, metadata !DIExpression(), metadata !186, metadata ptr %7, metadata !DIExpression()), !dbg !832
  store i32 2, ptr %6, align 4, !tbaa !286, !DIAssignID !834
  call void @llvm.dbg.assign(metadata i32 2, metadata !644, metadata !DIExpression(), metadata !834, metadata ptr %6, metadata !DIExpression()), !dbg !832
  call void @llvm.dbg.value(metadata ptr %0, metadata !647, metadata !DIExpression()), !dbg !832
  %605 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lh_map, ptr noundef nonnull %6) #5, !dbg !835
  call void @llvm.dbg.value(metadata ptr %605, metadata !648, metadata !DIExpression()), !dbg !832
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #5, !dbg !836
  store i32 0, ptr %7, align 4, !dbg !837, !tbaa !286, !DIAssignID !838
  call void @llvm.dbg.assign(metadata i32 0, metadata !649, metadata !DIExpression(), metadata !838, metadata ptr %7, metadata !DIExpression()), !dbg !832
  %606 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lhaddr_map, ptr noundef nonnull %7) #5, !dbg !839
  call void @llvm.dbg.value(metadata ptr %606, metadata !650, metadata !DIExpression()), !dbg !832
  %607 = icmp ne ptr %605, null, !dbg !840
  %608 = icmp ne ptr %606, null
  %609 = select i1 %607, i1 %608, i1 false, !dbg !841
  br i1 %609, label %610, label %699, !dbg !841

610:                                              ; preds = %604
  %611 = load i32, ptr %605, align 4, !dbg !842, !tbaa !293
  %612 = icmp eq i32 %611, 0, !dbg !843
  br i1 %612, label %699, label %613, !dbg !844

613:                                              ; preds = %610
  %614 = load i32, ptr %14, align 8, !dbg !845, !tbaa !241
  %615 = zext i32 %614 to i64, !dbg !846
  %616 = inttoptr i64 %615 to ptr, !dbg !847
  call void @llvm.dbg.value(metadata ptr %616, metadata !651, metadata !DIExpression()), !dbg !848
  %617 = load i32, ptr %18, align 4, !dbg !849, !tbaa !250
  %618 = zext i32 %617 to i64, !dbg !850
  %619 = inttoptr i64 %618 to ptr, !dbg !851
  call void @llvm.dbg.value(metadata ptr %619, metadata !654, metadata !DIExpression()), !dbg !848
  call void @llvm.dbg.value(metadata ptr %619, metadata !655, metadata !DIExpression()), !dbg !848
  %620 = getelementptr inbounds %struct.ethhdr, ptr %619, i64 1, !dbg !852
  %621 = icmp ugt ptr %620, %616, !dbg !853
  call void @llvm.dbg.value(metadata ptr %620, metadata !656, metadata !DIExpression()), !dbg !854
  %622 = getelementptr inbounds %struct.ethhdr, ptr %619, i64 2, i32 1
  %623 = icmp ugt ptr %622, %616
  %624 = select i1 %621, i1 true, i1 %623, !dbg !855
  br i1 %624, label %699, label %625, !dbg !855

625:                                              ; preds = %613
  %626 = getelementptr inbounds %struct.ethhdr, ptr %619, i64 0, i32 1, !dbg !856
  %627 = getelementptr inbounds %struct.lh_route, ptr %605, i64 0, i32 4, !dbg !857
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %626, ptr noundef nonnull align 4 dereferenceable(6) %627, i64 6, i1 false), !dbg !858
  %628 = getelementptr inbounds %struct.lh_route, ptr %605, i64 0, i32 5, !dbg !859
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %619, ptr noundef nonnull align 2 dereferenceable(6) %628, i64 6, i1 false), !dbg !860
  %629 = getelementptr inbounds %struct.lh_route, ptr %605, i64 0, i32 3, !dbg !861
  %630 = load i32, ptr %629, align 4, !dbg !861, !tbaa !316
  %631 = call i32 @llvm.bswap.i32(i32 %630), !dbg !861
  %632 = getelementptr inbounds %struct.ethhdr, ptr %619, i64 1, i32 2, !dbg !862
  %633 = getelementptr inbounds %struct.ethhdr, ptr %619, i64 2, i32 0, i64 2, !dbg !862
  store i32 %631, ptr %633, align 4, !dbg !863, !tbaa !262
  %634 = load i32, ptr %606, align 4, !dbg !864, !tbaa !286
  %635 = call i32 @llvm.bswap.i32(i32 %634), !dbg !864
  store i32 %635, ptr %632, align 4, !dbg !865, !tbaa !262
  %636 = load i8, ptr %620, align 4, !dbg !866
  %637 = shl i8 %636, 2, !dbg !866
  %638 = and i8 %637, 60, !dbg !866
  tail call void @llvm.dbg.value(metadata ptr %620, metadata !323, metadata !DIExpression()), !dbg !867
  tail call void @llvm.dbg.value(metadata i8 %638, metadata !329, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !867
  tail call void @llvm.dbg.value(metadata ptr %616, metadata !330, metadata !DIExpression()), !dbg !867
  tail call void @llvm.dbg.value(metadata i32 0, metadata !331, metadata !DIExpression()), !dbg !867
  %639 = getelementptr inbounds %struct.ethhdr, ptr %619, i64 1, i32 1, i64 4, !dbg !869
  store i8 0, ptr %639, align 1, !dbg !870, !tbaa !262
  %640 = getelementptr inbounds %struct.ethhdr, ptr %619, i64 1, i32 1, i64 5, !dbg !871
  store i8 0, ptr %640, align 1, !dbg !872, !tbaa !262
  tail call void @llvm.dbg.value(metadata i32 0, metadata !332, metadata !DIExpression()), !dbg !873
  %641 = icmp eq i8 %638, 0, !dbg !874
  br i1 %641, label %689, label %642, !dbg !875

642:                                              ; preds = %625
  %643 = zext nneg i8 %638 to i16, !dbg !866
  tail call void @llvm.dbg.value(metadata i16 %643, metadata !329, metadata !DIExpression()), !dbg !867
  br label %646, !dbg !875

644:                                              ; preds = %662
  %645 = icmp eq i16 %664, 0, !dbg !876
  br i1 %645, label %676, label %669, !dbg !877

646:                                              ; preds = %642, %662
  %647 = phi i32 [ %665, %662 ], [ 0, %642 ]
  %648 = phi i32 [ %663, %662 ], [ 0, %642 ]
  %649 = phi ptr [ %651, %662 ], [ %620, %642 ]
  %650 = phi i16 [ %664, %662 ], [ %643, %642 ]
  tail call void @llvm.dbg.value(metadata i32 %647, metadata !332, metadata !DIExpression()), !dbg !873
  tail call void @llvm.dbg.value(metadata i32 %648, metadata !331, metadata !DIExpression()), !dbg !867
  tail call void @llvm.dbg.value(metadata ptr %649, metadata !323, metadata !DIExpression()), !dbg !867
  tail call void @llvm.dbg.value(metadata i16 %650, metadata !329, metadata !DIExpression()), !dbg !867
  %651 = getelementptr inbounds i8, ptr %649, i64 2, !dbg !878
  %652 = icmp ugt ptr %651, %616, !dbg !879
  br i1 %652, label %662, label %653, !dbg !880

653:                                              ; preds = %646
  %654 = load i8, ptr %649, align 1, !dbg !881, !tbaa !262
  %655 = zext i8 %654 to i32, !dbg !882
  %656 = shl nuw nsw i32 %655, 8, !dbg !883
  %657 = getelementptr inbounds i8, ptr %649, i64 1, !dbg !884
  %658 = load i8, ptr %657, align 1, !dbg !885, !tbaa !262
  %659 = zext i8 %658 to i32, !dbg !886
  %660 = or disjoint i32 %656, %659, !dbg !887
  %661 = add i32 %660, %648, !dbg !888
  tail call void @llvm.dbg.value(metadata i32 %661, metadata !331, metadata !DIExpression()), !dbg !867
  br label %662, !dbg !889

662:                                              ; preds = %653, %646
  %663 = phi i32 [ %661, %653 ], [ %648, %646 ], !dbg !867
  tail call void @llvm.dbg.value(metadata i32 %663, metadata !331, metadata !DIExpression()), !dbg !867
  tail call void @llvm.dbg.value(metadata ptr %651, metadata !323, metadata !DIExpression()), !dbg !867
  %664 = add nsw i16 %650, -2, !dbg !890
  tail call void @llvm.dbg.value(metadata i16 %664, metadata !329, metadata !DIExpression()), !dbg !867
  %665 = add nuw nsw i32 %647, 2, !dbg !891
  tail call void @llvm.dbg.value(metadata i32 %665, metadata !332, metadata !DIExpression()), !dbg !873
  %666 = icmp ult i32 %647, 58, !dbg !892
  %667 = icmp ne i16 %664, 0, !dbg !874
  %668 = select i1 %666, i1 %667, i1 false, !dbg !874
  br i1 %668, label %646, label %644, !dbg !875, !llvm.loop !893

669:                                              ; preds = %644
  %670 = getelementptr inbounds i8, ptr %649, i64 3, !dbg !895
  %671 = icmp ugt ptr %670, %616, !dbg !896
  br i1 %671, label %693, label %672, !dbg !897

672:                                              ; preds = %669
  %673 = load i8, ptr %651, align 1, !dbg !898, !tbaa !262
  %674 = zext i8 %673 to i32, !dbg !899
  %675 = add i32 %663, %674, !dbg !900
  tail call void @llvm.dbg.value(metadata i32 %675, metadata !331, metadata !DIExpression()), !dbg !867
  br label %676, !dbg !901

676:                                              ; preds = %672, %644
  %677 = phi i32 [ %675, %672 ], [ %663, %644 ], !dbg !867
  tail call void @llvm.dbg.value(metadata i32 %677, metadata !331, metadata !DIExpression()), !dbg !867
  tail call void @llvm.dbg.value(metadata i32 0, metadata !334, metadata !DIExpression()), !dbg !867
  %678 = icmp ugt i32 %677, 65535, !dbg !902
  br i1 %678, label %679, label %689, !dbg !903

679:                                              ; preds = %676, %679
  %680 = phi i32 [ %685, %679 ], [ 0, %676 ]
  %681 = phi i32 [ %684, %679 ], [ %677, %676 ]
  tail call void @llvm.dbg.value(metadata i32 %680, metadata !334, metadata !DIExpression()), !dbg !867
  tail call void @llvm.dbg.value(metadata i32 %681, metadata !331, metadata !DIExpression()), !dbg !867
  %682 = lshr i32 %681, 16, !dbg !902
  %683 = and i32 %681, 65535, !dbg !904
  %684 = add nuw nsw i32 %683, %682, !dbg !905
  tail call void @llvm.dbg.value(metadata i32 %684, metadata !331, metadata !DIExpression()), !dbg !867
  %685 = add nuw nsw i32 %680, 1, !dbg !906
  tail call void @llvm.dbg.value(metadata i32 %685, metadata !334, metadata !DIExpression()), !dbg !867
  %686 = icmp ugt i32 %684, 65535, !dbg !902
  %687 = icmp ult i32 %680, 15, !dbg !907
  %688 = select i1 %686, i1 %687, i1 false, !dbg !907
  br i1 %688, label %679, label %689, !dbg !903, !llvm.loop !908

689:                                              ; preds = %679, %625, %676
  %690 = phi i32 [ %677, %676 ], [ 0, %625 ], [ %684, %679 ], !dbg !867
  %691 = trunc i32 %690 to i16, !dbg !910
  %692 = xor i16 %691, -1, !dbg !910
  tail call void @llvm.dbg.value(metadata i16 %692, metadata !335, metadata !DIExpression()), !dbg !867
  br label %693

693:                                              ; preds = %669, %689
  %694 = phi i16 [ %692, %689 ], [ 0, %669 ], !dbg !867
  %695 = call i16 @llvm.bswap.i16(i16 %694), !dbg !866
  store i16 %695, ptr %639, align 2, !dbg !911, !tbaa !390
  %696 = getelementptr inbounds %struct.lh_route, ptr %605, i64 0, i32 1, !dbg !912
  %697 = load i32, ptr %696, align 4, !dbg !912, !tbaa !394
  %698 = call i64 inttoptr (i64 13 to ptr)(ptr noundef %0, i32 noundef %697, i64 noundef 0) #5, !dbg !913
  br label %699, !dbg !914

699:                                              ; preds = %604, %610, %613, %693
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #5, !dbg !915
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6), !dbg !916
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8)
  call void @llvm.dbg.assign(metadata i1 undef, metadata !644, metadata !DIExpression(), metadata !187, metadata ptr %8, metadata !DIExpression()), !dbg !917
  call void @llvm.dbg.assign(metadata i1 undef, metadata !649, metadata !DIExpression(), metadata !188, metadata ptr %9, metadata !DIExpression()), !dbg !917
  store i32 3, ptr %8, align 4, !tbaa !286, !DIAssignID !919
  call void @llvm.dbg.assign(metadata i32 3, metadata !644, metadata !DIExpression(), metadata !919, metadata ptr %8, metadata !DIExpression()), !dbg !917
  call void @llvm.dbg.value(metadata ptr %0, metadata !647, metadata !DIExpression()), !dbg !917
  %700 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lh_map, ptr noundef nonnull %8) #5, !dbg !920
  call void @llvm.dbg.value(metadata ptr %700, metadata !648, metadata !DIExpression()), !dbg !917
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #5, !dbg !921
  store i32 0, ptr %9, align 4, !dbg !922, !tbaa !286, !DIAssignID !923
  call void @llvm.dbg.assign(metadata i32 0, metadata !649, metadata !DIExpression(), metadata !923, metadata ptr %9, metadata !DIExpression()), !dbg !917
  %701 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_lhaddr_map, ptr noundef nonnull %9) #5, !dbg !924
  call void @llvm.dbg.value(metadata ptr %701, metadata !650, metadata !DIExpression()), !dbg !917
  %702 = icmp ne ptr %700, null, !dbg !925
  %703 = icmp ne ptr %701, null
  %704 = select i1 %702, i1 %703, i1 false, !dbg !926
  br i1 %704, label %705, label %794, !dbg !926

705:                                              ; preds = %699
  %706 = load i32, ptr %700, align 4, !dbg !927, !tbaa !293
  %707 = icmp eq i32 %706, 0, !dbg !928
  br i1 %707, label %794, label %708, !dbg !929

708:                                              ; preds = %705
  %709 = load i32, ptr %14, align 8, !dbg !930, !tbaa !241
  %710 = zext i32 %709 to i64, !dbg !931
  %711 = inttoptr i64 %710 to ptr, !dbg !932
  call void @llvm.dbg.value(metadata ptr %711, metadata !651, metadata !DIExpression()), !dbg !933
  %712 = load i32, ptr %18, align 4, !dbg !934, !tbaa !250
  %713 = zext i32 %712 to i64, !dbg !935
  %714 = inttoptr i64 %713 to ptr, !dbg !936
  call void @llvm.dbg.value(metadata ptr %714, metadata !654, metadata !DIExpression()), !dbg !933
  call void @llvm.dbg.value(metadata ptr %714, metadata !655, metadata !DIExpression()), !dbg !933
  %715 = getelementptr inbounds %struct.ethhdr, ptr %714, i64 1, !dbg !937
  %716 = icmp ugt ptr %715, %711, !dbg !938
  call void @llvm.dbg.value(metadata ptr %715, metadata !656, metadata !DIExpression()), !dbg !939
  %717 = getelementptr inbounds %struct.ethhdr, ptr %714, i64 2, i32 1
  %718 = icmp ugt ptr %717, %711
  %719 = select i1 %716, i1 true, i1 %718, !dbg !940
  br i1 %719, label %794, label %720, !dbg !940

720:                                              ; preds = %708
  %721 = getelementptr inbounds %struct.ethhdr, ptr %714, i64 0, i32 1, !dbg !941
  %722 = getelementptr inbounds %struct.lh_route, ptr %700, i64 0, i32 4, !dbg !942
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %721, ptr noundef nonnull align 4 dereferenceable(6) %722, i64 6, i1 false), !dbg !943
  %723 = getelementptr inbounds %struct.lh_route, ptr %700, i64 0, i32 5, !dbg !944
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %714, ptr noundef nonnull align 2 dereferenceable(6) %723, i64 6, i1 false), !dbg !945
  %724 = getelementptr inbounds %struct.lh_route, ptr %700, i64 0, i32 3, !dbg !946
  %725 = load i32, ptr %724, align 4, !dbg !946, !tbaa !316
  %726 = call i32 @llvm.bswap.i32(i32 %725), !dbg !946
  %727 = getelementptr inbounds %struct.ethhdr, ptr %714, i64 1, i32 2, !dbg !947
  %728 = getelementptr inbounds %struct.ethhdr, ptr %714, i64 2, i32 0, i64 2, !dbg !947
  store i32 %726, ptr %728, align 4, !dbg !948, !tbaa !262
  %729 = load i32, ptr %701, align 4, !dbg !949, !tbaa !286
  %730 = call i32 @llvm.bswap.i32(i32 %729), !dbg !949
  store i32 %730, ptr %727, align 4, !dbg !950, !tbaa !262
  %731 = load i8, ptr %715, align 4, !dbg !951
  %732 = shl i8 %731, 2, !dbg !951
  %733 = and i8 %732, 60, !dbg !951
  tail call void @llvm.dbg.value(metadata ptr %715, metadata !323, metadata !DIExpression()), !dbg !952
  tail call void @llvm.dbg.value(metadata i8 %733, metadata !329, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !952
  tail call void @llvm.dbg.value(metadata ptr %711, metadata !330, metadata !DIExpression()), !dbg !952
  tail call void @llvm.dbg.value(metadata i32 0, metadata !331, metadata !DIExpression()), !dbg !952
  %734 = getelementptr inbounds %struct.ethhdr, ptr %714, i64 1, i32 1, i64 4, !dbg !954
  store i8 0, ptr %734, align 1, !dbg !955, !tbaa !262
  %735 = getelementptr inbounds %struct.ethhdr, ptr %714, i64 1, i32 1, i64 5, !dbg !956
  store i8 0, ptr %735, align 1, !dbg !957, !tbaa !262
  tail call void @llvm.dbg.value(metadata i32 0, metadata !332, metadata !DIExpression()), !dbg !958
  %736 = icmp eq i8 %733, 0, !dbg !959
  br i1 %736, label %784, label %737, !dbg !960

737:                                              ; preds = %720
  %738 = zext nneg i8 %733 to i16, !dbg !951
  tail call void @llvm.dbg.value(metadata i16 %738, metadata !329, metadata !DIExpression()), !dbg !952
  br label %741, !dbg !960

739:                                              ; preds = %757
  %740 = icmp eq i16 %759, 0, !dbg !961
  br i1 %740, label %771, label %764, !dbg !962

741:                                              ; preds = %737, %757
  %742 = phi i32 [ %760, %757 ], [ 0, %737 ]
  %743 = phi i32 [ %758, %757 ], [ 0, %737 ]
  %744 = phi ptr [ %746, %757 ], [ %715, %737 ]
  %745 = phi i16 [ %759, %757 ], [ %738, %737 ]
  tail call void @llvm.dbg.value(metadata i32 %742, metadata !332, metadata !DIExpression()), !dbg !958
  tail call void @llvm.dbg.value(metadata i32 %743, metadata !331, metadata !DIExpression()), !dbg !952
  tail call void @llvm.dbg.value(metadata ptr %744, metadata !323, metadata !DIExpression()), !dbg !952
  tail call void @llvm.dbg.value(metadata i16 %745, metadata !329, metadata !DIExpression()), !dbg !952
  %746 = getelementptr inbounds i8, ptr %744, i64 2, !dbg !963
  %747 = icmp ugt ptr %746, %711, !dbg !964
  br i1 %747, label %757, label %748, !dbg !965

748:                                              ; preds = %741
  %749 = load i8, ptr %744, align 1, !dbg !966, !tbaa !262
  %750 = zext i8 %749 to i32, !dbg !967
  %751 = shl nuw nsw i32 %750, 8, !dbg !968
  %752 = getelementptr inbounds i8, ptr %744, i64 1, !dbg !969
  %753 = load i8, ptr %752, align 1, !dbg !970, !tbaa !262
  %754 = zext i8 %753 to i32, !dbg !971
  %755 = or disjoint i32 %751, %754, !dbg !972
  %756 = add i32 %755, %743, !dbg !973
  tail call void @llvm.dbg.value(metadata i32 %756, metadata !331, metadata !DIExpression()), !dbg !952
  br label %757, !dbg !974

757:                                              ; preds = %748, %741
  %758 = phi i32 [ %756, %748 ], [ %743, %741 ], !dbg !952
  tail call void @llvm.dbg.value(metadata i32 %758, metadata !331, metadata !DIExpression()), !dbg !952
  tail call void @llvm.dbg.value(metadata ptr %746, metadata !323, metadata !DIExpression()), !dbg !952
  %759 = add nsw i16 %745, -2, !dbg !975
  tail call void @llvm.dbg.value(metadata i16 %759, metadata !329, metadata !DIExpression()), !dbg !952
  %760 = add nuw nsw i32 %742, 2, !dbg !976
  tail call void @llvm.dbg.value(metadata i32 %760, metadata !332, metadata !DIExpression()), !dbg !958
  %761 = icmp ult i32 %742, 58, !dbg !977
  %762 = icmp ne i16 %759, 0, !dbg !959
  %763 = select i1 %761, i1 %762, i1 false, !dbg !959
  br i1 %763, label %741, label %739, !dbg !960, !llvm.loop !978

764:                                              ; preds = %739
  %765 = getelementptr inbounds i8, ptr %744, i64 3, !dbg !980
  %766 = icmp ugt ptr %765, %711, !dbg !981
  br i1 %766, label %788, label %767, !dbg !982

767:                                              ; preds = %764
  %768 = load i8, ptr %746, align 1, !dbg !983, !tbaa !262
  %769 = zext i8 %768 to i32, !dbg !984
  %770 = add i32 %758, %769, !dbg !985
  tail call void @llvm.dbg.value(metadata i32 %770, metadata !331, metadata !DIExpression()), !dbg !952
  br label %771, !dbg !986

771:                                              ; preds = %767, %739
  %772 = phi i32 [ %770, %767 ], [ %758, %739 ], !dbg !952
  tail call void @llvm.dbg.value(metadata i32 %772, metadata !331, metadata !DIExpression()), !dbg !952
  tail call void @llvm.dbg.value(metadata i32 0, metadata !334, metadata !DIExpression()), !dbg !952
  %773 = icmp ugt i32 %772, 65535, !dbg !987
  br i1 %773, label %774, label %784, !dbg !988

774:                                              ; preds = %771, %774
  %775 = phi i32 [ %780, %774 ], [ 0, %771 ]
  %776 = phi i32 [ %779, %774 ], [ %772, %771 ]
  tail call void @llvm.dbg.value(metadata i32 %775, metadata !334, metadata !DIExpression()), !dbg !952
  tail call void @llvm.dbg.value(metadata i32 %776, metadata !331, metadata !DIExpression()), !dbg !952
  %777 = lshr i32 %776, 16, !dbg !987
  %778 = and i32 %776, 65535, !dbg !989
  %779 = add nuw nsw i32 %778, %777, !dbg !990
  tail call void @llvm.dbg.value(metadata i32 %779, metadata !331, metadata !DIExpression()), !dbg !952
  %780 = add nuw nsw i32 %775, 1, !dbg !991
  tail call void @llvm.dbg.value(metadata i32 %780, metadata !334, metadata !DIExpression()), !dbg !952
  %781 = icmp ugt i32 %779, 65535, !dbg !987
  %782 = icmp ult i32 %775, 15, !dbg !992
  %783 = select i1 %781, i1 %782, i1 false, !dbg !992
  br i1 %783, label %774, label %784, !dbg !988, !llvm.loop !993

784:                                              ; preds = %774, %720, %771
  %785 = phi i32 [ %772, %771 ], [ 0, %720 ], [ %779, %774 ], !dbg !952
  %786 = trunc i32 %785 to i16, !dbg !995
  %787 = xor i16 %786, -1, !dbg !995
  tail call void @llvm.dbg.value(metadata i16 %787, metadata !335, metadata !DIExpression()), !dbg !952
  br label %788

788:                                              ; preds = %764, %784
  %789 = phi i16 [ %787, %784 ], [ 0, %764 ], !dbg !952
  %790 = call i16 @llvm.bswap.i16(i16 %789), !dbg !951
  store i16 %790, ptr %734, align 2, !dbg !996, !tbaa !390
  %791 = getelementptr inbounds %struct.lh_route, ptr %700, i64 0, i32 1, !dbg !997
  %792 = load i32, ptr %791, align 4, !dbg !997, !tbaa !394
  %793 = call i64 inttoptr (i64 13 to ptr)(ptr noundef %0, i32 noundef %792, i64 noundef 0) #5, !dbg !998
  br label %794, !dbg !999

794:                                              ; preds = %699, %705, %708, %788
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #5, !dbg !1000
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8), !dbg !1001
  br label %795, !dbg !1002

795:                                              ; preds = %411, %27, %1, %794, %410
  %796 = phi i32 [ 2, %410 ], [ 2, %794 ], [ 0, %1 ], [ 0, %27 ], [ 0, %411 ]
  ret i32 %796, !dbg !1003
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.bswap.i32(i32) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.bswap.i16(i16) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.assign(metadata, metadata, metadata, metadata, metadata, metadata) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!169, !170, !171, !172, !173}
!llvm.ident = !{!174}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 244, type: !167, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !12, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "split_redirect_lh_ipv4_tc.c", directory: "/home/togoetha/projects/service/xdp-progs/multi-runtime-cni-ipv4", checksumkind: CSK_MD5, checksum: "5d1956f1db2028d48e48f30ce2098439")
!4 = !{!5, !6, !7, !10}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !8, line: 27, baseType: !9)
!8 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!9 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !8, line: 24, baseType: !11)
!11 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!12 = !{!0, !13, !44, !52, !60}
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "tc_lh_map", scope: !2, file: !3, line: 40, type: !15, isLocal: false, isDefinition: true)
!15 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 35, size: 256, elements: !16)
!16 = !{!17, !23, !28, !30}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !15, file: !3, line: 36, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 64, elements: !21)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !{!22}
!22 = !DISubrange(count: 2)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !15, file: !3, line: 37, baseType: !24, size: 64, offset: 64)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 256, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 8)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !15, file: !3, line: 38, baseType: !29, size: 64, offset: 128)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !15, file: !3, line: 39, baseType: !31, size: 64, offset: 192)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lh_route", file: !3, line: 26, size: 224, elements: !33)
!33 = !{!34, !35, !36, !37, !38, !43}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "active", scope: !32, file: !3, line: 27, baseType: !7, size: 32)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "targetifindex", scope: !32, file: !3, line: 28, baseType: !7, size: 32, offset: 32)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_saddr", scope: !32, file: !3, line: 29, baseType: !7, size: 32, offset: 64)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_daddr", scope: !32, file: !3, line: 30, baseType: !7, size: 32, offset: 96)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "smac", scope: !32, file: !3, line: 31, baseType: !39, size: 48, offset: 128)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 48, elements: !41)
!40 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!41 = !{!42}
!42 = !DISubrange(count: 6)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "dmac", scope: !32, file: !3, line: 32, baseType: !39, size: 48, offset: 176)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "tc_lhaddr_map", scope: !2, file: !3, line: 47, type: !46, isLocal: false, isDefinition: true)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 42, size: 256, elements: !47)
!47 = !{!48, !49, !50, !51}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !46, file: !3, line: 43, baseType: !18, size: 64)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !46, file: !3, line: 44, baseType: !24, size: 64, offset: 64)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !46, file: !3, line: 45, baseType: !29, size: 64, offset: 128)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !46, file: !3, line: 46, baseType: !29, size: 64, offset: 192)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!53 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !54, line: 56, type: !55, isLocal: true, isDefinition: true)
!54 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "09cfcd7169c24bec448f30582e8c6db9")
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DISubroutineType(types: !57)
!57 = !{!5, !5, !58}
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression(DW_OP_constu, 13, DW_OP_stack_value))
!61 = distinct !DIGlobalVariable(name: "bpf_clone_redirect", scope: !2, file: !54, line: 357, type: !62, isLocal: true, isDefinition: true)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DISubroutineType(types: !64)
!64 = !{!6, !65, !7, !138}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sk_buff", file: !67, line: 6111, size: 1536, elements: !68)
!67 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "8106ce79fb72e4cfc709095592a01f1d")
!68 = !{!69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !85, !86, !87, !88, !89, !90, !91, !92, !93, !97, !98, !99, !100, !101, !137, !140, !141, !142, !164, !165, !166}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !66, file: !67, line: 6112, baseType: !7, size: 32)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_type", scope: !66, file: !67, line: 6113, baseType: !7, size: 32, offset: 32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !66, file: !67, line: 6114, baseType: !7, size: 32, offset: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "queue_mapping", scope: !66, file: !67, line: 6115, baseType: !7, size: 32, offset: 96)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !66, file: !67, line: 6116, baseType: !7, size: 32, offset: 128)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_present", scope: !66, file: !67, line: 6117, baseType: !7, size: 32, offset: 160)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_tci", scope: !66, file: !67, line: 6118, baseType: !7, size: 32, offset: 192)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_proto", scope: !66, file: !67, line: 6119, baseType: !7, size: 32, offset: 224)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !66, file: !67, line: 6120, baseType: !7, size: 32, offset: 256)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !66, file: !67, line: 6121, baseType: !7, size: 32, offset: 288)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !66, file: !67, line: 6122, baseType: !7, size: 32, offset: 320)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "tc_index", scope: !66, file: !67, line: 6123, baseType: !7, size: 32, offset: 352)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "cb", scope: !66, file: !67, line: 6124, baseType: !82, size: 160, offset: 384)
!82 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 160, elements: !83)
!83 = !{!84}
!84 = !DISubrange(count: 5)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "hash", scope: !66, file: !67, line: 6125, baseType: !7, size: 32, offset: 544)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "tc_classid", scope: !66, file: !67, line: 6126, baseType: !7, size: 32, offset: 576)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !66, file: !67, line: 6127, baseType: !7, size: 32, offset: 608)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !66, file: !67, line: 6128, baseType: !7, size: 32, offset: 640)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "napi_id", scope: !66, file: !67, line: 6129, baseType: !7, size: 32, offset: 672)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !66, file: !67, line: 6132, baseType: !7, size: 32, offset: 704)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !66, file: !67, line: 6133, baseType: !7, size: 32, offset: 736)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !66, file: !67, line: 6134, baseType: !7, size: 32, offset: 768)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !66, file: !67, line: 6135, baseType: !94, size: 128, offset: 800)
!94 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 128, elements: !95)
!95 = !{!96}
!96 = !DISubrange(count: 4)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !66, file: !67, line: 6136, baseType: !94, size: 128, offset: 928)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !66, file: !67, line: 6137, baseType: !7, size: 32, offset: 1056)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !66, file: !67, line: 6138, baseType: !7, size: 32, offset: 1088)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !66, file: !67, line: 6141, baseType: !7, size: 32, offset: 1120)
!101 = !DIDerivedType(tag: DW_TAG_member, scope: !66, file: !67, line: 6142, baseType: !102, size: 64, align: 64, offset: 1152)
!102 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !66, file: !67, line: 6142, size: 64, align: 64, elements: !103)
!103 = !{!104}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "flow_keys", scope: !102, file: !67, line: 6142, baseType: !105, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_flow_keys", file: !67, line: 7128, size: 448, elements: !107)
!107 = !{!108, !109, !110, !111, !113, !114, !115, !116, !119, !120, !121, !135, !136}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "nhoff", scope: !106, file: !67, line: 7129, baseType: !10, size: 16)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "thoff", scope: !106, file: !67, line: 7130, baseType: !10, size: 16, offset: 16)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "addr_proto", scope: !106, file: !67, line: 7131, baseType: !10, size: 16, offset: 32)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "is_frag", scope: !106, file: !67, line: 7132, baseType: !112, size: 8, offset: 48)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !8, line: 21, baseType: !40)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "is_first_frag", scope: !106, file: !67, line: 7133, baseType: !112, size: 8, offset: 56)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "is_encap", scope: !106, file: !67, line: 7134, baseType: !112, size: 8, offset: 64)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !106, file: !67, line: 7135, baseType: !112, size: 8, offset: 72)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "n_proto", scope: !106, file: !67, line: 7136, baseType: !117, size: 16, offset: 80)
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !118, line: 32, baseType: !10)
!118 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "bf9fbc0e8f60927fef9d8917535375a6")
!119 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !106, file: !67, line: 7137, baseType: !117, size: 16, offset: 96)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !106, file: !67, line: 7138, baseType: !117, size: 16, offset: 112)
!121 = !DIDerivedType(tag: DW_TAG_member, scope: !106, file: !67, line: 7139, baseType: !122, size: 256, offset: 128)
!122 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !106, file: !67, line: 7139, size: 256, elements: !123)
!123 = !{!124, !130}
!124 = !DIDerivedType(tag: DW_TAG_member, scope: !122, file: !67, line: 7140, baseType: !125, size: 64)
!125 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !122, file: !67, line: 7140, size: 64, elements: !126)
!126 = !{!127, !129}
!127 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !125, file: !67, line: 7141, baseType: !128, size: 32)
!128 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !118, line: 34, baseType: !7)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !125, file: !67, line: 7142, baseType: !128, size: 32, offset: 32)
!130 = !DIDerivedType(tag: DW_TAG_member, scope: !122, file: !67, line: 7144, baseType: !131, size: 256)
!131 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !122, file: !67, line: 7144, size: 256, elements: !132)
!132 = !{!133, !134}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !131, file: !67, line: 7145, baseType: !94, size: 128)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !131, file: !67, line: 7146, baseType: !94, size: 128, offset: 128)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !106, file: !67, line: 7149, baseType: !7, size: 32, offset: 384)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "flow_label", scope: !106, file: !67, line: 7150, baseType: !128, size: 32, offset: 416)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp", scope: !66, file: !67, line: 6143, baseType: !138, size: 64, offset: 1216)
!138 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !8, line: 31, baseType: !139)
!139 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "wire_len", scope: !66, file: !67, line: 6144, baseType: !7, size: 32, offset: 1280)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "gso_segs", scope: !66, file: !67, line: 6145, baseType: !7, size: 32, offset: 1312)
!142 = !DIDerivedType(tag: DW_TAG_member, scope: !66, file: !67, line: 6146, baseType: !143, size: 64, align: 64, offset: 1344)
!143 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !66, file: !67, line: 6146, size: 64, align: 64, elements: !144)
!144 = !{!145}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "sk", scope: !143, file: !67, line: 6146, baseType: !146, size: 64)
!146 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64)
!147 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock", file: !67, line: 6215, size: 640, elements: !148)
!148 = !{!149, !150, !151, !152, !153, !154, !155, !156, !157, !158, !159, !160, !161, !162}
!149 = !DIDerivedType(tag: DW_TAG_member, name: "bound_dev_if", scope: !147, file: !67, line: 6216, baseType: !7, size: 32)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !147, file: !67, line: 6217, baseType: !7, size: 32, offset: 32)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !147, file: !67, line: 6218, baseType: !7, size: 32, offset: 64)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !147, file: !67, line: 6219, baseType: !7, size: 32, offset: 96)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !147, file: !67, line: 6220, baseType: !7, size: 32, offset: 128)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !147, file: !67, line: 6221, baseType: !7, size: 32, offset: 160)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip4", scope: !147, file: !67, line: 6223, baseType: !7, size: 32, offset: 192)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip6", scope: !147, file: !67, line: 6224, baseType: !94, size: 128, offset: 224)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !147, file: !67, line: 6225, baseType: !7, size: 32, offset: 352)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !147, file: !67, line: 6226, baseType: !117, size: 16, offset: 384)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip4", scope: !147, file: !67, line: 6228, baseType: !7, size: 32, offset: 416)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip6", scope: !147, file: !67, line: 6229, baseType: !94, size: 128, offset: 448)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !147, file: !67, line: 6230, baseType: !7, size: 32, offset: 576)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_mapping", scope: !147, file: !67, line: 6231, baseType: !163, size: 32, offset: 608)
!163 = !DIDerivedType(tag: DW_TAG_typedef, name: "__s32", file: !8, line: 26, baseType: !20)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "gso_size", scope: !66, file: !67, line: 6147, baseType: !7, size: 32, offset: 1408)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp_type", scope: !66, file: !67, line: 6148, baseType: !112, size: 8, offset: 1440)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "hwtstamp", scope: !66, file: !67, line: 6150, baseType: !138, size: 64, offset: 1472)
!167 = !DICompositeType(tag: DW_TAG_array_type, baseType: !168, size: 32, elements: !95)
!168 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!169 = !{i32 7, !"Dwarf Version", i32 5}
!170 = !{i32 2, !"Debug Info Version", i32 3}
!171 = !{i32 1, !"wchar_size", i32 4}
!172 = !{i32 7, !"frame-pointer", i32 2}
!173 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!174 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!175 = distinct !DISubprogram(name: "tc_lh2split", scope: !3, file: !3, line: 233, type: !176, scopeLine: 233, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !178)
!176 = !DISubroutineType(types: !177)
!177 = !{!20, !65}
!178 = !{!179, !180}
!179 = !DILocalVariable(name: "skb", arg: 1, scope: !175, file: !3, line: 233, type: !65)
!180 = !DILocalVariable(name: "handled", scope: !175, file: !3, line: 236, type: !20)
!181 = distinct !DIAssignID()
!182 = distinct !DIAssignID()
!183 = distinct !DIAssignID()
!184 = distinct !DIAssignID()
!185 = distinct !DIAssignID()
!186 = distinct !DIAssignID()
!187 = distinct !DIAssignID()
!188 = distinct !DIAssignID()
!189 = distinct !DIAssignID()
!190 = distinct !DIAssignID()
!191 = distinct !DIAssignID()
!192 = distinct !DIAssignID()
!193 = !DILocation(line: 0, scope: !175)
!194 = !DILocalVariable(name: "skb", arg: 1, scope: !195, file: !3, line: 161, type: !65)
!195 = distinct !DISubprogram(name: "ipv4_lh_handle", scope: !3, file: !3, line: 161, type: !176, scopeLine: 161, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !196)
!196 = !{!194, !197, !198, !199, !207, !235, !236, !237}
!197 = !DILocalVariable(name: "data_end", scope: !195, file: !3, line: 162, type: !5)
!198 = !DILocalVariable(name: "data", scope: !195, file: !3, line: 163, type: !5)
!199 = !DILocalVariable(name: "ethh", scope: !195, file: !3, line: 166, type: !200)
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !201, size: 64)
!201 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !202, line: 173, size: 112, elements: !203)
!202 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!203 = !{!204, !205, !206}
!204 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !201, file: !202, line: 174, baseType: !39, size: 48)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !201, file: !202, line: 175, baseType: !39, size: 48, offset: 48)
!206 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !201, file: !202, line: 176, baseType: !117, size: 16, offset: 96)
!207 = !DILocalVariable(name: "ip4h", scope: !195, file: !3, line: 172, type: !208)
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !209, size: 64)
!209 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !210, line: 87, size: 160, elements: !211)
!210 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!211 = !{!212, !213, !214, !215, !216, !217, !218, !219, !220, !222}
!212 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !209, file: !210, line: 89, baseType: !112, size: 4, flags: DIFlagBitField, extraData: i64 0)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !209, file: !210, line: 90, baseType: !112, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !209, file: !210, line: 97, baseType: !112, size: 8, offset: 8)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !209, file: !210, line: 98, baseType: !117, size: 16, offset: 16)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !209, file: !210, line: 99, baseType: !117, size: 16, offset: 32)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !209, file: !210, line: 100, baseType: !117, size: 16, offset: 48)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !209, file: !210, line: 101, baseType: !112, size: 8, offset: 64)
!219 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !209, file: !210, line: 102, baseType: !112, size: 8, offset: 72)
!220 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !209, file: !210, line: 103, baseType: !221, size: 16, offset: 80)
!221 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !118, line: 38, baseType: !10)
!222 = !DIDerivedType(tag: DW_TAG_member, scope: !209, file: !210, line: 104, baseType: !223, size: 64, offset: 96)
!223 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !209, file: !210, line: 104, size: 64, elements: !224)
!224 = !{!225, !230}
!225 = !DIDerivedType(tag: DW_TAG_member, scope: !223, file: !210, line: 104, baseType: !226, size: 64)
!226 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !223, file: !210, line: 104, size: 64, elements: !227)
!227 = !{!228, !229}
!228 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !226, file: !210, line: 104, baseType: !128, size: 32)
!229 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !226, file: !210, line: 104, baseType: !128, size: 32, offset: 32)
!230 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !223, file: !210, line: 104, baseType: !231, size: 64)
!231 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !223, file: !210, line: 104, size: 64, elements: !232)
!232 = !{!233, !234}
!233 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !231, file: !210, line: 104, baseType: !128, size: 32)
!234 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !231, file: !210, line: 104, baseType: !128, size: 32, offset: 32)
!235 = !DILocalVariable(name: "ip_dst_addr", scope: !195, file: !3, line: 186, type: !7)
!236 = !DILocalVariable(name: "lhaddr", scope: !195, file: !3, line: 188, type: !7)
!237 = !DILocalVariable(name: "snet", scope: !195, file: !3, line: 189, type: !7)
!238 = !DILocation(line: 0, scope: !195, inlinedAt: !239)
!239 = distinct !DILocation(line: 236, column: 16, scope: !175)
!240 = !DILocation(line: 162, column: 38, scope: !195, inlinedAt: !239)
!241 = !{!242, !243, i64 80}
!242 = !{!"__sk_buff", !243, i64 0, !243, i64 4, !243, i64 8, !243, i64 12, !243, i64 16, !243, i64 20, !243, i64 24, !243, i64 28, !243, i64 32, !243, i64 36, !243, i64 40, !243, i64 44, !244, i64 48, !243, i64 68, !243, i64 72, !243, i64 76, !243, i64 80, !243, i64 84, !243, i64 88, !243, i64 92, !243, i64 96, !244, i64 100, !244, i64 116, !243, i64 132, !243, i64 136, !243, i64 140, !244, i64 144, !246, i64 152, !243, i64 160, !243, i64 164, !244, i64 168, !243, i64 176, !244, i64 180, !246, i64 184}
!243 = !{!"int", !244, i64 0}
!244 = !{!"omnipotent char", !245, i64 0}
!245 = !{!"Simple C/C++ TBAA"}
!246 = !{!"long long", !244, i64 0}
!247 = !DILocation(line: 162, column: 27, scope: !195, inlinedAt: !239)
!248 = !DILocation(line: 162, column: 19, scope: !195, inlinedAt: !239)
!249 = !DILocation(line: 163, column: 34, scope: !195, inlinedAt: !239)
!250 = !{!242, !243, i64 76}
!251 = !DILocation(line: 163, column: 23, scope: !195, inlinedAt: !239)
!252 = !DILocation(line: 163, column: 15, scope: !195, inlinedAt: !239)
!253 = !DILocation(line: 167, column: 20, scope: !254, inlinedAt: !239)
!254 = distinct !DILexicalBlock(scope: !195, file: !3, line: 167, column: 6)
!255 = !DILocation(line: 167, column: 25, scope: !254, inlinedAt: !239)
!256 = !DILocation(line: 167, column: 6, scope: !195, inlinedAt: !239)
!257 = !DILocation(line: 180, column: 12, scope: !258, inlinedAt: !239)
!258 = distinct !DILexicalBlock(scope: !195, file: !3, line: 180, column: 6)
!259 = !DILocation(line: 180, column: 20, scope: !258, inlinedAt: !239)
!260 = !DILocation(line: 180, column: 6, scope: !195, inlinedAt: !239)
!261 = !DILocation(line: 186, column: 28, scope: !195, inlinedAt: !239)
!262 = !{!244, !244, i64 0}
!263 = !DILocation(line: 188, column: 23, scope: !195, inlinedAt: !239)
!264 = !DILocation(line: 188, column: 29, scope: !195, inlinedAt: !239)
!265 = !DILocation(line: 204, column: 18, scope: !266, inlinedAt: !239)
!266 = distinct !DILexicalBlock(scope: !195, file: !3, line: 204, column: 6)
!267 = !DILocation(line: 204, column: 6, scope: !195, inlinedAt: !239)
!268 = !DILocalVariable(name: "i", arg: 1, scope: !269, file: !3, line: 85, type: !7)
!269 = distinct !DISubprogram(name: "clone_redir_forward", scope: !3, file: !3, line: 85, type: !270, scopeLine: 85, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !272)
!270 = !DISubroutineType(types: !271)
!271 = !{!20, !7, !65}
!272 = !{!268, !273, !274, !275, !278, !279, !280}
!273 = !DILocalVariable(name: "skb", arg: 2, scope: !269, file: !3, line: 85, type: !65)
!274 = !DILocalVariable(name: "lhinfo", scope: !269, file: !3, line: 87, type: !31)
!275 = !DILocalVariable(name: "data_end", scope: !276, file: !3, line: 99, type: !5)
!276 = distinct !DILexicalBlock(scope: !277, file: !3, line: 95, column: 37)
!277 = distinct !DILexicalBlock(scope: !269, file: !3, line: 95, column: 6)
!278 = !DILocalVariable(name: "data", scope: !276, file: !3, line: 100, type: !5)
!279 = !DILocalVariable(name: "ethh", scope: !276, file: !3, line: 103, type: !200)
!280 = !DILocalVariable(name: "iph", scope: !281, file: !3, line: 106, type: !208)
!281 = distinct !DILexicalBlock(scope: !282, file: !3, line: 104, column: 39)
!282 = distinct !DILexicalBlock(scope: !276, file: !3, line: 104, column: 7)
!283 = !DILocation(line: 0, scope: !269, inlinedAt: !284)
!284 = distinct !DILocation(line: 205, column: 3, scope: !285, inlinedAt: !239)
!285 = distinct !DILexicalBlock(scope: !266, file: !3, line: 204, column: 29)
!286 = !{!243, !243, i64 0}
!287 = distinct !DIAssignID()
!288 = !DILocation(line: 88, column: 11, scope: !269, inlinedAt: !284)
!289 = !DILocation(line: 90, column: 13, scope: !290, inlinedAt: !284)
!290 = distinct !DILexicalBlock(scope: !269, file: !3, line: 90, column: 6)
!291 = !DILocation(line: 90, column: 6, scope: !269, inlinedAt: !284)
!292 = !DILocation(line: 95, column: 29, scope: !277, inlinedAt: !284)
!293 = !{!294, !243, i64 0}
!294 = !{!"lh_route", !243, i64 0, !243, i64 4, !243, i64 8, !243, i64 12, !244, i64 16, !244, i64 22}
!295 = !DILocation(line: 95, column: 21, scope: !277, inlinedAt: !284)
!296 = !DILocation(line: 95, column: 6, scope: !269, inlinedAt: !284)
!297 = !DILocation(line: 99, column: 39, scope: !276, inlinedAt: !284)
!298 = !DILocation(line: 99, column: 28, scope: !276, inlinedAt: !284)
!299 = !DILocation(line: 99, column: 20, scope: !276, inlinedAt: !284)
!300 = !DILocation(line: 0, scope: !276, inlinedAt: !284)
!301 = !DILocation(line: 100, column: 39, scope: !276, inlinedAt: !284)
!302 = !DILocation(line: 100, column: 28, scope: !276, inlinedAt: !284)
!303 = !DILocation(line: 100, column: 20, scope: !276, inlinedAt: !284)
!304 = !DILocation(line: 104, column: 21, scope: !282, inlinedAt: !284)
!305 = !DILocation(line: 104, column: 26, scope: !282, inlinedAt: !284)
!306 = !DILocation(line: 0, scope: !281, inlinedAt: !284)
!307 = !DILocation(line: 104, column: 7, scope: !276, inlinedAt: !284)
!308 = !DILocation(line: 111, column: 28, scope: !309, inlinedAt: !284)
!309 = distinct !DILexicalBlock(scope: !310, file: !3, line: 108, column: 39)
!310 = distinct !DILexicalBlock(scope: !281, file: !3, line: 108, column: 8)
!311 = !DILocation(line: 111, column: 46, scope: !309, inlinedAt: !284)
!312 = !DILocation(line: 111, column: 5, scope: !309, inlinedAt: !284)
!313 = !DILocation(line: 112, column: 44, scope: !309, inlinedAt: !284)
!314 = !DILocation(line: 112, column: 5, scope: !309, inlinedAt: !284)
!315 = !DILocation(line: 113, column: 18, scope: !309, inlinedAt: !284)
!316 = !{!294, !243, i64 12}
!317 = !DILocation(line: 113, column: 10, scope: !309, inlinedAt: !284)
!318 = !DILocation(line: 113, column: 16, scope: !309, inlinedAt: !284)
!319 = !DILocation(line: 114, column: 18, scope: !309, inlinedAt: !284)
!320 = !{!294, !243, i64 8}
!321 = !DILocation(line: 114, column: 16, scope: !309, inlinedAt: !284)
!322 = !DILocation(line: 115, column: 18, scope: !309, inlinedAt: !284)
!323 = !DILocalVariable(name: "packet", arg: 1, scope: !324, file: !3, line: 50, type: !327)
!324 = distinct !DISubprogram(name: "ipv4_check", scope: !3, file: !3, line: 50, type: !325, scopeLine: 50, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !328)
!325 = !DISubroutineType(types: !326)
!326 = !{!10, !327, !10, !5}
!327 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!328 = !{!323, !329, !330, !331, !332, !334, !335}
!329 = !DILocalVariable(name: "len", arg: 2, scope: !324, file: !3, line: 50, type: !10)
!330 = !DILocalVariable(name: "data_end", arg: 3, scope: !324, file: !3, line: 50, type: !5)
!331 = !DILocalVariable(name: "csum", scope: !324, file: !3, line: 51, type: !7)
!332 = !DILocalVariable(name: "i", scope: !333, file: !3, line: 58, type: !20)
!333 = distinct !DILexicalBlock(scope: !324, file: !3, line: 58, column: 5)
!334 = !DILocalVariable(name: "i", scope: !324, file: !3, line: 73, type: !20)
!335 = !DILocalVariable(name: "checksum", scope: !324, file: !3, line: 81, type: !10)
!336 = !DILocation(line: 0, scope: !324, inlinedAt: !337)
!337 = distinct !DILocation(line: 115, column: 18, scope: !309, inlinedAt: !284)
!338 = !DILocation(line: 54, column: 11, scope: !324, inlinedAt: !337)
!339 = !DILocation(line: 54, column: 17, scope: !324, inlinedAt: !337)
!340 = !DILocation(line: 55, column: 11, scope: !324, inlinedAt: !337)
!341 = !DILocation(line: 55, column: 17, scope: !324, inlinedAt: !337)
!342 = !DILocation(line: 0, scope: !333, inlinedAt: !337)
!343 = !DILocation(line: 58, column: 28, scope: !344, inlinedAt: !337)
!344 = distinct !DILexicalBlock(scope: !333, file: !3, line: 58, column: 5)
!345 = !DILocation(line: 58, column: 5, scope: !333, inlinedAt: !337)
!346 = !DILocation(line: 66, column: 10, scope: !347, inlinedAt: !337)
!347 = distinct !DILexicalBlock(scope: !324, file: !3, line: 66, column: 6)
!348 = !DILocation(line: 66, column: 6, scope: !324, inlinedAt: !337)
!349 = !DILocation(line: 59, column: 22, scope: !350, inlinedAt: !337)
!350 = distinct !DILexicalBlock(scope: !351, file: !3, line: 59, column: 7)
!351 = distinct !DILexicalBlock(scope: !344, file: !3, line: 58, column: 46)
!352 = !DILocation(line: 59, column: 27, scope: !350, inlinedAt: !337)
!353 = !DILocation(line: 59, column: 7, scope: !351, inlinedAt: !337)
!354 = !DILocation(line: 60, column: 13, scope: !355, inlinedAt: !337)
!355 = distinct !DILexicalBlock(scope: !350, file: !3, line: 59, column: 40)
!356 = !DILocation(line: 60, column: 12, scope: !355, inlinedAt: !337)
!357 = !DILocation(line: 60, column: 22, scope: !355, inlinedAt: !337)
!358 = !DILocation(line: 60, column: 39, scope: !355, inlinedAt: !337)
!359 = !DILocation(line: 60, column: 31, scope: !355, inlinedAt: !337)
!360 = !DILocation(line: 60, column: 30, scope: !355, inlinedAt: !337)
!361 = !DILocation(line: 60, column: 28, scope: !355, inlinedAt: !337)
!362 = !DILocation(line: 60, column: 9, scope: !355, inlinedAt: !337)
!363 = !DILocation(line: 61, column: 3, scope: !355, inlinedAt: !337)
!364 = !DILocation(line: 64, column: 7, scope: !351, inlinedAt: !337)
!365 = !DILocation(line: 58, column: 41, scope: !344, inlinedAt: !337)
!366 = !DILocation(line: 58, column: 23, scope: !344, inlinedAt: !337)
!367 = distinct !{!367, !345, !368, !369}
!368 = !DILocation(line: 65, column: 5, scope: !333, inlinedAt: !337)
!369 = !{!"llvm.loop.mustprogress"}
!370 = !DILocation(line: 67, column: 22, scope: !371, inlinedAt: !337)
!371 = distinct !DILexicalBlock(scope: !372, file: !3, line: 67, column: 7)
!372 = distinct !DILexicalBlock(scope: !347, file: !3, line: 66, column: 15)
!373 = !DILocation(line: 67, column: 27, scope: !371, inlinedAt: !337)
!374 = !DILocation(line: 67, column: 7, scope: !372, inlinedAt: !337)
!375 = !DILocation(line: 70, column: 12, scope: !372, inlinedAt: !337)
!376 = !DILocation(line: 70, column: 11, scope: !372, inlinedAt: !337)
!377 = !DILocation(line: 70, column: 8, scope: !372, inlinedAt: !337)
!378 = !DILocation(line: 71, column: 2, scope: !372, inlinedAt: !337)
!379 = !DILocation(line: 74, column: 17, scope: !324, inlinedAt: !337)
!380 = !DILocation(line: 74, column: 5, scope: !324, inlinedAt: !337)
!381 = !DILocation(line: 75, column: 22, scope: !382, inlinedAt: !337)
!382 = distinct !DILexicalBlock(scope: !324, file: !3, line: 74, column: 34)
!383 = !DILocation(line: 75, column: 32, scope: !382, inlinedAt: !337)
!384 = !DILocation(line: 76, column: 4, scope: !382, inlinedAt: !337)
!385 = !DILocation(line: 74, column: 23, scope: !324, inlinedAt: !337)
!386 = distinct !{!386, !380, !387, !369}
!387 = !DILocation(line: 77, column: 2, scope: !324, inlinedAt: !337)
!388 = !DILocation(line: 81, column: 22, scope: !324, inlinedAt: !337)
!389 = !DILocation(line: 115, column: 16, scope: !309, inlinedAt: !284)
!390 = !{!391, !392, i64 10}
!391 = !{!"iphdr", !244, i64 0, !244, i64 0, !244, i64 1, !392, i64 2, !392, i64 4, !392, i64 6, !244, i64 8, !244, i64 9, !392, i64 10, !244, i64 12}
!392 = !{!"short", !244, i64 0}
!393 = !DILocation(line: 117, column: 37, scope: !309, inlinedAt: !284)
!394 = !{!294, !243, i64 4}
!395 = !DILocation(line: 117, column: 5, scope: !309, inlinedAt: !284)
!396 = !DILocation(line: 118, column: 4, scope: !309, inlinedAt: !284)
!397 = !DILocation(line: 122, column: 1, scope: !269, inlinedAt: !284)
!398 = !DILocation(line: 0, scope: !269, inlinedAt: !399)
!399 = distinct !DILocation(line: 206, column: 3, scope: !285, inlinedAt: !239)
!400 = distinct !DIAssignID()
!401 = !DILocation(line: 88, column: 11, scope: !269, inlinedAt: !399)
!402 = !DILocation(line: 90, column: 13, scope: !290, inlinedAt: !399)
!403 = !DILocation(line: 90, column: 6, scope: !269, inlinedAt: !399)
!404 = !DILocation(line: 95, column: 29, scope: !277, inlinedAt: !399)
!405 = !DILocation(line: 95, column: 21, scope: !277, inlinedAt: !399)
!406 = !DILocation(line: 95, column: 6, scope: !269, inlinedAt: !399)
!407 = !DILocation(line: 99, column: 39, scope: !276, inlinedAt: !399)
!408 = !DILocation(line: 99, column: 28, scope: !276, inlinedAt: !399)
!409 = !DILocation(line: 99, column: 20, scope: !276, inlinedAt: !399)
!410 = !DILocation(line: 0, scope: !276, inlinedAt: !399)
!411 = !DILocation(line: 100, column: 39, scope: !276, inlinedAt: !399)
!412 = !DILocation(line: 100, column: 28, scope: !276, inlinedAt: !399)
!413 = !DILocation(line: 100, column: 20, scope: !276, inlinedAt: !399)
!414 = !DILocation(line: 104, column: 21, scope: !282, inlinedAt: !399)
!415 = !DILocation(line: 104, column: 26, scope: !282, inlinedAt: !399)
!416 = !DILocation(line: 0, scope: !281, inlinedAt: !399)
!417 = !DILocation(line: 104, column: 7, scope: !276, inlinedAt: !399)
!418 = !DILocation(line: 111, column: 28, scope: !309, inlinedAt: !399)
!419 = !DILocation(line: 111, column: 46, scope: !309, inlinedAt: !399)
!420 = !DILocation(line: 111, column: 5, scope: !309, inlinedAt: !399)
!421 = !DILocation(line: 112, column: 44, scope: !309, inlinedAt: !399)
!422 = !DILocation(line: 112, column: 5, scope: !309, inlinedAt: !399)
!423 = !DILocation(line: 113, column: 18, scope: !309, inlinedAt: !399)
!424 = !DILocation(line: 113, column: 10, scope: !309, inlinedAt: !399)
!425 = !DILocation(line: 113, column: 16, scope: !309, inlinedAt: !399)
!426 = !DILocation(line: 114, column: 18, scope: !309, inlinedAt: !399)
!427 = !DILocation(line: 114, column: 16, scope: !309, inlinedAt: !399)
!428 = !DILocation(line: 115, column: 18, scope: !309, inlinedAt: !399)
!429 = !DILocation(line: 0, scope: !324, inlinedAt: !430)
!430 = distinct !DILocation(line: 115, column: 18, scope: !309, inlinedAt: !399)
!431 = !DILocation(line: 54, column: 11, scope: !324, inlinedAt: !430)
!432 = !DILocation(line: 54, column: 17, scope: !324, inlinedAt: !430)
!433 = !DILocation(line: 55, column: 11, scope: !324, inlinedAt: !430)
!434 = !DILocation(line: 55, column: 17, scope: !324, inlinedAt: !430)
!435 = !DILocation(line: 0, scope: !333, inlinedAt: !430)
!436 = !DILocation(line: 58, column: 28, scope: !344, inlinedAt: !430)
!437 = !DILocation(line: 58, column: 5, scope: !333, inlinedAt: !430)
!438 = !DILocation(line: 66, column: 10, scope: !347, inlinedAt: !430)
!439 = !DILocation(line: 66, column: 6, scope: !324, inlinedAt: !430)
!440 = !DILocation(line: 59, column: 22, scope: !350, inlinedAt: !430)
!441 = !DILocation(line: 59, column: 27, scope: !350, inlinedAt: !430)
!442 = !DILocation(line: 59, column: 7, scope: !351, inlinedAt: !430)
!443 = !DILocation(line: 60, column: 13, scope: !355, inlinedAt: !430)
!444 = !DILocation(line: 60, column: 12, scope: !355, inlinedAt: !430)
!445 = !DILocation(line: 60, column: 22, scope: !355, inlinedAt: !430)
!446 = !DILocation(line: 60, column: 39, scope: !355, inlinedAt: !430)
!447 = !DILocation(line: 60, column: 31, scope: !355, inlinedAt: !430)
!448 = !DILocation(line: 60, column: 30, scope: !355, inlinedAt: !430)
!449 = !DILocation(line: 60, column: 28, scope: !355, inlinedAt: !430)
!450 = !DILocation(line: 60, column: 9, scope: !355, inlinedAt: !430)
!451 = !DILocation(line: 61, column: 3, scope: !355, inlinedAt: !430)
!452 = !DILocation(line: 64, column: 7, scope: !351, inlinedAt: !430)
!453 = !DILocation(line: 58, column: 41, scope: !344, inlinedAt: !430)
!454 = !DILocation(line: 58, column: 23, scope: !344, inlinedAt: !430)
!455 = distinct !{!455, !437, !456, !369}
!456 = !DILocation(line: 65, column: 5, scope: !333, inlinedAt: !430)
!457 = !DILocation(line: 67, column: 22, scope: !371, inlinedAt: !430)
!458 = !DILocation(line: 67, column: 27, scope: !371, inlinedAt: !430)
!459 = !DILocation(line: 67, column: 7, scope: !372, inlinedAt: !430)
!460 = !DILocation(line: 70, column: 12, scope: !372, inlinedAt: !430)
!461 = !DILocation(line: 70, column: 11, scope: !372, inlinedAt: !430)
!462 = !DILocation(line: 70, column: 8, scope: !372, inlinedAt: !430)
!463 = !DILocation(line: 71, column: 2, scope: !372, inlinedAt: !430)
!464 = !DILocation(line: 74, column: 17, scope: !324, inlinedAt: !430)
!465 = !DILocation(line: 74, column: 5, scope: !324, inlinedAt: !430)
!466 = !DILocation(line: 75, column: 22, scope: !382, inlinedAt: !430)
!467 = !DILocation(line: 75, column: 32, scope: !382, inlinedAt: !430)
!468 = !DILocation(line: 76, column: 4, scope: !382, inlinedAt: !430)
!469 = !DILocation(line: 74, column: 23, scope: !324, inlinedAt: !430)
!470 = distinct !{!470, !465, !471, !369}
!471 = !DILocation(line: 77, column: 2, scope: !324, inlinedAt: !430)
!472 = !DILocation(line: 81, column: 22, scope: !324, inlinedAt: !430)
!473 = !DILocation(line: 115, column: 16, scope: !309, inlinedAt: !399)
!474 = !DILocation(line: 117, column: 37, scope: !309, inlinedAt: !399)
!475 = !DILocation(line: 117, column: 5, scope: !309, inlinedAt: !399)
!476 = !DILocation(line: 118, column: 4, scope: !309, inlinedAt: !399)
!477 = !DILocation(line: 122, column: 1, scope: !269, inlinedAt: !399)
!478 = !DILocation(line: 0, scope: !269, inlinedAt: !479)
!479 = distinct !DILocation(line: 207, column: 3, scope: !285, inlinedAt: !239)
!480 = distinct !DIAssignID()
!481 = !DILocation(line: 88, column: 11, scope: !269, inlinedAt: !479)
!482 = !DILocation(line: 90, column: 13, scope: !290, inlinedAt: !479)
!483 = !DILocation(line: 90, column: 6, scope: !269, inlinedAt: !479)
!484 = !DILocation(line: 95, column: 29, scope: !277, inlinedAt: !479)
!485 = !DILocation(line: 95, column: 21, scope: !277, inlinedAt: !479)
!486 = !DILocation(line: 95, column: 6, scope: !269, inlinedAt: !479)
!487 = !DILocation(line: 99, column: 39, scope: !276, inlinedAt: !479)
!488 = !DILocation(line: 99, column: 28, scope: !276, inlinedAt: !479)
!489 = !DILocation(line: 99, column: 20, scope: !276, inlinedAt: !479)
!490 = !DILocation(line: 0, scope: !276, inlinedAt: !479)
!491 = !DILocation(line: 100, column: 39, scope: !276, inlinedAt: !479)
!492 = !DILocation(line: 100, column: 28, scope: !276, inlinedAt: !479)
!493 = !DILocation(line: 100, column: 20, scope: !276, inlinedAt: !479)
!494 = !DILocation(line: 104, column: 21, scope: !282, inlinedAt: !479)
!495 = !DILocation(line: 104, column: 26, scope: !282, inlinedAt: !479)
!496 = !DILocation(line: 0, scope: !281, inlinedAt: !479)
!497 = !DILocation(line: 104, column: 7, scope: !276, inlinedAt: !479)
!498 = !DILocation(line: 111, column: 28, scope: !309, inlinedAt: !479)
!499 = !DILocation(line: 111, column: 46, scope: !309, inlinedAt: !479)
!500 = !DILocation(line: 111, column: 5, scope: !309, inlinedAt: !479)
!501 = !DILocation(line: 112, column: 44, scope: !309, inlinedAt: !479)
!502 = !DILocation(line: 112, column: 5, scope: !309, inlinedAt: !479)
!503 = !DILocation(line: 113, column: 18, scope: !309, inlinedAt: !479)
!504 = !DILocation(line: 113, column: 10, scope: !309, inlinedAt: !479)
!505 = !DILocation(line: 113, column: 16, scope: !309, inlinedAt: !479)
!506 = !DILocation(line: 114, column: 18, scope: !309, inlinedAt: !479)
!507 = !DILocation(line: 114, column: 16, scope: !309, inlinedAt: !479)
!508 = !DILocation(line: 115, column: 18, scope: !309, inlinedAt: !479)
!509 = !DILocation(line: 0, scope: !324, inlinedAt: !510)
!510 = distinct !DILocation(line: 115, column: 18, scope: !309, inlinedAt: !479)
!511 = !DILocation(line: 54, column: 11, scope: !324, inlinedAt: !510)
!512 = !DILocation(line: 54, column: 17, scope: !324, inlinedAt: !510)
!513 = !DILocation(line: 55, column: 11, scope: !324, inlinedAt: !510)
!514 = !DILocation(line: 55, column: 17, scope: !324, inlinedAt: !510)
!515 = !DILocation(line: 0, scope: !333, inlinedAt: !510)
!516 = !DILocation(line: 58, column: 28, scope: !344, inlinedAt: !510)
!517 = !DILocation(line: 58, column: 5, scope: !333, inlinedAt: !510)
!518 = !DILocation(line: 66, column: 10, scope: !347, inlinedAt: !510)
!519 = !DILocation(line: 66, column: 6, scope: !324, inlinedAt: !510)
!520 = !DILocation(line: 59, column: 22, scope: !350, inlinedAt: !510)
!521 = !DILocation(line: 59, column: 27, scope: !350, inlinedAt: !510)
!522 = !DILocation(line: 59, column: 7, scope: !351, inlinedAt: !510)
!523 = !DILocation(line: 60, column: 13, scope: !355, inlinedAt: !510)
!524 = !DILocation(line: 60, column: 12, scope: !355, inlinedAt: !510)
!525 = !DILocation(line: 60, column: 22, scope: !355, inlinedAt: !510)
!526 = !DILocation(line: 60, column: 39, scope: !355, inlinedAt: !510)
!527 = !DILocation(line: 60, column: 31, scope: !355, inlinedAt: !510)
!528 = !DILocation(line: 60, column: 30, scope: !355, inlinedAt: !510)
!529 = !DILocation(line: 60, column: 28, scope: !355, inlinedAt: !510)
!530 = !DILocation(line: 60, column: 9, scope: !355, inlinedAt: !510)
!531 = !DILocation(line: 61, column: 3, scope: !355, inlinedAt: !510)
!532 = !DILocation(line: 64, column: 7, scope: !351, inlinedAt: !510)
!533 = !DILocation(line: 58, column: 41, scope: !344, inlinedAt: !510)
!534 = !DILocation(line: 58, column: 23, scope: !344, inlinedAt: !510)
!535 = distinct !{!535, !517, !536, !369}
!536 = !DILocation(line: 65, column: 5, scope: !333, inlinedAt: !510)
!537 = !DILocation(line: 67, column: 22, scope: !371, inlinedAt: !510)
!538 = !DILocation(line: 67, column: 27, scope: !371, inlinedAt: !510)
!539 = !DILocation(line: 67, column: 7, scope: !372, inlinedAt: !510)
!540 = !DILocation(line: 70, column: 12, scope: !372, inlinedAt: !510)
!541 = !DILocation(line: 70, column: 11, scope: !372, inlinedAt: !510)
!542 = !DILocation(line: 70, column: 8, scope: !372, inlinedAt: !510)
!543 = !DILocation(line: 71, column: 2, scope: !372, inlinedAt: !510)
!544 = !DILocation(line: 74, column: 17, scope: !324, inlinedAt: !510)
!545 = !DILocation(line: 74, column: 5, scope: !324, inlinedAt: !510)
!546 = !DILocation(line: 75, column: 22, scope: !382, inlinedAt: !510)
!547 = !DILocation(line: 75, column: 32, scope: !382, inlinedAt: !510)
!548 = !DILocation(line: 76, column: 4, scope: !382, inlinedAt: !510)
!549 = !DILocation(line: 74, column: 23, scope: !324, inlinedAt: !510)
!550 = distinct !{!550, !545, !551, !369}
!551 = !DILocation(line: 77, column: 2, scope: !324, inlinedAt: !510)
!552 = !DILocation(line: 81, column: 22, scope: !324, inlinedAt: !510)
!553 = !DILocation(line: 115, column: 16, scope: !309, inlinedAt: !479)
!554 = !DILocation(line: 117, column: 37, scope: !309, inlinedAt: !479)
!555 = !DILocation(line: 117, column: 5, scope: !309, inlinedAt: !479)
!556 = !DILocation(line: 118, column: 4, scope: !309, inlinedAt: !479)
!557 = !DILocation(line: 122, column: 1, scope: !269, inlinedAt: !479)
!558 = !DILocation(line: 0, scope: !269, inlinedAt: !559)
!559 = distinct !DILocation(line: 208, column: 3, scope: !285, inlinedAt: !239)
!560 = distinct !DIAssignID()
!561 = !DILocation(line: 88, column: 11, scope: !269, inlinedAt: !559)
!562 = !DILocation(line: 90, column: 13, scope: !290, inlinedAt: !559)
!563 = !DILocation(line: 90, column: 6, scope: !269, inlinedAt: !559)
!564 = !DILocation(line: 95, column: 29, scope: !277, inlinedAt: !559)
!565 = !DILocation(line: 95, column: 21, scope: !277, inlinedAt: !559)
!566 = !DILocation(line: 95, column: 6, scope: !269, inlinedAt: !559)
!567 = !DILocation(line: 99, column: 39, scope: !276, inlinedAt: !559)
!568 = !DILocation(line: 99, column: 28, scope: !276, inlinedAt: !559)
!569 = !DILocation(line: 99, column: 20, scope: !276, inlinedAt: !559)
!570 = !DILocation(line: 0, scope: !276, inlinedAt: !559)
!571 = !DILocation(line: 100, column: 39, scope: !276, inlinedAt: !559)
!572 = !DILocation(line: 100, column: 28, scope: !276, inlinedAt: !559)
!573 = !DILocation(line: 100, column: 20, scope: !276, inlinedAt: !559)
!574 = !DILocation(line: 104, column: 21, scope: !282, inlinedAt: !559)
!575 = !DILocation(line: 104, column: 26, scope: !282, inlinedAt: !559)
!576 = !DILocation(line: 0, scope: !281, inlinedAt: !559)
!577 = !DILocation(line: 104, column: 7, scope: !276, inlinedAt: !559)
!578 = !DILocation(line: 111, column: 28, scope: !309, inlinedAt: !559)
!579 = !DILocation(line: 111, column: 46, scope: !309, inlinedAt: !559)
!580 = !DILocation(line: 111, column: 5, scope: !309, inlinedAt: !559)
!581 = !DILocation(line: 112, column: 44, scope: !309, inlinedAt: !559)
!582 = !DILocation(line: 112, column: 5, scope: !309, inlinedAt: !559)
!583 = !DILocation(line: 113, column: 18, scope: !309, inlinedAt: !559)
!584 = !DILocation(line: 113, column: 10, scope: !309, inlinedAt: !559)
!585 = !DILocation(line: 113, column: 16, scope: !309, inlinedAt: !559)
!586 = !DILocation(line: 114, column: 18, scope: !309, inlinedAt: !559)
!587 = !DILocation(line: 114, column: 16, scope: !309, inlinedAt: !559)
!588 = !DILocation(line: 115, column: 18, scope: !309, inlinedAt: !559)
!589 = !DILocation(line: 0, scope: !324, inlinedAt: !590)
!590 = distinct !DILocation(line: 115, column: 18, scope: !309, inlinedAt: !559)
!591 = !DILocation(line: 54, column: 11, scope: !324, inlinedAt: !590)
!592 = !DILocation(line: 54, column: 17, scope: !324, inlinedAt: !590)
!593 = !DILocation(line: 55, column: 11, scope: !324, inlinedAt: !590)
!594 = !DILocation(line: 55, column: 17, scope: !324, inlinedAt: !590)
!595 = !DILocation(line: 0, scope: !333, inlinedAt: !590)
!596 = !DILocation(line: 58, column: 28, scope: !344, inlinedAt: !590)
!597 = !DILocation(line: 58, column: 5, scope: !333, inlinedAt: !590)
!598 = !DILocation(line: 66, column: 10, scope: !347, inlinedAt: !590)
!599 = !DILocation(line: 66, column: 6, scope: !324, inlinedAt: !590)
!600 = !DILocation(line: 59, column: 22, scope: !350, inlinedAt: !590)
!601 = !DILocation(line: 59, column: 27, scope: !350, inlinedAt: !590)
!602 = !DILocation(line: 59, column: 7, scope: !351, inlinedAt: !590)
!603 = !DILocation(line: 60, column: 13, scope: !355, inlinedAt: !590)
!604 = !DILocation(line: 60, column: 12, scope: !355, inlinedAt: !590)
!605 = !DILocation(line: 60, column: 22, scope: !355, inlinedAt: !590)
!606 = !DILocation(line: 60, column: 39, scope: !355, inlinedAt: !590)
!607 = !DILocation(line: 60, column: 31, scope: !355, inlinedAt: !590)
!608 = !DILocation(line: 60, column: 30, scope: !355, inlinedAt: !590)
!609 = !DILocation(line: 60, column: 28, scope: !355, inlinedAt: !590)
!610 = !DILocation(line: 60, column: 9, scope: !355, inlinedAt: !590)
!611 = !DILocation(line: 61, column: 3, scope: !355, inlinedAt: !590)
!612 = !DILocation(line: 64, column: 7, scope: !351, inlinedAt: !590)
!613 = !DILocation(line: 58, column: 41, scope: !344, inlinedAt: !590)
!614 = !DILocation(line: 58, column: 23, scope: !344, inlinedAt: !590)
!615 = distinct !{!615, !597, !616, !369}
!616 = !DILocation(line: 65, column: 5, scope: !333, inlinedAt: !590)
!617 = !DILocation(line: 67, column: 22, scope: !371, inlinedAt: !590)
!618 = !DILocation(line: 67, column: 27, scope: !371, inlinedAt: !590)
!619 = !DILocation(line: 67, column: 7, scope: !372, inlinedAt: !590)
!620 = !DILocation(line: 70, column: 12, scope: !372, inlinedAt: !590)
!621 = !DILocation(line: 70, column: 11, scope: !372, inlinedAt: !590)
!622 = !DILocation(line: 70, column: 8, scope: !372, inlinedAt: !590)
!623 = !DILocation(line: 71, column: 2, scope: !372, inlinedAt: !590)
!624 = !DILocation(line: 74, column: 17, scope: !324, inlinedAt: !590)
!625 = !DILocation(line: 74, column: 5, scope: !324, inlinedAt: !590)
!626 = !DILocation(line: 75, column: 22, scope: !382, inlinedAt: !590)
!627 = !DILocation(line: 75, column: 32, scope: !382, inlinedAt: !590)
!628 = !DILocation(line: 76, column: 4, scope: !382, inlinedAt: !590)
!629 = !DILocation(line: 74, column: 23, scope: !324, inlinedAt: !590)
!630 = distinct !{!630, !625, !631, !369}
!631 = !DILocation(line: 77, column: 2, scope: !324, inlinedAt: !590)
!632 = !DILocation(line: 81, column: 22, scope: !324, inlinedAt: !590)
!633 = !DILocation(line: 115, column: 16, scope: !309, inlinedAt: !559)
!634 = !DILocation(line: 117, column: 37, scope: !309, inlinedAt: !559)
!635 = !DILocation(line: 117, column: 5, scope: !309, inlinedAt: !559)
!636 = !DILocation(line: 118, column: 4, scope: !309, inlinedAt: !559)
!637 = !DILocation(line: 122, column: 1, scope: !269, inlinedAt: !559)
!638 = !DILocation(line: 213, column: 3, scope: !285, inlinedAt: !239)
!639 = !DILocation(line: 189, column: 27, scope: !195, inlinedAt: !239)
!640 = !DILocation(line: 216, column: 12, scope: !641, inlinedAt: !239)
!641 = distinct !DILexicalBlock(scope: !642, file: !3, line: 216, column: 7)
!642 = distinct !DILexicalBlock(scope: !266, file: !3, line: 214, column: 9)
!643 = !DILocation(line: 216, column: 7, scope: !642, inlinedAt: !239)
!644 = !DILocalVariable(name: "i", arg: 1, scope: !645, file: !3, line: 124, type: !7)
!645 = distinct !DISubprogram(name: "clone_redir_backward", scope: !3, file: !3, line: 124, type: !270, scopeLine: 124, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !646)
!646 = !{!644, !647, !648, !649, !650, !651, !654, !655, !656}
!647 = !DILocalVariable(name: "skb", arg: 2, scope: !645, file: !3, line: 124, type: !65)
!648 = !DILocalVariable(name: "lhinfo", scope: !645, file: !3, line: 126, type: !31)
!649 = !DILocalVariable(name: "idx", scope: !645, file: !3, line: 129, type: !7)
!650 = !DILocalVariable(name: "lhaddr", scope: !645, file: !3, line: 130, type: !29)
!651 = !DILocalVariable(name: "data_end", scope: !652, file: !3, line: 136, type: !5)
!652 = distinct !DILexicalBlock(scope: !653, file: !3, line: 132, column: 52)
!653 = distinct !DILexicalBlock(scope: !645, file: !3, line: 132, column: 6)
!654 = !DILocalVariable(name: "data", scope: !652, file: !3, line: 137, type: !5)
!655 = !DILocalVariable(name: "ethh", scope: !652, file: !3, line: 140, type: !200)
!656 = !DILocalVariable(name: "iph", scope: !657, file: !3, line: 143, type: !208)
!657 = distinct !DILexicalBlock(scope: !658, file: !3, line: 141, column: 39)
!658 = distinct !DILexicalBlock(scope: !652, file: !3, line: 141, column: 7)
!659 = !DILocation(line: 0, scope: !645, inlinedAt: !660)
!660 = distinct !DILocation(line: 217, column: 4, scope: !661, inlinedAt: !239)
!661 = distinct !DILexicalBlock(scope: !641, file: !3, line: 216, column: 28)
!662 = distinct !DIAssignID()
!663 = !DILocation(line: 127, column: 11, scope: !645, inlinedAt: !660)
!664 = !DILocation(line: 129, column: 2, scope: !645, inlinedAt: !660)
!665 = !DILocation(line: 129, column: 8, scope: !645, inlinedAt: !660)
!666 = distinct !DIAssignID()
!667 = !DILocation(line: 130, column: 18, scope: !645, inlinedAt: !660)
!668 = !DILocation(line: 132, column: 13, scope: !653, inlinedAt: !660)
!669 = !DILocation(line: 132, column: 18, scope: !653, inlinedAt: !660)
!670 = !DILocation(line: 132, column: 44, scope: !653, inlinedAt: !660)
!671 = !DILocation(line: 132, column: 36, scope: !653, inlinedAt: !660)
!672 = !DILocation(line: 132, column: 6, scope: !645, inlinedAt: !660)
!673 = !DILocation(line: 136, column: 39, scope: !652, inlinedAt: !660)
!674 = !DILocation(line: 136, column: 28, scope: !652, inlinedAt: !660)
!675 = !DILocation(line: 136, column: 20, scope: !652, inlinedAt: !660)
!676 = !DILocation(line: 0, scope: !652, inlinedAt: !660)
!677 = !DILocation(line: 137, column: 39, scope: !652, inlinedAt: !660)
!678 = !DILocation(line: 137, column: 28, scope: !652, inlinedAt: !660)
!679 = !DILocation(line: 137, column: 20, scope: !652, inlinedAt: !660)
!680 = !DILocation(line: 141, column: 21, scope: !658, inlinedAt: !660)
!681 = !DILocation(line: 141, column: 26, scope: !658, inlinedAt: !660)
!682 = !DILocation(line: 0, scope: !657, inlinedAt: !660)
!683 = !DILocation(line: 141, column: 7, scope: !652, inlinedAt: !660)
!684 = !DILocation(line: 148, column: 28, scope: !685, inlinedAt: !660)
!685 = distinct !DILexicalBlock(scope: !686, file: !3, line: 145, column: 39)
!686 = distinct !DILexicalBlock(scope: !657, file: !3, line: 145, column: 8)
!687 = !DILocation(line: 148, column: 46, scope: !685, inlinedAt: !660)
!688 = !DILocation(line: 148, column: 5, scope: !685, inlinedAt: !660)
!689 = !DILocation(line: 149, column: 44, scope: !685, inlinedAt: !660)
!690 = !DILocation(line: 149, column: 5, scope: !685, inlinedAt: !660)
!691 = !DILocation(line: 150, column: 18, scope: !685, inlinedAt: !660)
!692 = !DILocation(line: 150, column: 10, scope: !685, inlinedAt: !660)
!693 = !DILocation(line: 150, column: 16, scope: !685, inlinedAt: !660)
!694 = !DILocation(line: 151, column: 18, scope: !685, inlinedAt: !660)
!695 = !DILocation(line: 151, column: 16, scope: !685, inlinedAt: !660)
!696 = !DILocation(line: 152, column: 18, scope: !685, inlinedAt: !660)
!697 = !DILocation(line: 0, scope: !324, inlinedAt: !698)
!698 = distinct !DILocation(line: 152, column: 18, scope: !685, inlinedAt: !660)
!699 = !DILocation(line: 54, column: 11, scope: !324, inlinedAt: !698)
!700 = !DILocation(line: 54, column: 17, scope: !324, inlinedAt: !698)
!701 = !DILocation(line: 55, column: 11, scope: !324, inlinedAt: !698)
!702 = !DILocation(line: 55, column: 17, scope: !324, inlinedAt: !698)
!703 = !DILocation(line: 0, scope: !333, inlinedAt: !698)
!704 = !DILocation(line: 58, column: 28, scope: !344, inlinedAt: !698)
!705 = !DILocation(line: 58, column: 5, scope: !333, inlinedAt: !698)
!706 = !DILocation(line: 66, column: 10, scope: !347, inlinedAt: !698)
!707 = !DILocation(line: 66, column: 6, scope: !324, inlinedAt: !698)
!708 = !DILocation(line: 59, column: 22, scope: !350, inlinedAt: !698)
!709 = !DILocation(line: 59, column: 27, scope: !350, inlinedAt: !698)
!710 = !DILocation(line: 59, column: 7, scope: !351, inlinedAt: !698)
!711 = !DILocation(line: 60, column: 13, scope: !355, inlinedAt: !698)
!712 = !DILocation(line: 60, column: 12, scope: !355, inlinedAt: !698)
!713 = !DILocation(line: 60, column: 22, scope: !355, inlinedAt: !698)
!714 = !DILocation(line: 60, column: 39, scope: !355, inlinedAt: !698)
!715 = !DILocation(line: 60, column: 31, scope: !355, inlinedAt: !698)
!716 = !DILocation(line: 60, column: 30, scope: !355, inlinedAt: !698)
!717 = !DILocation(line: 60, column: 28, scope: !355, inlinedAt: !698)
!718 = !DILocation(line: 60, column: 9, scope: !355, inlinedAt: !698)
!719 = !DILocation(line: 61, column: 3, scope: !355, inlinedAt: !698)
!720 = !DILocation(line: 64, column: 7, scope: !351, inlinedAt: !698)
!721 = !DILocation(line: 58, column: 41, scope: !344, inlinedAt: !698)
!722 = !DILocation(line: 58, column: 23, scope: !344, inlinedAt: !698)
!723 = distinct !{!723, !705, !724, !369}
!724 = !DILocation(line: 65, column: 5, scope: !333, inlinedAt: !698)
!725 = !DILocation(line: 67, column: 22, scope: !371, inlinedAt: !698)
!726 = !DILocation(line: 67, column: 27, scope: !371, inlinedAt: !698)
!727 = !DILocation(line: 67, column: 7, scope: !372, inlinedAt: !698)
!728 = !DILocation(line: 70, column: 12, scope: !372, inlinedAt: !698)
!729 = !DILocation(line: 70, column: 11, scope: !372, inlinedAt: !698)
!730 = !DILocation(line: 70, column: 8, scope: !372, inlinedAt: !698)
!731 = !DILocation(line: 71, column: 2, scope: !372, inlinedAt: !698)
!732 = !DILocation(line: 74, column: 17, scope: !324, inlinedAt: !698)
!733 = !DILocation(line: 74, column: 5, scope: !324, inlinedAt: !698)
!734 = !DILocation(line: 75, column: 22, scope: !382, inlinedAt: !698)
!735 = !DILocation(line: 75, column: 32, scope: !382, inlinedAt: !698)
!736 = !DILocation(line: 76, column: 4, scope: !382, inlinedAt: !698)
!737 = !DILocation(line: 74, column: 23, scope: !324, inlinedAt: !698)
!738 = distinct !{!738, !733, !739, !369}
!739 = !DILocation(line: 77, column: 2, scope: !324, inlinedAt: !698)
!740 = !DILocation(line: 81, column: 22, scope: !324, inlinedAt: !698)
!741 = !DILocation(line: 152, column: 16, scope: !685, inlinedAt: !660)
!742 = !DILocation(line: 154, column: 37, scope: !685, inlinedAt: !660)
!743 = !DILocation(line: 154, column: 5, scope: !685, inlinedAt: !660)
!744 = !DILocation(line: 155, column: 4, scope: !685, inlinedAt: !660)
!745 = !DILocation(line: 159, column: 1, scope: !645, inlinedAt: !660)
!746 = !DILocation(line: 158, column: 2, scope: !645, inlinedAt: !660)
!747 = !DILocation(line: 0, scope: !645, inlinedAt: !748)
!748 = distinct !DILocation(line: 218, column: 4, scope: !661, inlinedAt: !239)
!749 = distinct !DIAssignID()
!750 = !DILocation(line: 127, column: 11, scope: !645, inlinedAt: !748)
!751 = !DILocation(line: 129, column: 2, scope: !645, inlinedAt: !748)
!752 = !DILocation(line: 129, column: 8, scope: !645, inlinedAt: !748)
!753 = distinct !DIAssignID()
!754 = !DILocation(line: 130, column: 18, scope: !645, inlinedAt: !748)
!755 = !DILocation(line: 132, column: 13, scope: !653, inlinedAt: !748)
!756 = !DILocation(line: 132, column: 18, scope: !653, inlinedAt: !748)
!757 = !DILocation(line: 132, column: 44, scope: !653, inlinedAt: !748)
!758 = !DILocation(line: 132, column: 36, scope: !653, inlinedAt: !748)
!759 = !DILocation(line: 132, column: 6, scope: !645, inlinedAt: !748)
!760 = !DILocation(line: 136, column: 39, scope: !652, inlinedAt: !748)
!761 = !DILocation(line: 136, column: 28, scope: !652, inlinedAt: !748)
!762 = !DILocation(line: 136, column: 20, scope: !652, inlinedAt: !748)
!763 = !DILocation(line: 0, scope: !652, inlinedAt: !748)
!764 = !DILocation(line: 137, column: 39, scope: !652, inlinedAt: !748)
!765 = !DILocation(line: 137, column: 28, scope: !652, inlinedAt: !748)
!766 = !DILocation(line: 137, column: 20, scope: !652, inlinedAt: !748)
!767 = !DILocation(line: 141, column: 21, scope: !658, inlinedAt: !748)
!768 = !DILocation(line: 141, column: 26, scope: !658, inlinedAt: !748)
!769 = !DILocation(line: 0, scope: !657, inlinedAt: !748)
!770 = !DILocation(line: 141, column: 7, scope: !652, inlinedAt: !748)
!771 = !DILocation(line: 148, column: 28, scope: !685, inlinedAt: !748)
!772 = !DILocation(line: 148, column: 46, scope: !685, inlinedAt: !748)
!773 = !DILocation(line: 148, column: 5, scope: !685, inlinedAt: !748)
!774 = !DILocation(line: 149, column: 44, scope: !685, inlinedAt: !748)
!775 = !DILocation(line: 149, column: 5, scope: !685, inlinedAt: !748)
!776 = !DILocation(line: 150, column: 18, scope: !685, inlinedAt: !748)
!777 = !DILocation(line: 150, column: 10, scope: !685, inlinedAt: !748)
!778 = !DILocation(line: 150, column: 16, scope: !685, inlinedAt: !748)
!779 = !DILocation(line: 151, column: 18, scope: !685, inlinedAt: !748)
!780 = !DILocation(line: 151, column: 16, scope: !685, inlinedAt: !748)
!781 = !DILocation(line: 152, column: 18, scope: !685, inlinedAt: !748)
!782 = !DILocation(line: 0, scope: !324, inlinedAt: !783)
!783 = distinct !DILocation(line: 152, column: 18, scope: !685, inlinedAt: !748)
!784 = !DILocation(line: 54, column: 11, scope: !324, inlinedAt: !783)
!785 = !DILocation(line: 54, column: 17, scope: !324, inlinedAt: !783)
!786 = !DILocation(line: 55, column: 11, scope: !324, inlinedAt: !783)
!787 = !DILocation(line: 55, column: 17, scope: !324, inlinedAt: !783)
!788 = !DILocation(line: 0, scope: !333, inlinedAt: !783)
!789 = !DILocation(line: 58, column: 28, scope: !344, inlinedAt: !783)
!790 = !DILocation(line: 58, column: 5, scope: !333, inlinedAt: !783)
!791 = !DILocation(line: 66, column: 10, scope: !347, inlinedAt: !783)
!792 = !DILocation(line: 66, column: 6, scope: !324, inlinedAt: !783)
!793 = !DILocation(line: 59, column: 22, scope: !350, inlinedAt: !783)
!794 = !DILocation(line: 59, column: 27, scope: !350, inlinedAt: !783)
!795 = !DILocation(line: 59, column: 7, scope: !351, inlinedAt: !783)
!796 = !DILocation(line: 60, column: 13, scope: !355, inlinedAt: !783)
!797 = !DILocation(line: 60, column: 12, scope: !355, inlinedAt: !783)
!798 = !DILocation(line: 60, column: 22, scope: !355, inlinedAt: !783)
!799 = !DILocation(line: 60, column: 39, scope: !355, inlinedAt: !783)
!800 = !DILocation(line: 60, column: 31, scope: !355, inlinedAt: !783)
!801 = !DILocation(line: 60, column: 30, scope: !355, inlinedAt: !783)
!802 = !DILocation(line: 60, column: 28, scope: !355, inlinedAt: !783)
!803 = !DILocation(line: 60, column: 9, scope: !355, inlinedAt: !783)
!804 = !DILocation(line: 61, column: 3, scope: !355, inlinedAt: !783)
!805 = !DILocation(line: 64, column: 7, scope: !351, inlinedAt: !783)
!806 = !DILocation(line: 58, column: 41, scope: !344, inlinedAt: !783)
!807 = !DILocation(line: 58, column: 23, scope: !344, inlinedAt: !783)
!808 = distinct !{!808, !790, !809, !369}
!809 = !DILocation(line: 65, column: 5, scope: !333, inlinedAt: !783)
!810 = !DILocation(line: 67, column: 22, scope: !371, inlinedAt: !783)
!811 = !DILocation(line: 67, column: 27, scope: !371, inlinedAt: !783)
!812 = !DILocation(line: 67, column: 7, scope: !372, inlinedAt: !783)
!813 = !DILocation(line: 70, column: 12, scope: !372, inlinedAt: !783)
!814 = !DILocation(line: 70, column: 11, scope: !372, inlinedAt: !783)
!815 = !DILocation(line: 70, column: 8, scope: !372, inlinedAt: !783)
!816 = !DILocation(line: 71, column: 2, scope: !372, inlinedAt: !783)
!817 = !DILocation(line: 74, column: 17, scope: !324, inlinedAt: !783)
!818 = !DILocation(line: 74, column: 5, scope: !324, inlinedAt: !783)
!819 = !DILocation(line: 75, column: 22, scope: !382, inlinedAt: !783)
!820 = !DILocation(line: 75, column: 32, scope: !382, inlinedAt: !783)
!821 = !DILocation(line: 76, column: 4, scope: !382, inlinedAt: !783)
!822 = !DILocation(line: 74, column: 23, scope: !324, inlinedAt: !783)
!823 = distinct !{!823, !818, !824, !369}
!824 = !DILocation(line: 77, column: 2, scope: !324, inlinedAt: !783)
!825 = !DILocation(line: 81, column: 22, scope: !324, inlinedAt: !783)
!826 = !DILocation(line: 152, column: 16, scope: !685, inlinedAt: !748)
!827 = !DILocation(line: 154, column: 37, scope: !685, inlinedAt: !748)
!828 = !DILocation(line: 154, column: 5, scope: !685, inlinedAt: !748)
!829 = !DILocation(line: 155, column: 4, scope: !685, inlinedAt: !748)
!830 = !DILocation(line: 159, column: 1, scope: !645, inlinedAt: !748)
!831 = !DILocation(line: 158, column: 2, scope: !645, inlinedAt: !748)
!832 = !DILocation(line: 0, scope: !645, inlinedAt: !833)
!833 = distinct !DILocation(line: 219, column: 4, scope: !661, inlinedAt: !239)
!834 = distinct !DIAssignID()
!835 = !DILocation(line: 127, column: 11, scope: !645, inlinedAt: !833)
!836 = !DILocation(line: 129, column: 2, scope: !645, inlinedAt: !833)
!837 = !DILocation(line: 129, column: 8, scope: !645, inlinedAt: !833)
!838 = distinct !DIAssignID()
!839 = !DILocation(line: 130, column: 18, scope: !645, inlinedAt: !833)
!840 = !DILocation(line: 132, column: 13, scope: !653, inlinedAt: !833)
!841 = !DILocation(line: 132, column: 18, scope: !653, inlinedAt: !833)
!842 = !DILocation(line: 132, column: 44, scope: !653, inlinedAt: !833)
!843 = !DILocation(line: 132, column: 36, scope: !653, inlinedAt: !833)
!844 = !DILocation(line: 132, column: 6, scope: !645, inlinedAt: !833)
!845 = !DILocation(line: 136, column: 39, scope: !652, inlinedAt: !833)
!846 = !DILocation(line: 136, column: 28, scope: !652, inlinedAt: !833)
!847 = !DILocation(line: 136, column: 20, scope: !652, inlinedAt: !833)
!848 = !DILocation(line: 0, scope: !652, inlinedAt: !833)
!849 = !DILocation(line: 137, column: 39, scope: !652, inlinedAt: !833)
!850 = !DILocation(line: 137, column: 28, scope: !652, inlinedAt: !833)
!851 = !DILocation(line: 137, column: 20, scope: !652, inlinedAt: !833)
!852 = !DILocation(line: 141, column: 21, scope: !658, inlinedAt: !833)
!853 = !DILocation(line: 141, column: 26, scope: !658, inlinedAt: !833)
!854 = !DILocation(line: 0, scope: !657, inlinedAt: !833)
!855 = !DILocation(line: 141, column: 7, scope: !652, inlinedAt: !833)
!856 = !DILocation(line: 148, column: 28, scope: !685, inlinedAt: !833)
!857 = !DILocation(line: 148, column: 46, scope: !685, inlinedAt: !833)
!858 = !DILocation(line: 148, column: 5, scope: !685, inlinedAt: !833)
!859 = !DILocation(line: 149, column: 44, scope: !685, inlinedAt: !833)
!860 = !DILocation(line: 149, column: 5, scope: !685, inlinedAt: !833)
!861 = !DILocation(line: 150, column: 18, scope: !685, inlinedAt: !833)
!862 = !DILocation(line: 150, column: 10, scope: !685, inlinedAt: !833)
!863 = !DILocation(line: 150, column: 16, scope: !685, inlinedAt: !833)
!864 = !DILocation(line: 151, column: 18, scope: !685, inlinedAt: !833)
!865 = !DILocation(line: 151, column: 16, scope: !685, inlinedAt: !833)
!866 = !DILocation(line: 152, column: 18, scope: !685, inlinedAt: !833)
!867 = !DILocation(line: 0, scope: !324, inlinedAt: !868)
!868 = distinct !DILocation(line: 152, column: 18, scope: !685, inlinedAt: !833)
!869 = !DILocation(line: 54, column: 11, scope: !324, inlinedAt: !868)
!870 = !DILocation(line: 54, column: 17, scope: !324, inlinedAt: !868)
!871 = !DILocation(line: 55, column: 11, scope: !324, inlinedAt: !868)
!872 = !DILocation(line: 55, column: 17, scope: !324, inlinedAt: !868)
!873 = !DILocation(line: 0, scope: !333, inlinedAt: !868)
!874 = !DILocation(line: 58, column: 28, scope: !344, inlinedAt: !868)
!875 = !DILocation(line: 58, column: 5, scope: !333, inlinedAt: !868)
!876 = !DILocation(line: 66, column: 10, scope: !347, inlinedAt: !868)
!877 = !DILocation(line: 66, column: 6, scope: !324, inlinedAt: !868)
!878 = !DILocation(line: 59, column: 22, scope: !350, inlinedAt: !868)
!879 = !DILocation(line: 59, column: 27, scope: !350, inlinedAt: !868)
!880 = !DILocation(line: 59, column: 7, scope: !351, inlinedAt: !868)
!881 = !DILocation(line: 60, column: 13, scope: !355, inlinedAt: !868)
!882 = !DILocation(line: 60, column: 12, scope: !355, inlinedAt: !868)
!883 = !DILocation(line: 60, column: 22, scope: !355, inlinedAt: !868)
!884 = !DILocation(line: 60, column: 39, scope: !355, inlinedAt: !868)
!885 = !DILocation(line: 60, column: 31, scope: !355, inlinedAt: !868)
!886 = !DILocation(line: 60, column: 30, scope: !355, inlinedAt: !868)
!887 = !DILocation(line: 60, column: 28, scope: !355, inlinedAt: !868)
!888 = !DILocation(line: 60, column: 9, scope: !355, inlinedAt: !868)
!889 = !DILocation(line: 61, column: 3, scope: !355, inlinedAt: !868)
!890 = !DILocation(line: 64, column: 7, scope: !351, inlinedAt: !868)
!891 = !DILocation(line: 58, column: 41, scope: !344, inlinedAt: !868)
!892 = !DILocation(line: 58, column: 23, scope: !344, inlinedAt: !868)
!893 = distinct !{!893, !875, !894, !369}
!894 = !DILocation(line: 65, column: 5, scope: !333, inlinedAt: !868)
!895 = !DILocation(line: 67, column: 22, scope: !371, inlinedAt: !868)
!896 = !DILocation(line: 67, column: 27, scope: !371, inlinedAt: !868)
!897 = !DILocation(line: 67, column: 7, scope: !372, inlinedAt: !868)
!898 = !DILocation(line: 70, column: 12, scope: !372, inlinedAt: !868)
!899 = !DILocation(line: 70, column: 11, scope: !372, inlinedAt: !868)
!900 = !DILocation(line: 70, column: 8, scope: !372, inlinedAt: !868)
!901 = !DILocation(line: 71, column: 2, scope: !372, inlinedAt: !868)
!902 = !DILocation(line: 74, column: 17, scope: !324, inlinedAt: !868)
!903 = !DILocation(line: 74, column: 5, scope: !324, inlinedAt: !868)
!904 = !DILocation(line: 75, column: 22, scope: !382, inlinedAt: !868)
!905 = !DILocation(line: 75, column: 32, scope: !382, inlinedAt: !868)
!906 = !DILocation(line: 76, column: 4, scope: !382, inlinedAt: !868)
!907 = !DILocation(line: 74, column: 23, scope: !324, inlinedAt: !868)
!908 = distinct !{!908, !903, !909, !369}
!909 = !DILocation(line: 77, column: 2, scope: !324, inlinedAt: !868)
!910 = !DILocation(line: 81, column: 22, scope: !324, inlinedAt: !868)
!911 = !DILocation(line: 152, column: 16, scope: !685, inlinedAt: !833)
!912 = !DILocation(line: 154, column: 37, scope: !685, inlinedAt: !833)
!913 = !DILocation(line: 154, column: 5, scope: !685, inlinedAt: !833)
!914 = !DILocation(line: 155, column: 4, scope: !685, inlinedAt: !833)
!915 = !DILocation(line: 159, column: 1, scope: !645, inlinedAt: !833)
!916 = !DILocation(line: 158, column: 2, scope: !645, inlinedAt: !833)
!917 = !DILocation(line: 0, scope: !645, inlinedAt: !918)
!918 = distinct !DILocation(line: 220, column: 4, scope: !661, inlinedAt: !239)
!919 = distinct !DIAssignID()
!920 = !DILocation(line: 127, column: 11, scope: !645, inlinedAt: !918)
!921 = !DILocation(line: 129, column: 2, scope: !645, inlinedAt: !918)
!922 = !DILocation(line: 129, column: 8, scope: !645, inlinedAt: !918)
!923 = distinct !DIAssignID()
!924 = !DILocation(line: 130, column: 18, scope: !645, inlinedAt: !918)
!925 = !DILocation(line: 132, column: 13, scope: !653, inlinedAt: !918)
!926 = !DILocation(line: 132, column: 18, scope: !653, inlinedAt: !918)
!927 = !DILocation(line: 132, column: 44, scope: !653, inlinedAt: !918)
!928 = !DILocation(line: 132, column: 36, scope: !653, inlinedAt: !918)
!929 = !DILocation(line: 132, column: 6, scope: !645, inlinedAt: !918)
!930 = !DILocation(line: 136, column: 39, scope: !652, inlinedAt: !918)
!931 = !DILocation(line: 136, column: 28, scope: !652, inlinedAt: !918)
!932 = !DILocation(line: 136, column: 20, scope: !652, inlinedAt: !918)
!933 = !DILocation(line: 0, scope: !652, inlinedAt: !918)
!934 = !DILocation(line: 137, column: 39, scope: !652, inlinedAt: !918)
!935 = !DILocation(line: 137, column: 28, scope: !652, inlinedAt: !918)
!936 = !DILocation(line: 137, column: 20, scope: !652, inlinedAt: !918)
!937 = !DILocation(line: 141, column: 21, scope: !658, inlinedAt: !918)
!938 = !DILocation(line: 141, column: 26, scope: !658, inlinedAt: !918)
!939 = !DILocation(line: 0, scope: !657, inlinedAt: !918)
!940 = !DILocation(line: 141, column: 7, scope: !652, inlinedAt: !918)
!941 = !DILocation(line: 148, column: 28, scope: !685, inlinedAt: !918)
!942 = !DILocation(line: 148, column: 46, scope: !685, inlinedAt: !918)
!943 = !DILocation(line: 148, column: 5, scope: !685, inlinedAt: !918)
!944 = !DILocation(line: 149, column: 44, scope: !685, inlinedAt: !918)
!945 = !DILocation(line: 149, column: 5, scope: !685, inlinedAt: !918)
!946 = !DILocation(line: 150, column: 18, scope: !685, inlinedAt: !918)
!947 = !DILocation(line: 150, column: 10, scope: !685, inlinedAt: !918)
!948 = !DILocation(line: 150, column: 16, scope: !685, inlinedAt: !918)
!949 = !DILocation(line: 151, column: 18, scope: !685, inlinedAt: !918)
!950 = !DILocation(line: 151, column: 16, scope: !685, inlinedAt: !918)
!951 = !DILocation(line: 152, column: 18, scope: !685, inlinedAt: !918)
!952 = !DILocation(line: 0, scope: !324, inlinedAt: !953)
!953 = distinct !DILocation(line: 152, column: 18, scope: !685, inlinedAt: !918)
!954 = !DILocation(line: 54, column: 11, scope: !324, inlinedAt: !953)
!955 = !DILocation(line: 54, column: 17, scope: !324, inlinedAt: !953)
!956 = !DILocation(line: 55, column: 11, scope: !324, inlinedAt: !953)
!957 = !DILocation(line: 55, column: 17, scope: !324, inlinedAt: !953)
!958 = !DILocation(line: 0, scope: !333, inlinedAt: !953)
!959 = !DILocation(line: 58, column: 28, scope: !344, inlinedAt: !953)
!960 = !DILocation(line: 58, column: 5, scope: !333, inlinedAt: !953)
!961 = !DILocation(line: 66, column: 10, scope: !347, inlinedAt: !953)
!962 = !DILocation(line: 66, column: 6, scope: !324, inlinedAt: !953)
!963 = !DILocation(line: 59, column: 22, scope: !350, inlinedAt: !953)
!964 = !DILocation(line: 59, column: 27, scope: !350, inlinedAt: !953)
!965 = !DILocation(line: 59, column: 7, scope: !351, inlinedAt: !953)
!966 = !DILocation(line: 60, column: 13, scope: !355, inlinedAt: !953)
!967 = !DILocation(line: 60, column: 12, scope: !355, inlinedAt: !953)
!968 = !DILocation(line: 60, column: 22, scope: !355, inlinedAt: !953)
!969 = !DILocation(line: 60, column: 39, scope: !355, inlinedAt: !953)
!970 = !DILocation(line: 60, column: 31, scope: !355, inlinedAt: !953)
!971 = !DILocation(line: 60, column: 30, scope: !355, inlinedAt: !953)
!972 = !DILocation(line: 60, column: 28, scope: !355, inlinedAt: !953)
!973 = !DILocation(line: 60, column: 9, scope: !355, inlinedAt: !953)
!974 = !DILocation(line: 61, column: 3, scope: !355, inlinedAt: !953)
!975 = !DILocation(line: 64, column: 7, scope: !351, inlinedAt: !953)
!976 = !DILocation(line: 58, column: 41, scope: !344, inlinedAt: !953)
!977 = !DILocation(line: 58, column: 23, scope: !344, inlinedAt: !953)
!978 = distinct !{!978, !960, !979, !369}
!979 = !DILocation(line: 65, column: 5, scope: !333, inlinedAt: !953)
!980 = !DILocation(line: 67, column: 22, scope: !371, inlinedAt: !953)
!981 = !DILocation(line: 67, column: 27, scope: !371, inlinedAt: !953)
!982 = !DILocation(line: 67, column: 7, scope: !372, inlinedAt: !953)
!983 = !DILocation(line: 70, column: 12, scope: !372, inlinedAt: !953)
!984 = !DILocation(line: 70, column: 11, scope: !372, inlinedAt: !953)
!985 = !DILocation(line: 70, column: 8, scope: !372, inlinedAt: !953)
!986 = !DILocation(line: 71, column: 2, scope: !372, inlinedAt: !953)
!987 = !DILocation(line: 74, column: 17, scope: !324, inlinedAt: !953)
!988 = !DILocation(line: 74, column: 5, scope: !324, inlinedAt: !953)
!989 = !DILocation(line: 75, column: 22, scope: !382, inlinedAt: !953)
!990 = !DILocation(line: 75, column: 32, scope: !382, inlinedAt: !953)
!991 = !DILocation(line: 76, column: 4, scope: !382, inlinedAt: !953)
!992 = !DILocation(line: 74, column: 23, scope: !324, inlinedAt: !953)
!993 = distinct !{!993, !988, !994, !369}
!994 = !DILocation(line: 77, column: 2, scope: !324, inlinedAt: !953)
!995 = !DILocation(line: 81, column: 22, scope: !324, inlinedAt: !953)
!996 = !DILocation(line: 152, column: 16, scope: !685, inlinedAt: !918)
!997 = !DILocation(line: 154, column: 37, scope: !685, inlinedAt: !918)
!998 = !DILocation(line: 154, column: 5, scope: !685, inlinedAt: !918)
!999 = !DILocation(line: 155, column: 4, scope: !685, inlinedAt: !918)
!1000 = !DILocation(line: 159, column: 1, scope: !645, inlinedAt: !918)
!1001 = !DILocation(line: 158, column: 2, scope: !645, inlinedAt: !918)
!1002 = !DILocation(line: 225, column: 4, scope: !661, inlinedAt: !239)
!1003 = !DILocation(line: 242, column: 1, scope: !175)
