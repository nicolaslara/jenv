# Jenv

A helper command for generating json strings with jq using any available environment variable

## Instalation

 * Copy jenv.sh to anywhere in your PATH.
 * (Optional) Rename to just `jenv` so that it looks better in your commands

 ## Usage

```
> export CONTRACT_ADDRESS=osmo14hj2tavq8fpesdwxxcu44rty3hh90vhujrvcmstl4zr3txmfvw9sq2r9g9
> jenv -c -r '{"get_count": {"addr": $CONTRACT_ADDRESS}}'
{"get_count":{"addr":"osmo14hj2tavq8fpesdwxxcu44rty3hh90vhujrvcmstl4zr3txmfvw9sq2r9g9"}}
```

### Arguments

jenv accepts any argument that jq accepts and passes it down to the jq invocation.

Additionally, you can use the `-w` argument (short for "wrap") to output the result within single quotes.

This is useful when using jenv inside other commands:

```
echo $(jenv -w -c -r '{"get_count": {"addr": $CONTRACT_ADDRESS}}')
```

