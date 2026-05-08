// Package logger provides shared logging utilities
package logger

import "log"

// Info logs an info message
func Info(msg string) {
	log.Println("[INFO]", msg)
}

// Error logs an error message
func Error(msg string) {
	log.Println("[ERROR]", msg)
}

// Warn logs a warning message
func Warn(msg string) {
	log.Println("[WARN]", msg)
}
