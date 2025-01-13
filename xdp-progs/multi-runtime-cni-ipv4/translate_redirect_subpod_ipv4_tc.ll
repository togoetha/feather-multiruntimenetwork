; ModuleID = 'translate_redirect_subpod_ipv4_tc.c'
source_filename = "translate_redirect_subpod_ipv4_tc.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.__sk_buff = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [5 x i32], i32, i32, i32, i32, i32, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, %union.anon, i64, i32, i32, %union.anon.0, i32, i8, [3 x i8], i64 }
%union.anon = type { ptr }
%union.anon.0 = type { ptr }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.redirect_route = type { i32, [6 x i8], [6 x i8] }

@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@tc_redirect_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !50
@ipv4_redirect_handle.____fmt = internal constant [9 x i8] c"no ipv4\0A\00", align 1, !dbg !78
@ipv4_redirect_handle.____fmt.1 = internal constant [23 x i8] c"no default route found\00", align 1, !dbg !257
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @tc_redirect_map, ptr @tc_subpodredirect], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local noundef i32 @tc_subpodredirect(ptr nocapture noundef readonly %0) #0 section "tc" !dbg !288 {
  %2 = alloca i32, align 4, !DIAssignID !297
  %3 = alloca i32, align 4, !DIAssignID !298
  tail call void @llvm.dbg.value(metadata ptr %0, metadata !292, metadata !DIExpression()), !dbg !299
  %4 = getelementptr inbounds %struct.__sk_buff, ptr %0, i64 0, i32 16, !dbg !300
  %5 = load i32, ptr %4, align 8, !dbg !300, !tbaa !301
  %6 = zext i32 %5 to i64, !dbg !307
  %7 = inttoptr i64 %6 to ptr, !dbg !308
  tail call void @llvm.dbg.value(metadata ptr %7, metadata !293, metadata !DIExpression()), !dbg !299
  %8 = getelementptr inbounds %struct.__sk_buff, ptr %0, i64 0, i32 15, !dbg !309
  %9 = load i32, ptr %8, align 4, !dbg !309, !tbaa !310
  %10 = zext i32 %9 to i64, !dbg !311
  %11 = inttoptr i64 %10 to ptr, !dbg !312
  tail call void @llvm.dbg.value(metadata ptr %11, metadata !294, metadata !DIExpression()), !dbg !299
  tail call void @llvm.dbg.value(metadata ptr %11, metadata !295, metadata !DIExpression()), !dbg !299
  %12 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 1, !dbg !313
  %13 = icmp ugt ptr %12, %7, !dbg !315
  call void @llvm.dbg.assign(metadata i1 undef, metadata !226, metadata !DIExpression(), metadata !297, metadata ptr %2, metadata !DIExpression()), !dbg !316
  call void @llvm.dbg.assign(metadata i1 undef, metadata !227, metadata !DIExpression(), metadata !298, metadata ptr %3, metadata !DIExpression()), !dbg !318
  call void @llvm.dbg.value(metadata ptr %0, metadata !192, metadata !DIExpression()), !dbg !316
  call void @llvm.dbg.value(metadata ptr %11, metadata !193, metadata !DIExpression()), !dbg !316
  call void @llvm.dbg.value(metadata ptr %7, metadata !194, metadata !DIExpression()), !dbg !316
  call void @llvm.dbg.value(metadata ptr %12, metadata !195, metadata !DIExpression()), !dbg !316
  %14 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 2, i32 1
  %15 = icmp ugt ptr %14, %7
  %16 = select i1 %13, i1 true, i1 %15, !dbg !319
  br i1 %16, label %130, label %17, !dbg !319

17:                                               ; preds = %1
  %18 = load i8, ptr %12, align 4, !dbg !320
  %19 = and i8 %18, -16, !dbg !322
  %20 = icmp eq i8 %19, 64, !dbg !322
  br i1 %20, label %23, label %21, !dbg !323

21:                                               ; preds = %17
  %22 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt, i32 noundef 9) #5, !dbg !324
  br label %130, !dbg !327

23:                                               ; preds = %17
  %24 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 1, i32 2, !dbg !328
  %25 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 2, i32 0, i64 2, !dbg !328
  %26 = load i32, ptr %25, align 4, !dbg !328, !tbaa !329
  call void @llvm.dbg.value(metadata i32 %26, metadata !223, metadata !DIExpression()), !dbg !316
  %27 = load i32, ptr %24, align 4, !dbg !330, !tbaa !329
  call void @llvm.dbg.value(metadata i32 %27, metadata !224, metadata !DIExpression()), !dbg !316
  %28 = and i32 %26, -117440513, !dbg !331
  call void @llvm.dbg.value(metadata i32 %26, metadata !223, metadata !DIExpression(DW_OP_constu, 18446744073592111103, DW_OP_and, DW_OP_stack_value)), !dbg !316
  %29 = and i32 %27, -117440513, !dbg !332
  call void @llvm.dbg.value(metadata i32 %29, metadata !224, metadata !DIExpression()), !dbg !316
  %30 = icmp eq i32 %28, %29, !dbg !333
  br i1 %30, label %130, label %31, !dbg !335

31:                                               ; preds = %23
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #5, !dbg !336
  %32 = tail call i32 @llvm.bswap.i32(i32 %28), !dbg !337
  store i32 %32, ptr %2, align 4, !dbg !338, !tbaa !339, !DIAssignID !340
  call void @llvm.dbg.assign(metadata i32 %32, metadata !226, metadata !DIExpression(), metadata !340, metadata ptr %2, metadata !DIExpression()), !dbg !316
  %33 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_redirect_map, ptr noundef nonnull %2) #5, !dbg !341
  call void @llvm.dbg.value(metadata ptr %33, metadata !225, metadata !DIExpression()), !dbg !316
  %34 = icmp eq ptr %33, null, !dbg !342
  br i1 %34, label %35, label %40, !dbg !343

35:                                               ; preds = %31
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #5, !dbg !344
  store i32 0, ptr %3, align 4, !dbg !345, !tbaa !339, !DIAssignID !346
  call void @llvm.dbg.assign(metadata i32 0, metadata !227, metadata !DIExpression(), metadata !346, metadata ptr %3, metadata !DIExpression()), !dbg !318
  %36 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_redirect_map, ptr noundef nonnull %3) #5, !dbg !347
  call void @llvm.dbg.value(metadata ptr %36, metadata !225, metadata !DIExpression()), !dbg !316
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #5, !dbg !348
  %37 = icmp eq ptr %36, null, !dbg !349
  br i1 %37, label %38, label %40, !dbg !351

38:                                               ; preds = %35
  %39 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.1, i32 noundef 23) #5, !dbg !352
  br label %116, !dbg !355

40:                                               ; preds = %31, %35
  %41 = phi ptr [ %36, %35 ], [ %33, %31 ]
  %42 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 1, i32 1, i64 3, !dbg !356
  %43 = load i8, ptr %42, align 1, !dbg !356, !tbaa !357
  %44 = icmp ne i8 %43, 6, !dbg !360
  call void @llvm.dbg.value(metadata ptr undef, metadata !230, metadata !DIExpression()), !dbg !361
  %45 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 3, i32 2
  %46 = icmp ugt ptr %45, %7
  %47 = select i1 %44, i1 true, i1 %46, !dbg !362
  br i1 %47, label %53, label %48, !dbg !362

48:                                               ; preds = %40
  %49 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 3, i32 0, i64 4, !dbg !363
  %50 = load i16, ptr %49, align 4, !dbg !363
  %51 = and i16 %50, 1024, !dbg !367
  %52 = icmp eq i16 %51, 0, !dbg !367
  br i1 %52, label %53, label %116, !dbg !368

53:                                               ; preds = %48, %40
  %54 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 0, i32 1, !dbg !369
  %55 = getelementptr inbounds %struct.redirect_route, ptr %41, i64 0, i32 1, !dbg !370
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %54, ptr noundef nonnull align 4 dereferenceable(6) %55, i64 6, i1 false), !dbg !371
  %56 = getelementptr inbounds %struct.redirect_route, ptr %41, i64 0, i32 2, !dbg !372
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %11, ptr noundef nonnull align 2 dereferenceable(6) %56, i64 6, i1 false), !dbg !373
  %57 = load i32, ptr %24, align 4, !dbg !374, !tbaa !329
  %58 = and i32 %57, -117440513, !dbg !374
  store i32 %58, ptr %24, align 4, !dbg !374, !tbaa !329
  %59 = load i8, ptr %12, align 4, !dbg !375
  %60 = shl i8 %59, 2, !dbg !375
  %61 = and i8 %60, 60, !dbg !375
  tail call void @llvm.dbg.value(metadata ptr %12, metadata !376, metadata !DIExpression()), !dbg !389
  tail call void @llvm.dbg.value(metadata i8 %61, metadata !382, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !389
  tail call void @llvm.dbg.value(metadata ptr %7, metadata !383, metadata !DIExpression()), !dbg !389
  tail call void @llvm.dbg.value(metadata i32 0, metadata !384, metadata !DIExpression()), !dbg !389
  %62 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 1, i32 1, i64 4, !dbg !391
  store i8 0, ptr %62, align 1, !dbg !392, !tbaa !329
  %63 = getelementptr inbounds %struct.ethhdr, ptr %11, i64 1, i32 1, i64 5, !dbg !393
  store i8 0, ptr %63, align 1, !dbg !394, !tbaa !329
  tail call void @llvm.dbg.value(metadata i32 0, metadata !385, metadata !DIExpression()), !dbg !395
  tail call void @llvm.dbg.value(metadata i32 0, metadata !384, metadata !DIExpression()), !dbg !389
  tail call void @llvm.dbg.value(metadata ptr %12, metadata !376, metadata !DIExpression()), !dbg !389
  tail call void @llvm.dbg.value(metadata i8 %61, metadata !382, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !389
  %64 = icmp eq i8 %61, 0, !dbg !396
  br i1 %64, label %112, label %65, !dbg !398

65:                                               ; preds = %53
  %66 = zext nneg i8 %61 to i16, !dbg !375
  tail call void @llvm.dbg.value(metadata i16 %66, metadata !382, metadata !DIExpression()), !dbg !389
  br label %69, !dbg !398

67:                                               ; preds = %85
  %68 = icmp eq i16 %87, 0, !dbg !399
  br i1 %68, label %99, label %92, !dbg !401

69:                                               ; preds = %65, %85
  %70 = phi i32 [ %88, %85 ], [ 0, %65 ]
  %71 = phi i32 [ %86, %85 ], [ 0, %65 ]
  %72 = phi ptr [ %74, %85 ], [ %12, %65 ]
  %73 = phi i16 [ %87, %85 ], [ %66, %65 ]
  tail call void @llvm.dbg.value(metadata i32 %70, metadata !385, metadata !DIExpression()), !dbg !395
  tail call void @llvm.dbg.value(metadata i32 %71, metadata !384, metadata !DIExpression()), !dbg !389
  tail call void @llvm.dbg.value(metadata ptr %72, metadata !376, metadata !DIExpression()), !dbg !389
  tail call void @llvm.dbg.value(metadata i16 %73, metadata !382, metadata !DIExpression()), !dbg !389
  %74 = getelementptr inbounds i8, ptr %72, i64 2, !dbg !402
  %75 = icmp ugt ptr %74, %7, !dbg !405
  br i1 %75, label %85, label %76, !dbg !406

76:                                               ; preds = %69
  %77 = load i8, ptr %72, align 1, !dbg !407, !tbaa !329
  %78 = zext i8 %77 to i32, !dbg !409
  %79 = shl nuw nsw i32 %78, 8, !dbg !410
  %80 = getelementptr inbounds i8, ptr %72, i64 1, !dbg !411
  %81 = load i8, ptr %80, align 1, !dbg !412, !tbaa !329
  %82 = zext i8 %81 to i32, !dbg !413
  %83 = or disjoint i32 %79, %82, !dbg !414
  %84 = add i32 %83, %71, !dbg !415
  tail call void @llvm.dbg.value(metadata i32 %84, metadata !384, metadata !DIExpression()), !dbg !389
  br label %85, !dbg !416

85:                                               ; preds = %76, %69
  %86 = phi i32 [ %84, %76 ], [ %71, %69 ], !dbg !389
  tail call void @llvm.dbg.value(metadata i32 %86, metadata !384, metadata !DIExpression()), !dbg !389
  tail call void @llvm.dbg.value(metadata ptr %74, metadata !376, metadata !DIExpression()), !dbg !389
  %87 = add nsw i16 %73, -2, !dbg !417
  tail call void @llvm.dbg.value(metadata i16 %87, metadata !382, metadata !DIExpression()), !dbg !389
  %88 = add nuw nsw i32 %70, 2, !dbg !418
  tail call void @llvm.dbg.value(metadata i32 %88, metadata !385, metadata !DIExpression()), !dbg !395
  %89 = icmp ult i32 %70, 58, !dbg !419
  %90 = icmp ne i16 %87, 0, !dbg !396
  %91 = select i1 %89, i1 %90, i1 false, !dbg !396
  br i1 %91, label %69, label %67, !dbg !398, !llvm.loop !420

92:                                               ; preds = %67
  %93 = getelementptr inbounds i8, ptr %72, i64 3, !dbg !423
  %94 = icmp ugt ptr %93, %7, !dbg !426
  br i1 %94, label %118, label %95, !dbg !427

95:                                               ; preds = %92
  %96 = load i8, ptr %74, align 1, !dbg !428, !tbaa !329
  %97 = zext i8 %96 to i32, !dbg !429
  %98 = add i32 %86, %97, !dbg !430
  tail call void @llvm.dbg.value(metadata i32 %98, metadata !384, metadata !DIExpression()), !dbg !389
  br label %99, !dbg !431

99:                                               ; preds = %95, %67
  %100 = phi i32 [ %98, %95 ], [ %86, %67 ], !dbg !389
  tail call void @llvm.dbg.value(metadata i32 %100, metadata !384, metadata !DIExpression()), !dbg !389
  tail call void @llvm.dbg.value(metadata i32 0, metadata !387, metadata !DIExpression()), !dbg !389
  %101 = icmp ugt i32 %100, 65535, !dbg !432
  br i1 %101, label %102, label %112, !dbg !433

102:                                              ; preds = %99, %102
  %103 = phi i32 [ %108, %102 ], [ 0, %99 ]
  %104 = phi i32 [ %107, %102 ], [ %100, %99 ]
  tail call void @llvm.dbg.value(metadata i32 %103, metadata !387, metadata !DIExpression()), !dbg !389
  tail call void @llvm.dbg.value(metadata i32 %104, metadata !384, metadata !DIExpression()), !dbg !389
  %105 = lshr i32 %104, 16, !dbg !432
  %106 = and i32 %104, 65535, !dbg !434
  %107 = add nuw nsw i32 %106, %105, !dbg !436
  tail call void @llvm.dbg.value(metadata i32 %107, metadata !384, metadata !DIExpression()), !dbg !389
  %108 = add nuw nsw i32 %103, 1, !dbg !437
  tail call void @llvm.dbg.value(metadata i32 %108, metadata !387, metadata !DIExpression()), !dbg !389
  %109 = icmp ugt i32 %107, 65535, !dbg !432
  %110 = icmp ult i32 %103, 15, !dbg !438
  %111 = select i1 %109, i1 %110, i1 false, !dbg !438
  br i1 %111, label %102, label %112, !dbg !433, !llvm.loop !439

112:                                              ; preds = %102, %53, %99
  %113 = phi i32 [ %100, %99 ], [ 0, %53 ], [ %107, %102 ], !dbg !389
  %114 = trunc i32 %113 to i16, !dbg !441
  %115 = xor i16 %114, -1, !dbg !441
  tail call void @llvm.dbg.value(metadata i16 %115, metadata !388, metadata !DIExpression()), !dbg !389
  br label %118

116:                                              ; preds = %38, %48
  %117 = phi i32 [ -1, %48 ], [ 0, %38 ]
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #5, !dbg !442
  tail call void @llvm.dbg.value(metadata i32 %117, metadata !296, metadata !DIExpression()), !dbg !299
  br label %125, !dbg !443

118:                                              ; preds = %112, %92
  %119 = phi i16 [ %115, %112 ], [ 0, %92 ], !dbg !389
  %120 = call i16 @llvm.bswap.i16(i16 %119), !dbg !375
  store i16 %120, ptr %62, align 2, !dbg !444, !tbaa !445
  %121 = load i32, ptr %41, align 4, !dbg !446, !tbaa !447
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #5, !dbg !442
  tail call void @llvm.dbg.value(metadata i32 %121, metadata !296, metadata !DIExpression()), !dbg !299
  %122 = icmp sgt i32 %121, 0, !dbg !449
  br i1 %122, label %123, label %125, !dbg !443

123:                                              ; preds = %118
  %124 = call i64 inttoptr (i64 23 to ptr)(i32 noundef %121, i64 noundef 1) #5, !dbg !451
  br label %130, !dbg !453

125:                                              ; preds = %116, %118
  %126 = phi i32 [ %121, %118 ], [ %117, %116 ]
  %127 = freeze i32 %126, !dbg !454
  %128 = icmp eq i32 %127, -1, !dbg !454
  br i1 %128, label %129, label %130, !dbg !456

129:                                              ; preds = %125
  br label %130, !dbg !456

130:                                              ; preds = %21, %23, %129, %125, %123, %1
  %131 = phi i32 [ 0, %1 ], [ 7, %123 ], [ 2, %129 ], [ 0, %125 ], [ 0, %23 ], [ 0, %21 ], !dbg !299
  ret i32 %131, !dbg !457
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.bswap.i32(i32) #2

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.bswap.i16(i16) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.assign(metadata, metadata, metadata, metadata, metadata, metadata) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!282, !283, !284, !285, !286}
!llvm.ident = !{!287}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 177, type: !281, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !42, globals: !49, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "translate_redirect_subpod_ipv4_tc.c", directory: "/home/togoetha/projects/service/xdp-progs/multi-runtime-cni-ipv4", checksumkind: CSK_MD5, checksum: "c4c1a8274b3c986f693e542138195250")
!4 = !{!5, !10}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 5937, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "8106ce79fb72e4cfc709095592a01f1d")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9}
!9 = !DIEnumerator(name: "BPF_F_INGRESS", value: 1)
!10 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !11, line: 29, baseType: !7, size: 32, elements: !12)
!11 = !DIFile(filename: "/usr/include/linux/in.h", directory: "", checksumkind: CSK_MD5, checksum: "fcee415bb19db8acb968eeda6f02fa29")
!12 = !{!13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41}
!13 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!14 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!15 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!16 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!17 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!18 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!19 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!20 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!21 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!22 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!23 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!24 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!25 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!26 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!27 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!28 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!29 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!30 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!31 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!32 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!33 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!34 = !DIEnumerator(name: "IPPROTO_L2TP", value: 115)
!35 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!36 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!37 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!38 = !DIEnumerator(name: "IPPROTO_ETHERNET", value: 143)
!39 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!40 = !DIEnumerator(name: "IPPROTO_MPTCP", value: 262)
!41 = !DIEnumerator(name: "IPPROTO_MAX", value: 263)
!42 = !{!43, !44, !45, !47}
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!44 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !46, line: 27, baseType: !7)
!46 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !46, line: 24, baseType: !48)
!48 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!49 = !{!0, !50, !78, !257, !262, !269, !276}
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "tc_redirect_map", scope: !2, file: !3, line: 38, type: !52, isLocal: false, isDefinition: true)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 33, size: 256, elements: !53)
!53 = !{!54, !60, !65, !67}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !52, file: !3, line: 34, baseType: !55, size: 64)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !57, size: 288, elements: !58)
!57 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!58 = !{!59}
!59 = !DISubrange(count: 9)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !52, file: !3, line: 35, baseType: !61, size: 64, offset: 64)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !57, size: 2048, elements: !63)
!63 = !{!64}
!64 = !DISubrange(count: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !52, file: !3, line: 36, baseType: !66, size: 64, offset: 128)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !52, file: !3, line: 37, baseType: !68, size: 64, offset: 192)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "redirect_route", file: !3, line: 27, size: 128, elements: !70)
!70 = !{!71, !72, !77}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !69, file: !3, line: 28, baseType: !45, size: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "smac", scope: !69, file: !3, line: 29, baseType: !73, size: 48, offset: 32)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !74, size: 48, elements: !75)
!74 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!75 = !{!76}
!76 = !DISubrange(count: 6)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "dmac", scope: !69, file: !3, line: 30, baseType: !73, size: 48, offset: 80)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "____fmt", scope: !80, file: !3, line: 86, type: !254, isLocal: true, isDefinition: true)
!80 = distinct !DISubprogram(name: "ipv4_redirect_handle", scope: !3, file: !3, line: 74, type: !81, scopeLine: 74, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !191)
!81 = !DISubroutineType(types: !82)
!82 = !{!57, !83, !184}
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sk_buff", file: !6, line: 6111, size: 1536, elements: !85)
!85 = !{!86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !96, !97, !98, !102, !103, !104, !105, !106, !107, !108, !109, !110, !114, !115, !116, !117, !118, !154, !157, !158, !159, !181, !182, !183}
!86 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !84, file: !6, line: 6112, baseType: !45, size: 32)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_type", scope: !84, file: !6, line: 6113, baseType: !45, size: 32, offset: 32)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !84, file: !6, line: 6114, baseType: !45, size: 32, offset: 64)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "queue_mapping", scope: !84, file: !6, line: 6115, baseType: !45, size: 32, offset: 96)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !84, file: !6, line: 6116, baseType: !45, size: 32, offset: 128)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_present", scope: !84, file: !6, line: 6117, baseType: !45, size: 32, offset: 160)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_tci", scope: !84, file: !6, line: 6118, baseType: !45, size: 32, offset: 192)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_proto", scope: !84, file: !6, line: 6119, baseType: !45, size: 32, offset: 224)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !84, file: !6, line: 6120, baseType: !45, size: 32, offset: 256)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !84, file: !6, line: 6121, baseType: !45, size: 32, offset: 288)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !84, file: !6, line: 6122, baseType: !45, size: 32, offset: 320)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "tc_index", scope: !84, file: !6, line: 6123, baseType: !45, size: 32, offset: 352)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "cb", scope: !84, file: !6, line: 6124, baseType: !99, size: 160, offset: 384)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 160, elements: !100)
!100 = !{!101}
!101 = !DISubrange(count: 5)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "hash", scope: !84, file: !6, line: 6125, baseType: !45, size: 32, offset: 544)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "tc_classid", scope: !84, file: !6, line: 6126, baseType: !45, size: 32, offset: 576)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !84, file: !6, line: 6127, baseType: !45, size: 32, offset: 608)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !84, file: !6, line: 6128, baseType: !45, size: 32, offset: 640)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "napi_id", scope: !84, file: !6, line: 6129, baseType: !45, size: 32, offset: 672)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !84, file: !6, line: 6132, baseType: !45, size: 32, offset: 704)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !84, file: !6, line: 6133, baseType: !45, size: 32, offset: 736)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !84, file: !6, line: 6134, baseType: !45, size: 32, offset: 768)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !84, file: !6, line: 6135, baseType: !111, size: 128, offset: 800)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 128, elements: !112)
!112 = !{!113}
!113 = !DISubrange(count: 4)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !84, file: !6, line: 6136, baseType: !111, size: 128, offset: 928)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !84, file: !6, line: 6137, baseType: !45, size: 32, offset: 1056)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !84, file: !6, line: 6138, baseType: !45, size: 32, offset: 1088)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !84, file: !6, line: 6141, baseType: !45, size: 32, offset: 1120)
!118 = !DIDerivedType(tag: DW_TAG_member, scope: !84, file: !6, line: 6142, baseType: !119, size: 64, align: 64, offset: 1152)
!119 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !84, file: !6, line: 6142, size: 64, align: 64, elements: !120)
!120 = !{!121}
!121 = !DIDerivedType(tag: DW_TAG_member, name: "flow_keys", scope: !119, file: !6, line: 6142, baseType: !122, size: 64)
!122 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !123, size: 64)
!123 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_flow_keys", file: !6, line: 7128, size: 448, elements: !124)
!124 = !{!125, !126, !127, !128, !130, !131, !132, !133, !136, !137, !138, !152, !153}
!125 = !DIDerivedType(tag: DW_TAG_member, name: "nhoff", scope: !123, file: !6, line: 7129, baseType: !47, size: 16)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "thoff", scope: !123, file: !6, line: 7130, baseType: !47, size: 16, offset: 16)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "addr_proto", scope: !123, file: !6, line: 7131, baseType: !47, size: 16, offset: 32)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "is_frag", scope: !123, file: !6, line: 7132, baseType: !129, size: 8, offset: 48)
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !46, line: 21, baseType: !74)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "is_first_frag", scope: !123, file: !6, line: 7133, baseType: !129, size: 8, offset: 56)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "is_encap", scope: !123, file: !6, line: 7134, baseType: !129, size: 8, offset: 64)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !123, file: !6, line: 7135, baseType: !129, size: 8, offset: 72)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "n_proto", scope: !123, file: !6, line: 7136, baseType: !134, size: 16, offset: 80)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !135, line: 32, baseType: !47)
!135 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "bf9fbc0e8f60927fef9d8917535375a6")
!136 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !123, file: !6, line: 7137, baseType: !134, size: 16, offset: 96)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !123, file: !6, line: 7138, baseType: !134, size: 16, offset: 112)
!138 = !DIDerivedType(tag: DW_TAG_member, scope: !123, file: !6, line: 7139, baseType: !139, size: 256, offset: 128)
!139 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !123, file: !6, line: 7139, size: 256, elements: !140)
!140 = !{!141, !147}
!141 = !DIDerivedType(tag: DW_TAG_member, scope: !139, file: !6, line: 7140, baseType: !142, size: 64)
!142 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !139, file: !6, line: 7140, size: 64, elements: !143)
!143 = !{!144, !146}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !142, file: !6, line: 7141, baseType: !145, size: 32)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !135, line: 34, baseType: !45)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !142, file: !6, line: 7142, baseType: !145, size: 32, offset: 32)
!147 = !DIDerivedType(tag: DW_TAG_member, scope: !139, file: !6, line: 7144, baseType: !148, size: 256)
!148 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !139, file: !6, line: 7144, size: 256, elements: !149)
!149 = !{!150, !151}
!150 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !148, file: !6, line: 7145, baseType: !111, size: 128)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !148, file: !6, line: 7146, baseType: !111, size: 128, offset: 128)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !123, file: !6, line: 7149, baseType: !45, size: 32, offset: 384)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "flow_label", scope: !123, file: !6, line: 7150, baseType: !145, size: 32, offset: 416)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp", scope: !84, file: !6, line: 6143, baseType: !155, size: 64, offset: 1216)
!155 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !46, line: 31, baseType: !156)
!156 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "wire_len", scope: !84, file: !6, line: 6144, baseType: !45, size: 32, offset: 1280)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "gso_segs", scope: !84, file: !6, line: 6145, baseType: !45, size: 32, offset: 1312)
!159 = !DIDerivedType(tag: DW_TAG_member, scope: !84, file: !6, line: 6146, baseType: !160, size: 64, align: 64, offset: 1344)
!160 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !84, file: !6, line: 6146, size: 64, align: 64, elements: !161)
!161 = !{!162}
!162 = !DIDerivedType(tag: DW_TAG_member, name: "sk", scope: !160, file: !6, line: 6146, baseType: !163, size: 64)
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!164 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock", file: !6, line: 6215, size: 640, elements: !165)
!165 = !{!166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176, !177, !178, !179}
!166 = !DIDerivedType(tag: DW_TAG_member, name: "bound_dev_if", scope: !164, file: !6, line: 6216, baseType: !45, size: 32)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !164, file: !6, line: 6217, baseType: !45, size: 32, offset: 32)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !164, file: !6, line: 6218, baseType: !45, size: 32, offset: 64)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !164, file: !6, line: 6219, baseType: !45, size: 32, offset: 96)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !164, file: !6, line: 6220, baseType: !45, size: 32, offset: 128)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !164, file: !6, line: 6221, baseType: !45, size: 32, offset: 160)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip4", scope: !164, file: !6, line: 6223, baseType: !45, size: 32, offset: 192)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip6", scope: !164, file: !6, line: 6224, baseType: !111, size: 128, offset: 224)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !164, file: !6, line: 6225, baseType: !45, size: 32, offset: 352)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !164, file: !6, line: 6226, baseType: !134, size: 16, offset: 384)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip4", scope: !164, file: !6, line: 6228, baseType: !45, size: 32, offset: 416)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip6", scope: !164, file: !6, line: 6229, baseType: !111, size: 128, offset: 448)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !164, file: !6, line: 6230, baseType: !45, size: 32, offset: 576)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_mapping", scope: !164, file: !6, line: 6231, baseType: !180, size: 32, offset: 608)
!180 = !DIDerivedType(tag: DW_TAG_typedef, name: "__s32", file: !46, line: 26, baseType: !57)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "gso_size", scope: !84, file: !6, line: 6147, baseType: !45, size: 32, offset: 1408)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp_type", scope: !84, file: !6, line: 6148, baseType: !129, size: 8, offset: 1440)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "hwtstamp", scope: !84, file: !6, line: 6150, baseType: !155, size: 64, offset: 1472)
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !185, size: 64)
!185 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !186, line: 173, size: 112, elements: !187)
!186 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!187 = !{!188, !189, !190}
!188 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !185, file: !186, line: 174, baseType: !73, size: 48)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !185, file: !186, line: 175, baseType: !73, size: 48, offset: 48)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !185, file: !186, line: 176, baseType: !134, size: 16, offset: 96)
!191 = !{!192, !193, !194, !195, !223, !224, !225, !226, !227, !230}
!192 = !DILocalVariable(name: "skb", arg: 1, scope: !80, file: !3, line: 74, type: !83)
!193 = !DILocalVariable(name: "ethh", arg: 2, scope: !80, file: !3, line: 74, type: !184)
!194 = !DILocalVariable(name: "data_end", scope: !80, file: !3, line: 75, type: !43)
!195 = !DILocalVariable(name: "iph", scope: !80, file: !3, line: 77, type: !196)
!196 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !197, size: 64)
!197 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !198, line: 87, size: 160, elements: !199)
!198 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!199 = !{!200, !201, !202, !203, !204, !205, !206, !207, !208, !210}
!200 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !197, file: !198, line: 89, baseType: !129, size: 4, flags: DIFlagBitField, extraData: i64 0)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !197, file: !198, line: 90, baseType: !129, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !197, file: !198, line: 97, baseType: !129, size: 8, offset: 8)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !197, file: !198, line: 98, baseType: !134, size: 16, offset: 16)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !197, file: !198, line: 99, baseType: !134, size: 16, offset: 32)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !197, file: !198, line: 100, baseType: !134, size: 16, offset: 48)
!206 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !197, file: !198, line: 101, baseType: !129, size: 8, offset: 64)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !197, file: !198, line: 102, baseType: !129, size: 8, offset: 72)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !197, file: !198, line: 103, baseType: !209, size: 16, offset: 80)
!209 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !135, line: 38, baseType: !47)
!210 = !DIDerivedType(tag: DW_TAG_member, scope: !197, file: !198, line: 104, baseType: !211, size: 64, offset: 96)
!211 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !197, file: !198, line: 104, size: 64, elements: !212)
!212 = !{!213, !218}
!213 = !DIDerivedType(tag: DW_TAG_member, scope: !211, file: !198, line: 104, baseType: !214, size: 64)
!214 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !211, file: !198, line: 104, size: 64, elements: !215)
!215 = !{!216, !217}
!216 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !214, file: !198, line: 104, baseType: !145, size: 32)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !214, file: !198, line: 104, baseType: !145, size: 32, offset: 32)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !211, file: !198, line: 104, baseType: !219, size: 64)
!219 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !211, file: !198, line: 104, size: 64, elements: !220)
!220 = !{!221, !222}
!221 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !219, file: !198, line: 104, baseType: !145, size: 32)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !219, file: !198, line: 104, baseType: !145, size: 32, offset: 32)
!223 = !DILocalVariable(name: "ip_dst_addr", scope: !80, file: !3, line: 91, type: !45)
!224 = !DILocalVariable(name: "ip_src_addr", scope: !80, file: !3, line: 92, type: !45)
!225 = !DILocalVariable(name: "lhinfo", scope: !80, file: !3, line: 102, type: !68)
!226 = !DILocalVariable(name: "haddr", scope: !80, file: !3, line: 104, type: !45)
!227 = !DILocalVariable(name: "defaddr", scope: !228, file: !3, line: 111, type: !45)
!228 = distinct !DILexicalBlock(scope: !229, file: !3, line: 109, column: 19)
!229 = distinct !DILexicalBlock(scope: !80, file: !3, line: 109, column: 6)
!230 = !DILocalVariable(name: "tcph", scope: !231, file: !3, line: 123, type: !233)
!231 = distinct !DILexicalBlock(scope: !232, file: !3, line: 122, column: 36)
!232 = distinct !DILexicalBlock(scope: !80, file: !3, line: 122, column: 6)
!233 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !234, size: 64)
!234 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !235, line: 25, size: 160, elements: !236)
!235 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "", checksumkind: CSK_MD5, checksum: "bd53e42c49642a86fd7da9761b6f86eb")
!236 = !{!237, !238, !239, !240, !241, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253}
!237 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !234, file: !235, line: 26, baseType: !134, size: 16)
!238 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !234, file: !235, line: 27, baseType: !134, size: 16, offset: 16)
!239 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !234, file: !235, line: 28, baseType: !145, size: 32, offset: 32)
!240 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !234, file: !235, line: 29, baseType: !145, size: 32, offset: 64)
!241 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !234, file: !235, line: 31, baseType: !47, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!242 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !234, file: !235, line: 32, baseType: !47, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!243 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !234, file: !235, line: 33, baseType: !47, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!244 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !234, file: !235, line: 34, baseType: !47, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !234, file: !235, line: 35, baseType: !47, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!246 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !234, file: !235, line: 36, baseType: !47, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!247 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !234, file: !235, line: 37, baseType: !47, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !234, file: !235, line: 38, baseType: !47, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!249 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !234, file: !235, line: 39, baseType: !47, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!250 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !234, file: !235, line: 40, baseType: !47, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!251 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !234, file: !235, line: 55, baseType: !134, size: 16, offset: 112)
!252 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !234, file: !235, line: 56, baseType: !209, size: 16, offset: 128)
!253 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !234, file: !235, line: 57, baseType: !134, size: 16, offset: 144)
!254 = !DICompositeType(tag: DW_TAG_array_type, baseType: !255, size: 72, elements: !58)
!255 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !256)
!256 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!257 = !DIGlobalVariableExpression(var: !258, expr: !DIExpression())
!258 = distinct !DIGlobalVariable(name: "____fmt", scope: !80, file: !3, line: 117, type: !259, isLocal: true, isDefinition: true)
!259 = !DICompositeType(tag: DW_TAG_array_type, baseType: !255, size: 184, elements: !260)
!260 = !{!261}
!261 = !DISubrange(count: 23)
!262 = !DIGlobalVariableExpression(var: !263, expr: !DIExpression(DW_OP_constu, 6, DW_OP_stack_value))
!263 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !264, line: 177, type: !265, isLocal: true, isDefinition: true)
!264 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "09cfcd7169c24bec448f30582e8c6db9")
!265 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !266, size: 64)
!266 = !DISubroutineType(types: !267)
!267 = !{!44, !268, !45, null}
!268 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !255, size: 64)
!269 = !DIGlobalVariableExpression(var: !270, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!270 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !264, line: 56, type: !271, isLocal: true, isDefinition: true)
!271 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !272, size: 64)
!272 = !DISubroutineType(types: !273)
!273 = !{!43, !43, !274}
!274 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !275, size: 64)
!275 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!276 = !DIGlobalVariableExpression(var: !277, expr: !DIExpression(DW_OP_constu, 23, DW_OP_stack_value))
!277 = distinct !DIGlobalVariable(name: "bpf_redirect", scope: !2, file: !264, line: 621, type: !278, isLocal: true, isDefinition: true)
!278 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !279, size: 64)
!279 = !DISubroutineType(types: !280)
!280 = !{!44, !45, !155}
!281 = !DICompositeType(tag: DW_TAG_array_type, baseType: !256, size: 32, elements: !112)
!282 = !{i32 7, !"Dwarf Version", i32 5}
!283 = !{i32 2, !"Debug Info Version", i32 3}
!284 = !{i32 1, !"wchar_size", i32 4}
!285 = !{i32 7, !"frame-pointer", i32 2}
!286 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!287 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!288 = distinct !DISubprogram(name: "tc_subpodredirect", scope: !3, file: !3, line: 151, type: !289, scopeLine: 151, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !291)
!289 = !DISubroutineType(types: !290)
!290 = !{!57, !83}
!291 = !{!292, !293, !294, !295, !296}
!292 = !DILocalVariable(name: "skb", arg: 1, scope: !288, file: !3, line: 151, type: !83)
!293 = !DILocalVariable(name: "data_end", scope: !288, file: !3, line: 152, type: !43)
!294 = !DILocalVariable(name: "data", scope: !288, file: !3, line: 153, type: !43)
!295 = !DILocalVariable(name: "ethh", scope: !288, file: !3, line: 156, type: !184)
!296 = !DILocalVariable(name: "interface", scope: !288, file: !3, line: 162, type: !57)
!297 = distinct !DIAssignID()
!298 = distinct !DIAssignID()
!299 = !DILocation(line: 0, scope: !288)
!300 = !DILocation(line: 152, column: 38, scope: !288)
!301 = !{!302, !303, i64 80}
!302 = !{!"__sk_buff", !303, i64 0, !303, i64 4, !303, i64 8, !303, i64 12, !303, i64 16, !303, i64 20, !303, i64 24, !303, i64 28, !303, i64 32, !303, i64 36, !303, i64 40, !303, i64 44, !304, i64 48, !303, i64 68, !303, i64 72, !303, i64 76, !303, i64 80, !303, i64 84, !303, i64 88, !303, i64 92, !303, i64 96, !304, i64 100, !304, i64 116, !303, i64 132, !303, i64 136, !303, i64 140, !304, i64 144, !306, i64 152, !303, i64 160, !303, i64 164, !304, i64 168, !303, i64 176, !304, i64 180, !306, i64 184}
!303 = !{!"int", !304, i64 0}
!304 = !{!"omnipotent char", !305, i64 0}
!305 = !{!"Simple C/C++ TBAA"}
!306 = !{!"long long", !304, i64 0}
!307 = !DILocation(line: 152, column: 27, scope: !288)
!308 = !DILocation(line: 152, column: 19, scope: !288)
!309 = !DILocation(line: 153, column: 38, scope: !288)
!310 = !{!302, !303, i64 76}
!311 = !DILocation(line: 153, column: 27, scope: !288)
!312 = !DILocation(line: 153, column: 19, scope: !288)
!313 = !DILocation(line: 157, column: 20, scope: !314)
!314 = distinct !DILexicalBlock(scope: !288, file: !3, line: 157, column: 6)
!315 = !DILocation(line: 157, column: 25, scope: !314)
!316 = !DILocation(line: 0, scope: !80, inlinedAt: !317)
!317 = distinct !DILocation(line: 162, column: 18, scope: !288)
!318 = !DILocation(line: 0, scope: !228, inlinedAt: !317)
!319 = !DILocation(line: 157, column: 6, scope: !288)
!320 = !DILocation(line: 85, column: 11, scope: !321, inlinedAt: !317)
!321 = distinct !DILexicalBlock(scope: !80, file: !3, line: 85, column: 6)
!322 = !DILocation(line: 85, column: 19, scope: !321, inlinedAt: !317)
!323 = !DILocation(line: 85, column: 6, scope: !80, inlinedAt: !317)
!324 = !DILocation(line: 86, column: 3, scope: !325, inlinedAt: !317)
!325 = distinct !DILexicalBlock(scope: !326, file: !3, line: 86, column: 3)
!326 = distinct !DILexicalBlock(scope: !321, file: !3, line: 85, column: 25)
!327 = !DILocation(line: 87, column: 3, scope: !326, inlinedAt: !317)
!328 = !DILocation(line: 91, column: 27, scope: !80, inlinedAt: !317)
!329 = !{!304, !304, i64 0}
!330 = !DILocation(line: 92, column: 27, scope: !80, inlinedAt: !317)
!331 = !DILocation(line: 96, column: 14, scope: !80, inlinedAt: !317)
!332 = !DILocation(line: 97, column: 14, scope: !80, inlinedAt: !317)
!333 = !DILocation(line: 98, column: 18, scope: !334, inlinedAt: !317)
!334 = distinct !DILexicalBlock(scope: !80, file: !3, line: 98, column: 6)
!335 = !DILocation(line: 98, column: 6, scope: !80, inlinedAt: !317)
!336 = !DILocation(line: 104, column: 2, scope: !80, inlinedAt: !317)
!337 = !DILocation(line: 104, column: 16, scope: !80, inlinedAt: !317)
!338 = !DILocation(line: 104, column: 8, scope: !80, inlinedAt: !317)
!339 = !{!303, !303, i64 0}
!340 = distinct !DIAssignID()
!341 = !DILocation(line: 106, column: 11, scope: !80, inlinedAt: !317)
!342 = !DILocation(line: 109, column: 13, scope: !229, inlinedAt: !317)
!343 = !DILocation(line: 109, column: 6, scope: !80, inlinedAt: !317)
!344 = !DILocation(line: 111, column: 3, scope: !228, inlinedAt: !317)
!345 = !DILocation(line: 111, column: 9, scope: !228, inlinedAt: !317)
!346 = distinct !DIAssignID()
!347 = !DILocation(line: 112, column: 12, scope: !228, inlinedAt: !317)
!348 = !DILocation(line: 113, column: 2, scope: !229, inlinedAt: !317)
!349 = !DILocation(line: 115, column: 13, scope: !350, inlinedAt: !317)
!350 = distinct !DILexicalBlock(scope: !80, file: !3, line: 115, column: 6)
!351 = !DILocation(line: 115, column: 6, scope: !80, inlinedAt: !317)
!352 = !DILocation(line: 117, column: 3, scope: !353, inlinedAt: !317)
!353 = distinct !DILexicalBlock(scope: !354, file: !3, line: 117, column: 3)
!354 = distinct !DILexicalBlock(scope: !350, file: !3, line: 115, column: 19)
!355 = !DILocation(line: 118, column: 3, scope: !354, inlinedAt: !317)
!356 = !DILocation(line: 122, column: 11, scope: !232, inlinedAt: !317)
!357 = !{!358, !304, i64 9}
!358 = !{!"iphdr", !304, i64 0, !304, i64 0, !304, i64 1, !359, i64 2, !359, i64 4, !359, i64 6, !304, i64 8, !304, i64 9, !359, i64 10, !304, i64 12}
!359 = !{!"short", !304, i64 0}
!360 = !DILocation(line: 122, column: 20, scope: !232, inlinedAt: !317)
!361 = !DILocation(line: 0, scope: !231, inlinedAt: !317)
!362 = !DILocation(line: 122, column: 6, scope: !80, inlinedAt: !317)
!363 = !DILocation(line: 126, column: 14, scope: !364, inlinedAt: !317)
!364 = distinct !DILexicalBlock(scope: !365, file: !3, line: 126, column: 8)
!365 = distinct !DILexicalBlock(scope: !366, file: !3, line: 125, column: 39)
!366 = distinct !DILexicalBlock(scope: !231, file: !3, line: 125, column: 7)
!367 = !DILocation(line: 126, column: 8, scope: !364, inlinedAt: !317)
!368 = !DILocation(line: 126, column: 8, scope: !365, inlinedAt: !317)
!369 = !DILocation(line: 137, column: 25, scope: !80, inlinedAt: !317)
!370 = !DILocation(line: 137, column: 43, scope: !80, inlinedAt: !317)
!371 = !DILocation(line: 137, column: 2, scope: !80, inlinedAt: !317)
!372 = !DILocation(line: 138, column: 41, scope: !80, inlinedAt: !317)
!373 = !DILocation(line: 138, column: 2, scope: !80, inlinedAt: !317)
!374 = !DILocation(line: 140, column: 13, scope: !80, inlinedAt: !317)
!375 = !DILocation(line: 142, column: 15, scope: !80, inlinedAt: !317)
!376 = !DILocalVariable(name: "packet", arg: 1, scope: !377, file: !3, line: 41, type: !380)
!377 = distinct !DISubprogram(name: "ipv4_check", scope: !3, file: !3, line: 41, type: !378, scopeLine: 41, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !381)
!378 = !DISubroutineType(types: !379)
!379 = !{!47, !380, !47, !43}
!380 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !129, size: 64)
!381 = !{!376, !382, !383, !384, !385, !387, !388}
!382 = !DILocalVariable(name: "len", arg: 2, scope: !377, file: !3, line: 41, type: !47)
!383 = !DILocalVariable(name: "data_end", arg: 3, scope: !377, file: !3, line: 41, type: !43)
!384 = !DILocalVariable(name: "csum", scope: !377, file: !3, line: 42, type: !45)
!385 = !DILocalVariable(name: "i", scope: !386, file: !3, line: 49, type: !57)
!386 = distinct !DILexicalBlock(scope: !377, file: !3, line: 49, column: 5)
!387 = !DILocalVariable(name: "i", scope: !377, file: !3, line: 64, type: !57)
!388 = !DILocalVariable(name: "checksum", scope: !377, file: !3, line: 70, type: !47)
!389 = !DILocation(line: 0, scope: !377, inlinedAt: !390)
!390 = distinct !DILocation(line: 142, column: 15, scope: !80, inlinedAt: !317)
!391 = !DILocation(line: 45, column: 11, scope: !377, inlinedAt: !390)
!392 = !DILocation(line: 45, column: 17, scope: !377, inlinedAt: !390)
!393 = !DILocation(line: 46, column: 11, scope: !377, inlinedAt: !390)
!394 = !DILocation(line: 46, column: 17, scope: !377, inlinedAt: !390)
!395 = !DILocation(line: 0, scope: !386, inlinedAt: !390)
!396 = !DILocation(line: 49, column: 28, scope: !397, inlinedAt: !390)
!397 = distinct !DILexicalBlock(scope: !386, file: !3, line: 49, column: 5)
!398 = !DILocation(line: 49, column: 5, scope: !386, inlinedAt: !390)
!399 = !DILocation(line: 57, column: 10, scope: !400, inlinedAt: !390)
!400 = distinct !DILexicalBlock(scope: !377, file: !3, line: 57, column: 6)
!401 = !DILocation(line: 57, column: 6, scope: !377, inlinedAt: !390)
!402 = !DILocation(line: 50, column: 22, scope: !403, inlinedAt: !390)
!403 = distinct !DILexicalBlock(scope: !404, file: !3, line: 50, column: 7)
!404 = distinct !DILexicalBlock(scope: !397, file: !3, line: 49, column: 46)
!405 = !DILocation(line: 50, column: 27, scope: !403, inlinedAt: !390)
!406 = !DILocation(line: 50, column: 7, scope: !404, inlinedAt: !390)
!407 = !DILocation(line: 51, column: 13, scope: !408, inlinedAt: !390)
!408 = distinct !DILexicalBlock(scope: !403, file: !3, line: 50, column: 40)
!409 = !DILocation(line: 51, column: 12, scope: !408, inlinedAt: !390)
!410 = !DILocation(line: 51, column: 22, scope: !408, inlinedAt: !390)
!411 = !DILocation(line: 51, column: 39, scope: !408, inlinedAt: !390)
!412 = !DILocation(line: 51, column: 31, scope: !408, inlinedAt: !390)
!413 = !DILocation(line: 51, column: 30, scope: !408, inlinedAt: !390)
!414 = !DILocation(line: 51, column: 28, scope: !408, inlinedAt: !390)
!415 = !DILocation(line: 51, column: 9, scope: !408, inlinedAt: !390)
!416 = !DILocation(line: 52, column: 3, scope: !408, inlinedAt: !390)
!417 = !DILocation(line: 55, column: 7, scope: !404, inlinedAt: !390)
!418 = !DILocation(line: 49, column: 41, scope: !397, inlinedAt: !390)
!419 = !DILocation(line: 49, column: 23, scope: !397, inlinedAt: !390)
!420 = distinct !{!420, !398, !421, !422}
!421 = !DILocation(line: 56, column: 5, scope: !386, inlinedAt: !390)
!422 = !{!"llvm.loop.mustprogress"}
!423 = !DILocation(line: 58, column: 22, scope: !424, inlinedAt: !390)
!424 = distinct !DILexicalBlock(scope: !425, file: !3, line: 58, column: 7)
!425 = distinct !DILexicalBlock(scope: !400, file: !3, line: 57, column: 15)
!426 = !DILocation(line: 58, column: 27, scope: !424, inlinedAt: !390)
!427 = !DILocation(line: 58, column: 7, scope: !425, inlinedAt: !390)
!428 = !DILocation(line: 61, column: 12, scope: !425, inlinedAt: !390)
!429 = !DILocation(line: 61, column: 11, scope: !425, inlinedAt: !390)
!430 = !DILocation(line: 61, column: 8, scope: !425, inlinedAt: !390)
!431 = !DILocation(line: 62, column: 2, scope: !425, inlinedAt: !390)
!432 = !DILocation(line: 65, column: 17, scope: !377, inlinedAt: !390)
!433 = !DILocation(line: 65, column: 5, scope: !377, inlinedAt: !390)
!434 = !DILocation(line: 66, column: 22, scope: !435, inlinedAt: !390)
!435 = distinct !DILexicalBlock(scope: !377, file: !3, line: 65, column: 34)
!436 = !DILocation(line: 66, column: 32, scope: !435, inlinedAt: !390)
!437 = !DILocation(line: 67, column: 4, scope: !435, inlinedAt: !390)
!438 = !DILocation(line: 65, column: 23, scope: !377, inlinedAt: !390)
!439 = distinct !{!439, !433, !440, !422}
!440 = !DILocation(line: 68, column: 2, scope: !377, inlinedAt: !390)
!441 = !DILocation(line: 70, column: 22, scope: !377, inlinedAt: !390)
!442 = !DILocation(line: 146, column: 1, scope: !80, inlinedAt: !317)
!443 = !DILocation(line: 164, column: 6, scope: !288)
!444 = !DILocation(line: 142, column: 13, scope: !80, inlinedAt: !317)
!445 = !{!358, !359, i64 10}
!446 = !DILocation(line: 145, column: 17, scope: !80, inlinedAt: !317)
!447 = !{!448, !303, i64 0}
!448 = !{!"redirect_route", !303, i64 0, !304, i64 4, !304, i64 10}
!449 = !DILocation(line: 164, column: 16, scope: !450)
!450 = distinct !DILexicalBlock(scope: !288, file: !3, line: 164, column: 6)
!451 = !DILocation(line: 166, column: 3, scope: !452)
!452 = distinct !DILexicalBlock(scope: !450, file: !3, line: 164, column: 21)
!453 = !DILocation(line: 168, column: 3, scope: !452)
!454 = !DILocation(line: 169, column: 23, scope: !455)
!455 = distinct !DILexicalBlock(scope: !450, file: !3, line: 169, column: 13)
!456 = !DILocation(line: 0, scope: !455)
!457 = !DILocation(line: 174, column: 1, scope: !288)
