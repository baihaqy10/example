package main


import (
"fmt"
"html/template"
"log"
"net/http"
"strconv"
)


var tmpl = template.Must(template.ParseFiles("templates/index.html"))


func handler(w http.ResponseWriter, r *http.Request) {
style := 1
if s := r.URL.Query().Get("style"); s != "" {
if v, err := strconv.Atoi(s); err == nil && v >= 1 && v <= 3 {
style = v
}
}
err := tmpl.Execute(w, style)
if err != nil {
http.Error(w, err.Error(), http.StatusInternalServerError)
}
}


func main() {
http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
http.HandleFunc("/", handler)
fmt.Println("Server running on :8080")
log.Fatal(http.ListenAndServe(":8080", nil))
}