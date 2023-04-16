#!/bin/bash

mkdir datagenerator
cd datagenerator

#init go module 
go mod init datagenerator

#create generateBase64Encoded to define functions
mkdir -p generateBase64Encoded
echo 'package generateBase64Encoded
import (
    "crypto/rand"
    "encoding/base64"
)
func GenerateNamespaceID() string {
    randomBytes := make([]byte, 8)
    _, err := rand.Read(randomBytes)
    if err != nil {
        panic(err)
    }
    namespaceID := base64.StdEncoding.EncodeToString(randomBytes)
    return namespaceID
}
func GenerateMessage(length int) (string, error) {
    randomBytes := make([]byte, length)
    _, err := rand.Read(randomBytes)
    if err != nil {
        return "", err
    }
    Message := base64.StdEncoding.EncodeToString(randomBytes)
    return Message, nil
}' > generateBase64Encoded/generateBase64Encoded.go

# creates main.go to call generateBase64Encoded package
echo 'package main
import (
    "fmt"
    "datagenerator_base64/generateBase64Encoded"
)
func main() {
    // generate a random 8-byte string
    namespaceID := generateBase64Encoded.GenerateNamespaceID()
    fmt.Println(namespaceID)
    // generate a random message of length 100 bytes
    message, err := generateBase64Encoded.GenerateMessage(50)
    if err != nil {
        panic(err)
    }
    fmt.Println(message)
}' > main.go

# make executable file from 'main.go' change name to datagenerator
go build -o datagenerator main.go

# add to path to run from any directory 
echo 'export PATH="$PATH:'"$PWD"'"' >> $HOME/.bash_profile
source $HOME/.bash_profile

# a binary to generate random data now exists in datagenerator to generate random data for PFB Txs just run 'datagenerator' from any directory
echo "a binary to generate random data now exists in datagenerator to generate random data for PFB Txs just run 'datagenerator' from any directory"
