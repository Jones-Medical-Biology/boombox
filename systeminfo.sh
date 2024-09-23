#!/bin/bash

echo "System Information:"
echo "==================="

# OS Information
echo "OS:"
uname -a

# CPU Information
echo -e "\nCPU:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sysctl -n machdep.cpu.brand_string
    echo "Cores: $(sysctl -n hw.ncpu)"
else
    # Linux
    cat /proc/cpuinfo | grep "model name" | head -n 1
    echo "Cores: $(nproc)"
fi

# Memory Information
echo -e "\nMemory:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "Total: $(($(sysctl -n hw.memsize) / 1024 / 1024)) MB"
else
    # Linux
    free -h | grep Mem | awk '{print "Total: " $2 ", Used: " $3 ", Free: " $4}'
fi

# Disk Information
echo -e "\nDisk:"
df -h / | tail -n 1 | awk '{print "Total: " $2 ", Used: " $3 ", Available: " $4}'

# If on Linux, add GPU information
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "\nGPU:"
    lspci | grep -i vga
fi

# Programming Language Versions
echo -e "\nLanguage Versions:"
echo "Python: $(python --version 2>&1)"
echo "GHC: $(ghc --version | awk '{print $NF}')"
echo "Cabal: $(cabal --version | head -n 1 | awk '{print $NF}')"

# Current date and time
echo -e "\nTimestamp:"
date
