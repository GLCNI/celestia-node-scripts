#!/bin/bash

mkdir datagenerator
cd datagenerator

#init go module 
go mod init datagenerator

#create generateRandHexEncoded to define functions
mkdir -p generateRandHexEncoded
touch generateRandHexEncoded/generateRandHexEncoded.go
nano generateRandHexEncoded/generateRandHexEncoded.go
cat <<EOF > generateRandHexEncoded/generateRandHexEncoded.go
package generateRandHexEncoded

import (
    "crypto/rand"
    "encoding/hex"
)

func GenerateNamespaceID() string {
    randomBytes := make([]byte, 8)
    _, err := rand.Read(randomBytes)
    if err != nil {
        panic(err)
    }
    namespaceID := hex.EncodeToString(randomBytes)
    return namespaceID
}

func GenerateMessage(length int) (string, error) {
    randomBytes := make([]byte, length)
    _, err := rand.Read(randomBytes)
    if err != nil {
        return "", err
    }
    Message := hex.EncodeToString(randomBytes)
    return Message, nil
}
EOF

# creates main.go to call generateRandHexEncoded package
nano main.go
cat <<EOF > ../main.go
package main

import (
    "fmt"
    "datagenerator/generateRandHexEncoded"
)

func main() {
    // generate a random 8-byte string
    namespaceID := generateRandHexEncoded.GenerateNamespaceID()
    fmt.Println(namespaceID)

    // generate a random message of length 100 bytes
    message, err := generateRandHexEncoded.GenerateMessage(50)
    if err != nil {
        panic(err)
    }
    fmt.Println(message)
}
EOF

# make executable file from 'main.go' change name to datagenerator
go build -o datagenerator main.go

# add to path to run from any directory 
echo 'export PATH=$PATH:$PWD' >> $HOME/.bash_profile
source $HOME/.bash_profile

# a binary to generate random data now exists in datagenerator to generate random data for PFB Txs just run 'datagenerator'
echo "a binary to generate random data now exists in datagenerator to generate random data for PFB Txs just run 'datagenerator' from any directory"
