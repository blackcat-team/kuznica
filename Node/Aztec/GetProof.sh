#!/bin/bash

# Получаем номер блока
BLOCK_NUMBER=$(curl -s -X POST -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","method":"node_getL2Tips","params":[],"id":67}' \
  http://localhost:8080 | jq -r '.result.proven.number')

# Получаем proof, подставив номер блока дважды
PROOF=$(curl -s -X POST -H 'Content-Type: application/json' \
  -d "{\"jsonrpc\":\"2.0\",\"method\":\"node_getArchiveSiblingPath\",\"params\":[\"$BLOCK_NUMBER\",\"$BLOCK_NUMBER\"],\"id\":67}" \
  http://localhost:8080 | jq -r ".result")

# Выводим результат
echo "Номер блока: $BLOCK_NUMBER"
echo
echo "Proof: $PROOF"
