; ModuleID = 'translate_redirect_lh_ipv4_tc.c'
source_filename = "translate_redirect_lh_ipv4_tc.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.__sk_buff = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [5 x i32], i32, i32, i32, i32, i32, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, %union.anon, i64, i32, i32, %union.anon.0, i32, i8, [3 x i8], i64 }
%union.anon = type { ptr }
%union.anon.0 = type { ptr }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@tc_lhredirect.____fmt = internal constant [7 x i8] c"start\0A\00", align 1, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !120
@tc_redirect_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !124
@ipv4_redirect_handle.____fmt = internal constant [12 x i8] c"ipv4 check\0A\00", align 1, !dbg !153
@ipv4_redirect_handle.____fmt.1 = internal constant [9 x i8] c"no ipv4\0A\00", align 1, !dbg !207
@ipv4_redirect_handle.____fmt.2 = internal constant [17 x i8] c"localhost check\0A\00", align 1, !dbg !210
@ipv4_redirect_handle.____fmt.3 = internal constant [25 x i8] c"no localhost route found\00", align 1, !dbg !215
@ipv4_redirect_handle.____fmt.4 = internal constant [8 x i8] c"lh info\00", align 1, !dbg !220
@ipv4_redirect_handle.____fmt.5 = internal constant [13 x i8] c"ip check %x\0A\00", align 1, !dbg !225
@ipv4_check.____fmt = internal constant [10 x i8] c"csum %08x\00", align 1, !dbg !237
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @tc_lhredirect, ptr @tc_redirect_map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local noundef i32 @tc_lhredirect(ptr nocapture noundef readonly %0) #0 section "tc" !dbg !2 {
  %2 = alloca i32, align 4, !DIAssignID !269
  tail call void @llvm.dbg.value(metadata ptr %0, metadata !256, metadata !DIExpression()), !dbg !270
  %3 = getelementptr inbounds %struct.__sk_buff, ptr %0, i64 0, i32 16, !dbg !271
  %4 = load i32, ptr %3, align 8, !dbg !271, !tbaa !272
  %5 = zext i32 %4 to i64, !dbg !278
  %6 = inttoptr i64 %5 to ptr, !dbg !279
  tail call void @llvm.dbg.value(metadata ptr %6, metadata !257, metadata !DIExpression()), !dbg !270
  %7 = getelementptr inbounds %struct.__sk_buff, ptr %0, i64 0, i32 15, !dbg !280
  %8 = load i32, ptr %7, align 4, !dbg !280, !tbaa !281
  %9 = zext i32 %8 to i64, !dbg !282
  %10 = inttoptr i64 %9 to ptr, !dbg !283
  tail call void @llvm.dbg.value(metadata ptr %10, metadata !258, metadata !DIExpression()), !dbg !270
  %11 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @tc_lhredirect.____fmt, i32 noundef 7) #4, !dbg !284
  tail call void @llvm.dbg.value(metadata ptr %10, metadata !259, metadata !DIExpression()), !dbg !270
  %12 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 1, !dbg !286
  %13 = icmp ugt ptr %12, %6, !dbg !288
  br i1 %13, label %111, label %14, !dbg !289

14:                                               ; preds = %1
  call void @llvm.dbg.assign(metadata i1 undef, metadata !203, metadata !DIExpression(), metadata !269, metadata ptr %2, metadata !DIExpression()), !dbg !290
  call void @llvm.dbg.value(metadata ptr %0, metadata !169, metadata !DIExpression()), !dbg !290
  call void @llvm.dbg.value(metadata ptr %10, metadata !170, metadata !DIExpression()), !dbg !290
  %15 = load i32, ptr %3, align 8, !dbg !292, !tbaa !272
  %16 = zext i32 %15 to i64, !dbg !293
  %17 = inttoptr i64 %16 to ptr, !dbg !294
  call void @llvm.dbg.value(metadata ptr %17, metadata !171, metadata !DIExpression()), !dbg !290
  call void @llvm.dbg.value(metadata ptr %12, metadata !172, metadata !DIExpression()), !dbg !290
  %18 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 2, i32 1, !dbg !295
  %19 = icmp ugt ptr %18, %17, !dbg !297
  br i1 %19, label %111, label %20, !dbg !298

20:                                               ; preds = %14
  %21 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt, i32 noundef 12) #4, !dbg !299
  %22 = load i8, ptr %12, align 4, !dbg !301
  %23 = and i8 %22, -16, !dbg !303
  %24 = icmp eq i8 %23, 64, !dbg !303
  br i1 %24, label %27, label %25, !dbg !304

25:                                               ; preds = %20
  %26 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.1, i32 noundef 9) #4, !dbg !305
  br label %111, !dbg !308

27:                                               ; preds = %20
  %28 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.2, i32 noundef 17) #4, !dbg !309
  %29 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 1, i32 2, !dbg !311
  %30 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 2, i32 0, i64 2, !dbg !311
  %31 = load i32, ptr %30, align 4, !dbg !311, !tbaa !312
  call void @llvm.dbg.value(metadata i32 %31, metadata !200, metadata !DIExpression()), !dbg !290
  %32 = load i32, ptr %29, align 4, !dbg !313, !tbaa !312
  call void @llvm.dbg.value(metadata i32 %32, metadata !201, metadata !DIExpression()), !dbg !290
  %33 = and i32 %31, -117440513, !dbg !314
  call void @llvm.dbg.value(metadata i32 %33, metadata !200, metadata !DIExpression()), !dbg !290
  %34 = and i32 %32, -117440513, !dbg !315
  call void @llvm.dbg.value(metadata i32 %34, metadata !201, metadata !DIExpression()), !dbg !290
  %35 = icmp ne i32 %33, %34, !dbg !316
  %36 = icmp eq i32 %32, %34
  %37 = or i1 %35, %36, !dbg !318
  br i1 %37, label %111, label %38, !dbg !318

38:                                               ; preds = %27
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #4, !dbg !319
  store i32 0, ptr %2, align 4, !dbg !320, !tbaa !321, !DIAssignID !322
  call void @llvm.dbg.assign(metadata i32 0, metadata !203, metadata !DIExpression(), metadata !322, metadata ptr %2, metadata !DIExpression()), !dbg !290
  %39 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tc_redirect_map, ptr noundef nonnull %2) #4, !dbg !323
  call void @llvm.dbg.value(metadata ptr %39, metadata !202, metadata !DIExpression()), !dbg !290
  %40 = icmp eq ptr %39, null, !dbg !324
  br i1 %40, label %41, label %43, !dbg !326

41:                                               ; preds = %38
  %42 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.3, i32 noundef 25) #4, !dbg !327
  br label %110, !dbg !330

43:                                               ; preds = %38
  %44 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.4, i32 noundef 8) #4, !dbg !331
  %45 = load i32, ptr %39, align 4, !dbg !333, !tbaa !334
  %46 = call i32 @llvm.bswap.i32(i32 %45), !dbg !333
  store i32 %46, ptr %29, align 4, !dbg !336, !tbaa !312
  %47 = load i8, ptr %12, align 4, !dbg !337
  %48 = shl i8 %47, 2, !dbg !337
  %49 = and i8 %48, 60, !dbg !337
  call void @llvm.dbg.value(metadata ptr %12, metadata !244, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %49, metadata !245, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !338
  call void @llvm.dbg.value(metadata ptr %17, metadata !246, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i32 0, metadata !247, metadata !DIExpression()), !dbg !338
  %50 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 1, i32 1, i64 4, !dbg !340
  store i8 0, ptr %50, align 1, !dbg !341, !tbaa !312
  %51 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 1, i32 1, i64 5, !dbg !342
  store i8 0, ptr %51, align 1, !dbg !343, !tbaa !312
  call void @llvm.dbg.value(metadata i32 0, metadata !248, metadata !DIExpression()), !dbg !344
  call void @llvm.dbg.value(metadata ptr %12, metadata !244, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i32 0, metadata !247, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %49, metadata !245, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !338
  %52 = icmp eq i8 %49, 0, !dbg !345
  br i1 %52, label %100, label %53, !dbg !347

53:                                               ; preds = %43
  %54 = zext nneg i8 %49 to i16, !dbg !337
  call void @llvm.dbg.value(metadata i16 %54, metadata !245, metadata !DIExpression()), !dbg !338
  br label %57, !dbg !347

55:                                               ; preds = %73
  %56 = icmp eq i16 %75, 0, !dbg !348
  br i1 %56, label %87, label %80, !dbg !350

57:                                               ; preds = %53, %73
  %58 = phi ptr [ %62, %73 ], [ %12, %53 ]
  %59 = phi i32 [ %76, %73 ], [ 0, %53 ]
  %60 = phi i32 [ %74, %73 ], [ 0, %53 ]
  %61 = phi i16 [ %75, %73 ], [ %54, %53 ]
  call void @llvm.dbg.value(metadata ptr %58, metadata !244, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i32 %59, metadata !248, metadata !DIExpression()), !dbg !344
  call void @llvm.dbg.value(metadata i32 %60, metadata !247, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i16 %61, metadata !245, metadata !DIExpression()), !dbg !338
  %62 = getelementptr inbounds i8, ptr %58, i64 2, !dbg !351
  %63 = icmp ugt ptr %62, %17, !dbg !354
  br i1 %63, label %73, label %64, !dbg !355

64:                                               ; preds = %57
  %65 = load i8, ptr %58, align 1, !dbg !356, !tbaa !312
  %66 = zext i8 %65 to i32, !dbg !358
  %67 = shl nuw nsw i32 %66, 8, !dbg !359
  %68 = getelementptr inbounds i8, ptr %58, i64 1, !dbg !360
  %69 = load i8, ptr %68, align 1, !dbg !361, !tbaa !312
  %70 = zext i8 %69 to i32, !dbg !362
  %71 = or disjoint i32 %67, %70, !dbg !363
  %72 = add i32 %71, %60, !dbg !364
  call void @llvm.dbg.value(metadata i32 %72, metadata !247, metadata !DIExpression()), !dbg !338
  br label %73, !dbg !365

73:                                               ; preds = %64, %57
  %74 = phi i32 [ %72, %64 ], [ %60, %57 ], !dbg !338
  call void @llvm.dbg.value(metadata i32 %74, metadata !247, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata ptr %62, metadata !244, metadata !DIExpression()), !dbg !338
  %75 = add nsw i16 %61, -2, !dbg !366
  call void @llvm.dbg.value(metadata i16 %75, metadata !245, metadata !DIExpression()), !dbg !338
  %76 = add nuw nsw i32 %59, 2, !dbg !367
  call void @llvm.dbg.value(metadata i32 %76, metadata !248, metadata !DIExpression()), !dbg !344
  %77 = icmp ult i32 %59, 58, !dbg !368
  %78 = icmp ne i16 %75, 0, !dbg !345
  %79 = select i1 %77, i1 %78, i1 false, !dbg !345
  br i1 %79, label %57, label %55, !dbg !347, !llvm.loop !369

80:                                               ; preds = %55
  %81 = getelementptr inbounds i8, ptr %58, i64 3, !dbg !372
  %82 = icmp ugt ptr %81, %17, !dbg !375
  br i1 %82, label %105, label %83, !dbg !376

83:                                               ; preds = %80
  %84 = load i8, ptr %62, align 1, !dbg !377, !tbaa !312
  %85 = zext i8 %84 to i32, !dbg !378
  %86 = add i32 %74, %85, !dbg !379
  call void @llvm.dbg.value(metadata i32 %86, metadata !247, metadata !DIExpression()), !dbg !338
  br label %87, !dbg !380

87:                                               ; preds = %83, %55
  %88 = phi i32 [ %86, %83 ], [ %74, %55 ], !dbg !338
  call void @llvm.dbg.value(metadata i32 %88, metadata !247, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i32 0, metadata !250, metadata !DIExpression()), !dbg !338
  %89 = icmp ugt i32 %88, 65535, !dbg !381
  br i1 %89, label %90, label %100, !dbg !382

90:                                               ; preds = %87, %90
  %91 = phi i32 [ %96, %90 ], [ 0, %87 ]
  %92 = phi i32 [ %95, %90 ], [ %88, %87 ]
  call void @llvm.dbg.value(metadata i32 %91, metadata !250, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i32 %92, metadata !247, metadata !DIExpression()), !dbg !338
  %93 = lshr i32 %92, 16, !dbg !381
  %94 = and i32 %92, 65535, !dbg !383
  %95 = add nuw nsw i32 %94, %93, !dbg !385
  call void @llvm.dbg.value(metadata i32 %95, metadata !247, metadata !DIExpression()), !dbg !338
  %96 = add nuw nsw i32 %91, 1, !dbg !386
  call void @llvm.dbg.value(metadata i32 %96, metadata !250, metadata !DIExpression()), !dbg !338
  %97 = icmp ugt i32 %95, 65535, !dbg !381
  %98 = icmp ult i32 %91, 15, !dbg !387
  %99 = select i1 %97, i1 %98, i1 false, !dbg !387
  br i1 %99, label %90, label %100, !dbg !382, !llvm.loop !388

100:                                              ; preds = %90, %43, %87
  %101 = phi i32 [ %88, %87 ], [ 0, %43 ], [ %95, %90 ], !dbg !338
  %102 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_check.____fmt, i32 noundef 10, i32 noundef %101) #4, !dbg !390
  %103 = trunc i32 %101 to i16, !dbg !392
  %104 = xor i16 %103, -1, !dbg !392
  call void @llvm.dbg.value(metadata i16 %104, metadata !251, metadata !DIExpression()), !dbg !338
  br label %105

105:                                              ; preds = %80, %100
  %106 = phi i16 [ %104, %100 ], [ 0, %80 ], !dbg !338
  %107 = call i16 @llvm.bswap.i16(i16 %106), !dbg !337
  %108 = zext i16 %107 to i32, !dbg !337
  store i16 %107, ptr %50, align 2, !dbg !393, !tbaa !394
  %109 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.5, i32 noundef 13, i32 noundef %108) #4, !dbg !397
  br label %110, !dbg !399

110:                                              ; preds = %105, %41
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #4, !dbg !400
  br label %111

111:                                              ; preds = %110, %27, %25, %14, %1
  ret i32 0, !dbg !401
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.bswap.i32(i32) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.bswap.i16(i16) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.assign(metadata, metadata, metadata, metadata, metadata, metadata) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!115}
!llvm.module.flags = !{!263, !264, !265, !266, !267}
!llvm.ident = !{!268}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "____fmt", scope: !2, file: !3, line: 129, type: !260, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "tc_lhredirect", scope: !3, file: !3, line: 125, type: !4, scopeLine: 125, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !115, retainedNodes: !255)
!3 = !DIFile(filename: "translate_redirect_lh_ipv4_tc.c", directory: "/home/togoetha/projects/service/xdp-progs/multi-runtime-cni-ipv4", checksumkind: CSK_MD5, checksum: "442e69c0f39652ff0f9a98892f7bda00")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sk_buff", file: !9, line: 6111, size: 1536, elements: !10)
!9 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "8106ce79fb72e4cfc709095592a01f1d")
!10 = !{!11, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !30, !31, !32, !33, !34, !35, !36, !37, !38, !42, !43, !44, !45, !46, !85, !88, !89, !90, !112, !113, !114}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !8, file: !9, line: 6112, baseType: !12, size: 32)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !13, line: 27, baseType: !14)
!13 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!14 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_type", scope: !8, file: !9, line: 6113, baseType: !12, size: 32, offset: 32)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !8, file: !9, line: 6114, baseType: !12, size: 32, offset: 64)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "queue_mapping", scope: !8, file: !9, line: 6115, baseType: !12, size: 32, offset: 96)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !8, file: !9, line: 6116, baseType: !12, size: 32, offset: 128)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_present", scope: !8, file: !9, line: 6117, baseType: !12, size: 32, offset: 160)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_tci", scope: !8, file: !9, line: 6118, baseType: !12, size: 32, offset: 192)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_proto", scope: !8, file: !9, line: 6119, baseType: !12, size: 32, offset: 224)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !8, file: !9, line: 6120, baseType: !12, size: 32, offset: 256)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !8, file: !9, line: 6121, baseType: !12, size: 32, offset: 288)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !8, file: !9, line: 6122, baseType: !12, size: 32, offset: 320)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "tc_index", scope: !8, file: !9, line: 6123, baseType: !12, size: 32, offset: 352)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "cb", scope: !8, file: !9, line: 6124, baseType: !27, size: 160, offset: 384)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 160, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 5)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "hash", scope: !8, file: !9, line: 6125, baseType: !12, size: 32, offset: 544)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "tc_classid", scope: !8, file: !9, line: 6126, baseType: !12, size: 32, offset: 576)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !8, file: !9, line: 6127, baseType: !12, size: 32, offset: 608)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !8, file: !9, line: 6128, baseType: !12, size: 32, offset: 640)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "napi_id", scope: !8, file: !9, line: 6129, baseType: !12, size: 32, offset: 672)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !8, file: !9, line: 6132, baseType: !12, size: 32, offset: 704)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !8, file: !9, line: 6133, baseType: !12, size: 32, offset: 736)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !8, file: !9, line: 6134, baseType: !12, size: 32, offset: 768)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !8, file: !9, line: 6135, baseType: !39, size: 128, offset: 800)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 128, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 4)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !8, file: !9, line: 6136, baseType: !39, size: 128, offset: 928)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !8, file: !9, line: 6137, baseType: !12, size: 32, offset: 1056)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !8, file: !9, line: 6138, baseType: !12, size: 32, offset: 1088)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !8, file: !9, line: 6141, baseType: !12, size: 32, offset: 1120)
!46 = !DIDerivedType(tag: DW_TAG_member, scope: !8, file: !9, line: 6142, baseType: !47, size: 64, align: 64, offset: 1152)
!47 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !8, file: !9, line: 6142, size: 64, align: 64, elements: !48)
!48 = !{!49}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "flow_keys", scope: !47, file: !9, line: 6142, baseType: !50, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_flow_keys", file: !9, line: 7128, size: 448, elements: !52)
!52 = !{!53, !56, !57, !58, !61, !62, !63, !64, !67, !68, !69, !83, !84}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "nhoff", scope: !51, file: !9, line: 7129, baseType: !54, size: 16)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !13, line: 24, baseType: !55)
!55 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "thoff", scope: !51, file: !9, line: 7130, baseType: !54, size: 16, offset: 16)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "addr_proto", scope: !51, file: !9, line: 7131, baseType: !54, size: 16, offset: 32)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "is_frag", scope: !51, file: !9, line: 7132, baseType: !59, size: 8, offset: 48)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !13, line: 21, baseType: !60)
!60 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "is_first_frag", scope: !51, file: !9, line: 7133, baseType: !59, size: 8, offset: 56)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "is_encap", scope: !51, file: !9, line: 7134, baseType: !59, size: 8, offset: 64)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !51, file: !9, line: 7135, baseType: !59, size: 8, offset: 72)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "n_proto", scope: !51, file: !9, line: 7136, baseType: !65, size: 16, offset: 80)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !66, line: 32, baseType: !54)
!66 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "bf9fbc0e8f60927fef9d8917535375a6")
!67 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !51, file: !9, line: 7137, baseType: !65, size: 16, offset: 96)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !51, file: !9, line: 7138, baseType: !65, size: 16, offset: 112)
!69 = !DIDerivedType(tag: DW_TAG_member, scope: !51, file: !9, line: 7139, baseType: !70, size: 256, offset: 128)
!70 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !51, file: !9, line: 7139, size: 256, elements: !71)
!71 = !{!72, !78}
!72 = !DIDerivedType(tag: DW_TAG_member, scope: !70, file: !9, line: 7140, baseType: !73, size: 64)
!73 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !70, file: !9, line: 7140, size: 64, elements: !74)
!74 = !{!75, !77}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !73, file: !9, line: 7141, baseType: !76, size: 32)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !66, line: 34, baseType: !12)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !73, file: !9, line: 7142, baseType: !76, size: 32, offset: 32)
!78 = !DIDerivedType(tag: DW_TAG_member, scope: !70, file: !9, line: 7144, baseType: !79, size: 256)
!79 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !70, file: !9, line: 7144, size: 256, elements: !80)
!80 = !{!81, !82}
!81 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !79, file: !9, line: 7145, baseType: !39, size: 128)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !79, file: !9, line: 7146, baseType: !39, size: 128, offset: 128)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !51, file: !9, line: 7149, baseType: !12, size: 32, offset: 384)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "flow_label", scope: !51, file: !9, line: 7150, baseType: !76, size: 32, offset: 416)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp", scope: !8, file: !9, line: 6143, baseType: !86, size: 64, offset: 1216)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !13, line: 31, baseType: !87)
!87 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "wire_len", scope: !8, file: !9, line: 6144, baseType: !12, size: 32, offset: 1280)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "gso_segs", scope: !8, file: !9, line: 6145, baseType: !12, size: 32, offset: 1312)
!90 = !DIDerivedType(tag: DW_TAG_member, scope: !8, file: !9, line: 6146, baseType: !91, size: 64, align: 64, offset: 1344)
!91 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !8, file: !9, line: 6146, size: 64, align: 64, elements: !92)
!92 = !{!93}
!93 = !DIDerivedType(tag: DW_TAG_member, name: "sk", scope: !91, file: !9, line: 6146, baseType: !94, size: 64)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock", file: !9, line: 6215, size: 640, elements: !96)
!96 = !{!97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "bound_dev_if", scope: !95, file: !9, line: 6216, baseType: !12, size: 32)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !95, file: !9, line: 6217, baseType: !12, size: 32, offset: 32)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !95, file: !9, line: 6218, baseType: !12, size: 32, offset: 64)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !95, file: !9, line: 6219, baseType: !12, size: 32, offset: 96)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !95, file: !9, line: 6220, baseType: !12, size: 32, offset: 128)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !95, file: !9, line: 6221, baseType: !12, size: 32, offset: 160)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip4", scope: !95, file: !9, line: 6223, baseType: !12, size: 32, offset: 192)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip6", scope: !95, file: !9, line: 6224, baseType: !39, size: 128, offset: 224)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !95, file: !9, line: 6225, baseType: !12, size: 32, offset: 352)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !95, file: !9, line: 6226, baseType: !65, size: 16, offset: 384)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip4", scope: !95, file: !9, line: 6228, baseType: !12, size: 32, offset: 416)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip6", scope: !95, file: !9, line: 6229, baseType: !39, size: 128, offset: 448)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !95, file: !9, line: 6230, baseType: !12, size: 32, offset: 576)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_mapping", scope: !95, file: !9, line: 6231, baseType: !111, size: 32, offset: 608)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "__s32", file: !13, line: 26, baseType: !6)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "gso_size", scope: !8, file: !9, line: 6147, baseType: !12, size: 32, offset: 1408)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp_type", scope: !8, file: !9, line: 6148, baseType: !59, size: 8, offset: 1440)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "hwtstamp", scope: !8, file: !9, line: 6150, baseType: !86, size: 64, offset: 1472)
!115 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !116, globals: !119, splitDebugInlining: false, nameTableKind: None)
!116 = !{!117, !118, !12, !54}
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!118 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!119 = !{!0, !120, !124, !145, !153, !207, !210, !215, !220, !225, !230, !237}
!120 = !DIGlobalVariableExpression(var: !121, expr: !DIExpression())
!121 = distinct !DIGlobalVariable(name: "_license", scope: !115, file: !3, line: 154, type: !122, isLocal: false, isDefinition: true)
!122 = !DICompositeType(tag: DW_TAG_array_type, baseType: !123, size: 32, elements: !40)
!123 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!124 = !DIGlobalVariableExpression(var: !125, expr: !DIExpression())
!125 = distinct !DIGlobalVariable(name: "tc_redirect_map", scope: !115, file: !3, line: 29, type: !126, isLocal: false, isDefinition: true)
!126 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 24, size: 256, elements: !127)
!127 = !{!128, !133, !138, !140}
!128 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !126, file: !3, line: 25, baseType: !129, size: 64)
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 288, elements: !131)
!131 = !{!132}
!132 = !DISubrange(count: 9)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !126, file: !3, line: 26, baseType: !134, size: 64, offset: 64)
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !135, size: 64)
!135 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 64, elements: !136)
!136 = !{!137}
!137 = !DISubrange(count: 2)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !126, file: !3, line: 27, baseType: !139, size: 64, offset: 128)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !126, file: !3, line: 28, baseType: !141, size: 64, offset: 192)
!141 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!142 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lh_info", file: !3, line: 16, size: 32, elements: !143)
!143 = !{!144}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_saddr", scope: !142, file: !3, line: 18, baseType: !12, size: 32)
!145 = !DIGlobalVariableExpression(var: !146, expr: !DIExpression(DW_OP_constu, 6, DW_OP_stack_value))
!146 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !115, file: !147, line: 177, type: !148, isLocal: true, isDefinition: true)
!147 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "09cfcd7169c24bec448f30582e8c6db9")
!148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !149, size: 64)
!149 = !DISubroutineType(types: !150)
!150 = !{!118, !151, !12, null}
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !152, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !123)
!153 = !DIGlobalVariableExpression(var: !154, expr: !DIExpression())
!154 = distinct !DIGlobalVariable(name: "____fmt", scope: !155, file: !3, line: 77, type: !204, isLocal: true, isDefinition: true)
!155 = distinct !DISubprogram(name: "ipv4_redirect_handle", scope: !3, file: !3, line: 67, type: !156, scopeLine: 67, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !115, retainedNodes: !168)
!156 = !DISubroutineType(types: !157)
!157 = !{!6, !7, !158}
!158 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !159, size: 64)
!159 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !160, line: 173, size: 112, elements: !161)
!160 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!161 = !{!162, !166, !167}
!162 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !159, file: !160, line: 174, baseType: !163, size: 48)
!163 = !DICompositeType(tag: DW_TAG_array_type, baseType: !60, size: 48, elements: !164)
!164 = !{!165}
!165 = !DISubrange(count: 6)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !159, file: !160, line: 175, baseType: !163, size: 48, offset: 48)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !159, file: !160, line: 176, baseType: !65, size: 16, offset: 96)
!168 = !{!169, !170, !171, !172, !200, !201, !202, !203}
!169 = !DILocalVariable(name: "skb", arg: 1, scope: !155, file: !3, line: 67, type: !7)
!170 = !DILocalVariable(name: "ethh", arg: 2, scope: !155, file: !3, line: 67, type: !158)
!171 = !DILocalVariable(name: "data_end", scope: !155, file: !3, line: 68, type: !117)
!172 = !DILocalVariable(name: "iph", scope: !155, file: !3, line: 70, type: !173)
!173 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !174, size: 64)
!174 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !175, line: 87, size: 160, elements: !176)
!175 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!176 = !{!177, !178, !179, !180, !181, !182, !183, !184, !185, !187}
!177 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !174, file: !175, line: 89, baseType: !59, size: 4, flags: DIFlagBitField, extraData: i64 0)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !174, file: !175, line: 90, baseType: !59, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !174, file: !175, line: 97, baseType: !59, size: 8, offset: 8)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !174, file: !175, line: 98, baseType: !65, size: 16, offset: 16)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !174, file: !175, line: 99, baseType: !65, size: 16, offset: 32)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !174, file: !175, line: 100, baseType: !65, size: 16, offset: 48)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !174, file: !175, line: 101, baseType: !59, size: 8, offset: 64)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !174, file: !175, line: 102, baseType: !59, size: 8, offset: 72)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !174, file: !175, line: 103, baseType: !186, size: 16, offset: 80)
!186 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !66, line: 38, baseType: !54)
!187 = !DIDerivedType(tag: DW_TAG_member, scope: !174, file: !175, line: 104, baseType: !188, size: 64, offset: 96)
!188 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !174, file: !175, line: 104, size: 64, elements: !189)
!189 = !{!190, !195}
!190 = !DIDerivedType(tag: DW_TAG_member, scope: !188, file: !175, line: 104, baseType: !191, size: 64)
!191 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !188, file: !175, line: 104, size: 64, elements: !192)
!192 = !{!193, !194}
!193 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !191, file: !175, line: 104, baseType: !76, size: 32)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !191, file: !175, line: 104, baseType: !76, size: 32, offset: 32)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !188, file: !175, line: 104, baseType: !196, size: 64)
!196 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !188, file: !175, line: 104, size: 64, elements: !197)
!197 = !{!198, !199}
!198 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !196, file: !175, line: 104, baseType: !76, size: 32)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !196, file: !175, line: 104, baseType: !76, size: 32, offset: 32)
!200 = !DILocalVariable(name: "ip_dst_addr", scope: !155, file: !3, line: 84, type: !12)
!201 = !DILocalVariable(name: "ip_src_addr", scope: !155, file: !3, line: 85, type: !12)
!202 = !DILocalVariable(name: "lhinfo", scope: !155, file: !3, line: 99, type: !141)
!203 = !DILocalVariable(name: "idx", scope: !155, file: !3, line: 101, type: !12)
!204 = !DICompositeType(tag: DW_TAG_array_type, baseType: !152, size: 96, elements: !205)
!205 = !{!206}
!206 = !DISubrange(count: 12)
!207 = !DIGlobalVariableExpression(var: !208, expr: !DIExpression())
!208 = distinct !DIGlobalVariable(name: "____fmt", scope: !155, file: !3, line: 79, type: !209, isLocal: true, isDefinition: true)
!209 = !DICompositeType(tag: DW_TAG_array_type, baseType: !152, size: 72, elements: !131)
!210 = !DIGlobalVariableExpression(var: !211, expr: !DIExpression())
!211 = distinct !DIGlobalVariable(name: "____fmt", scope: !155, file: !3, line: 83, type: !212, isLocal: true, isDefinition: true)
!212 = !DICompositeType(tag: DW_TAG_array_type, baseType: !152, size: 136, elements: !213)
!213 = !{!214}
!214 = !DISubrange(count: 17)
!215 = !DIGlobalVariableExpression(var: !216, expr: !DIExpression())
!216 = distinct !DIGlobalVariable(name: "____fmt", scope: !155, file: !3, line: 106, type: !217, isLocal: true, isDefinition: true)
!217 = !DICompositeType(tag: DW_TAG_array_type, baseType: !152, size: 200, elements: !218)
!218 = !{!219}
!219 = !DISubrange(count: 25)
!220 = !DIGlobalVariableExpression(var: !221, expr: !DIExpression())
!221 = distinct !DIGlobalVariable(name: "____fmt", scope: !155, file: !3, line: 110, type: !222, isLocal: true, isDefinition: true)
!222 = !DICompositeType(tag: DW_TAG_array_type, baseType: !152, size: 64, elements: !223)
!223 = !{!224}
!224 = !DISubrange(count: 8)
!225 = !DIGlobalVariableExpression(var: !226, expr: !DIExpression())
!226 = distinct !DIGlobalVariable(name: "____fmt", scope: !155, file: !3, line: 119, type: !227, isLocal: true, isDefinition: true)
!227 = !DICompositeType(tag: DW_TAG_array_type, baseType: !152, size: 104, elements: !228)
!228 = !{!229}
!229 = !DISubrange(count: 13)
!230 = !DIGlobalVariableExpression(var: !231, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!231 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !115, file: !147, line: 56, type: !232, isLocal: true, isDefinition: true)
!232 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !233, size: 64)
!233 = !DISubroutineType(types: !234)
!234 = !{!117, !117, !235}
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !236, size: 64)
!236 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!237 = !DIGlobalVariableExpression(var: !238, expr: !DIExpression())
!238 = distinct !DIGlobalVariable(name: "____fmt", scope: !239, file: !3, line: 61, type: !252, isLocal: true, isDefinition: true)
!239 = distinct !DISubprogram(name: "ipv4_check", scope: !3, file: !3, line: 32, type: !240, scopeLine: 32, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !115, retainedNodes: !243)
!240 = !DISubroutineType(types: !241)
!241 = !{!54, !242, !54, !117}
!242 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!243 = !{!244, !245, !246, !247, !248, !250, !251}
!244 = !DILocalVariable(name: "packet", arg: 1, scope: !239, file: !3, line: 32, type: !242)
!245 = !DILocalVariable(name: "len", arg: 2, scope: !239, file: !3, line: 32, type: !54)
!246 = !DILocalVariable(name: "data_end", arg: 3, scope: !239, file: !3, line: 32, type: !117)
!247 = !DILocalVariable(name: "csum", scope: !239, file: !3, line: 33, type: !12)
!248 = !DILocalVariable(name: "i", scope: !249, file: !3, line: 40, type: !6)
!249 = distinct !DILexicalBlock(scope: !239, file: !3, line: 40, column: 5)
!250 = !DILocalVariable(name: "i", scope: !239, file: !3, line: 55, type: !6)
!251 = !DILocalVariable(name: "checksum", scope: !239, file: !3, line: 63, type: !54)
!252 = !DICompositeType(tag: DW_TAG_array_type, baseType: !152, size: 80, elements: !253)
!253 = !{!254}
!254 = !DISubrange(count: 10)
!255 = !{!256, !257, !258, !259}
!256 = !DILocalVariable(name: "skb", arg: 1, scope: !2, file: !3, line: 125, type: !7)
!257 = !DILocalVariable(name: "data_end", scope: !2, file: !3, line: 126, type: !117)
!258 = !DILocalVariable(name: "data", scope: !2, file: !3, line: 127, type: !117)
!259 = !DILocalVariable(name: "ethh", scope: !2, file: !3, line: 130, type: !158)
!260 = !DICompositeType(tag: DW_TAG_array_type, baseType: !152, size: 56, elements: !261)
!261 = !{!262}
!262 = !DISubrange(count: 7)
!263 = !{i32 7, !"Dwarf Version", i32 5}
!264 = !{i32 2, !"Debug Info Version", i32 3}
!265 = !{i32 1, !"wchar_size", i32 4}
!266 = !{i32 7, !"frame-pointer", i32 2}
!267 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!268 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!269 = distinct !DIAssignID()
!270 = !DILocation(line: 0, scope: !2)
!271 = !DILocation(line: 126, column: 38, scope: !2)
!272 = !{!273, !274, i64 80}
!273 = !{!"__sk_buff", !274, i64 0, !274, i64 4, !274, i64 8, !274, i64 12, !274, i64 16, !274, i64 20, !274, i64 24, !274, i64 28, !274, i64 32, !274, i64 36, !274, i64 40, !274, i64 44, !275, i64 48, !274, i64 68, !274, i64 72, !274, i64 76, !274, i64 80, !274, i64 84, !274, i64 88, !274, i64 92, !274, i64 96, !275, i64 100, !275, i64 116, !274, i64 132, !274, i64 136, !274, i64 140, !275, i64 144, !277, i64 152, !274, i64 160, !274, i64 164, !275, i64 168, !274, i64 176, !275, i64 180, !277, i64 184}
!274 = !{!"int", !275, i64 0}
!275 = !{!"omnipotent char", !276, i64 0}
!276 = !{!"Simple C/C++ TBAA"}
!277 = !{!"long long", !275, i64 0}
!278 = !DILocation(line: 126, column: 27, scope: !2)
!279 = !DILocation(line: 126, column: 19, scope: !2)
!280 = !DILocation(line: 127, column: 38, scope: !2)
!281 = !{!273, !274, i64 76}
!282 = !DILocation(line: 127, column: 27, scope: !2)
!283 = !DILocation(line: 127, column: 19, scope: !2)
!284 = !DILocation(line: 129, column: 2, scope: !285)
!285 = distinct !DILexicalBlock(scope: !2, file: !3, line: 129, column: 2)
!286 = !DILocation(line: 131, column: 20, scope: !287)
!287 = distinct !DILexicalBlock(scope: !2, file: !3, line: 131, column: 6)
!288 = !DILocation(line: 131, column: 25, scope: !287)
!289 = !DILocation(line: 131, column: 6, scope: !2)
!290 = !DILocation(line: 0, scope: !155, inlinedAt: !291)
!291 = distinct !DILocation(line: 136, column: 2, scope: !2)
!292 = !DILocation(line: 68, column: 38, scope: !155, inlinedAt: !291)
!293 = !DILocation(line: 68, column: 27, scope: !155, inlinedAt: !291)
!294 = !DILocation(line: 68, column: 19, scope: !155, inlinedAt: !291)
!295 = !DILocation(line: 72, column: 19, scope: !296, inlinedAt: !291)
!296 = distinct !DILexicalBlock(scope: !155, file: !3, line: 72, column: 6)
!297 = !DILocation(line: 72, column: 24, scope: !296, inlinedAt: !291)
!298 = !DILocation(line: 72, column: 6, scope: !155, inlinedAt: !291)
!299 = !DILocation(line: 77, column: 2, scope: !300, inlinedAt: !291)
!300 = distinct !DILexicalBlock(scope: !155, file: !3, line: 77, column: 2)
!301 = !DILocation(line: 78, column: 11, scope: !302, inlinedAt: !291)
!302 = distinct !DILexicalBlock(scope: !155, file: !3, line: 78, column: 6)
!303 = !DILocation(line: 78, column: 19, scope: !302, inlinedAt: !291)
!304 = !DILocation(line: 78, column: 6, scope: !155, inlinedAt: !291)
!305 = !DILocation(line: 79, column: 3, scope: !306, inlinedAt: !291)
!306 = distinct !DILexicalBlock(scope: !307, file: !3, line: 79, column: 3)
!307 = distinct !DILexicalBlock(scope: !302, file: !3, line: 78, column: 25)
!308 = !DILocation(line: 80, column: 3, scope: !307, inlinedAt: !291)
!309 = !DILocation(line: 83, column: 2, scope: !310, inlinedAt: !291)
!310 = distinct !DILexicalBlock(scope: !155, file: !3, line: 83, column: 2)
!311 = !DILocation(line: 84, column: 27, scope: !155, inlinedAt: !291)
!312 = !{!275, !275, i64 0}
!313 = !DILocation(line: 85, column: 27, scope: !155, inlinedAt: !291)
!314 = !DILocation(line: 88, column: 14, scope: !155, inlinedAt: !291)
!315 = !DILocation(line: 89, column: 14, scope: !155, inlinedAt: !291)
!316 = !DILocation(line: 90, column: 18, scope: !317, inlinedAt: !291)
!317 = distinct !DILexicalBlock(scope: !155, file: !3, line: 90, column: 6)
!318 = !DILocation(line: 90, column: 6, scope: !155, inlinedAt: !291)
!319 = !DILocation(line: 101, column: 2, scope: !155, inlinedAt: !291)
!320 = !DILocation(line: 101, column: 8, scope: !155, inlinedAt: !291)
!321 = !{!274, !274, i64 0}
!322 = distinct !DIAssignID()
!323 = !DILocation(line: 103, column: 11, scope: !155, inlinedAt: !291)
!324 = !DILocation(line: 105, column: 13, scope: !325, inlinedAt: !291)
!325 = distinct !DILexicalBlock(scope: !155, file: !3, line: 105, column: 6)
!326 = !DILocation(line: 105, column: 6, scope: !155, inlinedAt: !291)
!327 = !DILocation(line: 106, column: 3, scope: !328, inlinedAt: !291)
!328 = distinct !DILexicalBlock(scope: !329, file: !3, line: 106, column: 3)
!329 = distinct !DILexicalBlock(scope: !325, file: !3, line: 105, column: 19)
!330 = !DILocation(line: 107, column: 3, scope: !329, inlinedAt: !291)
!331 = !DILocation(line: 110, column: 2, scope: !332, inlinedAt: !291)
!332 = distinct !DILexicalBlock(scope: !155, file: !3, line: 110, column: 2)
!333 = !DILocation(line: 117, column: 15, scope: !155, inlinedAt: !291)
!334 = !{!335, !274, i64 0}
!335 = !{!"lh_info", !274, i64 0}
!336 = !DILocation(line: 117, column: 13, scope: !155, inlinedAt: !291)
!337 = !DILocation(line: 118, column: 18, scope: !155, inlinedAt: !291)
!338 = !DILocation(line: 0, scope: !239, inlinedAt: !339)
!339 = distinct !DILocation(line: 118, column: 18, scope: !155, inlinedAt: !291)
!340 = !DILocation(line: 36, column: 11, scope: !239, inlinedAt: !339)
!341 = !DILocation(line: 36, column: 17, scope: !239, inlinedAt: !339)
!342 = !DILocation(line: 37, column: 11, scope: !239, inlinedAt: !339)
!343 = !DILocation(line: 37, column: 17, scope: !239, inlinedAt: !339)
!344 = !DILocation(line: 0, scope: !249, inlinedAt: !339)
!345 = !DILocation(line: 40, column: 28, scope: !346, inlinedAt: !339)
!346 = distinct !DILexicalBlock(scope: !249, file: !3, line: 40, column: 5)
!347 = !DILocation(line: 40, column: 5, scope: !249, inlinedAt: !339)
!348 = !DILocation(line: 48, column: 10, scope: !349, inlinedAt: !339)
!349 = distinct !DILexicalBlock(scope: !239, file: !3, line: 48, column: 6)
!350 = !DILocation(line: 48, column: 6, scope: !239, inlinedAt: !339)
!351 = !DILocation(line: 41, column: 22, scope: !352, inlinedAt: !339)
!352 = distinct !DILexicalBlock(scope: !353, file: !3, line: 41, column: 7)
!353 = distinct !DILexicalBlock(scope: !346, file: !3, line: 40, column: 46)
!354 = !DILocation(line: 41, column: 27, scope: !352, inlinedAt: !339)
!355 = !DILocation(line: 41, column: 7, scope: !353, inlinedAt: !339)
!356 = !DILocation(line: 42, column: 13, scope: !357, inlinedAt: !339)
!357 = distinct !DILexicalBlock(scope: !352, file: !3, line: 41, column: 40)
!358 = !DILocation(line: 42, column: 12, scope: !357, inlinedAt: !339)
!359 = !DILocation(line: 42, column: 22, scope: !357, inlinedAt: !339)
!360 = !DILocation(line: 42, column: 39, scope: !357, inlinedAt: !339)
!361 = !DILocation(line: 42, column: 31, scope: !357, inlinedAt: !339)
!362 = !DILocation(line: 42, column: 30, scope: !357, inlinedAt: !339)
!363 = !DILocation(line: 42, column: 28, scope: !357, inlinedAt: !339)
!364 = !DILocation(line: 42, column: 9, scope: !357, inlinedAt: !339)
!365 = !DILocation(line: 43, column: 3, scope: !357, inlinedAt: !339)
!366 = !DILocation(line: 46, column: 7, scope: !353, inlinedAt: !339)
!367 = !DILocation(line: 40, column: 41, scope: !346, inlinedAt: !339)
!368 = !DILocation(line: 40, column: 23, scope: !346, inlinedAt: !339)
!369 = distinct !{!369, !347, !370, !371}
!370 = !DILocation(line: 47, column: 5, scope: !249, inlinedAt: !339)
!371 = !{!"llvm.loop.mustprogress"}
!372 = !DILocation(line: 49, column: 22, scope: !373, inlinedAt: !339)
!373 = distinct !DILexicalBlock(scope: !374, file: !3, line: 49, column: 7)
!374 = distinct !DILexicalBlock(scope: !349, file: !3, line: 48, column: 15)
!375 = !DILocation(line: 49, column: 27, scope: !373, inlinedAt: !339)
!376 = !DILocation(line: 49, column: 7, scope: !374, inlinedAt: !339)
!377 = !DILocation(line: 52, column: 12, scope: !374, inlinedAt: !339)
!378 = !DILocation(line: 52, column: 11, scope: !374, inlinedAt: !339)
!379 = !DILocation(line: 52, column: 8, scope: !374, inlinedAt: !339)
!380 = !DILocation(line: 53, column: 2, scope: !374, inlinedAt: !339)
!381 = !DILocation(line: 56, column: 17, scope: !239, inlinedAt: !339)
!382 = !DILocation(line: 56, column: 5, scope: !239, inlinedAt: !339)
!383 = !DILocation(line: 57, column: 22, scope: !384, inlinedAt: !339)
!384 = distinct !DILexicalBlock(scope: !239, file: !3, line: 56, column: 34)
!385 = !DILocation(line: 57, column: 32, scope: !384, inlinedAt: !339)
!386 = !DILocation(line: 58, column: 4, scope: !384, inlinedAt: !339)
!387 = !DILocation(line: 56, column: 23, scope: !239, inlinedAt: !339)
!388 = distinct !{!388, !382, !389, !371}
!389 = !DILocation(line: 59, column: 2, scope: !239, inlinedAt: !339)
!390 = !DILocation(line: 61, column: 2, scope: !391, inlinedAt: !339)
!391 = distinct !DILexicalBlock(scope: !239, file: !3, line: 61, column: 2)
!392 = !DILocation(line: 63, column: 22, scope: !239, inlinedAt: !339)
!393 = !DILocation(line: 118, column: 16, scope: !155, inlinedAt: !291)
!394 = !{!395, !396, i64 10}
!395 = !{!"iphdr", !275, i64 0, !275, i64 0, !275, i64 1, !396, i64 2, !396, i64 4, !396, i64 6, !275, i64 8, !275, i64 9, !396, i64 10, !275, i64 12}
!396 = !{!"short", !275, i64 0}
!397 = !DILocation(line: 119, column: 5, scope: !398, inlinedAt: !291)
!398 = distinct !DILexicalBlock(scope: !155, file: !3, line: 119, column: 5)
!399 = !DILocation(line: 121, column: 2, scope: !155, inlinedAt: !291)
!400 = !DILocation(line: 122, column: 1, scope: !155, inlinedAt: !291)
!401 = !DILocation(line: 144, column: 1, scope: !2)
