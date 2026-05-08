package main

import (
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func getEnv(key, fallback string) string {
	value := os.Getenv(key)
	if value == "" {
		return fallback
	}

	return value
}

func findDistDir() string {
	if fromEnv := os.Getenv("FRONTEND_DIST_DIR"); fromEnv != "" {
		if _, err := os.Stat(filepath.Join(fromEnv, "index.html")); err == nil {
			return fromEnv
		}
	}

	candidates := []string{
		"./ui/dist",
		"services/frontend/ui/dist",
		"/app/ui/dist",
	}

	for _, candidate := range candidates {
		if _, err := os.Stat(filepath.Join(candidate, "index.html")); err == nil {
			return candidate
		}
	}

	return ""
}

func main() {
	port := getEnv("PORT", "80")
	distDir := findDistDir()

	if distDir == "" {
		log.Fatal("frontend assets not found: expected index.html under ui/dist")
	}

	log.Printf("serving frontend assets from %s", distDir)

	staticFiles := http.FileServer(http.Dir(distDir))
	mux := http.NewServeMux()

	mux.HandleFunc("/healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte("ok"))
	})

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet && r.Method != http.MethodHead {
			http.Error(w, "method not allowed", http.StatusMethodNotAllowed)

			return
		}

		path := strings.TrimPrefix(filepath.Clean(r.URL.Path), "/")
		if path == "." {
			path = ""
		}

		if path != "" {
			candidate := filepath.Join(distDir, path)
			if info, err := os.Stat(candidate); err == nil && !info.IsDir() {
				staticFiles.ServeHTTP(w, r)

				return
			}
		}

		http.ServeFile(w, r, filepath.Join(distDir, "index.html"))
	})

	addr := ":" + port
	log.Printf("frontend service listening on %s", addr)

	if err := http.ListenAndServe(addr, mux); err != nil {
		log.Fatalf("frontend service failed: %v", err)
	}
}
