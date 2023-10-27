# LDPC Report - group 1

- Léo BONNAIRE
- Léonard PRINCE
- Etienne CAMBRAY-LAGASSY
- Alan JUMEAUCOURT
- Lucas LANDY

[Docs on Moodle](https://moodle.insa-lyon.fr/mod/folder/view.php?id=64114)

**LDPC** means *Low-density parity-check*. This comes for the fact that there's a low density of `1`'s compared to the amount of `0`'s in its *parity-check* matrix.
The amount of `1`'s in each columns and rows are greatly less than the dimension of the initial code, i.e. $w_c \ll n$ and $w_r \ll m$, using the notations defined in *"LDPC Codes - a brief Tutorial"*.

The LDPC codes belong to the family of linear block codes.

> To get $G$ from $H$ on Matlab, use the following :

```matlab
H = ...
H_sys = mod(rref(H), 2)
G = gen2par(H_sys)
```
