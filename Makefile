# Directory chứa các file .proto
PROTO_DIR = api

# Tìm tất cả các file .proto trong thư mục api
PROTO_FILES := $(wildcard $(PROTO_DIR)/*.proto)

# Nội dung file go trong server
GO_FILE_CONTENT = package $$lowercase_service\n\
\n\
import (\n\
\t$$base_name \"$$go_module/api\"\n\
)\n\
\n\
func NewServer() $$base_name.$$uppercase_service""Server {\n\
\treturn &$$lowercase_service""Server{}\n\
}\n\
\n\
type $$lowercase_service""Server struct {\n\
\t$$base_name.Unimplemented$$uppercase_service""Server\n\
}\n\

RPC_FILE_CONTENT = package $$lowercase_service\n\
\n\
import (\n\
\t$$base_name \"$$go_module/api\"\n\
\t\"context\"\n\
)\n\
\n\
func (s *$$lowercase_service""Server) $$uppercase_rpc""(ctx context.Context, request *$$base_name"".$$request_type) (*$$base_name"".$$response_type, error) {\n\
\treturn nil, nil\n\
}\n\


generate:
	@for proto in $(PROTO_FILES); do \
		echo "Processing $$proto"; \
		go_module=$$(echo go_pattern); \
		base_name=$$(basename $$proto .proto); \
		BaseName=$$(echo $$base_name | awk '{print toupper(substr($$0, 1, 1)) substr($$0, 2)}'); \
		protoc --go_out=. --go_opt=paths=source_relative \
			--go-grpc_out=. --go-grpc_opt=paths=source_relative \
			$$proto; \
		services=$$(grep 'service ' $$proto | awk '{print $$2}'); \
		for service_name in $$services; do \
			lowercase_service=$$(echo $$service_name | awk '{print tolower($$0)}'); \
			uppercase_service=$$(echo $$service_name | awk '{print toupper(substr($$0, 1, 1)) substr($$0, 2)}'); \
			mkdir -p ./internal/server/$$lowercase_service; \
			file_path=./internal/server/$$lowercase_service/"grpc_"$$lowercase_service".go"; \
			if [ ! -f $$file_path ]; then \
				echo "$(GO_FILE_CONTENT)" > $$file_path; \
			else \
				echo "File $$file_path already exists. Skipping creation."; \
			fi; \
		 	rpcs=$$(sed -n "/service $$service_name {/,/}/p" $$proto | grep 'rpc ' | awk '{print $$2}'); \
			for rpc in $$rpcs; do \
				lowercase_rpc=$$(echo $$rpc | awk '{print tolower($$0)}'); \
				uppercase_rpc=$$(echo $$rpc | awk '{print toupper(substr($$0, 1, 1)) substr($$0, 2)}'); \
				rpc_line=$$(sed -n "/rpc $$rpc/,/}/p" $$proto | grep -m 1 -E "rpc $$rpc "); \
				request_type=$$(echo "$$rpc_line" | awk -F'[()]' '{print $$2}' | awk '{$$1=$$1; print}'); \
				response_type=$$(echo "$$rpc_line" | sed -E 's/rpc [^ ]+ \([^\)]+\) returns \(([^\)]+)\).*/\1/' | awk '{$$1=$$1; print}'); \
				file_path=./internal/server/$$lowercase_service/"grpc_"$$lowercase_service"_"$$lowercase_rpc".go"; \
				if [ ! -f $$file_path ]; then \
					echo "$(RPC_FILE_CONTENT)" > $$file_path; \
				else \
					echo "File $$file_path already exists. Skipping creation."; \
				fi; \
			done; \
		done; \
	done
	@go mod tidy
	@go mod vendor
	@go run -mod=mod entgo.io/ent/cmd/ent generate --target ./package/ent --feature sql/lock,sql/modifier,sql/upsert,sql/execquery ./schema

list-rpcs:
	@echo "Listing RPCs for service: $(SERVICE_NAME) in file: $(PROTO_FILE)"
	@services=$$(grep -A 1 "service $(SERVICE_NAME)" $(PROTO_FILE) | grep 'service ' | awk '{print $$2}'); \
	for service in $$services; do \
		echo "Service: $$service"; \
		rpcs=$$(grep -A 2 "^service $(SERVICE_NAME)" $(PROTO_FILE) | grep -A 1 'rpc ' | grep 'rpc ' | awk '{print $$2}'); \
		for rpc_name in $$rpcs; do \
			request=$$(grep -A 2 "rpc $$rpc_name" $(PROTO_FILE) | grep 'rpc ' | awk '{print $$4}'); \
			echo "  RPC: $$rpc_name"; \
			echo "    Request: $$request"; \
		done; \
	done


clean:
	@find . -name '*.pb.go' -delete

build_image:
	go build -o server ./cmd

gen_node:
	@for proto in $(PROTO_FILES); do \
		protoc --js_out=import_style=commonjs,binary:./connect/node \
       --grpc_out=./connect/node \
       --plugin=protoc-gen-grpc=`which grpc_tools_node_protoc_plugin` \
		$$proto; \
	done

gen_web:
	@for proto in $(PROTO_FILES); do \
		protoc --js_out=import_style=commonjs,binary:./connect/web \
       --grpc-web_out=import_style=commonjs,mode=grpcwebtext:./connect/web \
       $$proto; \
	done

gen_ts:
	@for proto in $(PROTO_FILES); do \
		protoc --ts_out=connect/ts \
		--ts_opt=target=web\
       $$proto; \
	done

gen_web2:
	@for proto in $(PROTO_FILES); do \
		protoc -I. $$proto\
  		--grpc-web_out=import_style=closure,mode=grpcweb:./connect/web; \
	done

gen_proto:
	@for proto in $(PROTO_FILES); do \
		npx grpc_tools_node_protoc \
		--plugin=protoc-gen-grpc="$(which grpc_tools_node_protoc_plugin)" \
		--ts_opt=target=web\
		--ts_out=grpc_js:./connect/proto \
       $$proto; \
	done
