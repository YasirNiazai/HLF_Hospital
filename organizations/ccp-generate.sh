#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${HOSP}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${HOSP}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

HOSP=1
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/hosp1.example.com/tlsca/tlsca.hosp1.example.com-cert.pem
CAPEM=organizations/peerOrganizations/hosp1.example.com/ca/ca.hosp1.example.com-cert.pem

echo "$(json_ccp $HOSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hosp1.example.com/connection-hosp1.json
echo "$(yaml_ccp $HOSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hosp1.example.com/connection-hosp1.yaml

HOSP=2
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/hosp2.example.com/tlsca/tlsca.hosp2.example.com-cert.pem
CAPEM=organizations/peerOrganizations/hosp2.example.com/ca/ca.hosp2.example.com-cert.pem

echo "$(json_ccp $HOSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hosp2.example.com/connection-hosp2.json
echo "$(yaml_ccp $HOSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hosp2.example.com/connection-hosp2.yaml
