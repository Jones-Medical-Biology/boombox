# BioBoomBox (BBB)
## Testing
```sh
sh gentestdata.sh 1000000 5 large_random.csv
time cabal exec bioboombox knn large_random.csv
# Ref: [358.0,606.0,183.0,190.0,744.0]
# 1: [353.0,607.0,204.0,216.0,739.0], Distance: 34.17601498127012
# 2: [353.0,636.0,158.0,211.0,725.0], Distance: 48.49742261192856
# 
# real	0m5.221s
# user	0m4.723s
# sys	0m0.466s
time python nearestneighbors.py large_random.csv 
# Ref: [358.0, 606.0, 183.0, 190.0, 744.0]
# 1: [353.0, 607.0, 204.0, 216.0, 739.0], Distance: 34.17601498127012
# 2: [353.0, 636.0, 158.0, 211.0, 725.0], Distance: 48.49742261192856
# 
# real	0m5.654s
# user	0m5.344s
# sys	0m0.275s
# (venv)
sh gentestdata.sh 1000 1000 square_random.csv
time cabal exec bioboombox knn square_random.csv
# Ref: [4.0,822.0,299.0,329.0,151.0,...]
# 1: [236.0,498.0,532.0,158.0,357.0,8.0,...], Distance: 12081.106861542115
# 2: [561.0,111.0,957.0,313.0,605.0,263.0,...], Distance: 12210.816188936758
# 
# real	0m0.996s
# user	0m0.852s
# sys	0m0.133s
# 
time python nearestneighbors.py square_random.csv
# Ref: [4.0,822.0,299.0,329.0,151.0,...]
# 1: [236.0, 498.0, 532.0, 158.0, 357.0,...], Distance: 12081.106861542115
# 2: [561.0, 111.0, 957.0, 313.0, 605.0,...], Distance: 12210.816188936758
# 
# real	0m1.149s
# user	0m0.999s
# sys	0m0.161s
# (venv) 
``

Threadscope seems to show that only one thread is activating in the kmeans
program. This seems to be the new thing that needs to be addressed.

-[ ] It would be good if students could work on threading