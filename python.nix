{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python3
    python3Packages.numpy
    python3Packages.scikit-learn
    python3Packages.pip
  ];

  shellHook = ''
    # Create a virtual environment if it doesn't exist
    if [ ! -d "venv" ]; then
      python3 -m venv venv
    fi
    
    # Activate the virtual environment
    source venv/bin/activate

    # Upgrade pip
    pip install --upgrade pip

    # Install any additional packages if needed
    # pip install package-name

    echo "Python environment ready!"
  '';
}
