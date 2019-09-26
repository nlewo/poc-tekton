package main

import (
	"fmt"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "hello world\n")
}

func main() {
	log.Print("Server listening on port ", 8080)
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
