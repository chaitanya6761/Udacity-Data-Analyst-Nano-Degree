Code

-   [Show All Code](#)
-   [Hide All Code](#)
-   -   [Download Rmd](#)

R Notebook {.title .toc-ignore}
==========

### 1. Laoding Diamond Dataset.

``` {.r}
data(diamonds)
```

### 2. How many observations are in the dataset.

``` {.r}
nrow(diamonds)
```

    [1] 53940

### 3. How many variables are there in the dataset ?

``` {.r}
ncol(diamonds)
```

    [1] 10

### 4. How many ordered factors are there in the dataset?

``` {.r}
str(diamonds)
```

    Classes ‘tbl_df’, ‘tbl’ and 'data.frame':   53940 obs. of  10 variables:
     $ carat  : num  0.23 0.21 0.23 0.29 0.31 0.24 0.24 0.26 0.22 0.23 ...
     $ cut    : Ord.factor w/ 5 levels "Fair"<"Good"<..: 5 4 2 4 2 3 3 3 1 3 ...
     $ color  : Ord.factor w/ 7 levels "D"<"E"<"F"<"G"<..: 2 2 2 6 7 7 6 5 2 5 ...
     $ clarity: Ord.factor w/ 8 levels "I1"<"SI2"<"SI1"<..: 2 3 5 4 2 6 7 3 4 5 ...
     $ depth  : num  61.5 59.8 56.9 62.4 63.3 62.8 62.3 61.9 65.1 59.4 ...
     $ table  : num  55 61 65 58 58 57 57 55 61 61 ...
     $ price  : int  326 326 327 334 335 336 336 337 337 338 ...
     $ x      : num  3.95 3.89 4.05 4.2 4.34 3.94 3.95 4.07 3.87 4 ...
     $ y      : num  3.98 3.84 4.07 4.23 4.35 3.96 3.98 4.11 3.78 4.05 ...
     $ z      : num  2.43 2.31 2.31 2.63 2.75 2.48 2.47 2.53 2.49 2.39 ...

### 5. What leter represents the best color for a diamonds?

``` {.r}
levels(diamonds$color)
```

    [1] "D" "E" "F" "G" "H" "I" "J"

### 6. Create Histogram for price data.

``` {.r}
ggplot(aes(x=price),data=diamonds)+
  geom_histogram(fill='blue',color='black')
```

![](data:image/png;base64,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)

LS0tDQp0aXRsZTogIlIgTm90ZWJvb2siDQpvdXRwdXQ6IGh0bWxfbm90ZWJvb2sNCi0tLQ0KDQojIyMxLiBMYW9kaW5nIERpYW1vbmQgRGF0YXNldC4NCmBgYHtyfQ0KZGF0YShkaWFtb25kcykNCmBgYA0KDQojIyMyLiBIb3cgbWFueSBvYnNlcnZhdGlvbnMgYXJlIGluIHRoZSBkYXRhc2V0Lg0KYGBge3J9DQpucm93KGRpYW1vbmRzKQ0KYGBgDQojIyMzLiBIb3cgbWFueSB2YXJpYWJsZXMgYXJlIHRoZXJlIGluIHRoZSBkYXRhc2V0ID8NCmBgYHtyfQ0KbmNvbChkaWFtb25kcykNCmBgYA0KIyMjIDQuIEhvdyBtYW55IG9yZGVyZWQgZmFjdG9ycyBhcmUgdGhlcmUgaW4gdGhlIGRhdGFzZXQ/DQpgYGB7cn0NCnN0cihkaWFtb25kcykNCmBgYA0KIyMjIDUuIFdoYXQgbGV0ZXIgcmVwcmVzZW50cyB0aGUgYmVzdCBjb2xvciBmb3IgYSBkaWFtb25kcz8NCmBgYHtyfQ0KbGV2ZWxzKGRpYW1vbmRzJGNvbG9yKQ0KYGBgDQoNCiMjIyA2LiBDcmVhdGUgSGlzdG9ncmFtIGZvciBwcmljZSBkYXRhLg0KYGBge3J9DQpnZ3Bsb3QoYWVzKHg9cHJpY2UpLGRhdGE9ZGlhbW9uZHMpKw0KICBnZW9tX2hpc3RvZ3JhbShmaWxsPSdibHVlJyxjb2xvcj0nYmxhY2snKQ0KYGBgDQoNCg==
