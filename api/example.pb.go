// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.33.0
// 	protoc        v5.27.1
// source: api/example.proto

package go_pattern

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

var File_api_example_proto protoreflect.FileDescriptor

var file_api_example_proto_rawDesc = []byte{
	0x0a, 0x11, 0x61, 0x70, 0x69, 0x2f, 0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x2e, 0x70, 0x72,
	0x6f, 0x74, 0x6f, 0x12, 0x0a, 0x67, 0x6f, 0x5f, 0x70, 0x61, 0x74, 0x74, 0x65, 0x72, 0x6e, 0x32,
	0x09, 0x0a, 0x07, 0x45, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x42, 0x1b, 0x5a, 0x19, 0x67, 0x6f,
	0x5f, 0x70, 0x61, 0x74, 0x74, 0x65, 0x72, 0x6e, 0x2f, 0x61, 0x70, 0x69, 0x3b, 0x67, 0x6f, 0x5f,
	0x70, 0x61, 0x74, 0x74, 0x65, 0x72, 0x6e,
}

var file_api_example_proto_goTypes = []interface{}{}
var file_api_example_proto_depIdxs = []int32{
	0, // [0:0] is the sub-list for method output_type
	0, // [0:0] is the sub-list for method input_type
	0, // [0:0] is the sub-list for extension type_name
	0, // [0:0] is the sub-list for extension extendee
	0, // [0:0] is the sub-list for field type_name
}

func init() { file_api_example_proto_init() }
func file_api_example_proto_init() {
	if File_api_example_proto != nil {
		return
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_api_example_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   0,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_api_example_proto_goTypes,
		DependencyIndexes: file_api_example_proto_depIdxs,
	}.Build()
	File_api_example_proto = out.File
	file_api_example_proto_rawDesc = nil
	file_api_example_proto_goTypes = nil
	file_api_example_proto_depIdxs = nil
}
