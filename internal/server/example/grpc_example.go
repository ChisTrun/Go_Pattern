package example
 
 import (
 	example "go_pattern/api"
 )
 
 func NewServer() example.ExampleServer {
 	return &exampleServer{}
 }
 
 type exampleServer struct {
 	example.UnimplementedExampleServer
 }
 
