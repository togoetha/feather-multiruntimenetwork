; ModuleID = 'bpf_tail_call_ipv4.c'
source_filename = "bpf_tail_call_ipv4.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon.3 = type { ptr, ptr, ptr, ptr }
%struct.anon.4 = type { ptr, ptr, ptr, ptr }
%struct.__sk_buff = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [5 x i32], i32, i32, i32, i32, i32, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, %union.anon, i64, i32, i32, %union.anon.0, i32, i8, [3 x i8], i64 }
%union.anon = type { ptr }
%union.anon.0 = type { ptr }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@ip_map = dso_local global %struct.anon.3 zeroinitializer, section ".maps", align 8, !dbg !0
@jump_table = dso_local global %struct.anon.4 zeroinitializer, section ".maps", align 8, !dbg !17
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !11
@llvm.compiler.used = appending global [4 x ptr] [ptr @_license, ptr @ip_map, ptr @jump_table, ptr @lh_tails_ipv4], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local noundef i32 @lh_tails_ipv4(ptr noundef %0) #0 section "tc" !dbg !64 {
  %2 = alloca i32, align 4, !DIAssignID !227
  call void @llvm.dbg.assign(metadata i1 undef, metadata !215, metadata !DIExpression(), metadata !227, metadata ptr %2, metadata !DIExpression()), !dbg !228
  tail call void @llvm.dbg.value(metadata ptr %0, metadata !171, metadata !DIExpression()), !dbg !229
  %3 = getelementptr inbounds %struct.__sk_buff, ptr %0, i64 0, i32 16, !dbg !230
  %4 = load i32, ptr %3, align 8, !dbg !230, !tbaa !231
  %5 = zext i32 %4 to i64, !dbg !237
  %6 = inttoptr i64 %5 to ptr, !dbg !238
  tail call void @llvm.dbg.value(metadata ptr %6, metadata !172, metadata !DIExpression()), !dbg !229
  %7 = getelementptr inbounds %struct.__sk_buff, ptr %0, i64 0, i32 15, !dbg !239
  %8 = load i32, ptr %7, align 4, !dbg !239, !tbaa !240
  %9 = zext i32 %8 to i64, !dbg !241
  %10 = inttoptr i64 %9 to ptr, !dbg !242
  tail call void @llvm.dbg.value(metadata ptr %10, metadata !173, metadata !DIExpression()), !dbg !229
  tail call void @llvm.dbg.value(metadata ptr %10, metadata !174, metadata !DIExpression()), !dbg !229
  %11 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 1, !dbg !243
  %12 = icmp ugt ptr %11, %6, !dbg !244
  tail call void @llvm.dbg.value(metadata ptr %11, metadata !185, metadata !DIExpression()), !dbg !245
  %13 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 2, i32 1
  %14 = icmp ugt ptr %13, %6
  %15 = select i1 %12, i1 true, i1 %14, !dbg !246
  br i1 %15, label %47, label %16, !dbg !246

16:                                               ; preds = %1
  %17 = load i8, ptr %11, align 4, !dbg !247
  %18 = and i8 %17, -16, !dbg !248
  %19 = icmp eq i8 %18, 64, !dbg !248
  br i1 %19, label %20, label %47, !dbg !249

20:                                               ; preds = %16
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #4, !dbg !250
  store i32 0, ptr %2, align 4, !dbg !251, !tbaa !252, !DIAssignID !253
  call void @llvm.dbg.assign(metadata i32 0, metadata !215, metadata !DIExpression(), metadata !253, metadata ptr %2, metadata !DIExpression()), !dbg !228
  %21 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @ip_map, ptr noundef nonnull %2) #4, !dbg !254
  tail call void @llvm.dbg.value(metadata ptr %21, metadata !220, metadata !DIExpression()), !dbg !228
  %22 = icmp eq ptr %21, null, !dbg !255
  br i1 %22, label %46, label %23, !dbg !256

23:                                               ; preds = %20
  %24 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 1, i32 2, !dbg !257
  %25 = load i32, ptr %24, align 4, !dbg !257, !tbaa !258
  %26 = and i32 %25, -117440513, !dbg !259
  tail call void @llvm.dbg.value(metadata i32 %26, metadata !221, metadata !DIExpression()), !dbg !260
  %27 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 2, i32 0, i64 2, !dbg !261
  %28 = load i32, ptr %27, align 4, !dbg !261, !tbaa !258
  %29 = and i32 %28, -117440513, !dbg !262
  tail call void @llvm.dbg.value(metadata i32 %29, metadata !224, metadata !DIExpression()), !dbg !260
  %30 = load i32, ptr %21, align 4, !dbg !263, !tbaa !252
  %31 = call i32 @llvm.bswap.i32(i32 %30), !dbg !263
  tail call void @llvm.dbg.value(metadata i32 %31, metadata !225, metadata !DIExpression()), !dbg !260
  %32 = and i32 %31, 33554431, !dbg !264
  tail call void @llvm.dbg.value(metadata i32 %32, metadata !226, metadata !DIExpression()), !dbg !260
  %33 = icmp eq i32 %26, %29, !dbg !265
  %34 = icmp eq i32 %25, %32
  %35 = select i1 %33, i1 true, i1 %34, !dbg !267
  %36 = icmp eq i32 %28, %32
  %37 = select i1 %35, i1 true, i1 %36, !dbg !267
  br i1 %37, label %46, label %38, !dbg !267

38:                                               ; preds = %23
  %39 = icmp eq i32 %29, %31, !dbg !268
  br i1 %39, label %40, label %42, !dbg !271

40:                                               ; preds = %38
  %41 = call i64 inttoptr (i64 12 to ptr)(ptr noundef nonnull %0, ptr noundef nonnull @jump_table, i32 noundef 0) #4, !dbg !272
  br label %42, !dbg !274

42:                                               ; preds = %40, %38
  %43 = icmp eq i32 %26, %31, !dbg !275
  br i1 %43, label %44, label %46, !dbg !277

44:                                               ; preds = %42
  %45 = call i64 inttoptr (i64 12 to ptr)(ptr noundef nonnull %0, ptr noundef nonnull @jump_table, i32 noundef 1) #4, !dbg !278
  br label %46, !dbg !280

46:                                               ; preds = %23, %44, %42, %20
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #4, !dbg !281
  br label %47, !dbg !282

47:                                               ; preds = %46, %16, %1
  ret i32 0, !dbg !283
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.bswap.i32(i32) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.assign(metadata, metadata, metadata, metadata, metadata, metadata) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!58, !59, !60, !61, !62}
!llvm.ident = !{!63}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "ip_map", scope: !2, file: !3, line: 25, type: !48, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !10, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "bpf_tail_call_ipv4.c", directory: "/home/togoetha/projects/service/xdp-progs/multi-runtime-cni-ipv4", checksumkind: CSK_MD5, checksum: "a3d63a981017f766ffcccfcb3893242d")
!4 = !{!5, !6, !7}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !8, line: 27, baseType: !9)
!8 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!9 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!10 = !{!11, !17, !0, !35, !43}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 85, type: !13, isLocal: false, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 32, elements: !15)
!14 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!15 = !{!16}
!16 = !DISubrange(count: 4)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(name: "jump_table", scope: !2, file: !3, line: 18, type: !19, isLocal: false, isDefinition: true)
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 13, size: 256, elements: !20)
!20 = !{!21, !27, !29, !30}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !19, file: !3, line: 14, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 96, elements: !25)
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !{!26}
!26 = !DISubrange(count: 3)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !19, file: !3, line: 15, baseType: !28, size: 64, offset: 64)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !19, file: !3, line: 16, baseType: !28, size: 64, offset: 128)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !19, file: !3, line: 17, baseType: !31, size: 64, offset: 192)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 64, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 2)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!36 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !37, line: 56, type: !38, isLocal: true, isDefinition: true)
!37 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "09cfcd7169c24bec448f30582e8c6db9")
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DISubroutineType(types: !40)
!40 = !{!5, !5, !41}
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression(DW_OP_constu, 12, DW_OP_stack_value))
!44 = distinct !DIGlobalVariable(name: "bpf_tail_call", scope: !2, file: !37, line: 327, type: !45, isLocal: true, isDefinition: true)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = !DISubroutineType(types: !47)
!47 = !{!6, !5, !5, !7}
!48 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 20, size: 256, elements: !49)
!49 = !{!50, !51, !56, !57}
!50 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !48, file: !3, line: 21, baseType: !31, size: 64)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !48, file: !3, line: 22, baseType: !52, size: 64, offset: 64)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 1)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !48, file: !3, line: 23, baseType: !28, size: 64, offset: 128)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !48, file: !3, line: 24, baseType: !28, size: 64, offset: 192)
!58 = !{i32 7, !"Dwarf Version", i32 5}
!59 = !{i32 2, !"Debug Info Version", i32 3}
!60 = !{i32 1, !"wchar_size", i32 4}
!61 = !{i32 7, !"frame-pointer", i32 2}
!62 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!63 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!64 = distinct !DISubprogram(name: "lh_tails_ipv4", scope: !3, file: !3, line: 28, type: !65, scopeLine: 28, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !170)
!65 = !DISubroutineType(types: !66)
!66 = !{!24, !67}
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !68, size: 64)
!68 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sk_buff", file: !69, line: 6111, size: 1536, elements: !70)
!69 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "8106ce79fb72e4cfc709095592a01f1d")
!70 = !{!71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !87, !88, !89, !90, !91, !92, !93, !94, !95, !97, !98, !99, !100, !101, !140, !143, !144, !145, !167, !168, !169}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !68, file: !69, line: 6112, baseType: !7, size: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_type", scope: !68, file: !69, line: 6113, baseType: !7, size: 32, offset: 32)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !68, file: !69, line: 6114, baseType: !7, size: 32, offset: 64)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "queue_mapping", scope: !68, file: !69, line: 6115, baseType: !7, size: 32, offset: 96)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !68, file: !69, line: 6116, baseType: !7, size: 32, offset: 128)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_present", scope: !68, file: !69, line: 6117, baseType: !7, size: 32, offset: 160)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_tci", scope: !68, file: !69, line: 6118, baseType: !7, size: 32, offset: 192)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_proto", scope: !68, file: !69, line: 6119, baseType: !7, size: 32, offset: 224)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !68, file: !69, line: 6120, baseType: !7, size: 32, offset: 256)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !68, file: !69, line: 6121, baseType: !7, size: 32, offset: 288)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !68, file: !69, line: 6122, baseType: !7, size: 32, offset: 320)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "tc_index", scope: !68, file: !69, line: 6123, baseType: !7, size: 32, offset: 352)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "cb", scope: !68, file: !69, line: 6124, baseType: !84, size: 160, offset: 384)
!84 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 160, elements: !85)
!85 = !{!86}
!86 = !DISubrange(count: 5)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "hash", scope: !68, file: !69, line: 6125, baseType: !7, size: 32, offset: 544)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "tc_classid", scope: !68, file: !69, line: 6126, baseType: !7, size: 32, offset: 576)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !68, file: !69, line: 6127, baseType: !7, size: 32, offset: 608)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !68, file: !69, line: 6128, baseType: !7, size: 32, offset: 640)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "napi_id", scope: !68, file: !69, line: 6129, baseType: !7, size: 32, offset: 672)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !68, file: !69, line: 6132, baseType: !7, size: 32, offset: 704)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !68, file: !69, line: 6133, baseType: !7, size: 32, offset: 736)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !68, file: !69, line: 6134, baseType: !7, size: 32, offset: 768)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !68, file: !69, line: 6135, baseType: !96, size: 128, offset: 800)
!96 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 128, elements: !15)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !68, file: !69, line: 6136, baseType: !96, size: 128, offset: 928)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !68, file: !69, line: 6137, baseType: !7, size: 32, offset: 1056)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !68, file: !69, line: 6138, baseType: !7, size: 32, offset: 1088)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !68, file: !69, line: 6141, baseType: !7, size: 32, offset: 1120)
!101 = !DIDerivedType(tag: DW_TAG_member, scope: !68, file: !69, line: 6142, baseType: !102, size: 64, align: 64, offset: 1152)
!102 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !68, file: !69, line: 6142, size: 64, align: 64, elements: !103)
!103 = !{!104}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "flow_keys", scope: !102, file: !69, line: 6142, baseType: !105, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_flow_keys", file: !69, line: 7128, size: 448, elements: !107)
!107 = !{!108, !111, !112, !113, !116, !117, !118, !119, !122, !123, !124, !138, !139}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "nhoff", scope: !106, file: !69, line: 7129, baseType: !109, size: 16)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !8, line: 24, baseType: !110)
!110 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "thoff", scope: !106, file: !69, line: 7130, baseType: !109, size: 16, offset: 16)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "addr_proto", scope: !106, file: !69, line: 7131, baseType: !109, size: 16, offset: 32)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "is_frag", scope: !106, file: !69, line: 7132, baseType: !114, size: 8, offset: 48)
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !8, line: 21, baseType: !115)
!115 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "is_first_frag", scope: !106, file: !69, line: 7133, baseType: !114, size: 8, offset: 56)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "is_encap", scope: !106, file: !69, line: 7134, baseType: !114, size: 8, offset: 64)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !106, file: !69, line: 7135, baseType: !114, size: 8, offset: 72)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "n_proto", scope: !106, file: !69, line: 7136, baseType: !120, size: 16, offset: 80)
!120 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !121, line: 32, baseType: !109)
!121 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "bf9fbc0e8f60927fef9d8917535375a6")
!122 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !106, file: !69, line: 7137, baseType: !120, size: 16, offset: 96)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !106, file: !69, line: 7138, baseType: !120, size: 16, offset: 112)
!124 = !DIDerivedType(tag: DW_TAG_member, scope: !106, file: !69, line: 7139, baseType: !125, size: 256, offset: 128)
!125 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !106, file: !69, line: 7139, size: 256, elements: !126)
!126 = !{!127, !133}
!127 = !DIDerivedType(tag: DW_TAG_member, scope: !125, file: !69, line: 7140, baseType: !128, size: 64)
!128 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !125, file: !69, line: 7140, size: 64, elements: !129)
!129 = !{!130, !132}
!130 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !128, file: !69, line: 7141, baseType: !131, size: 32)
!131 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !121, line: 34, baseType: !7)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !128, file: !69, line: 7142, baseType: !131, size: 32, offset: 32)
!133 = !DIDerivedType(tag: DW_TAG_member, scope: !125, file: !69, line: 7144, baseType: !134, size: 256)
!134 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !125, file: !69, line: 7144, size: 256, elements: !135)
!135 = !{!136, !137}
!136 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !134, file: !69, line: 7145, baseType: !96, size: 128)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !134, file: !69, line: 7146, baseType: !96, size: 128, offset: 128)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !106, file: !69, line: 7149, baseType: !7, size: 32, offset: 384)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "flow_label", scope: !106, file: !69, line: 7150, baseType: !131, size: 32, offset: 416)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp", scope: !68, file: !69, line: 6143, baseType: !141, size: 64, offset: 1216)
!141 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !8, line: 31, baseType: !142)
!142 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "wire_len", scope: !68, file: !69, line: 6144, baseType: !7, size: 32, offset: 1280)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "gso_segs", scope: !68, file: !69, line: 6145, baseType: !7, size: 32, offset: 1312)
!145 = !DIDerivedType(tag: DW_TAG_member, scope: !68, file: !69, line: 6146, baseType: !146, size: 64, align: 64, offset: 1344)
!146 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !68, file: !69, line: 6146, size: 64, align: 64, elements: !147)
!147 = !{!148}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "sk", scope: !146, file: !69, line: 6146, baseType: !149, size: 64)
!149 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !150, size: 64)
!150 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock", file: !69, line: 6215, size: 640, elements: !151)
!151 = !{!152, !153, !154, !155, !156, !157, !158, !159, !160, !161, !162, !163, !164, !165}
!152 = !DIDerivedType(tag: DW_TAG_member, name: "bound_dev_if", scope: !150, file: !69, line: 6216, baseType: !7, size: 32)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !150, file: !69, line: 6217, baseType: !7, size: 32, offset: 32)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !150, file: !69, line: 6218, baseType: !7, size: 32, offset: 64)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !150, file: !69, line: 6219, baseType: !7, size: 32, offset: 96)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !150, file: !69, line: 6220, baseType: !7, size: 32, offset: 128)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !150, file: !69, line: 6221, baseType: !7, size: 32, offset: 160)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip4", scope: !150, file: !69, line: 6223, baseType: !7, size: 32, offset: 192)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip6", scope: !150, file: !69, line: 6224, baseType: !96, size: 128, offset: 224)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !150, file: !69, line: 6225, baseType: !7, size: 32, offset: 352)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !150, file: !69, line: 6226, baseType: !120, size: 16, offset: 384)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip4", scope: !150, file: !69, line: 6228, baseType: !7, size: 32, offset: 416)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip6", scope: !150, file: !69, line: 6229, baseType: !96, size: 128, offset: 448)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !150, file: !69, line: 6230, baseType: !7, size: 32, offset: 576)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_mapping", scope: !150, file: !69, line: 6231, baseType: !166, size: 32, offset: 608)
!166 = !DIDerivedType(tag: DW_TAG_typedef, name: "__s32", file: !8, line: 26, baseType: !24)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "gso_size", scope: !68, file: !69, line: 6147, baseType: !7, size: 32, offset: 1408)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp_type", scope: !68, file: !69, line: 6148, baseType: !114, size: 8, offset: 1440)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "hwtstamp", scope: !68, file: !69, line: 6150, baseType: !141, size: 64, offset: 1472)
!170 = !{!171, !172, !173, !174, !185, !215, !220, !221, !224, !225, !226}
!171 = !DILocalVariable(name: "skb", arg: 1, scope: !64, file: !3, line: 28, type: !67)
!172 = !DILocalVariable(name: "data_end", scope: !64, file: !3, line: 29, type: !5)
!173 = !DILocalVariable(name: "data", scope: !64, file: !3, line: 30, type: !5)
!174 = !DILocalVariable(name: "ethh", scope: !64, file: !3, line: 33, type: !175)
!175 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !176, size: 64)
!176 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !177, line: 173, size: 112, elements: !178)
!177 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!178 = !{!179, !183, !184}
!179 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !176, file: !177, line: 174, baseType: !180, size: 48)
!180 = !DICompositeType(tag: DW_TAG_array_type, baseType: !115, size: 48, elements: !181)
!181 = !{!182}
!182 = !DISubrange(count: 6)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !176, file: !177, line: 175, baseType: !180, size: 48, offset: 48)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !176, file: !177, line: 176, baseType: !120, size: 16, offset: 96)
!185 = !DILocalVariable(name: "iph", scope: !186, file: !3, line: 36, type: !188)
!186 = distinct !DILexicalBlock(scope: !187, file: !3, line: 34, column: 41)
!187 = distinct !DILexicalBlock(scope: !64, file: !3, line: 34, column: 9)
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !189, size: 64)
!189 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !190, line: 87, size: 160, elements: !191)
!190 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!191 = !{!192, !193, !194, !195, !196, !197, !198, !199, !200, !202}
!192 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !189, file: !190, line: 89, baseType: !114, size: 4, flags: DIFlagBitField, extraData: i64 0)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !189, file: !190, line: 90, baseType: !114, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !189, file: !190, line: 97, baseType: !114, size: 8, offset: 8)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !189, file: !190, line: 98, baseType: !120, size: 16, offset: 16)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !189, file: !190, line: 99, baseType: !120, size: 16, offset: 32)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !189, file: !190, line: 100, baseType: !120, size: 16, offset: 48)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !189, file: !190, line: 101, baseType: !114, size: 8, offset: 64)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !189, file: !190, line: 102, baseType: !114, size: 8, offset: 72)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !189, file: !190, line: 103, baseType: !201, size: 16, offset: 80)
!201 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !121, line: 38, baseType: !109)
!202 = !DIDerivedType(tag: DW_TAG_member, scope: !189, file: !190, line: 104, baseType: !203, size: 64, offset: 96)
!203 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !189, file: !190, line: 104, size: 64, elements: !204)
!204 = !{!205, !210}
!205 = !DIDerivedType(tag: DW_TAG_member, scope: !203, file: !190, line: 104, baseType: !206, size: 64)
!206 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !203, file: !190, line: 104, size: 64, elements: !207)
!207 = !{!208, !209}
!208 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !206, file: !190, line: 104, baseType: !131, size: 32)
!209 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !206, file: !190, line: 104, baseType: !131, size: 32, offset: 32)
!210 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !203, file: !190, line: 104, baseType: !211, size: 64)
!211 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !203, file: !190, line: 104, size: 64, elements: !212)
!212 = !{!213, !214}
!213 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !211, file: !190, line: 104, baseType: !131, size: 32)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !211, file: !190, line: 104, baseType: !131, size: 32, offset: 32)
!215 = !DILocalVariable(name: "idx", scope: !216, file: !3, line: 42, type: !7)
!216 = distinct !DILexicalBlock(scope: !217, file: !3, line: 41, column: 36)
!217 = distinct !DILexicalBlock(scope: !218, file: !3, line: 41, column: 17)
!218 = distinct !DILexicalBlock(scope: !219, file: !3, line: 38, column: 44)
!219 = distinct !DILexicalBlock(scope: !186, file: !3, line: 38, column: 13)
!220 = !DILocalVariable(name: "ipnet", scope: !216, file: !3, line: 43, type: !28)
!221 = !DILocalVariable(name: "snet", scope: !222, file: !3, line: 49, type: !7)
!222 = distinct !DILexicalBlock(scope: !223, file: !3, line: 48, column: 33)
!223 = distinct !DILexicalBlock(scope: !216, file: !3, line: 48, column: 21)
!224 = !DILocalVariable(name: "dnet", scope: !222, file: !3, line: 50, type: !7)
!225 = !DILocalVariable(name: "nsnet", scope: !222, file: !3, line: 51, type: !7)
!226 = !DILocalVariable(name: "iploc", scope: !222, file: !3, line: 52, type: !7)
!227 = distinct !DIAssignID()
!228 = !DILocation(line: 0, scope: !216)
!229 = !DILocation(line: 0, scope: !64)
!230 = !DILocation(line: 29, column: 38, scope: !64)
!231 = !{!232, !233, i64 80}
!232 = !{!"__sk_buff", !233, i64 0, !233, i64 4, !233, i64 8, !233, i64 12, !233, i64 16, !233, i64 20, !233, i64 24, !233, i64 28, !233, i64 32, !233, i64 36, !233, i64 40, !233, i64 44, !234, i64 48, !233, i64 68, !233, i64 72, !233, i64 76, !233, i64 80, !233, i64 84, !233, i64 88, !233, i64 92, !233, i64 96, !234, i64 100, !234, i64 116, !233, i64 132, !233, i64 136, !233, i64 140, !234, i64 144, !236, i64 152, !233, i64 160, !233, i64 164, !234, i64 168, !233, i64 176, !234, i64 180, !236, i64 184}
!233 = !{!"int", !234, i64 0}
!234 = !{!"omnipotent char", !235, i64 0}
!235 = !{!"Simple C/C++ TBAA"}
!236 = !{!"long long", !234, i64 0}
!237 = !DILocation(line: 29, column: 27, scope: !64)
!238 = !DILocation(line: 29, column: 19, scope: !64)
!239 = !DILocation(line: 30, column: 41, scope: !64)
!240 = !{!232, !233, i64 76}
!241 = !DILocation(line: 30, column: 30, scope: !64)
!242 = !DILocation(line: 30, column: 22, scope: !64)
!243 = !DILocation(line: 34, column: 23, scope: !187)
!244 = !DILocation(line: 34, column: 28, scope: !187)
!245 = !DILocation(line: 0, scope: !186)
!246 = !DILocation(line: 34, column: 9, scope: !64)
!247 = !DILocation(line: 41, column: 22, scope: !217)
!248 = !DILocation(line: 41, column: 30, scope: !217)
!249 = !DILocation(line: 41, column: 17, scope: !218)
!250 = !DILocation(line: 42, column: 17, scope: !216)
!251 = !DILocation(line: 42, column: 23, scope: !216)
!252 = !{!233, !233, i64 0}
!253 = distinct !DIAssignID()
!254 = !DILocation(line: 43, column: 32, scope: !216)
!255 = !DILocation(line: 48, column: 27, scope: !223)
!256 = !DILocation(line: 48, column: 21, scope: !216)
!257 = !DILocation(line: 49, column: 39, scope: !222)
!258 = !{!234, !234, i64 0}
!259 = !DILocation(line: 49, column: 45, scope: !222)
!260 = !DILocation(line: 0, scope: !222)
!261 = !DILocation(line: 50, column: 39, scope: !222)
!262 = !DILocation(line: 50, column: 45, scope: !222)
!263 = !DILocation(line: 51, column: 35, scope: !222)
!264 = !DILocation(line: 52, column: 41, scope: !222)
!265 = !DILocation(line: 61, column: 30, scope: !266)
!266 = distinct !DILexicalBlock(scope: !222, file: !3, line: 61, column: 25)
!267 = !DILocation(line: 61, column: 38, scope: !266)
!268 = !DILocation(line: 64, column: 34, scope: !269)
!269 = distinct !DILexicalBlock(scope: !270, file: !3, line: 64, column: 29)
!270 = distinct !DILexicalBlock(scope: !266, file: !3, line: 61, column: 85)
!271 = !DILocation(line: 64, column: 29, scope: !270)
!272 = !DILocation(line: 66, column: 29, scope: !273)
!273 = distinct !DILexicalBlock(scope: !269, file: !3, line: 64, column: 44)
!274 = !DILocation(line: 68, column: 25, scope: !273)
!275 = !DILocation(line: 70, column: 34, scope: !276)
!276 = distinct !DILexicalBlock(scope: !270, file: !3, line: 70, column: 29)
!277 = !DILocation(line: 70, column: 29, scope: !270)
!278 = !DILocation(line: 72, column: 29, scope: !279)
!279 = distinct !DILexicalBlock(scope: !276, file: !3, line: 70, column: 44)
!280 = !DILocation(line: 74, column: 25, scope: !279)
!281 = !DILocation(line: 78, column: 13, scope: !217)
!282 = !DILocation(line: 78, column: 13, scope: !216)
!283 = !DILocation(line: 82, column: 5, scope: !64)
