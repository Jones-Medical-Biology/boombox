nix-shell default.nix --command 'sh timegen.sh --haskell -r 1000 -c 1000 -n 10 \
    && sh timegen.sh --haskell -r 2000 -c 1000 -n 10 \
    && sh timegen.sh --haskell -r 3000 -c 1000 -n 10 \
    && sh timegen.sh --haskell -r 4000 -c 1000 -n 10 \
    && sh timegen.sh --haskell -r 5000 -c 1000 -n 10 \
    && sh timegen.sh --haskell -r 6000 -c 1000 -n 10 \
    && sh timegen.sh --haskell -r 8000 -c 1000 -n 10 \
    && sh timegen.sh --haskell -r 1000 -c 2000 -n 10 \
    && sh timegen.sh --haskell -r 1000 -c 3000 -n 10 \
    && sh timegen.sh --haskell -r 1000 -c 4000 -n 10 \
    && sh timegen.sh --haskell -r 1000 -c 5000 -n 10 \
    && sh timegen.sh --haskell -r 1000 -c 6000 -n 10 \
    && sh timegen.sh --haskell -r 1000 -c 8000 -n 10 \'

nix-shell python.nix --command 'sh timegen.sh --python -r 1000 -c 1000 -n 10 \
    && sh timegen.sh --python -r 2000 -c 1000 -n 10 \
    && sh timegen.sh --python -r 3000 -c 1000 -n 10 \
    && sh timegen.sh --python -r 4000 -c 1000 -n 10 \
    && sh timegen.sh --python -r 5000 -c 1000 -n 10 \
    && sh timegen.sh --python -r 6000 -c 1000 -n 10 \
    && sh timegen.sh --python -r 8000 -c 1000 -n 10 \
    && sh timegen.sh --python -r 1000 -c 2000 -n 10 \
    && sh timegen.sh --python -r 1000 -c 3000 -n 10 \
    && sh timegen.sh --python -r 1000 -c 4000 -n 10 \
    && sh timegen.sh --python -r 1000 -c 5000 -n 10 \
    && sh timegen.sh --python -r 1000 -c 6000 -n 10 \
    && sh timegen.sh --python -r 1000 -c 8000 -n 10'
