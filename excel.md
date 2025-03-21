## IF

```
=IF(AND(F12>=20000,F13>=9000),"Pass","Fail")
=IF(OR(F12>=20000,F13>=9000),"Pass","Fail")

=IF(F1>TIME(9,0,0),"Eligible","Resit")

=SUMIF(E2:E8,"Development",J2:J8)
=SUMIF(E2:E8,Cell_Reference,J2:J8)
	range, criteria, sum_range

=AVERAGEIF(E2:E8,"Development",J2:J8)
	range, criteria, averagej_range

=SUMIFS(J2:J8,E2:E8,E2,F2:F8,F4)
	sum_range, criteria_range1, criteria1, [criteria_range2, criteria2], ...
```

## VLOOKUP & XLOOKUP

```
=VLOOKUP(A4,A10:I46,2,FALSE) Look up value must be in the first column of data

=XLOOKUP(A4,A10:A46,B10:B46)
=XLOOKUP(A4,A10:A46,D10:D46)
=XLOOKUP(A4,A10:A46,I10:I46)
	lookup_value, lookup_array, return_array

=XLOOKUP(A4,A10:A46,C10:C46,"Not in list",0,1)
	lookup_value, lookup_array, return_array, [if_not_found], [match_mode], [return_mode])
```

## UNIQUE

```
=UNIQUE(E2:E8,,TRUE)
	array, [by_col], [exactly_once]
=UNIQUE(B2:B8&" "&C2:C8)
=UNIQUE(F2:G8)
=SORT(UNIQUE(C2:C8),,1)
```

## SORT

```
=SORT(B2:G8,3,1)
	array, [sort_index], [sort_order]

=SORTBY(D2:G8,D2:D8,-1)
	array, by_array1, [sort_order]
=SORTBY(D2:G8,D2:D8,-1,E2:E8,1)
	array, by_array1, [sort_order1], [by_array2, sort_order2], ....
```

## FILTER

```
=FILTER(B2:E8,E2:E8="Technology","")
	array, include, [if_empty]
```

[Crack Shash](https://www.crackshash.com)
