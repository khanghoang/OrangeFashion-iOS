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