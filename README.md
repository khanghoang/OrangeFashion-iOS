OrangeFashion-iOS
=================

iOS app for OrangeFashion.vn

Base URL : "http://orangefashion.vn/api/api?"

### Get all products ###
 * URL: 'rquest=getproducts'
 * method: 'GET'
 * success response:

```javascript
[
  {
    "MaSanPham": "91",
    "TenSanPham": "\\u0110\\u1ea7m Voan c\\u00f4ng ch\\u00faa",
    "GiaBan": "195000",
    "MaTinhTrangSanPham": "0",
    "SoLuongXem": "0",
    "SoLuongBan": "0",
    "SoLuongTon": "12",
    "MaLoaiSanPham": "1",
    "ChatLieu": "Voan",
    "Mau": "Trang, \\u0111en",
    "DanhGia": "H\\u00e0ng hot",
    "NgayDang": "2011-02-08",
    "MaNhaSanXuat": "1",
    "MaNguoiDang": "0",
    "GiaGoc": "80000",
    "MaBoSuuTap": "3",
    "MaHienThi": "2931_T",
    "ChiTiet": ""
  }
]
```

### Get all image of a product ###
 * URL: 'rquest=getimages&product_id=:product_id'
 * method: 'GET'
 * success response:

```javascript
[
    "https://lh4.googleusercontent.com/-VZ2JcJEq7WY/UVliN12zFrI/AAAAAAAAQO4/8CSp7qo0lHc/001_3.jpg",
    "https://lh6.googleusercontent.com/-VX6rRXk4eqA/UVliPO5Q_EI/AAAAAAAAQPA/_j6EeANUozw/002_3.jpg",
    "https://lh6.googleusercontent.com/-vRZOk78Zj1E/UVliQuS-tII/AAAAAAAAQPI/NYzA5ECfx4Q/3.jpg",
    "https://lh3.googleusercontent.com/-lmOUmYj0SzM/UVliR9YqGlI/AAAAAAAAQPQ/LllO3cyoflY/4.jpg",
    "https://lh5.googleusercontent.com/--3wACDF885k/UVliS7-gaiI/AAAAAAAAQPc/IuFcrup_Kz0/T27.fgXbVbXXXXXXXX_%2521%2521388462979.jpg"
]
```

### Get sidebar menu ###
 * URL: 'rquest=getMenu'
 * method: 'GET'
 * success response:

```javascript
[
    {
        "session": [
            {
                "name": "Hàng mới về",
                "id": "21"
            },
            {
                "name": "Tin tức",
                "id": "22"
            }
        ],
        "name": "Nổi bật"
    },
    {
        "session": [
            {
                "name": "Đầm cao cấp",
                "id": "3"
            },
            {
                "name": "Đầm",
                "id": "1"
            },
            {
                "name": "Áo",
                "id": "2"
            },
            {
                "name": "Váy",
                "id": "4"
            }
        ],
        "name": "Sản phẩm"
    }
]
```

### Get products by category ###
 * URL: 'rquest=getProductsFromCategory&category_id=:category_id'
 * method: 'GET'
 * success response:

```javascript
[
  {
    "MaSanPham": "91",
    "TenSanPham": "\\u0110\\u1ea7m Voan c\\u00f4ng ch\\u00faa",
    "GiaBan": "195000",
    "MaTinhTrangSanPham": "0",
    "SoLuongXem": "0",
    "SoLuongBan": "0",
    "SoLuongTon": "12",
    "MaLoaiSanPham": "1",
    "ChatLieu": "Voan",
    "Mau": "Trang, \\u0111en",
    "DanhGia": "H\\u00e0ng hot",
    "NgayDang": "2011-02-08",
    "MaNhaSanXuat": "1",
    "MaNguoiDang": "0",
    "GiaGoc": "80000",
    "MaBoSuuTap": "3",
    "MaHienThi": "2931_T",
    "ChiTiet": ""
  }
]
```

### Get list of news ###
 * URL: 'rquest=getListNews'
 * method: 'GET'
 * success response:

```javascript
[
    {
        "MaTinTuc": "61",
        "NgayDang": "2013-06-28",
        "NoiDung": "<p style=text-align: center;><strong>BST Hoa V&agrave; Ren</strong></p>\r\n<p style=text-align: center;><strong>H&agrave;ng Mới Về 28/06/2013</strong></p>\r\n<p style=text-align: center;><a href=../index.php?menu=2 target=_blank>Xem chi tiết H&agrave;ng Mới tại đ&acirc;y</a></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6415.jpg alt= width=600 height=369 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6416.jpg alt= width=246 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6417.jpg alt= width=239 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6418.jpg alt= width=248 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6419.jpg alt= width=233 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6420.jpg alt= width=247 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6421.jpg alt= width=241 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6422.jpg alt= width=236 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6423.jpg alt= width=240 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6424.jpg alt= width=236 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6425.jpg alt= width=232 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6426.jpg alt= width=242 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6427.jpg alt= width=250 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6428.jpg alt= width=244 height=350 /></p>\r\n<p style=text-align: center;><img src=http://orangefashion.vn/store/-1/-1_6429.jpg alt= width=227 height=350 /></p>",
        "HinhNho": "http://orangefashion.vn/store/-1/-1_6269.jpg",
        "TieuDe": "BST Hoa và Ren",
        "CauDan": "Hàng Mới Về 28/6",
        "IsDelete": "0"
    }
]
```