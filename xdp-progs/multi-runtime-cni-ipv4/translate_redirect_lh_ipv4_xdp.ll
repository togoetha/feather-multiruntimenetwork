; ModuleID = 'translate_redirect_lh_ipv4_xdp.c'
source_filename = "translate_redirect_lh_ipv4_xdp.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@xdp_lhredirect.____fmt = internal constant [7 x i8] c"start\0A\00", align 1, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !35
@xdp_redirect_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !41
@ipv4_redirect_handle.____fmt = internal constant [12 x i8] c"ipv4 check\0A\00", align 1, !dbg !70
@ipv4_redirect_handle.____fmt.1 = internal constant [9 x i8] c"no ipv4\0A\00", align 1, !dbg !129
@ipv4_redirect_handle.____fmt.2 = internal constant [17 x i8] c"localhost check\0A\00", align 1, !dbg !132
@ipv4_redirect_handle.____fmt.3 = internal constant [25 x i8] c"no localhost route found\00", align 1, !dbg !137
@ipv4_redirect_handle.____fmt.4 = internal constant [8 x i8] c"lh info\00", align 1, !dbg !142
@ipv4_redirect_handle.____fmt.5 = internal constant [13 x i8] c"ip check %x\0A\00", align 1, !dbg !147
@ipv4_check.____fmt = internal constant [10 x i8] c"csum %08x\00", align 1, !dbg !159
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @xdp_lhredirect, ptr @xdp_redirect_map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local noundef i32 @xdp_lhredirect(ptr nocapture noundef readonly %0) #0 section "xdp" !dbg !2 {
  %2 = alloca i32, align 4, !DIAssignID !191
  tail call void @llvm.dbg.value(metadata ptr %0, metadata !178, metadata !DIExpression()), !dbg !192
  %3 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !193
  %4 = load i32, ptr %3, align 4, !dbg !193, !tbaa !194
  %5 = zext i32 %4 to i64, !dbg !199
  %6 = inttoptr i64 %5 to ptr, !dbg !200
  tail call void @llvm.dbg.value(metadata ptr %6, metadata !179, metadata !DIExpression()), !dbg !192
  %7 = load i32, ptr %0, align 4, !dbg !201, !tbaa !202
  %8 = zext i32 %7 to i64, !dbg !203
  %9 = inttoptr i64 %8 to ptr, !dbg !204
  tail call void @llvm.dbg.value(metadata ptr %9, metadata !180, metadata !DIExpression()), !dbg !192
  %10 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @xdp_lhredirect.____fmt, i32 noundef 7) #4, !dbg !205
  tail call void @llvm.dbg.value(metadata ptr %9, metadata !181, metadata !DIExpression()), !dbg !192
  %11 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 1, !dbg !207
  %12 = icmp ugt ptr %11, %6, !dbg !209
  br i1 %12, label %110, label %13, !dbg !210

13:                                               ; preds = %1
  call void @llvm.dbg.assign(metadata i1 undef, metadata !125, metadata !DIExpression(), metadata !191, metadata ptr %2, metadata !DIExpression()), !dbg !211
  call void @llvm.dbg.value(metadata ptr %0, metadata !89, metadata !DIExpression()), !dbg !211
  call void @llvm.dbg.value(metadata ptr %9, metadata !90, metadata !DIExpression()), !dbg !211
  %14 = load i32, ptr %3, align 4, !dbg !213, !tbaa !194
  %15 = zext i32 %14 to i64, !dbg !214
  %16 = inttoptr i64 %15 to ptr, !dbg !215
  call void @llvm.dbg.value(metadata ptr %16, metadata !91, metadata !DIExpression()), !dbg !211
  call void @llvm.dbg.value(metadata ptr %11, metadata !92, metadata !DIExpression()), !dbg !211
  %17 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 2, i32 1, !dbg !216
  %18 = icmp ugt ptr %17, %16, !dbg !218
  br i1 %18, label %110, label %19, !dbg !219

19:                                               ; preds = %13
  %20 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt, i32 noundef 12) #4, !dbg !220
  %21 = load i8, ptr %11, align 4, !dbg !222
  %22 = and i8 %21, -16, !dbg !224
  %23 = icmp eq i8 %22, 64, !dbg !224
  br i1 %23, label %26, label %24, !dbg !225

24:                                               ; preds = %19
  %25 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.1, i32 noundef 9) #4, !dbg !226
  br label %110, !dbg !229

26:                                               ; preds = %19
  %27 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.2, i32 noundef 17) #4, !dbg !230
  %28 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 1, i32 2, !dbg !232
  %29 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 2, i32 0, i64 2, !dbg !232
  %30 = load i32, ptr %29, align 4, !dbg !232, !tbaa !233
  call void @llvm.dbg.value(metadata i32 %30, metadata !122, metadata !DIExpression()), !dbg !211
  %31 = load i32, ptr %28, align 4, !dbg !234, !tbaa !233
  call void @llvm.dbg.value(metadata i32 %31, metadata !123, metadata !DIExpression()), !dbg !211
  %32 = and i32 %30, -117440513, !dbg !235
  call void @llvm.dbg.value(metadata i32 %32, metadata !122, metadata !DIExpression()), !dbg !211
  %33 = and i32 %31, -117440513, !dbg !236
  call void @llvm.dbg.value(metadata i32 %33, metadata !123, metadata !DIExpression()), !dbg !211
  %34 = icmp ne i32 %32, %33, !dbg !237
  %35 = icmp eq i32 %31, %33
  %36 = or i1 %34, %35, !dbg !239
  br i1 %36, label %110, label %37, !dbg !239

37:                                               ; preds = %26
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #4, !dbg !240
  store i32 0, ptr %2, align 4, !dbg !241, !tbaa !242, !DIAssignID !243
  call void @llvm.dbg.assign(metadata i32 0, metadata !125, metadata !DIExpression(), metadata !243, metadata ptr %2, metadata !DIExpression()), !dbg !211
  %38 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @xdp_redirect_map, ptr noundef nonnull %2) #4, !dbg !244
  call void @llvm.dbg.value(metadata ptr %38, metadata !124, metadata !DIExpression()), !dbg !211
  %39 = icmp eq ptr %38, null, !dbg !245
  br i1 %39, label %40, label %42, !dbg !247

40:                                               ; preds = %37
  %41 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.3, i32 noundef 25) #4, !dbg !248
  br label %109, !dbg !251

42:                                               ; preds = %37
  %43 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.4, i32 noundef 8) #4, !dbg !252
  %44 = load i32, ptr %38, align 4, !dbg !254, !tbaa !255
  %45 = call i32 @llvm.bswap.i32(i32 %44), !dbg !254
  store i32 %45, ptr %28, align 4, !dbg !257, !tbaa !233
  %46 = load i8, ptr %11, align 4, !dbg !258
  %47 = shl i8 %46, 2, !dbg !258
  %48 = and i8 %47, 60, !dbg !258
  call void @llvm.dbg.value(metadata ptr %11, metadata !166, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i8 %48, metadata !167, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !259
  call void @llvm.dbg.value(metadata ptr %16, metadata !168, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i32 0, metadata !169, metadata !DIExpression()), !dbg !259
  %49 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 1, i32 1, i64 4, !dbg !261
  store i8 0, ptr %49, align 1, !dbg !262, !tbaa !233
  %50 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 1, i32 1, i64 5, !dbg !263
  store i8 0, ptr %50, align 1, !dbg !264, !tbaa !233
  call void @llvm.dbg.value(metadata i32 0, metadata !170, metadata !DIExpression()), !dbg !265
  call void @llvm.dbg.value(metadata ptr %11, metadata !166, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i32 0, metadata !169, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i8 %48, metadata !167, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !259
  %51 = icmp eq i8 %48, 0, !dbg !266
  br i1 %51, label %99, label %52, !dbg !268

52:                                               ; preds = %42
  %53 = zext nneg i8 %48 to i16, !dbg !258
  call void @llvm.dbg.value(metadata i16 %53, metadata !167, metadata !DIExpression()), !dbg !259
  br label %56, !dbg !268

54:                                               ; preds = %72
  %55 = icmp eq i16 %74, 0, !dbg !269
  br i1 %55, label %86, label %79, !dbg !271

56:                                               ; preds = %52, %72
  %57 = phi ptr [ %61, %72 ], [ %11, %52 ]
  %58 = phi i32 [ %75, %72 ], [ 0, %52 ]
  %59 = phi i32 [ %73, %72 ], [ 0, %52 ]
  %60 = phi i16 [ %74, %72 ], [ %53, %52 ]
  call void @llvm.dbg.value(metadata ptr %57, metadata !166, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i32 %58, metadata !170, metadata !DIExpression()), !dbg !265
  call void @llvm.dbg.value(metadata i32 %59, metadata !169, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i16 %60, metadata !167, metadata !DIExpression()), !dbg !259
  %61 = getelementptr inbounds i8, ptr %57, i64 2, !dbg !272
  %62 = icmp ugt ptr %61, %16, !dbg !275
  br i1 %62, label %72, label %63, !dbg !276

63:                                               ; preds = %56
  %64 = load i8, ptr %57, align 1, !dbg !277, !tbaa !233
  %65 = zext i8 %64 to i32, !dbg !279
  %66 = shl nuw nsw i32 %65, 8, !dbg !280
  %67 = getelementptr inbounds i8, ptr %57, i64 1, !dbg !281
  %68 = load i8, ptr %67, align 1, !dbg !282, !tbaa !233
  %69 = zext i8 %68 to i32, !dbg !283
  %70 = or disjoint i32 %66, %69, !dbg !284
  %71 = add i32 %70, %59, !dbg !285
  call void @llvm.dbg.value(metadata i32 %71, metadata !169, metadata !DIExpression()), !dbg !259
  br label %72, !dbg !286

72:                                               ; preds = %63, %56
  %73 = phi i32 [ %71, %63 ], [ %59, %56 ], !dbg !259
  call void @llvm.dbg.value(metadata i32 %73, metadata !169, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata ptr %61, metadata !166, metadata !DIExpression()), !dbg !259
  %74 = add nsw i16 %60, -2, !dbg !287
  call void @llvm.dbg.value(metadata i16 %74, metadata !167, metadata !DIExpression()), !dbg !259
  %75 = add nuw nsw i32 %58, 2, !dbg !288
  call void @llvm.dbg.value(metadata i32 %75, metadata !170, metadata !DIExpression()), !dbg !265
  %76 = icmp ult i32 %58, 58, !dbg !289
  %77 = icmp ne i16 %74, 0, !dbg !266
  %78 = select i1 %76, i1 %77, i1 false, !dbg !266
  br i1 %78, label %56, label %54, !dbg !268, !llvm.loop !290

79:                                               ; preds = %54
  %80 = getelementptr inbounds i8, ptr %57, i64 3, !dbg !293
  %81 = icmp ugt ptr %80, %16, !dbg !296
  br i1 %81, label %104, label %82, !dbg !297

82:                                               ; preds = %79
  %83 = load i8, ptr %61, align 1, !dbg !298, !tbaa !233
  %84 = zext i8 %83 to i32, !dbg !299
  %85 = add i32 %73, %84, !dbg !300
  call void @llvm.dbg.value(metadata i32 %85, metadata !169, metadata !DIExpression()), !dbg !259
  br label %86, !dbg !301

86:                                               ; preds = %82, %54
  %87 = phi i32 [ %85, %82 ], [ %73, %54 ], !dbg !259
  call void @llvm.dbg.value(metadata i32 %87, metadata !169, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i32 0, metadata !172, metadata !DIExpression()), !dbg !259
  %88 = icmp ugt i32 %87, 65535, !dbg !302
  br i1 %88, label %89, label %99, !dbg !303

89:                                               ; preds = %86, %89
  %90 = phi i32 [ %95, %89 ], [ 0, %86 ]
  %91 = phi i32 [ %94, %89 ], [ %87, %86 ]
  call void @llvm.dbg.value(metadata i32 %90, metadata !172, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i32 %91, metadata !169, metadata !DIExpression()), !dbg !259
  %92 = lshr i32 %91, 16, !dbg !302
  %93 = and i32 %91, 65535, !dbg !304
  %94 = add nuw nsw i32 %93, %92, !dbg !306
  call void @llvm.dbg.value(metadata i32 %94, metadata !169, metadata !DIExpression()), !dbg !259
  %95 = add nuw nsw i32 %90, 1, !dbg !307
  call void @llvm.dbg.value(metadata i32 %95, metadata !172, metadata !DIExpression()), !dbg !259
  %96 = icmp ugt i32 %94, 65535, !dbg !302
  %97 = icmp ult i32 %90, 15, !dbg !308
  %98 = select i1 %96, i1 %97, i1 false, !dbg !308
  br i1 %98, label %89, label %99, !dbg !303, !llvm.loop !309

99:                                               ; preds = %89, %42, %86
  %100 = phi i32 [ %87, %86 ], [ 0, %42 ], [ %94, %89 ], !dbg !259
  %101 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_check.____fmt, i32 noundef 10, i32 noundef %100) #4, !dbg !311
  %102 = trunc i32 %100 to i16, !dbg !313
  %103 = xor i16 %102, -1, !dbg !313
  call void @llvm.dbg.value(metadata i16 %103, metadata !173, metadata !DIExpression()), !dbg !259
  br label %104

104:                                              ; preds = %79, %99
  %105 = phi i16 [ %103, %99 ], [ 0, %79 ], !dbg !259
  %106 = call i16 @llvm.bswap.i16(i16 %105), !dbg !258
  %107 = zext i16 %106 to i32, !dbg !258
  store i16 %106, ptr %49, align 2, !dbg !314, !tbaa !315
  %108 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @ipv4_redirect_handle.____fmt.5, i32 noundef 13, i32 noundef %107) #4, !dbg !318
  br label %109, !dbg !320

109:                                              ; preds = %104, %40
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #4, !dbg !321
  br label %110

110:                                              ; preds = %109, %26, %24, %13, %1
  ret i32 2, !dbg !322
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

!llvm.dbg.cu = !{!20}
!llvm.module.flags = !{!185, !186, !187, !188, !189}
!llvm.ident = !{!190}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "____fmt", scope: !2, file: !3, line: 129, type: !182, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "xdp_lhredirect", scope: !3, file: !3, line: 125, type: !4, scopeLine: 125, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !177)
!3 = !DIFile(filename: "translate_redirect_lh_ipv4_xdp.c", directory: "/home/togoetha/projects/service/xdp-progs/multi-runtime-cni-ipv4", checksumkind: CSK_MD5, checksum: "191da4ed2edd519b01f937ec4b8bac69")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !9, line: 6331, size: 192, elements: !10)
!9 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "8106ce79fb72e4cfc709095592a01f1d")
!10 = !{!11, !15, !16, !17, !18, !19}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !8, file: !9, line: 6332, baseType: !12, size: 32)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !13, line: 27, baseType: !14)
!13 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!14 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !8, file: !9, line: 6333, baseType: !12, size: 32, offset: 32)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !8, file: !9, line: 6334, baseType: !12, size: 32, offset: 64)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !8, file: !9, line: 6336, baseType: !12, size: 32, offset: 96)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !8, file: !9, line: 6337, baseType: !12, size: 32, offset: 128)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !8, file: !9, line: 6339, baseType: !12, size: 32, offset: 160)
!20 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !21, retainedTypes: !29, globals: !34, splitDebugInlining: false, nameTableKind: None)
!21 = !{!22}
!22 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !9, line: 6320, baseType: !14, size: 32, elements: !23)
!23 = !{!24, !25, !26, !27, !28}
!24 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!25 = !DIEnumerator(name: "XDP_DROP", value: 1)
!26 = !DIEnumerator(name: "XDP_PASS", value: 2)
!27 = !DIEnumerator(name: "XDP_TX", value: 3)
!28 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!29 = !{!30, !31, !12, !32}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!31 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !13, line: 24, baseType: !33)
!33 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!34 = !{!0, !35, !41, !62, !70, !129, !132, !137, !142, !147, !152, !159}
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "_license", scope: !20, file: !3, line: 155, type: !37, isLocal: false, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 32, elements: !39)
!38 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!39 = !{!40}
!40 = !DISubrange(count: 4)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "xdp_redirect_map", scope: !20, file: !3, line: 29, type: !43, isLocal: false, isDefinition: true)
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 24, size: 256, elements: !44)
!44 = !{!45, !50, !55, !57}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !43, file: !3, line: 25, baseType: !46, size: 64)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 288, elements: !48)
!48 = !{!49}
!49 = !DISubrange(count: 9)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !43, file: !3, line: 26, baseType: !51, size: 64, offset: 64)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 64, elements: !53)
!53 = !{!54}
!54 = !DISubrange(count: 2)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !43, file: !3, line: 27, baseType: !56, size: 64, offset: 128)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !43, file: !3, line: 28, baseType: !58, size: 64, offset: 192)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lh_info", file: !3, line: 16, size: 32, elements: !60)
!60 = !{!61}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_saddr", scope: !59, file: !3, line: 18, baseType: !12, size: 32)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression(DW_OP_constu, 6, DW_OP_stack_value))
!63 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !20, file: !64, line: 177, type: !65, isLocal: true, isDefinition: true)
!64 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "09cfcd7169c24bec448f30582e8c6db9")
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DISubroutineType(types: !67)
!67 = !{!31, !68, !12, null}
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "____fmt", scope: !72, file: !3, line: 77, type: !126, isLocal: true, isDefinition: true)
!72 = distinct !DISubprogram(name: "ipv4_redirect_handle", scope: !3, file: !3, line: 67, type: !73, scopeLine: 67, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !88)
!73 = !DISubroutineType(types: !74)
!74 = !{!6, !7, !75}
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !77, line: 173, size: 112, elements: !78)
!77 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!78 = !{!79, !84, !85}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !76, file: !77, line: 174, baseType: !80, size: 48)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !81, size: 48, elements: !82)
!81 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!82 = !{!83}
!83 = !DISubrange(count: 6)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !76, file: !77, line: 175, baseType: !80, size: 48, offset: 48)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !76, file: !77, line: 176, baseType: !86, size: 16, offset: 96)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !87, line: 32, baseType: !32)
!87 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "bf9fbc0e8f60927fef9d8917535375a6")
!88 = !{!89, !90, !91, !92, !122, !123, !124, !125}
!89 = !DILocalVariable(name: "ctx", arg: 1, scope: !72, file: !3, line: 67, type: !7)
!90 = !DILocalVariable(name: "ethh", arg: 2, scope: !72, file: !3, line: 67, type: !75)
!91 = !DILocalVariable(name: "data_end", scope: !72, file: !3, line: 68, type: !30)
!92 = !DILocalVariable(name: "iph", scope: !72, file: !3, line: 70, type: !93)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !95, line: 87, size: 160, elements: !96)
!95 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!96 = !{!97, !99, !100, !101, !102, !103, !104, !105, !106, !108}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !94, file: !95, line: 89, baseType: !98, size: 4, flags: DIFlagBitField, extraData: i64 0)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !13, line: 21, baseType: !81)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !94, file: !95, line: 90, baseType: !98, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !94, file: !95, line: 97, baseType: !98, size: 8, offset: 8)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !94, file: !95, line: 98, baseType: !86, size: 16, offset: 16)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !94, file: !95, line: 99, baseType: !86, size: 16, offset: 32)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !94, file: !95, line: 100, baseType: !86, size: 16, offset: 48)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !94, file: !95, line: 101, baseType: !98, size: 8, offset: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !94, file: !95, line: 102, baseType: !98, size: 8, offset: 72)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !94, file: !95, line: 103, baseType: !107, size: 16, offset: 80)
!107 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !87, line: 38, baseType: !32)
!108 = !DIDerivedType(tag: DW_TAG_member, scope: !94, file: !95, line: 104, baseType: !109, size: 64, offset: 96)
!109 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !94, file: !95, line: 104, size: 64, elements: !110)
!110 = !{!111, !117}
!111 = !DIDerivedType(tag: DW_TAG_member, scope: !109, file: !95, line: 104, baseType: !112, size: 64)
!112 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !109, file: !95, line: 104, size: 64, elements: !113)
!113 = !{!114, !116}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !112, file: !95, line: 104, baseType: !115, size: 32)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !87, line: 34, baseType: !12)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !112, file: !95, line: 104, baseType: !115, size: 32, offset: 32)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !109, file: !95, line: 104, baseType: !118, size: 64)
!118 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !109, file: !95, line: 104, size: 64, elements: !119)
!119 = !{!120, !121}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !118, file: !95, line: 104, baseType: !115, size: 32)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !118, file: !95, line: 104, baseType: !115, size: 32, offset: 32)
!122 = !DILocalVariable(name: "ip_dst_addr", scope: !72, file: !3, line: 84, type: !12)
!123 = !DILocalVariable(name: "ip_src_addr", scope: !72, file: !3, line: 85, type: !12)
!124 = !DILocalVariable(name: "lhinfo", scope: !72, file: !3, line: 99, type: !58)
!125 = !DILocalVariable(name: "idx", scope: !72, file: !3, line: 101, type: !12)
!126 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 96, elements: !127)
!127 = !{!128}
!128 = !DISubrange(count: 12)
!129 = !DIGlobalVariableExpression(var: !130, expr: !DIExpression())
!130 = distinct !DIGlobalVariable(name: "____fmt", scope: !72, file: !3, line: 79, type: !131, isLocal: true, isDefinition: true)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 72, elements: !48)
!132 = !DIGlobalVariableExpression(var: !133, expr: !DIExpression())
!133 = distinct !DIGlobalVariable(name: "____fmt", scope: !72, file: !3, line: 83, type: !134, isLocal: true, isDefinition: true)
!134 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 136, elements: !135)
!135 = !{!136}
!136 = !DISubrange(count: 17)
!137 = !DIGlobalVariableExpression(var: !138, expr: !DIExpression())
!138 = distinct !DIGlobalVariable(name: "____fmt", scope: !72, file: !3, line: 106, type: !139, isLocal: true, isDefinition: true)
!139 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 200, elements: !140)
!140 = !{!141}
!141 = !DISubrange(count: 25)
!142 = !DIGlobalVariableExpression(var: !143, expr: !DIExpression())
!143 = distinct !DIGlobalVariable(name: "____fmt", scope: !72, file: !3, line: 110, type: !144, isLocal: true, isDefinition: true)
!144 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 64, elements: !145)
!145 = !{!146}
!146 = !DISubrange(count: 8)
!147 = !DIGlobalVariableExpression(var: !148, expr: !DIExpression())
!148 = distinct !DIGlobalVariable(name: "____fmt", scope: !72, file: !3, line: 119, type: !149, isLocal: true, isDefinition: true)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 104, elements: !150)
!150 = !{!151}
!151 = !DISubrange(count: 13)
!152 = !DIGlobalVariableExpression(var: !153, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!153 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !20, file: !64, line: 56, type: !154, isLocal: true, isDefinition: true)
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!155 = !DISubroutineType(types: !156)
!156 = !{!30, !30, !157}
!157 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !158, size: 64)
!158 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!159 = !DIGlobalVariableExpression(var: !160, expr: !DIExpression())
!160 = distinct !DIGlobalVariable(name: "____fmt", scope: !161, file: !3, line: 61, type: !174, isLocal: true, isDefinition: true)
!161 = distinct !DISubprogram(name: "ipv4_check", scope: !3, file: !3, line: 32, type: !162, scopeLine: 32, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !165)
!162 = !DISubroutineType(types: !163)
!163 = !{!32, !164, !32, !30}
!164 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!165 = !{!166, !167, !168, !169, !170, !172, !173}
!166 = !DILocalVariable(name: "packet", arg: 1, scope: !161, file: !3, line: 32, type: !164)
!167 = !DILocalVariable(name: "len", arg: 2, scope: !161, file: !3, line: 32, type: !32)
!168 = !DILocalVariable(name: "data_end", arg: 3, scope: !161, file: !3, line: 32, type: !30)
!169 = !DILocalVariable(name: "csum", scope: !161, file: !3, line: 33, type: !12)
!170 = !DILocalVariable(name: "i", scope: !171, file: !3, line: 40, type: !6)
!171 = distinct !DILexicalBlock(scope: !161, file: !3, line: 40, column: 5)
!172 = !DILocalVariable(name: "i", scope: !161, file: !3, line: 55, type: !6)
!173 = !DILocalVariable(name: "checksum", scope: !161, file: !3, line: 63, type: !32)
!174 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 80, elements: !175)
!175 = !{!176}
!176 = !DISubrange(count: 10)
!177 = !{!178, !179, !180, !181}
!178 = !DILocalVariable(name: "ctx", arg: 1, scope: !2, file: !3, line: 125, type: !7)
!179 = !DILocalVariable(name: "data_end", scope: !2, file: !3, line: 126, type: !30)
!180 = !DILocalVariable(name: "data", scope: !2, file: !3, line: 127, type: !30)
!181 = !DILocalVariable(name: "ethh", scope: !2, file: !3, line: 130, type: !75)
!182 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 56, elements: !183)
!183 = !{!184}
!184 = !DISubrange(count: 7)
!185 = !{i32 7, !"Dwarf Version", i32 5}
!186 = !{i32 2, !"Debug Info Version", i32 3}
!187 = !{i32 1, !"wchar_size", i32 4}
!188 = !{i32 7, !"frame-pointer", i32 2}
!189 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!190 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!191 = distinct !DIAssignID()
!192 = !DILocation(line: 0, scope: !2)
!193 = !DILocation(line: 126, column: 38, scope: !2)
!194 = !{!195, !196, i64 4}
!195 = !{!"xdp_md", !196, i64 0, !196, i64 4, !196, i64 8, !196, i64 12, !196, i64 16, !196, i64 20}
!196 = !{!"int", !197, i64 0}
!197 = !{!"omnipotent char", !198, i64 0}
!198 = !{!"Simple C/C++ TBAA"}
!199 = !DILocation(line: 126, column: 27, scope: !2)
!200 = !DILocation(line: 126, column: 19, scope: !2)
!201 = !DILocation(line: 127, column: 38, scope: !2)
!202 = !{!195, !196, i64 0}
!203 = !DILocation(line: 127, column: 27, scope: !2)
!204 = !DILocation(line: 127, column: 19, scope: !2)
!205 = !DILocation(line: 129, column: 2, scope: !206)
!206 = distinct !DILexicalBlock(scope: !2, file: !3, line: 129, column: 2)
!207 = !DILocation(line: 131, column: 20, scope: !208)
!208 = distinct !DILexicalBlock(scope: !2, file: !3, line: 131, column: 6)
!209 = !DILocation(line: 131, column: 25, scope: !208)
!210 = !DILocation(line: 131, column: 6, scope: !2)
!211 = !DILocation(line: 0, scope: !72, inlinedAt: !212)
!212 = distinct !DILocation(line: 136, column: 2, scope: !2)
!213 = !DILocation(line: 68, column: 38, scope: !72, inlinedAt: !212)
!214 = !DILocation(line: 68, column: 27, scope: !72, inlinedAt: !212)
!215 = !DILocation(line: 68, column: 19, scope: !72, inlinedAt: !212)
!216 = !DILocation(line: 72, column: 19, scope: !217, inlinedAt: !212)
!217 = distinct !DILexicalBlock(scope: !72, file: !3, line: 72, column: 6)
!218 = !DILocation(line: 72, column: 24, scope: !217, inlinedAt: !212)
!219 = !DILocation(line: 72, column: 6, scope: !72, inlinedAt: !212)
!220 = !DILocation(line: 77, column: 2, scope: !221, inlinedAt: !212)
!221 = distinct !DILexicalBlock(scope: !72, file: !3, line: 77, column: 2)
!222 = !DILocation(line: 78, column: 11, scope: !223, inlinedAt: !212)
!223 = distinct !DILexicalBlock(scope: !72, file: !3, line: 78, column: 6)
!224 = !DILocation(line: 78, column: 19, scope: !223, inlinedAt: !212)
!225 = !DILocation(line: 78, column: 6, scope: !72, inlinedAt: !212)
!226 = !DILocation(line: 79, column: 3, scope: !227, inlinedAt: !212)
!227 = distinct !DILexicalBlock(scope: !228, file: !3, line: 79, column: 3)
!228 = distinct !DILexicalBlock(scope: !223, file: !3, line: 78, column: 25)
!229 = !DILocation(line: 80, column: 3, scope: !228, inlinedAt: !212)
!230 = !DILocation(line: 83, column: 2, scope: !231, inlinedAt: !212)
!231 = distinct !DILexicalBlock(scope: !72, file: !3, line: 83, column: 2)
!232 = !DILocation(line: 84, column: 27, scope: !72, inlinedAt: !212)
!233 = !{!197, !197, i64 0}
!234 = !DILocation(line: 85, column: 27, scope: !72, inlinedAt: !212)
!235 = !DILocation(line: 88, column: 14, scope: !72, inlinedAt: !212)
!236 = !DILocation(line: 89, column: 14, scope: !72, inlinedAt: !212)
!237 = !DILocation(line: 90, column: 18, scope: !238, inlinedAt: !212)
!238 = distinct !DILexicalBlock(scope: !72, file: !3, line: 90, column: 6)
!239 = !DILocation(line: 90, column: 6, scope: !72, inlinedAt: !212)
!240 = !DILocation(line: 101, column: 2, scope: !72, inlinedAt: !212)
!241 = !DILocation(line: 101, column: 8, scope: !72, inlinedAt: !212)
!242 = !{!196, !196, i64 0}
!243 = distinct !DIAssignID()
!244 = !DILocation(line: 103, column: 11, scope: !72, inlinedAt: !212)
!245 = !DILocation(line: 105, column: 13, scope: !246, inlinedAt: !212)
!246 = distinct !DILexicalBlock(scope: !72, file: !3, line: 105, column: 6)
!247 = !DILocation(line: 105, column: 6, scope: !72, inlinedAt: !212)
!248 = !DILocation(line: 106, column: 3, scope: !249, inlinedAt: !212)
!249 = distinct !DILexicalBlock(scope: !250, file: !3, line: 106, column: 3)
!250 = distinct !DILexicalBlock(scope: !246, file: !3, line: 105, column: 19)
!251 = !DILocation(line: 107, column: 3, scope: !250, inlinedAt: !212)
!252 = !DILocation(line: 110, column: 2, scope: !253, inlinedAt: !212)
!253 = distinct !DILexicalBlock(scope: !72, file: !3, line: 110, column: 2)
!254 = !DILocation(line: 117, column: 15, scope: !72, inlinedAt: !212)
!255 = !{!256, !196, i64 0}
!256 = !{!"lh_info", !196, i64 0}
!257 = !DILocation(line: 117, column: 13, scope: !72, inlinedAt: !212)
!258 = !DILocation(line: 118, column: 18, scope: !72, inlinedAt: !212)
!259 = !DILocation(line: 0, scope: !161, inlinedAt: !260)
!260 = distinct !DILocation(line: 118, column: 18, scope: !72, inlinedAt: !212)
!261 = !DILocation(line: 36, column: 11, scope: !161, inlinedAt: !260)
!262 = !DILocation(line: 36, column: 17, scope: !161, inlinedAt: !260)
!263 = !DILocation(line: 37, column: 11, scope: !161, inlinedAt: !260)
!264 = !DILocation(line: 37, column: 17, scope: !161, inlinedAt: !260)
!265 = !DILocation(line: 0, scope: !171, inlinedAt: !260)
!266 = !DILocation(line: 40, column: 28, scope: !267, inlinedAt: !260)
!267 = distinct !DILexicalBlock(scope: !171, file: !3, line: 40, column: 5)
!268 = !DILocation(line: 40, column: 5, scope: !171, inlinedAt: !260)
!269 = !DILocation(line: 48, column: 10, scope: !270, inlinedAt: !260)
!270 = distinct !DILexicalBlock(scope: !161, file: !3, line: 48, column: 6)
!271 = !DILocation(line: 48, column: 6, scope: !161, inlinedAt: !260)
!272 = !DILocation(line: 41, column: 22, scope: !273, inlinedAt: !260)
!273 = distinct !DILexicalBlock(scope: !274, file: !3, line: 41, column: 7)
!274 = distinct !DILexicalBlock(scope: !267, file: !3, line: 40, column: 46)
!275 = !DILocation(line: 41, column: 27, scope: !273, inlinedAt: !260)
!276 = !DILocation(line: 41, column: 7, scope: !274, inlinedAt: !260)
!277 = !DILocation(line: 42, column: 13, scope: !278, inlinedAt: !260)
!278 = distinct !DILexicalBlock(scope: !273, file: !3, line: 41, column: 40)
!279 = !DILocation(line: 42, column: 12, scope: !278, inlinedAt: !260)
!280 = !DILocation(line: 42, column: 22, scope: !278, inlinedAt: !260)
!281 = !DILocation(line: 42, column: 39, scope: !278, inlinedAt: !260)
!282 = !DILocation(line: 42, column: 31, scope: !278, inlinedAt: !260)
!283 = !DILocation(line: 42, column: 30, scope: !278, inlinedAt: !260)
!284 = !DILocation(line: 42, column: 28, scope: !278, inlinedAt: !260)
!285 = !DILocation(line: 42, column: 9, scope: !278, inlinedAt: !260)
!286 = !DILocation(line: 43, column: 3, scope: !278, inlinedAt: !260)
!287 = !DILocation(line: 46, column: 7, scope: !274, inlinedAt: !260)
!288 = !DILocation(line: 40, column: 41, scope: !267, inlinedAt: !260)
!289 = !DILocation(line: 40, column: 23, scope: !267, inlinedAt: !260)
!290 = distinct !{!290, !268, !291, !292}
!291 = !DILocation(line: 47, column: 5, scope: !171, inlinedAt: !260)
!292 = !{!"llvm.loop.mustprogress"}
!293 = !DILocation(line: 49, column: 22, scope: !294, inlinedAt: !260)
!294 = distinct !DILexicalBlock(scope: !295, file: !3, line: 49, column: 7)
!295 = distinct !DILexicalBlock(scope: !270, file: !3, line: 48, column: 15)
!296 = !DILocation(line: 49, column: 27, scope: !294, inlinedAt: !260)
!297 = !DILocation(line: 49, column: 7, scope: !295, inlinedAt: !260)
!298 = !DILocation(line: 52, column: 12, scope: !295, inlinedAt: !260)
!299 = !DILocation(line: 52, column: 11, scope: !295, inlinedAt: !260)
!300 = !DILocation(line: 52, column: 8, scope: !295, inlinedAt: !260)
!301 = !DILocation(line: 53, column: 2, scope: !295, inlinedAt: !260)
!302 = !DILocation(line: 56, column: 17, scope: !161, inlinedAt: !260)
!303 = !DILocation(line: 56, column: 5, scope: !161, inlinedAt: !260)
!304 = !DILocation(line: 57, column: 22, scope: !305, inlinedAt: !260)
!305 = distinct !DILexicalBlock(scope: !161, file: !3, line: 56, column: 34)
!306 = !DILocation(line: 57, column: 32, scope: !305, inlinedAt: !260)
!307 = !DILocation(line: 58, column: 4, scope: !305, inlinedAt: !260)
!308 = !DILocation(line: 56, column: 23, scope: !161, inlinedAt: !260)
!309 = distinct !{!309, !303, !310, !292}
!310 = !DILocation(line: 59, column: 2, scope: !161, inlinedAt: !260)
!311 = !DILocation(line: 61, column: 2, scope: !312, inlinedAt: !260)
!312 = distinct !DILexicalBlock(scope: !161, file: !3, line: 61, column: 2)
!313 = !DILocation(line: 63, column: 22, scope: !161, inlinedAt: !260)
!314 = !DILocation(line: 118, column: 16, scope: !72, inlinedAt: !212)
!315 = !{!316, !317, i64 10}
!316 = !{!"iphdr", !197, i64 0, !197, i64 0, !197, i64 1, !317, i64 2, !317, i64 4, !317, i64 6, !197, i64 8, !197, i64 9, !317, i64 10, !197, i64 12}
!317 = !{!"short", !197, i64 0}
!318 = !DILocation(line: 119, column: 5, scope: !319, inlinedAt: !212)
!319 = distinct !DILexicalBlock(scope: !72, file: !3, line: 119, column: 5)
!320 = !DILocation(line: 121, column: 2, scope: !72, inlinedAt: !212)
!321 = !DILocation(line: 122, column: 1, scope: !72, inlinedAt: !212)
!322 = !DILocation(line: 145, column: 1, scope: !2)
