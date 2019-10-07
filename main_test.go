package main

import (
	"bytes"
	"io/ioutil"
	"net/http/httptest"
	"testing"
)

func TestHandler(t *testing.T) {
	expected := []byte("hello world\n")
	req := httptest.NewRequest("GET", "http://localhost:8080/", nil)
	w := httptest.NewRecorder()
	handler(w, req)
	resp := w.Result()
	body, _ := ioutil.ReadAll(resp.Body)
	if bytes.Compare(body, expected) != 0 {
		t.Errorf("Body is:\n%s\nWant:\n%s", body, expected)
	}
}
