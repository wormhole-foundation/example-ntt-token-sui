#!/bin/bash
# Parse sui publish output and extract key information

if [ -z "$1" ]; then
    FILE="publish-output.txt"
else
    FILE="$1"
fi

echo "Parsing Sui Publish Output"
echo "════════════════════════════════════════════════════════"

# Extract Package ID
PACKAGE_ID=$(grep "PackageID:" "$FILE" | grep -oE "0x[a-f0-9]{64}")
echo "Package ID:"
echo "  $PACKAGE_ID"
echo ""

# Extract Module Name
MODULE=$(grep "Modules:" "$FILE" | sed 's/.*Modules: //' | sed 's/[^a-zA-Z0-9_]//g')
echo "Module Name:"
echo "  $MODULE"
echo ""

# Extract TreasuryCap Object ID (look backwards from TreasuryCap to find ObjectID)
TREASURY_CAP=$(grep -B5 "TreasuryCap<" "$FILE" | grep "ObjectID:" | head -1 | grep -oE "0x[a-f0-9]{64}")
echo "TreasuryCap ID:"
echo "  $TREASURY_CAP"
echo ""

# Extract Sender Address
SENDER=$(grep "Sender:" "$FILE" | head -1 | grep -oE "0x[a-f0-9]{64}")
echo "Sender Address:"
echo "  $SENDER"
echo ""

echo "Mint command:"
echo "════════════════════════════════════════════════════════"
echo "sui client call \\"
echo "  --package $PACKAGE_ID \\"
echo "  --module $MODULE \\"
echo "  --function mint \\"
echo "  --args $TREASURY_CAP AMOUNT_HERE $SENDER \\"
echo "  --gas-budget 10000000"
echo ""
echo "Replace AMOUNT_HERE with your desired amount (with 9 decimals)"
echo "Example: 1000000000000 = 1000 tokens"
echo ""
echo "Check balance command:"
echo "════════════════════════════════════════════════════════"
echo "sui client balance --coin-type $PACKAGE_ID::$MODULE::MY_COIN"

