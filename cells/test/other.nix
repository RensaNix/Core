# test to make sure infinite recursion doesn't happen when accessing sibling blocks
# run `nix eval .#<system>.test` to check
# should return { other = { hello = "world"; }; test = «repeated»; }
{cell, ...}: cell.test
