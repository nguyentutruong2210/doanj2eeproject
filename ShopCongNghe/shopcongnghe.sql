USE master
CREATE DATABASE SHOPCONGNGHE
GO
USE [SHOPCONGNGHE]
GO
/****** Object:  StoredProcedure [dbo].[Kiemtra_Dangnhap_KHACHHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Kiemtra_Dangnhap_KHACHHANG]
@TENDN VARCHAR(20),
@MATKHAU VARCHAR(20)
AS
	BEGIN
		SELECT * FROM KHACHHANG
		WHERE TENDNKH=@TENDN AND MATKHAUKH=@MATKHAU
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Chitiet_DONHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Chitiet_DONHANG]
@MADH VARCHAR (8)
AS
	BEGIN
	SELECT DISTINCT(CT_DONHANG.MASP),TENSP,GIASP, HOTEN,DIACHI,DIENTHOAI,EMAILKH,DONDATHANG.MADH,CONVERT(VARCHAR,NGAYDH,103)AS[DD/MM/YYYY],TONGTIEN,CT_DONHANG.SOLUONG,CT_DONHANG.THANHTIEN
	 FROM CT_DONHANG,DONDATHANG,SANPHAM,KHACHHANG,THONGTINNGUOINHAN 
	 WHERE CT_DONHANG.MADH=DONDATHANG.MADH AND KHACHHANG.MAKH = DONDATHANG.MAKH AND DONDATHANG.MADH=THONGTINNGUOINHAN.MADH AND CT_DONHANG.MASP=SANPHAM.MASP
	 AND DONDATHANG.MADH=@MADH
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Chitiet_HOADON]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Chitiet_HOADON]
@MAHD VARCHAR(10)
AS
	BEGIN
		SELECT DISTINCT(SANPHAM.MASP)AS MASP,TENSP,GIASP, TENKH,TENLOAIKH,HOTENNV,DIACHIKH,SODTKH,EMAILKH,HOADON.MAHD,CONVERT(VARCHAR,NGAYHD,103)AS[DD/MM/YYYY],TONGTIENHD,CT_HOADON.SOLUONG,CT_HOADON.THANHTIEN
		FROM HOADON,CT_HOADON,SANPHAM,KHACHHANG,NHANVIEN,LOAIKHACHHANG
		WHERE CT_HOADON.MAHD=HOADON.MAHD AND KHACHHANG.MAKH = HOADON.MAKH AND NHANVIEN.MANV=HOADON.MANV AND CT_HOADON.MASP=SANPHAM.MASP AND KHACHHANG.MALOAIKH=LOAIKHACHHANG.MALOAIKH AND HOADON.MAHD=@MAHD
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhgia_Khachhang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_Danhgia_Khachhang]
@tieude nvarchar(100),
@noidung nvarchar(300),
@masp varchar (8)
as
	begin
		insert into DANHGIA values(@tieude,@noidung,@masp)
	end


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_Danhgia]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_Danhsach_Danhgia]
@trang int,
@sobai_trang int
as
	if @trang is null
	begin
		set @trang=1
	end
	declare
		@batdau int,
		@ketthuc int
	set @batdau=@sobai_trang*@trang-(@sobai_trang-1)
	set @ketthuc=@sobai_trang*@trang
	select * from (select ROW_NUMBER() OVER (ORDER BY MADG DESC) AS ROWID, TIEUDE,NOIDUNG,TENSP,MADG
	FROM DANHGIA,SANPHAM WHERE DANHGIA.MASP=SANPHAM.MASP)TB
	WHERE ROWID between @batdau and @ketthuc


GO
/****** Object:  StoredProcedure [dbo].[sp_DanhSach_DONGSANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_DanhSach_DONGSANPHAM]
AS
	BEGIN
		SELECT * FROM DONGSANPHAM ORDER BY MADONGSP ASC
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_DONHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_DONHANG]
AS
	BEGIN 
		SELECT * FROM DONDATHANG
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_DONHANG_Trang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_DONHANG_Trang]
@sodonhang_trang int,
@trang int
AS
BEGIN
	IF @trang is null
	BEGIN
		SET @trang=1;
	END
	DECLARE
		@batdau int,
		@ketthuc int
	SET @batdau=@trang*@sodonhang_trang-(@sodonhang_trang-1)
	SET @ketthuc=@trang*@sodonhang_trang
	SELECT * FROM (
	SELECT MADH,TENKH,CONVERT(VARCHAR,NGAYDH,103)AS[DD/MM/YYYY],TONGTIEN,TINHTRANG,ROW_NUMBER() OVER(ORDER BY TINHTRANG ASC,NGAYDH DESC)AS rowid
	FROM DONDATHANG,KHACHHANG
	WHERE DONDATHANG.MAKH=KHACHHANG.MAKH)AS DH WHERE  rowid BETWEEN @batdau AND @ketthuc
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_HOADON]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_HOADON]
AS
	BEGIN
		SELECT * FROM HOADON
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_HOADON_Trang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_HOADON_Trang]
@sobai_trang INT,
@trang INT
AS
BEGIN
	IF @trang is null
	BEGIN
		SET @trang=1;
	END
	DECLARE 
	@batdau int,
	@ketthuc int
	SET @batdau=@sobai_trang*@trang-(@sobai_trang-1)
	SET @ketthuc=@sobai_trang*@trang
	SELECT * FROM(
	SELECT MAHD,HOTENNV, CONVERT(VARCHAR,NGAYHD,103)AS [DD/MM/YYYY],TONGTIENHD,TENKH,(ROW_NUMBER() OVER(ORDER BY CONVERT(DATE,NGAYHD,103) DESC))AS ROWID 
	FROM HOADON, NHANVIEN,KHACHHANG
	WHERE HOADON.MAKH=KHACHHANG.MAKH AND NHANVIEN.MANV=HOADON.MANV)AS TB
	WHERE ROWID BETWEEN @batdau AND @ketthuc
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_KHUYENMAI]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_KHUYENMAI]
AS
	BEGIN
	SELECT * FROM KHUYENMAI
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_NHOMSANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_NHOMSANPHAM]
AS
	BEGIN
		SELECT * FROM NHOMSANPHAM ORDER BY MANHOMSP DESC
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_NHOMSANPHAM_DONGSP]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_NHOMSANPHAM_DONGSP]
@MADONGSP VARCHAR(8)
AS
	BEGIN
		SELECT * FROM NHOMSANPHAM WHERE MADONGSP=@MADONGSP
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_SANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_SANPHAM]
AS
	BEGIN
		SELECT * FROM SANPHAM
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_SANPHAM_Cungnhom]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_SANPHAM_Cungnhom]
@MASP VARCHAR(8)
AS
BEGIN
	SELECT TOP 3(MASP),* FROM SANPHAM
	WHERE MANHOMSP IN (SELECT MANHOMSP FROM SANPHAM WHERE MASP=@MASP) AND MASP <>@MASP
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DanhSach_SANPHAM_DONGSP]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_DanhSach_SANPHAM_DONGSP]
@sosp_trang int,
@trang int,
@madongsp varchar(8),
@manhomsp varchar(8)
AS
	BEGIN
		IF @trang is null
		BEGIN
			SET @trang=1;
		END
		DECLARE
		@vitribatdau int,
		@vitriketthuc int
		SET @vitribatdau=@trang*@sosp_trang-(@sosp_trang-1)
		SET @vitriketthuc =@trang*@sosp_trang
		SELECT * FROM (SELECT MASP,TENSP,GIASP,MOTASP,XUATXU,DONVITINH,HINHANH,SOLUONG,ROW_NUMBER()OVER(ORDER BY MASP DESC)AS rowid 
		FROM SANPHAM,NHOMSANPHAM,DONGSANPHAM WHERE DONGSANPHAM.MADONGSP=NHOMSANPHAM.MADONGSP AND
		 NHOMSANPHAM.MANHOMSP=SANPHAM.MANHOMSP AND DONGSANPHAM.MADONGSP=@madongsp AND NHOMSANPHAM.MANHOMSP=@manhomsp)AS SP
		WHERE  rowid between @vitribatdau and @vitriketthuc
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_DanhSach_SANPHAM_DONGSP_NHOMSP]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_DanhSach_SANPHAM_DONGSP_NHOMSP]
@madongsp varchar(8),
@manhomsp varchar(8)
AS
	BEGIN
			SELECT MASP,TENSP,GIASP,MOTASP,XUATXU,DONVITINH,HINHANH,SOLUONG
			FROM SANPHAM,NHOMSANPHAM,DONGSANPHAM WHERE DONGSANPHAM.MADONGSP=NHOMSANPHAM.MADONGSP AND
			NHOMSANPHAM.MANHOMSP=SANPHAM.MANHOMSP AND DONGSANPHAM.MADONGSP=@madongsp AND NHOMSANPHAM.MANHOMSP=@manhomsp	
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_DanhSach_SANPHAM_DONGSP_NHOMSP_Trang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_DanhSach_SANPHAM_DONGSP_NHOMSP_Trang]
@sosp_trang int,
@trang int,
@madongsp varchar(8),
@manhomsp varchar(8)
AS
	BEGIN
		IF @trang is null
		BEGIN
			SET @trang=1
		END
			DECLARE
			@vitribatdau int,
			@vitriketthuc int
			SET @vitribatdau=@trang*@sosp_trang-(@sosp_trang-1)
			SET @vitriketthuc =@trang*@sosp_trang
			SELECT * FROM (SELECT MASP,TENSP,GIASP,MOTASP,XUATXU,DONVITINH,HINHANH,SOLUONG,ROW_NUMBER() OVER(ORDER BY MASP DESC)AS rowid 
			FROM SANPHAM,NHOMSANPHAM,DONGSANPHAM WHERE DONGSANPHAM.MADONGSP=NHOMSANPHAM.MADONGSP AND
			 NHOMSANPHAM.MANHOMSP=SANPHAM.MANHOMSP AND DONGSANPHAM.MADONGSP=@madongsp AND NHOMSANPHAM.MANHOMSP=@manhomsp
			)AS SP
			WHERE  rowid between @vitribatdau and @vitriketthuc
			
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_SANPHAM_trang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_SANPHAM_trang]
@tranghientai INT,
@sobai_trang INT
AS
	BEGIN
		DECLARE 
		@Batdautrang int,
		@Kethuctrang int
		IF @tranghientai=NULL
		BEGIN
			SET @tranghientai=1;
		END
		SET @Batdautrang=@tranghientai*@sobai_trang-(@sobai_trang-1)
		SET @Kethuctrang=@tranghientai*@sobai_trang
		SELECT * FROM (SELECT *,ROW_NUMBER() OVER(ORDER BY MASP DESC)AS rowid FROM SANPHAM) AS SP
		WHERE rowid BETWEEN @Batdautrang AND @Kethuctrang
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Danhsach_Trang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Danhsach_Trang]
@sodonhang_trang int,
@trang int
AS
BEGIN
	IF @trang is null
	BEGIN
		SET @trang=1;
	END
	DECLARE
		@batdau int,
		@ketthuc int
	SET @batdau=@trang*@sodonhang_trang-@sodonhang_trang-1
	SET @ketthuc=@trang*@sodonhang_trang
	SELECT * FROM (
	SELECT MADH,TENKH,CONVERT(VARCHAR,NGAYDH,103)AS[DD/MM/YYYY],TONGTIEN,TINHTRANG,ROW_NUMBER() OVER(ORDER BY TINHTRANG ASC)AS rowid
	FROM DONDATHANG,KHACHHANG
	WHERE DONDATHANG.MAKH=KHACHHANG.MAKH)AS DH WHERE  rowid BETWEEN @batdau AND @ketthuc
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DanhsachNgay_HOADON]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_DanhsachNgay_HOADON]
AS
	BEGIN
		SELECT DISTINCT(CONVERT(VARCHAR,CONVERT(DATE,NGAYHD,103),103))AS NGAYHD
		FROM HOADON
		ORDER BY CONVERT(VARCHAR,CONVERT(DATE,NGAYHD,103),103) ASC
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_DATHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_DATHANG]
--KHAI BAO BIEN CHO BANG DONHANG
@MADH VARCHAR(10),
@MAKH VARCHAR(8),
@TONGTIEN MONEY,
--KHAI BAO BIEN CHO BANG CT_DONHANG
@MASP VARCHAR(8),
@SOLUONG INT,
@THANHTIEN MONEY
AS
	BEGIN
		--THEM DON HANG VA CAP NHAT LAI THONG TIN KHACH HANG NEU NHU DON HANG CHUA TON TAI
		IF NOT EXISTS(SELECT * FROM DONDATHANG WHERE MADH=@MADH)
		BEGIN
			DECLARE 
			@LOAIKH VARCHAR(8),--Luu gia tri Loaikh dang mua hang
			@TRANGTHAI CHAR(1)
			SET @LOAIKH=(SELECT MALOAIKH FROM KHACHHANG WHERE MAKH=@MAKH)
			SET @TRANGTHAI=(SELECT TRANGTHAI FROM KHACHHANG WHERE MAKH=@MAKH)
			IF(@LOAIKH='LKH03'AND @TRANGTHAI='1')--NEU LA KHACH HANG VIP THI DUOC GIAM 5% TIEN DON HANG
				BEGIN
					SET @TONGTIEN=@TONGTIEN*0.95
				END
			ELSE
				BEGIN
					IF(@LOAIKH='LKH02'AND @TRANGTHAI='1')--NEU LA KHACH HANG THAN THIET THI DUOC GIAM 2% TIEN DON HANG
					BEGIN
						SET @TONGTIEN=@TONGTIEN*0.98
					END
				END
			INSERT INTO DONDATHANG VALUES(@MADH,@MAKH,GETDATE(),0,@TONGTIEN)--THEM THONG TIN VAO BANG DONDATHANG
			--THEM CTDONHANG DAU TIEN
			INSERT CT_DONHANG VALUES(@MADH,@MASP,@SOLUONG,@THANHTIEN)
		END
		ELSE
		--BUOC TIEP THEO LA THEM THONG TIN DAT HANG CON LAI VAO CT_DONHANG
		BEGIN
			IF NOT EXISTS(SELECT * FROM CT_DONHANG WHERE MADH=@MADH AND MASP=@MASP)
			BEGIN
				INSERT CT_DONHANG VALUES(@MADH,@MASP,@SOLUONG,@THANHTIEN)
			END
		END
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_Huy_DONHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Huy_DONHANG]
@MADH VARCHAR(8)
AS
	IF NOT EXISTS (SELECT * FROM DONDATHANG WHERE MADH=@MADH)
	BEGIN
		RETURN
	END
	ELSE
	BEGIN
		BEGIN TRAN
		SET TRAN ISOLATION LEVEL SERIALIZABLE
		IF (SELECT TINHTRANG FROM DONDATHANG WHERE MADH=@MADH)=1
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		ELSE
		BEGIN
			DELETE FROM THONGTINNGUOINHAN WHERE MADH=@MADH
			IF (@@ERROR<>0)
			BEGIN
				 ROLLBACK TRAN
				 RETURN
			END
			DELETE FROM CT_DONHANG WHERE MADH=@MADH
			IF (@@ERROR<>0)
			BEGIN
				 ROLLBACK TRAN
				 RETURN
			END
			DELETE FROM DONDATHANG WHERE MADH=@MADH
			IF(@@ERROR<>0)
			BEGIN
				 ROLLBACK TRAN
				 RETURN
			END
		END
		COMMIT
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_In_DONHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_In_DONHANG]
@MADH VARCHAR (8)
AS
	BEGIN
	SELECT DISTINCT(CT_DONHANG.MASP),TENSP,GIASP, HOTEN,DIACHI,DIENTHOAI,EMAILKH,DONDATHANG.MADH,CONVERT(VARCHAR,NGAYDH,103)AS[DD/MM/YYYY],TONGTIEN,CT_DONHANG.SOLUONG,CT_DONHANG.THANHTIEN
	 FROM CT_DONHANG,DONDATHANG,SANPHAM,KHACHHANG,THONGTINNGUOINHAN 
	 WHERE CT_DONHANG.MADH=DONDATHANG.MADH AND KHACHHANG.MAKH = DONDATHANG.MAKH AND DONDATHANG.MADH=THONGTINNGUOINHAN.MADH AND CT_DONHANG.MASP=SANPHAM.MASP
	 AND DONDATHANG.MADH=@MADH
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Kiemtra_Dangnhap_KHACHHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Kiemtra_Dangnhap_KHACHHANG]
@TENDN VARCHAR(20),
@MATKHAU VARCHAR(20)
AS
	BEGIN
		SELECT * FROM KHACHHANG
		WHERE TENDNKH=@TENDN AND MATKHAUKH=@MATKHAU AND TrangThai='1'
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_KiemtraDangnhap]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_KiemtraDangnhap]
@TENDN VARCHAR(20),
@MATKHAU VARCHAR(20)
AS
	BEGIN
		SELECT * FROM NHANVIEN
		WHERE TENDNNV=@TENDN AND MATKHAUNV=@MATKHAU
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraTrungEmail_KhachHang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_KiemTraTrungEmail_KhachHang](@EmailKH varchar(100))
as
begin
	select * from KHACHHANG where EMAILKH=@EmailKH
end


GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraTrungTenDangNhap_KhachHang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_KiemTraTrungTenDangNhap_KhachHang](@TenDNKH varchar(20))
as
begin
	select * from KHACHHANG where TENDNKH=@TenDNKH
end


GO
/****** Object:  StoredProcedure [dbo].[sp_LayGia_KHUYENMAI]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_LayGia_KHUYENMAI]
@MASP VARCHAR(8)
AS
	BEGIN
		SELECT GIAKM FROM KHUYENMAI WHERE MASP=@MASP AND
		 CONVERT(DATE,GETDATE(),103) BETWEEN CONVERT(DATE,NGAYBATDAU,103) AND CONVERT(DATE,NGAYKETTHUC,103)
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_NhanVienCapNhat]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_NhanVienCapNhat]
@Manv varchar(10),@HotenNv nvarchar(50),
@NgaysinhNv varchar(20),@GioitinhNv char(1),
@DiachiNv nvarchar(100),@SodtNv varchar(15),
@TenDnNv varchar(20),@MatkhauNv varchar(20)
AS
	BEGIN
		declare @NGAYSINHKH_CV datetime;
		set @NGAYSINHKH_CV=CONVERT(datetime,@NgaysinhNv,103);
		UPDATE NHANVIEN SET HOTENNV= @HotenNv, NGAYSINHNV= @NGAYSINHKH_CV,
		GIOITINHNV= @GioitinhNv,DIACHINV=@DiachiNv,SODTNV=@SodtNv,
		TENDNNV=@TenDnNv,MATKHAUNV=@MatkhauNv
		WHERE MANV=@Manv
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_NhanVienDangNhap]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_NhanVienDangNhap]
@tendnnv varchar(20),
@matkhau	varchar(20)
as
begin
	select * from NHANVIEN where TENDNNV=@tendnnv and MATKHAUNV=@matkhau;
end


GO
/****** Object:  StoredProcedure [dbo].[sp_NhanVienKiemTraTrungTenDangNhap]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_NhanVienKiemTraTrungTenDangNhap]
@tendnnv varchar(20)
as
begin
	select * from NHANVIEN where TENDNNV=@tendnnv
end


GO
/****** Object:  StoredProcedure [dbo].[sp_NhanVienThemMoi]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[sp_NhanVienThemMoi]
@Manv varchar(10),@HotenNv nvarchar(50),
@NgaysinhNv varchar(20),@GioitinhNv char(1),
@DiachiNv nvarchar(100),@SodtNv varchar(15),
@TenDnNv varchar(20),@MatkhauNv varchar(20)
AS
	BEGIN
		declare @NGAYSINHKH_CV date;
		set @NGAYSINHKH_CV=CONVERT(date,@NgaysinhNv,103);
		INSERT INTO NHANVIEN VALUES(@Manv,@HotenNv,@NGAYSINHKH_CV,@GioitinhNv,@DiachiNv,@SodtNv,@TenDnNv,@MatkhauNv)
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_NhanVienThongTin]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_NhanVienThongTin]
as
	BEGIN
		SELECT MANV,HOTENNV,CONVERT(VARCHAR,NGAYSINHNV,103)AS[DD/MM/YYYY],GIOITINHNV,DIACHINV,SODTNV,TENDNNV,MATKHAUNV from NHANVIEN
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_NhanVienTimKiemMaNV]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_NhanVienTimKiemMaNV]
@manv nvarchar(50)
as
	BEGIN
		select MANV,HOTENNV,CONVERT(VARCHAR,NGAYSINHNV,103)AS NGAYSINHNV,GIOITINHNV,DIACHINV,SODTNV,TENDNNV,MATKHAUNV from NHANVIEN
		where MANV like '%' + @manv + '%' or HOTENNV like '%' + @manv + '%';
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_NhanVienXoa]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_NhanVienXoa]
@Manv varchar(10)
AS
	BEGIN 
		IF NOT EXISTS (SELECT * FROM HOADON WHERE MANV=@Manv)
		BEGIN
			DELETE FROM NHANVIEN
			WHERE MANV=@Manv
		END
		ELSE
		BEGIN
			RETURN
		END
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_PhanTrang_KhachHang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[sp_PhanTrang_KhachHang](@tranghientai INT, @sobai_trang INT)
AS
	BEGIN
		DECLARE 
		@Batdautrang int,
		@Kethuctrang int
		IF @tranghientai=NULL
		BEGIN
			SET @tranghientai=1;
		END
		SET @Batdautrang=@tranghientai*@sobai_trang-(@sobai_trang-1)
		SET @Kethuctrang=@tranghientai*@sobai_trang
		--SELECT * FROM (SELECT *,ROW_NUMBER() OVER(ORDER BY MAKH DESC)AS rowid FROM KHACHHANG) AS KH
		--WHERE rowid BETWEEN @Batdautrang AND @Kethuctrang
		SELECT * FROM (SELECT *,ROW_NUMBER() OVER(ORDER BY MaKH)AS rowid FROM KHACHHANG) AS SP
		WHERE rowid BETWEEN @Batdautrang AND @Kethuctrang
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Sua_DONGSANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Sua_DONGSANPHAM]
@MADONGSP VARCHAR(10),
@TENDONGSP NVARCHAR(50),
@GHICHU NVARCHAR(50)
AS
BEGIN
	UPDATE DONGSANPHAM
	SET TENDONGSP=@TENDONGSP,GHICHU=@GHICHU
	WHERE MADONGSP=@MADONGSP
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Sua_KhachHang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_Sua_KhachHang](@MAKH varchar(20), @MALOAIKH varchar(10), @TENKH nvarchar(50), @GIOITINHKH char(1), @DIACHIKH nvarchar(80), @SODTKH varchar(15), @MATKHAUKH varchar(20), @TrangThai int, @NgaySinhKH varchar(20), @EmailKH varchar(100))
as
BEGIN
	declare @NGAYSINHKH_CV date;
	set @NGAYSINHKH_CV=CONVERT(date,@NGAYSINHKH,20);
	update KHACHHANG set MaLoaiKH=@MALOAIKH, TenKH=@TENKH, GIOITINHKH=@GIOITINHKH, DiaChiKH=@DIACHIKH, SoDTKH=@SODTKH,
						 MatKhauKH=@MATKHAUKH, TrangThai=@TrangThai, EMAILKH=@EmailKH, NGAYSINHKH=@NgaySinhKH_CV where MaKH=@MaKH	 
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Sua_KHUYENMAI]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Sua_KHUYENMAI]
@MaKm varchar(10),@MaSp varchar(10),
@Ngaybatdau VARCHAR(50),@Ngayketthuc VARCHAR(50),
@GiaKm int
AS
	BEGIN
		UPDATE KHUYENMAI SET MASP=@MaSp,NGAYBATDAU=CONVERT(DATETIME,@Ngaybatdau),
		NGAYKETTHUC=CONVERT(DATETIME,@Ngayketthuc),GIAKM=@GiaKm
		WHERE MAKM=@MaKm
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Sua_LOAIKHACHHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Sua_LOAIKHACHHANG]
@MaloaiKh VARCHAR(10),
@TenloaiKh NVARCHAR(20),
@Ghichu NVARCHAR(50)
AS
	BEGIN
		UPDATE LOAIKHACHHANG SET TENLOAIKH=@TenloaiKh,GHICHU=@Ghichu WHERE MALOAIKH=@MaloaiKh
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Sua_NHANVIEN]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Sua_NHANVIEN]
@Manv varchar(10),@HotenNv nvarchar(50),
@NgaysinhNv datetime,@GioitinhNv char(1),
@DiachiNv nvarchar(100),@SodtNv varchar(15),
@TenDnNv varchar(20),@MatkhauNv varchar(20)
AS
	BEGIN
		UPDATE NHANVIEN SET HOTENNV= @HotenNv, NGAYSINHNV= @NgaysinhNv,
		GIOITINHNV= @GioitinhNv,DIACHINV=@DiachiNv,SODTNV=@SodtNv,
		TENDNNV=@TenDnNv,MATKHAUNV=@MatkhauNv
		WHERE MANV=@Manv
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Sua_NHOMSANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Sửa NHOMSANPHAM
CREATE PROC [dbo].[sp_Sua_NHOMSANPHAM]
@ManhomSp varchar(10),
@MadongSp varchar(10),
@TennhomSp nvarchar(50),
@GhichuNhomSp nvarchar(50)
AS
	BEGIN
		UPDATE NHOMSANPHAM SET MADONGSP=@MadongSp,TENNHOMSP=@TennhomSp,GHICHUNSP=@GhichuNhomSp WHERE MANHOMSP=@ManhomSp
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Sua_SANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Sua_SANPHAM]
@MASP VARCHAR(10),
@MANHOMSP NVARCHAR(10),
@TENSP NVARCHAR(50),
@GIASP MONEY,
@MOTASP NVARCHAR(1000),
@XUATXU NVARCHAR(10),
@DONVITINH NVARCHAR(10),
@HINHANH VARCHAR(200),
@SOLUONG INT
AS
	BEGIN
		UPDATE SANPHAM
		SET MANHOMSP=@MANHOMSP,TENSP=@TENSP,GIASP=@GIASP,MOTASP=@MOTASP,XUATXU=@XUATXU,DONVITINH=@DONVITINH,HINHANH=@HINHANH,SOLUONG=@SOLUONG
		WHERE MASP=@MASP
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Sua_Thongtin]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_Sua_Thongtin]
@ID varchar(10),
@TenCuahang nvarchar(15),
@Diachi nvarchar(200),
@Sodienthoai varchar(15),
@Email varchar(50)
AS
	BEGIN
		UPDATE THONGTINCUAHANG
		SET DIACHI=@Diachi,SODIENTHOAI=@Sodienthoai,EMAIL=@Email,TENCUAHANG=@TenCuahang
		Where ID=@ID
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Tatca_Danhgia]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Tatca_Danhgia]
AS
	BEGIN
		SELECT * FROM DANHGIA
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Tatca_ThongTin]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_Tatca_ThongTin]
AS
	BEGIN
		SELECT * FROM THONGTINCUAHANG
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Them_CTDH]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Them_CTDH]
@MADH VARCHAR(8),
@MASP VARCHAR(8),
@SOLUONG INT,
@THANHTIEN MONEY
AS
	BEGIN
			IF NOT EXISTS(SELECT * FROM CT_DONHANG WHERE MADH=@MADH AND MASP=@MASP)
			BEGIN
				INSERT CT_DONHANG VALUES(@MADH,@MASP,@SOLUONG,@THANHTIEN)
			END
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Them_DONGSANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Them_DONGSANPHAM]
@MADONGSP VARCHAR(10),
@TENDONGSP NVARCHAR(50),
@GHICHU NVARCHAR(50)
AS
BEGIN
			INSERT INTO DONGSANPHAM VALUES(@MADONGSP,@TENDONGSP,@GHICHU)
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Them_KhachHang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[sp_Them_KhachHang](@MAKH varchar(20), @MALOAIKH varchar(10), @TENKH nvarchar(50), @GIOITINHKH char(1), @DIACHIKH nvarchar(80), @SODTKH varchar(15), @TENDNKH varchar(20), @MATKHAUKH varchar(20), @NGAYSINHKH varchar(20), @EMAILKH varchar(100))
as
BEGIN
	declare @NGAYSINHKH_CV date;
	set @NGAYSINHKH_CV=CONVERT(date,@NGAYSINHKH,103);
	insert into KHACHHANG(MaKH, MaLoaiKH, TenKH, GIOITINHKH, DiaChiKH, SoDTKH, TenDNKH, MatKhauKH, TrangThai, NGAYSINHKH, EMAILKH)
	 values(@MAKH, @MALOAIKH, @TENKH, @GIOITINHKH, @DIACHIKH, @SODTKH, @TENDNKH, @MATKHAUKH,1, @NGAYSINHKH_CV, @EMAILKH)
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Them_KHUYENMAI]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Them_KHUYENMAI]
@MaKm varchar(10),@MaSp varchar(10),
@Ngaybatdau varchar(50),@Ngayketthuc varchar(50),
@GiaKm int
AS
	BEGIN
		INSERT INTO KHUYENMAI VALUES(@MaKm,@MaSp,CONVERT(DATETIME,@Ngaybatdau),CONVERT(DATETIME,@Ngayketthuc),@GiaKm)
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Them_NHANVIEN]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Them_NHANVIEN]
@Manv varchar(10),@HotenNv nvarchar(50),
@NgaysinhNv datetime,@GioitinhNv char(1),
@DiachiNv nvarchar(100),@SodtNv varchar(15),
@TenDnNv varchar(20),@MatkhauNv varchar(20)
AS
	BEGIN
		INSERT INTO NHANVIEN VALUES(@Manv,@HotenNv,@NgaysinhNv,@GioitinhNv,@DiachiNv,@SodtNv,@TenDnNv,@MatkhauNv)
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Them_NHOMSANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Them_NHOMSANPHAM]
@ManhomSp varchar(10),
@MadongSp varchar(10),
@TennhomSp nvarchar(50),
@GhichuNhomSp nvarchar(50)
AS
	BEGIN
		INSERT INTO NHOMSANPHAM VALUES(@ManhomSp,@MadongSp,@TennhomSp,@GhichuNhomSp)
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Them_SANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Them_SANPHAM]
@MASP VARCHAR(10),
@MANHOMSP NVARCHAR(10),
@TENSP NVARCHAR(50),
@GIASP MONEY,
@MOTASP NVARCHAR(1000),
@XUATXU NVARCHAR(10),
@DONVITINH NVARCHAR(10),
@HINHANH VARCHAR(200),
@SOLUONG INT
AS
	BEGIN
		IF NOT EXISTS( SELECT * FROM SANPHAM WHERE MASP=@MASP)
		BEGIN
		INSERT INTO SANPHAM VALUES(@MASP,@MANHOMSP,@TENSP,@GIASP,@MOTASP,@XUATXU,@DONVITINH,@HINHANH,@SOLUONG)	
		END
		ELSE
		BEGIN
			RETURN
		END
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Them_THONGTINCUAHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATE TABLE [dbo].[THONGTINCUAHANG](
--	[ID] [varchar](10) NOT NULL,
--	[TENCUAHANG] [nvarchar](150) NULL,
--	[DIACHI] [nvarchar](200) NULL,
--	[SODIENTHOAI] [varchar](15) NULL,
--	[EMAIL] [varchar](50) NULL,
CREATE PROC [dbo].[sp_Them_THONGTINCUAHANG]
@id varchar(10),
@TenCuahang nvarchar(15),
@Diachi nvarchar(200),
@Sodienthoai varchar(15),
@Email varchar(50)
AS
	BEGIN
		INSERT INTO THONGTINCUAHANG VALUES(@id,@TenCuahang,@Diachi,@Sodienthoai,@Email)
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Them_THONGTINNGUOINHAN]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Them_THONGTINNGUOINHAN]
@MADH VARCHAR(10),
@HOTEN NVARCHAR(50),
@DIACHI NVARCHAR (200),
@DIENTHOAI VARCHAR(15),
@PHUONGTHUCGIAOHANG NVARCHAR(100),
@HINHTHUCTHANHTOAN NVARCHAR(100),
@YEUCAUKHAC NVARCHAR(200)
AS
	BEGIN
		INSERT INTO THONGTINNGUOINHAN VALUES(@HOTEN,@DIACHI,@DIENTHOAI,@PHUONGTHUCGIAOHANG,@HINHTHUCTHANHTOAN,@YEUCAUKHAC,@MADH)
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_themDonhang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_themDonhang]
@MADH VARCHAR(10),
@MAKH VARCHAR(8),
@TONGTIEN MONEY
AS
 BEGIN TRAN
	SET TRAN ISOLATION LEVEL SERIALIZABLE
	IF NOT EXISTS(SELECT * FROM DONDATHANG WHERE MADH=@MADH)
		BEGIN
			DECLARE 
			@LOAIKH VARCHAR(8),--Luu gia tri Loaikh dang mua hang
			@TRANGTHAI CHAR(1)
			SET @LOAIKH=(SELECT MALOAIKH FROM KHACHHANG WHERE MAKH=@MAKH)
			SET @TRANGTHAI=(SELECT TRANGTHAI FROM KHACHHANG WHERE MAKH=@MAKH)
			IF(@LOAIKH='LKH03'AND @TRANGTHAI='1')--NEU LA KHACH HANG VIP THI DUOC GIAM 5% TIEN DON HANG
				BEGIN
					SET @TONGTIEN=@TONGTIEN*0.95
				END
			ELSE
				BEGIN
					IF(@LOAIKH='LKH02'AND @TRANGTHAI='1')--NEU LA KHACH HANG THAN THIET THI DUOC GIAM 3% TIEN DON HANG
					BEGIN
						SET @TONGTIEN=@TONGTIEN*0.97
					END
				END
			INSERT INTO DONDATHANG VALUES(@MADH,@MAKH,GETDATE(),0,@TONGTIEN)--THEM THONG TIN VAO BANG DONDATHANG
			IF @@ERROR<>0
			BEGIN
				ROLLBACK
				RETURN
			END
	END
	WAITFOR DELAY'00:00:15'
	COMMIT


GO
/****** Object:  StoredProcedure [dbo].[sp_Thongke_Hangton]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Thongke_Hangton]
AS
BEGIN
	SELECT MASP,TENSP,SOLUONG,GIASP,GIASP*SOLUONG AS THANHTIEN
	FROM SANPHAM
	WHERE SOLUONG>0
	ORDER BY MASP ASC
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ThongkeDoanhthu_Thang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_ThongkeDoanhthu_Thang]
@thang int,
@nam int
AS
BEGIN
	SELECT CONVERT(VARCHAR,NGAYHD,103)AS[DD/MM/YYYY],SUM(TONGTIENHD)AS DOANHTHU
	FROM HOADON
	WHERE  MONTH(NGAYHD)=@thang AND YEAR(NGAYHD)=@nam
	GROUP BY CONVERT(VARCHAR,NGAYHD,103)
	ORDER BY CONVERT(VARCHAR,NGAYHD,103) ASC
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ThongKeDoanhthu_Theongay]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_ThongKeDoanhthu_Theongay]
@tungay varchar(20),
@denngay varchar(20)
AS
	BEGIN
		SELECT CONVERT(VARCHAR,NGAYHD,103)AS[DD/MM/YYYY],SUM(TONGTIENHD)AS DOANHTHU
		FROM HOADON
		WHERE  CONVERT(DATE,NGAYHD,103) BETWEEN CONVERT(DATE,@tungay,103) AND CONVERT(DATE,@denngay,103)
		GROUP BY CONVERT(VARCHAR,NGAYHD,103)
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_ThongTin_cuahang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_ThongTin_cuahang]
@ID varchar(10)
AS
	BEGIN
		SELECT * FROM THONGTINCUAHANG
		Where ID=@ID
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Thongtin_DONGSANPHAM_MADONGSP]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Thongtin_DONGSANPHAM_MADONGSP]
@MADONGSP VARCHAR(8)
AS
	BEGIN
		SELECT * FROM DONGSANPHAM WHERE MADONGSP=@MADONGSP
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Thongtin_DONGSANPHAM_MASP]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Thongtin_DONGSANPHAM_MASP]
@MADONGSP VARCHAR(8)
AS
	BEGIN
		SELECT * FROM DONGSANPHAM WHERE MADONGSP=@MADONGSP
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Thongtin_KHUYENMAI]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Thongtin_KHUYENMAI]
AS
	BEGIN
		SELECT MAKM,TENSP,CONVERT(VARCHAR,NGAYBATDAU,103) AS[DD-MM-YYYY],CONVERT(VARCHAR,NGAYKETTHUC,103) AS[DD-MM-YYYY],GIAKM FROM KHUYENMAI,SANPHAM WHERE SANPHAM.MASP=KHUYENMAI.MASP
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Thongtin_KHUYENMAI_MAKM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Thongtin_KHUYENMAI_MAKM]
@MAKM VARCHAR(8)
AS
	BEGIN
	SELECT MAKM,MASP,CONVERT(VARCHAR,NGAYBATDAU,103)AS[DD/MM/YYYY],CONVERT(VARCHAR,NGAYKETTHUC,103)AS[DD/MM/YYYY],GIAKM FROM KHUYENMAI
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Thongtin_NHOMSANPHAM_MANHOMSP]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Thongtin_NHOMSANPHAM_MANHOMSP]
@MANHOMSP VARCHAR(8)
AS
	BEGIN
		SELECT * FROM NHOMSANPHAM WHERE MANHOMSP=@MANHOMSP
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Thongtin_SANPHAM_MASP]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Thongtin_SANPHAM_MASP]
@masp varchar(8)
AS
	BEGIN
		SELECT * FROM SANPHAM WHERE MASP=@masp
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_thongtincuahang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[sp_thongtincuahang]
@ID VARCHAR(10),
@tencuahang nvarchar(150),
@diachi nvarchar (200),
@sdt nvarchar(15),
@email varchar(50)
as
	begin
		insert into THONGTINCUAHANG values(@ID,@tencuahang,@diachi,@sdt,@email)
	end


GO
/****** Object:  StoredProcedure [dbo].[sp_Tien_DONHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Tien_DONHANG]
@MADH VARCHAR(8)
AS
	BEGIN
		SELECT TONGTIEN FROM DONDATHANG WHERE MADH=@MADH
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Tim_DONHANG_MADH]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Tim_DONHANG_MADH]
@MADH VARCHAR(8)
AS
BEGIN
	SELECT MADH,TENKH,CONVERT(VARCHAR,NGAYDH,103)AS[DD/MM/YYYY],TONGTIEN,TINHTRANG
	FROM DONDATHANG,KHACHHANG
	WHERE DONDATHANG.MAKH=KHACHHANG.MAKH AND DONDATHANG.MADH=@MADH
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Tim_DONHANG_TENKH]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Tim_DONHANG_TENKH]
@TENKH NVARCHAR (50)
AS
BEGIN
	SELECT * FROM (
	SELECT MADH,TENKH,CONVERT(VARCHAR,NGAYDH,103)AS[DD/MM/YYYY],TONGTIEN,TINHTRANG,ROW_NUMBER() OVER(ORDER BY TINHTRANG ASC)AS rowid
	FROM DONDATHANG,KHACHHANG
	WHERE DONDATHANG.MAKH=KHACHHANG.MAKH AND (TENKH LIKE N'%'+@TENKH+'%'))AS DH
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Tim_KhachHang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_Tim_KhachHang](@TuKhoa nvarchar(50))
as
begin
	select * from khachhang where (Tenkh like '%' + @tuKhoa + '%') or(MAKH like '%' + @tuKhoa + '%')
end


GO
/****** Object:  StoredProcedure [dbo].[sp_Tim_KHACHHANG_TENDN]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Tim_KHACHHANG_TENDN]
@TENDN VARCHAR(20)
AS
	BEGIN
		SELECT * FROM KHACHHANG
		WHERE TENDNKH=@TENDN 
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_TimHoadon_MAHD]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_TimHoadon_MAHD]
@MAHD VARCHAR(10)
AS
	BEGIN
	SELECT MAHD,HOTENNV, CONVERT(VARCHAR,NGAYHD,103)AS [DD/MM/YYYY],TONGTIENHD,TENKH
	FROM HOADON, NHANVIEN,KHACHHANG
	WHERE HOADON.MAKH=KHACHHANG.MAKH AND NHANVIEN.MANV=HOADON.MANV AND MAHD=@MAHD
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_TimHoadon_TenKH]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_TimHoadon_TenKH]
@TENKH NVARCHAR(50)
AS
	BEGIN
	SELECT MAHD,HOTENNV, CONVERT(VARCHAR,NGAYHD,103)AS [DD/MM/YYYY],TONGTIENHD,TENKH
	FROM HOADON, NHANVIEN,KHACHHANG
	WHERE HOADON.MAKH=KHACHHANG.MAKH AND NHANVIEN.MANV=HOADON.MANV AND (TENKH LIKE N'%'+@TENKH+'%')
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Timkiem_SANPHAM_KHACHHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Timkiem_SANPHAM_KHACHHANG]
@TUKHOA NVARCHAR(50)
AS
	BEGIN
		SELECT * FROM SANPHAM WHERE (TENSP LIKE N'%'+@TUKHOA+'%') OR (MOTASP LIKE N'%'+@TUKHOA+'%')
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Timkiem_SANPHAM_MASP]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Timkiem_SANPHAM_MASP]
@MASP VARCHAR(8)
AS
	BEGIN
		SET NOCOUNT ON
		SELECT * FROM SANPHAM WHERE MASP=@MASP
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Timkiem_SANPHAM_TENSP]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Timkiem_SANPHAM_TENSP]
@TENSP NVARCHAR(50)
AS
	BEGIN
		SELECT * FROM SANPHAM WHERE (TENSP LIKE N'%'+@TENSP+'%')
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_TOP10_SANPHAM_Banchay]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_TOP10_SANPHAM_Banchay]
@thang int,
@nam int
AS
	BEGIN
	SELECT TOP 10 (SUM(CT_DONHANG.SOLUONG)) AS SL,SANPHAM.MASP,TENSP,GIASP,XUATXU
	FROM SANPHAM,DONDATHANG,CT_DONHANG
	WHERE DONDATHANG.MADH=CT_DONHANG.MADH AND CT_DONHANG.MASP=SANPHAM.MASP AND MONTH(NGAYDH)= @thang AND YEAR(NGAYDH)=@nam AND TINHTRANG=1
	GROUP BY SANPHAM.MASP,TENSP,GIASP,XUATXU
	ORDER BY SUM(CT_DONHANG.SOLUONG) DESC
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_TOP6_SANPHAM_Banchay]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_TOP6_SANPHAM_Banchay]

AS
	BEGIN
	SELECT TOP 6 (SUM(CT_DONHANG.SOLUONG)) AS SL,SANPHAM.MASP,TENSP,GIASP,XUATXU,HINHANH
	FROM SANPHAM,DONDATHANG,CT_DONHANG
	WHERE DONDATHANG.MADH=CT_DONHANG.MADH AND CT_DONHANG.MASP=SANPHAM.MASP AND TINHTRANG=1
	GROUP BY SANPHAM.MASP,TENSP,GIASP,XUATXU,HINHANH
	ORDER BY SUM(CT_DONHANG.SOLUONG) DESC
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_TruyVan_KhachHang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_TruyVan_KhachHang]
as
begin
	select * from KHACHHANG
end


GO
/****** Object:  StoredProcedure [dbo].[sp_TruyVan_KhachHang_TheoMa]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[sp_TruyVan_KhachHang_TheoMa](@MaKH varchar(20))
as
begin
	select * from KHACHHANG where MAKH=@MaKH
end


GO
/****** Object:  StoredProcedure [dbo].[sp_TruyVan_LoaiKhachHang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_TruyVan_LoaiKhachHang]
as
begin
	select * from LOAIKHACHHANG;
end


GO
/****** Object:  StoredProcedure [dbo].[sp_TruyVan_LoaiKhachHang_LayTenTheoMaLoai]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_TruyVan_LoaiKhachHang_LayTenTheoMaLoai](@MaLoaiKH varchar(10))
as
begin
	select TENLOAIKH from LOAIKHACHHANG where MALOAIKH=@MaLoaiKH;
end


GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSoLuong_SANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_UpdateSoLuong_SANPHAM]---
@MASP VARCHAR(10),
@SOLUONG INT
AS
	BEGIN
		UPDATE SANPHAM
		SET SOLUONG=SOLUONG-@SOLUONG
		WHERE MASP=@MASP
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Xoa_Danhgia]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Xoa_Danhgia]
@MADG VARCHAR(8)
AS
	BEGIN
		DELETE FROM DANHGIA WHERE MADG=@MADG
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Xoa_DONGSANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Xoa_DONGSANPHAM]
@MADONGSP VARCHAR(10)
AS
BEGIN
	IF NOT EXISTS( SELECT * FROM NHOMSANPHAM WHERE MADONGSP=@MADONGSP)
	BEGIN
			DELETE FROM DONGSANPHAM
			WHERE MADONGSP=@MADONGSP
	END
	ELSE
	BEGIN
		RETURN
	END
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Xoa_KhachHang]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_Xoa_KhachHang](@MAKH varchar(20))
as
BEGIN
	update KHACHHANG set TrangThai=0 where MaKH=@MaKH	 
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Xoa_KHUYENMAI]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Xoa_KHUYENMAI]
@MaKm varchar(10)
AS
	BEGIN
		DELETE FROM KHUYENMAI WHERE MAKM=@MaKm
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Xoa_NHANVIEN]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Xoa_NHANVIEN]
@Manv varchar(10)
AS
	BEGIN
		DELETE FROM NHANVIEN
		WHERE MANV=@Manv
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Xoa_NHOMSANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Xoa_NHOMSANPHAM]
@ManhomSp varchar(10) ---SELECT * FROM SANPHAM WHERE MANHOMSP='NSP00013'
---SELECT * FROM KHUYENMAI WHERE MASP=(select MASP from SANPHAM where MANHOMSP='NSP00013')
AS
	BEGIN
		IF NOT EXISTS (SELECT * FROM SANPHAM WHERE MANHOMSP=@ManhomSp)
		or NOT EXISTS (SELECT * FROM CT_DONHANG WHERE MASP=(select MASP from SANPHAM where MANHOMSP=@ManhomSp))
		OR NOT EXISTS (SELECT * FROM DANHGIA WHERE MASP=(select MASP from SANPHAM where MANHOMSP=@ManhomSp))
		OR NOT EXISTS (SELECT * FROM KHUYENMAI WHERE MASP=(select MASP from SANPHAM where MANHOMSP=@ManhomSp))
		BEGIN
			DELETE FROM NHOMSANPHAM
			WHERE MANHOMSP=@ManhomSp
		END
		ELSE
		BEGIN
			RETURN
		END
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_Xoa_SANPHAM]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Xoa_SANPHAM]
@MASP VARCHAR(10)
AS
BEGIN	
	IF NOT EXISTS (SELECT * FROM CT_DONHANG WHERE MASP=@MASP)
	OR NOT EXISTS (SELECT * FROM DANHGIA WHERE MASP=@MASP)
	OR NOT EXISTS (SELECT * FROM KHUYENMAI WHERE MASP=@MASP)
	BEGIN
			DELETE SANPHAM
			WHERE SANPHAM.MASP=@MASP
	END
	ELSE
	BEGIN
		RETURN
	END
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Xoa_THONGTINCUAHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Xoa_THONGTINCUAHANG]
AS
	BEGIN
		DELETE FROM THONGTINCUAHANG
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_Xuly_DONHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Xuly_DONHANG]
@MADH VARCHAR(8),
@MANV VARCHAR(8)
AS
	IF NOT EXISTS (SELECT * FROM DONDATHANG WHERE MADH=@MADH)
	BEGIN
		RETURN
	END
	ELSE
	BEGIN
		DECLARE
		@CTDH CURSOR,
		@MAHD VARCHAR(8),
		@TONGTIEN MONEY,
		@MAKH VARCHAR(8),
		--LUU GIA TRI LOAIKH
		@LOAIKH VARCHAR(8),
		--KHAI BAO CAC BIEN DE LUU GIA TRI TREN TUNG CTDH
		@MASP VARCHAR(8),
		@SOLUONG INT,
		@THANHTIEN MONEY
		SET @MAHD=REPLACE(@MADH,'DH','HD')
		SET @MAKH=(SELECT MAKH FROM DONDATHANG WHERE MADH=@MADH)
		SET @TONGTIEN= (SELECT TONGTIEN FROM DONDATHANG WHERE MADH=@MADH)
		SET @LOAIKH=(SELECT MALOAIKH FROM KHACHHANG WHERE MAKH=@MAKH)
		BEGIN TRAN
			IF NOT EXISTS(SELECT * FROM HOADON WHERE MAHD=@MAHD)
			BEGIN
				--CHUYEN DU LIEU TU BANG DONHANG QUA BANG HOADON
				INSERT INTO HOADON VALUES(@MAHD,@MANV,GETDATE(),@TONGTIEN,@MAKH)
				IF(@@ERROR<>0)
				BEGIN
					ROLLBACK TRAN
					RETURN
				END
				--AP DUNG CHINH SACH THEO TUNG LOAI KHACH HANG KHI MUA HANG
				IF(@TONGTIEN>=500000)--NEU TIEN DON HANG LON HON HOAC BANG 500K
				BEGIN
					--NEU CHUA PHAI KHACH HANG VIP THI SET KHACH HANG LEN KH THAN THIET
					IF(@LOAIKH<>'LKH03')
					BEGIN
						UPDATE KHACHHANG SET MALOAIKH='LKH02' WHERE MAKH=@MAKH
						IF(@@ERROR<>0)
						BEGIN
							ROLLBACK TRAN 
							RETURN
						END
					END
				END
				--CONG THEM DIEM MUA HANG CHO KHACH HANG MOI LAN MUA HANG, CU MOI 200K KH SE DUOC 1D
				UPDATE KHACHHANG SET DIEMMUAHANG=DIEMMUAHANG+@TONGTIEN/200000 WHERE MAKH=@MAKH
				IF(@@ERROR<>0)
					BEGIN
						ROLLBACK TRAN
						RETURN
					END
				--KIEM TRA DIEM MUA HANG CUA KHACH HANG,NEU >=500 THI DUA KHACH HANG LEN LOAI VIP
				IF((SELECT DIEMMUAHANG FROM KHACHHANG WHERE MAKH=@MAKH)>=500)
				BEGIN
					UPDATE KHACHHANG SET MALOAIKH='LKH03' WHERE MAKH=@MAKH
					IF(@@ERROR<>0)
					BEGIN
						ROLLBACK TRAN
						RETURN
					END
				END
				--
				SET @CTDH=CURSOR FOR(SELECT MASP,SOLUONG,THANHTIEN FROM CT_DONHANG WHERE MADH=@MADH)
				OPEN @CTDH
				FETCH NEXT FROM @CTDH INTO @MASP,@SOLUONG,@THANHTIEN
				--BAT DAU CHUYEN TUNG DONG TREN CT_DONHANG QUA BANG CT_HOADON
				WHILE @@FETCH_STATUS=0
				BEGIN
					--THEM TUNG DONG VAO CT_HOADON
					INSERT INTO CT_HOADON VALUES(@MAHD,@MASP,@SOLUONG,@THANHTIEN)
					IF(@@ERROR<>0)
					BEGIN
						ROLLBACK TRAN
						RETURN
					END
					BEGIN TRAN
					--THIET LAP MUC CO LAP
					SET TRAN ISOLATION LEVEL READ COMMITTED
					-- CAP NHAT LAI SO LUONG SANPHAM
					UPDATE SANPHAM SET SOLUONG=SOLUONG-@SOLUONG WHERE MASP=@MASP 
					IF(@@ERROR<>0)
					BEGIN
						ROLLBACK TRAN
						RETURN
					END
					COMMIT TRAN
					FETCH NEXT FROM @CTDH INTO @MASP,@SOLUONG,@THANHTIEN
				END
				--CAP NHAT LAI TINH TRANG DON HANG
				UPDATE DONDATHANG SET TINHTRANG=1 WHERE MADH=@MADH 
				IF(@@ERROR<>0)
				BEGIN
					ROLLBACK TRAN
					RETURN
				END
			END
			ELSE
			BEGIN 
				ROLLBACK TRAN
				RETURN
			END
			
		COMMIT TRAN
	END
GO
/****** Object:  StoredProcedure [dbo].[Tim_KHACHHANG_TENDN]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Tim_KHACHHANG_TENDN]
@TENDN VARCHAR(20)
AS
	BEGIN
		SELECT * FROM KHACHHANG
		WHERE TENDNKH=@TENDN 
	END


GO
/****** Object:  Table [dbo].[CT_DONHANG]    Script Date: 6/2/2017 11:50:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CT_DONHANG](
	[MADH] [varchar](10) NOT NULL,
	[MASP] [varchar](10) NOT NULL,
	[SOLUONG] [int] NULL,
	[THANHTIEN] [money] NULL,
 CONSTRAINT [PK_CT_DONHANG] PRIMARY KEY CLUSTERED 
(
	[MADH] ASC,
	[MASP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CT_HOADON]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CT_HOADON](
	[MAHD] [varchar](10) NOT NULL,
	[MASP] [varchar](10) NOT NULL,
	[SOLUONG] [int] NULL,
	[THANHTIEN] [money] NULL,
 CONSTRAINT [PK_CT_HOADON] PRIMARY KEY CLUSTERED 
(
	[MAHD] ASC,
	[MASP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DANHGIA]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DANHGIA](
	[MADG] [int] IDENTITY(1,1) NOT NULL,
	[TIEUDE] [nvarchar](100) NULL,
	[NOIDUNG] [nvarchar](1000) NULL,
	[MASP] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MADG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DONDATHANG]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DONDATHANG](
	[MADH] [varchar](10) NOT NULL,
	[MAKH] [varchar](20) NULL,
	[NGAYDH] [datetime] NULL,
	[TINHTRANG] [int] NULL,
	[TONGTIEN] [money] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DONGSANPHAM]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DONGSANPHAM](
	[MADONGSP] [varchar](10) NOT NULL,
	[TENDONGSP] [nvarchar](50) NULL,
	[GHICHU] [nvarchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HOADON]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HOADON](
	[MAHD] [varchar](10) NOT NULL,
	[MANV] [varchar](10) NULL,
	[NGAYHD] [datetime] NULL,
	[TONGTIENHD] [money] NULL,
	[MAKH] [varchar](20) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHACHHANG](
	[MAKH] [varchar](20) NOT NULL,
	[MALOAIKH] [varchar](10) NULL,
	[TENKH] [nvarchar](50) NULL,
	[GIOITINHKH] [char](1) NULL,
	[DIACHIKH] [nvarchar](80) NULL,
	[SODTKH] [varchar](15) NULL,
	[TENDNKH] [varchar](20) NULL,
	[MATKHAUKH] [varchar](200) NULL,
	[DIEMMUAHANG] [int] NULL,
	[TRANGTHAI] [char](1) NULL,
	[NGAYSINHKH] [date] NULL,
	[EMAILKH] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KHUYENMAI]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHUYENMAI](
	[MAKM] [varchar](10) NOT NULL,
	[MASP] [varchar](10) NULL,
	[NGAYBATDAU] [datetime] NULL,
	[NGAYKETTHUC] [datetime] NULL,
	[GIAKM] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAIKHACHHANG]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAIKHACHHANG](
	[MALOAIKH] [varchar](10) NOT NULL,
	[TENLOAIKH] [nvarchar](20) NULL,
	[GHICHU] [nvarchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NHANVIEN](
	[MANV] [varchar](10) NOT NULL,
	[HOTENNV] [nvarchar](50) NULL,
	[NGAYSINHNV] [datetime] NULL,
	[GIOITINHNV] [char](1) NULL,
	[DIACHINV] [nvarchar](100) NULL,
	[SODTNV] [varchar](15) NULL,
	[TENDNNV] [varchar](20) NULL,
	[MATKHAUNV] [varchar](200) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NHOMSANPHAM]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NHOMSANPHAM](
	[MANHOMSP] [varchar](10) NOT NULL,
	[MADONGSP] [varchar](10) NULL,
	[TENNHOMSP] [nvarchar](50) NULL,
	[GHICHUNSP] [nvarchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SANPHAM]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SANPHAM](
	[MASP] [varchar](10) NOT NULL,
	[MANHOMSP] [varchar](10) NULL,
	[TENSP] [nvarchar](50) NULL,
	[GIASP] [money] NULL,
	[MOTASP] [nvarchar](1000) NULL,
	[XUATXU] [nvarchar](50) NULL,
	[DONVITINH] [nvarchar](10) NULL,
	[HINHANH] [varchar](200) NULL,
	[SOLUONG] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[THAMSO]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THAMSO](
	[TEN] [nvarchar](20) NULL,
	[GIATRI] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[THONGTINCUAHANG]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[THONGTINCUAHANG](
	[ID] [varchar](10) NOT NULL,
	[TENCUAHANG] [nvarchar](150) NULL,
	[DIACHI] [nvarchar](200) NULL,
	[SODIENTHOAI] [varchar](15) NULL,
	[EMAIL] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[THONGTINNGUOINHAN]    Script Date: 6/2/2017 11:50:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[THONGTINNGUOINHAN](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HOTEN] [nvarchar](50) NULL,
	[DIACHI] [nvarchar](200) NULL,
	[DIENTHOAI] [varchar](15) NULL,
	[PHUONGTHUCGIAOHANG] [nvarchar](100) NULL,
	[HINHTHUCTHANHTOAN] [nvarchar](100) NULL,
	[YEUCAUKHAC] [nvarchar](200) NULL,
	[MADH] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000001', N'SP000014', 1, 39000000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000002', N'SP000007', 3, 50100000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000003', N'SP000002', 1, 1500000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000004', N'SP000033', 1, 7900000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000005', N'SP000006', 12, 180000000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000006', N'SP000010', 1, 5000020.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000007', N'SP000040', 1, 140000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000008', N'SP000040', 48, 6720000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000009', N'SP000040', 48, 6720000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000010', N'SP000040', 2, 280000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000012', N'SP000033', 2, 15800000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000015', N'SP000007', 10, 167000000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000029', N'SP000040', 1, 140000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000030', N'SP000037', 5, 200000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000031', N'SP000037', 1, 40000.0000)
INSERT [dbo].[CT_DONHANG] ([MADH], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'DH000032', N'SP000037', 1, 40000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000001', N'SP000014', 1, 39000000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000002', N'SP000007', 3, 50100000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000003', N'SP000002', 1, 1500000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000004', N'SP000033', 1, 7900000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000005', N'SP000006', 12, 180000000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000006', N'SP000010', 1, 5000020.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000007', N'SP000040', 1, 140000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000008', N'SP000040', 48, 6720000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000009', N'SP000040', 48, 6720000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000010', N'SP000040', 2, 280000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000012', N'SP000033', 2, 15800000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000015', N'SP000007', 10, 167000000.0000)
INSERT [dbo].[CT_HOADON] ([MAHD], [MASP], [SOLUONG], [THANHTIEN]) VALUES (N'HD000030', N'SP000037', 5, 200000.0000)
SET IDENTITY_INSERT [dbo].[DANHGIA] ON 

INSERT [dbo].[DANHGIA] ([MADG], [TIEUDE], [NOIDUNG], [MASP]) VALUES (1, N'Tuyệt vời', N'sản phẩn quá tốt', N'SP000040')
INSERT [dbo].[DANHGIA] ([MADG], [TIEUDE], [NOIDUNG], [MASP]) VALUES (2, N'tuyệt', N'good ', N'SP000039')
SET IDENTITY_INSERT [dbo].[DANHGIA] OFF
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000001', N'KH000001', CAST(N'2016-12-27 03:22:08.577' AS DateTime), 1, 35100000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000002', N'KH000001', CAST(N'2016-12-27 03:22:49.040' AS DateTime), 1, 45090000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000003', N'KH000006', CAST(N'2016-12-27 21:41:02.227' AS DateTime), 1, 1500000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000004', N'KH000001', CAST(N'2016-12-27 23:00:44.957' AS DateTime), 1, 7110000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000006', N'KH000001', CAST(N'2016-12-27 23:08:52.363' AS DateTime), 1, 4500018.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000005', N'KH000001', CAST(N'2016-12-27 23:01:44.207' AS DateTime), 1, 162000000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000007', N'KH000001', CAST(N'2017-04-12 15:23:55.150' AS DateTime), 1, 133000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000008', N'KH000001', CAST(N'2017-05-05 15:18:01.100' AS DateTime), 1, 6384000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000009', N'KH000001', CAST(N'2017-05-05 15:18:55.430' AS DateTime), 1, 6384000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000010', N'KH000001', CAST(N'2017-05-05 15:20:51.003' AS DateTime), 1, 266000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000015', N'KH000001', CAST(N'2017-06-02 09:01:15.497' AS DateTime), 1, 158650000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000012', N'KH000001', CAST(N'2017-05-30 22:04:50.100' AS DateTime), 1, 15010000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000031', N'KH000001', CAST(N'2017-06-02 15:29:49.537' AS DateTime), 0, 38000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000032', N'KH000001', CAST(N'2017-06-02 16:33:49.990' AS DateTime), 0, 38000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000029', N'KH000001', CAST(N'2017-06-02 15:24:41.890' AS DateTime), 0, 133000.0000)
INSERT [dbo].[DONDATHANG] ([MADH], [MAKH], [NGAYDH], [TINHTRANG], [TONGTIEN]) VALUES (N'DH000030', N'KH000001', CAST(N'2017-06-02 15:27:06.730' AS DateTime), 1, 190000.0000)
INSERT [dbo].[DONGSANPHAM] ([MADONGSP], [TENDONGSP], [GHICHU]) VALUES (N'DSP00001', N'Laptop', N'Laptop chính hãng')
INSERT [dbo].[DONGSANPHAM] ([MADONGSP], [TENDONGSP], [GHICHU]) VALUES (N'DSP00002', N'Điện Thoại', N'Điện thoại chính hãng')
INSERT [dbo].[DONGSANPHAM] ([MADONGSP], [TENDONGSP], [GHICHU]) VALUES (N'DSP00003', N'Phụ Kiện', N'Phụ kiện chính hãng')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000001', N'NV00001', CAST(N'2016-12-27 03:24:45.000' AS DateTime), 35100000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000002', N'NV00001', CAST(N'2016-12-27 03:25:26.567' AS DateTime), 45090000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000005', N'NV00001', CAST(N'2016-12-27 23:13:52.167' AS DateTime), 162000000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000006', N'NV00001', CAST(N'2016-12-27 23:14:20.540' AS DateTime), 4500018.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000004', N'NV00001', CAST(N'2017-04-12 14:55:14.123' AS DateTime), 7110000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000003', N'NV00006', CAST(N'2017-04-19 09:49:37.610' AS DateTime), 1500000.0000, N'KH000006')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000007', N'NV00006', CAST(N'2017-04-19 09:52:16.003' AS DateTime), 133000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000008', N'NV00001', CAST(N'2017-05-05 15:19:36.840' AS DateTime), 6384000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000010', N'NV00001', CAST(N'2017-05-05 15:22:22.387' AS DateTime), 266000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000009', N'NV00001', CAST(N'2017-05-13 11:32:22.427' AS DateTime), 6384000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000012', N'NV00001', CAST(N'2017-05-30 22:05:58.160' AS DateTime), 15010000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000015', N'NV00001', CAST(N'2017-06-02 09:02:36.350' AS DateTime), 158650000.0000, N'KH000001')
INSERT [dbo].[HOADON] ([MAHD], [MANV], [NGAYHD], [TONGTIENHD], [MAKH]) VALUES (N'HD000030', N'NV00001', CAST(N'2017-06-02 15:28:03.320' AS DateTime), 190000.0000, N'KH000001')
INSERT [dbo].[KHACHHANG] ([MAKH], [MALOAIKH], [TENKH], [GIOITINHKH], [DIACHIKH], [SODTKH], [TENDNKH], [MATKHAUKH], [DIEMMUAHANG], [TRANGTHAI], [NGAYSINHKH], [EMAILKH]) VALUES (N'KH000001', N'LKH03', N'Lê Văn Phú', N'1', N'Tiền Giang', N'0981111111', N'baithuoc', N'124bd1296bec0d9d93c7', 2168, N'1', CAST(N'1993-02-13' AS Date), N'baithuoc@gmail.com')
INSERT [dbo].[KHACHHANG] ([MAKH], [MALOAIKH], [TENKH], [GIOITINHKH], [DIACHIKH], [SODTKH], [TENDNKH], [MATKHAUKH], [DIEMMUAHANG], [TRANGTHAI], [NGAYSINHKH], [EMAILKH]) VALUES (N'KH000002', N'LKH02', N'Ngô Sơn Lâm', N'1', N'Tiền Giang', N'0982222222', N'thaithuoc1', N'124bd1296bec0d9d93c7', NULL, N'1', CAST(N'1993-01-01' AS Date), N'ngolam@gmail.com')
INSERT [dbo].[KHACHHANG] ([MAKH], [MALOAIKH], [TENKH], [GIOITINHKH], [DIACHIKH], [SODTKH], [TENDNKH], [MATKHAUKH], [DIEMMUAHANG], [TRANGTHAI], [NGAYSINHKH], [EMAILKH]) VALUES (N'KH000003', N'LKH01', N'Nguyễn Minh Trí 1', N'1', N'Tiền Giang', N'098333333', N'mtri', N'124bd1296bec0d9d93c7', NULL, N'1', CAST(N'1993-01-01' AS Date), N'minhtri@gmail.com')
INSERT [dbo].[KHACHHANG] ([MAKH], [MALOAIKH], [TENKH], [GIOITINHKH], [DIACHIKH], [SODTKH], [TENDNKH], [MATKHAUKH], [DIEMMUAHANG], [TRANGTHAI], [NGAYSINHKH], [EMAILKH]) VALUES (N'KH000004', N'LKH01', N'Nguyễn Hoàng Hiệp', N'1', N'Tiền Giang', N'0984444444', N'hiep', N'124bd1296bec0d9d93c7', NULL, N'1', CAST(N'1993-01-01' AS Date), N'hiep@gmail.com')
INSERT [dbo].[KHACHHANG] ([MAKH], [MALOAIKH], [TENKH], [GIOITINHKH], [DIACHIKH], [SODTKH], [TENDNKH], [MATKHAUKH], [DIEMMUAHANG], [TRANGTHAI], [NGAYSINHKH], [EMAILKH]) VALUES (N'KH000005', N'LKH03', N'Toàn ABC', N'1', N'abc', N'123', N'abc', N'21232f297a57a5a74389', NULL, N'1', CAST(N'1993-01-01' AS Date), N'abc@gmail.com')
INSERT [dbo].[KHACHHANG] ([MAKH], [MALOAIKH], [TENKH], [GIOITINHKH], [DIACHIKH], [SODTKH], [TENDNKH], [MATKHAUKH], [DIEMMUAHANG], [TRANGTHAI], [NGAYSINHKH], [EMAILKH]) VALUES (N'KH000006', N'LKH02', N'abc', N'1', N'abc vvv', N'012345', N'abc123', N'e10adc3949ba59abbe56', NULL, N'1', CAST(N'1990-01-01' AS Date), N'abc')
INSERT [dbo].[KHUYENMAI] ([MAKM], [MASP], [NGAYBATDAU], [NGAYKETTHUC], [GIAKM]) VALUES (N'KM000005', N'SP000004', CAST(N'2017-06-02 00:00:00.000' AS DateTime), CAST(N'2017-06-05 00:00:00.000' AS DateTime), 8000000)
INSERT [dbo].[KHUYENMAI] ([MAKM], [MASP], [NGAYBATDAU], [NGAYKETTHUC], [GIAKM]) VALUES (N'KM000004', N'SP000039', CAST(N'2017-06-02 00:00:00.000' AS DateTime), CAST(N'2017-06-06 00:00:00.000' AS DateTime), 8000)
INSERT [dbo].[LOAIKHACHHANG] ([MALOAIKH], [TENLOAIKH], [GHICHU]) VALUES (N'LKH01', N'Thường', NULL)
INSERT [dbo].[LOAIKHACHHANG] ([MALOAIKH], [TENLOAIKH], [GHICHU]) VALUES (N'LKH02', N'Thân thiết', NULL)
INSERT [dbo].[LOAIKHACHHANG] ([MALOAIKH], [TENLOAIKH], [GHICHU]) VALUES (N'LKH03', N'Vip', NULL)
INSERT [dbo].[NHANVIEN] ([MANV], [HOTENNV], [NGAYSINHNV], [GIOITINHNV], [DIACHINV], [SODTNV], [TENDNNV], [MATKHAUNV]) VALUES (N'NV00001', N'Lê Admin', CAST(N'1993-07-14 00:00:00.000' AS DateTime), N'1', N'TPHCM', N'0987', N'admin', N'21232f297a57a5a74389')
INSERT [dbo].[NHANVIEN] ([MANV], [HOTENNV], [NGAYSINHNV], [GIOITINHNV], [DIACHINV], [SODTNV], [TENDNNV], [MATKHAUNV]) VALUES (N'NV00002', N'Ngô Sơn Lâm', CAST(N'1993-02-13 00:00:00.000' AS DateTime), N'0', N'TPHCM', N'09876', N'sonlam', N'9fcb126aa9f6c505d508')
INSERT [dbo].[NHANVIEN] ([MANV], [HOTENNV], [NGAYSINHNV], [GIOITINHNV], [DIACHINV], [SODTNV], [TENDNNV], [MATKHAUNV]) VALUES (N'NV00003', N'Nguyễn Hoàng Hiệp', CAST(N'1993-07-14 00:00:00.000' AS DateTime), N'1', N'TPHCM', N'09876', N'hoanghiep', N'124bd1296bec0d9d93c7')
INSERT [dbo].[NHANVIEN] ([MANV], [HOTENNV], [NGAYSINHNV], [GIOITINHNV], [DIACHINV], [SODTNV], [TENDNNV], [MATKHAUNV]) VALUES (N'NV00004', N'Nguyễn Minh Trí', CAST(N'2014-01-01 00:00:00.000' AS DateTime), N'1', N'TPHCM', N'097', N'minhtri', N'124bd1296bec0d9d93c7')
INSERT [dbo].[NHANVIEN] ([MANV], [HOTENNV], [NGAYSINHNV], [GIOITINHNV], [DIACHINV], [SODTNV], [TENDNNV], [MATKHAUNV]) VALUES (N'NV00005', N'Lê Văn Ấu', CAST(N'2014-01-01 00:00:00.000' AS DateTime), N'1', N'TPHCM', N'1234', N'vanau1', N'26ccd728259ba6a64d29')
INSERT [dbo].[NHANVIEN] ([MANV], [HOTENNV], [NGAYSINHNV], [GIOITINHNV], [DIACHINV], [SODTNV], [TENDNNV], [MATKHAUNV]) VALUES (N'NV00006', N'baithuocnv', CAST(N'2014-01-01 00:00:00.000' AS DateTime), N'0', N's', N'012444', N'baithuocnv', N'124bd1296bec0d9d93c7')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00001', N'DSP00001', N'Dell', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00002', N'DSP00001', N'Asus', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00003', N'DSP00001', N'HP', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00004', N'DSP00001', N'Lenovo', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00005', N'DSP00002', N'Apple', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00006', N'DSP00002', N'Samsung', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00007', N'DSP00002', N'Asus', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00008', N'DSP00002', N'HTC', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00009', N'DSP00002', N'Sony', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00010', N'DSP00003', N'Pin sạc dự phòng', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00011', N'DSP00003', N'Cáp sạc', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00012', N'DSP00003', N'Thẻ nhớ', N'')
INSERT [dbo].[NHOMSANPHAM] ([MANHOMSP], [MADONGSP], [TENNHOMSP], [GHICHUNSP]) VALUES (N'NSP00013', N'DSP00003', N'Tai nghe', N'')
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000001', N'NSP00001', N'Dell Inspirion 15 3552', 7090000.0000, N'CPU : Intel Pentium N3700 1.6GHz - 2M (up to 2.4GHz)<br>
RAM : 4GB DDR3L/1600 (one SODIMM slot)<br>
HDD 500GB 5400rpm 2.5''''<br>
Graphics : Intel HD Graphics 15.6" HD(1366x768)<br>
Multimedia : LED-Blacklit, Webcam HD No Lan, Wifi, Bluetooth 4.0, card reader, DVD-RW<br>
Weight : 2.19kg - 4cell battery<br>
Ports : 1x USB 3.0, 2x USB 2.0, HDMI<br>
OS : Windows 10 Home SL 64bits<br>
', N'Trung Quốc', N'Cái', N'dell_3552.jpg', 200)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000002', N'NSP00001', N'Dell Inspiron 14 3452-Y7Y4K1 (Đen)', 7090000.0000, N'CPU : Intel Pentium N3700 1.6GHz - 2M (up to 2.4GHz)<br>
RAM : 1x 4GB DDR3L/1600 (Chỉ 1slot),<br>
HDD 500GB 5400rpm Sata3<br>
Graphics : Intel HD Graphics 14" HD<br>
Multimedia : HDMI, Webcam Wifi, Bluetooth, Reader<br>
Weight and Battery : 1.9Kg - 4Cell<br>
Ports : USB 3.0, 2x USB 2.0<br>
OS : Windows 10 Home SL 64bits<br>
', N'Trung Quốc', N'Cái', N'Inspiron_3452.jpg', 149)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000003', N'NSP00001', N'Dell 3552 (F3552-70072013) (Đen)', 7290000.0000, N'Intel Pentium N3700 1.6GHz - 2M<br>
DDRAM 1x4GB/1600 (1slot)<br>
HDD 500GB 5400rpm<br>
Intel HD Graphics<br>
15.6" HD Led (1366x768) - HDMI - Webcam<br>
No DVD<br>
No Lan - Wifi - Bluetooth<br>
Reader - USB 3.0, 2xUSB 2.0 <br>
Weight 2.19kg - Battery 40Whrs<br>
OS Windows 10 Home SL 64bit <br>
', N'Trung Quốc', N'Cái', N'dell_3552.jpg', 200)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000004', N'NSP00001', N'Dell Inspiron 15 N3558E (Đen)', 9690000.0000, N'Intel Core i3 5005U 2.0GHz - 3M<br>
DDRAM 1x4GB DDR3L/1600 (2 slot)<br>
HDD 500GB 5400rpm<br>
Intel HD Graphics 5500<br>
15.6" HD Led (1366x768) - HDMI - Webcam<br>
DVD-RW<br>
Lan 1G - Wifi - Bluetooth<br>
Reader - USB 3.0, 2xUSSB2.0<br>
Weight 2.2Kg - Battery 40Whrs<br>
OS Ubuntu<br>', N'Trung Quốc', N'Cái', N'Inspiron_15.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000005', N'NSP00001', N'Dell Inspirion 14 3458 (F3458-70071888) (Đen)', 10100000.0000, N'Intel Core i3 5005U 2.0GHz - 3M<br>
DDRAM 1x4GB DDR3L/1600 (2 slot)<br>
HDD 500GB 5400rpm<br>
NVIDIA GF 820M 2GB DDR3 // Intel HD Graphics 5500<br>
14" HD Led (1366x768) - HDMI - Webcam HD <br>
Lan 10/100 - Wifi AC - Bluetooth 4.0<br>
Reader - 1xRI45, 2xUSB2.0, 1xUSB3.0, 1xheadset<br>
Weight 1.9Kg - Battery 4Cell<br>
OS Option<br>
', N'Trung Quốc', N'Cái', N'Inspirion_3458.jpg', 150)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000006', N'NSP00001', N'Laptop Dell Vostro 5568 (F5568-70087070) (Xanh)', 15000000.0000, N'Intel Core i5 7200U 2.5GHz - 3M (up to 3.1GHz)<br>
1x 4GB DDR4/2133 (2 slots)<br>
HDD 500GB 5400rpm s/p M.2 2280<br>
Intel HD Graphics 620<br>
15.6'''' HD Glare, VGA, HDMI, FingerPrint, Webcam HD Lan 1G, Wifi AC, Bluetooth 4.2, Reader<br>
1.98Kg - 3Cell, USB 2.0, 2x USB 3.0, 1x USB 3.0 with PowerShare<br>
Windows 10 Home SL 64bits<br>
', N'Trung Quốc', N'Cái', N'dell_vostro_15_55688.jpg', 88)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000007', N'NSP00001', N'Laptop Dell Vostro 5459-V5459C (Vàng đồng)', 16700000.0000, N'Máy xách tay/ Laptop Dell Vostro 5459-V5459C (Vàng đồng)<br>
CPU : Intel Core i5-6200U 2.3Ghz - 3M (up to 2.8GHz)<br>
RAM : 1x 4GB DDR3L/1600 (1 slot)<br>
HDD 500GB 5400rpm 2.5''''<br>
Graphics : NVIDIA 930M 2GB // Intel HD Graphics 520<br>
Display : 14" HD<br>
Muldimedia : HDMI,Webcam HD Lan 1G, Wifi AC, Bluetooth, Reader<br>
Weight and battery : 1.7Kg - 3Cell<br>
Ports :  3x USB 3.0<br>
OS : Windows 10 Home SL 64 bits<br>
', N'Trung Quốc', N'Cái', N'dell-vostro-goldd.jpg', 87)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000008', N'NSP00001', N'Laptop Dell Vostro 5568-077M52 (I5-7200U) (Vàng)', 17390000.0000, N'CPU: Intel Core i5 7200U 2.5GHz - 3M (up to 3.1GHz)<br>
Ram: 1x 4GB DDR4/2400 (2 slots)<br>
HDD 1TB 5400rpm with Free Fall Data Protection<br>
Graphics: NVIDIA 940MX 2GB // Intel HD Graphics 620<br>
Display: 15.6'''' HD Glare,<br>
Multimedia: VGA, HDMI, Webcam with Dual Digital Microphones Lan 1G, Wifi AC, Bluetooth 4.2, Reader<br>
Weight and Battery : 1.98Kg - 3Cell,<br>
Ports: USB 2.0, 3x USB 3.0, 1x SSD (M.2 2280), FingerPrint Reader<br>
OS: Windows 10 Home SL 64bits<br>
', N'Trung Quốc', N'Cái', N'dell-vostro-55688.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000036', N'NSP00011', N'Cáp Micro USB 20cm eSaver BST-0728 Trắng', 40000.0000, N'Jack kết nối:	Micro USB<br>
Nguồn vào:	5V – 2A<br>
Nguồn ra:	5V – 2A<br>
Độ dài dây:	20cm<br>', N'Việt Nam', N'Cái', N'cap-micro-usb-20cm-esaver-bst-0728-trang-km-808x499.png', 50)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000039', N'NSP00012', N'Thẻ nhớ SD 8GB Transcend Class 10', 150000.0000, N'Dung lượng 8GB<br>
Tốc độ đọc 20Mb/s<br>
Tốc độ ghi tối 10-17Mb/s<br>
Sử dụng cho điện thoại, tablet', N'Mỹ', N'Cái', N'the-nho-sdxc-sdhc-class-10-transcend-8gb-300x300.jpg', 50)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000009', N'NSP00001', N'Laptop Dell XPS12A (M5 6Y57) (Bạc)', 19000000.0000, N'CPU: Intel Core M5 6Y57 1.1GHz - 4M (up to 2.8GHz)<br>
RAM : 8GB LPDDR3/1600 Onboard (No upgrade)<br>
SSD 256GB M.2 2280 Sata<br>
Graphics : Intel HD Graphics 515<br>
Display : 12.5'''' Ultra HD 4K Touch<br>
Multimedia : VGA, HDMI, Display Port, Webcam HD Wifi AC, Bluetooth 4.1, Reader<br>
Weight and Multimedia : 1.27Kg - 2Cell<br>
Ports : USB 3.1 Gen2, 2x  Thunderbolt, USB-A<br>
OS : Windows 10 Home SL 64bits  <br>
', N'Trung Quốc', N'Cái', N'dell_xps_122.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000010', N'NSP00002', N'Laptop Asus X441SA-WX020D (N3060) (Đen)', 5000020.0000, N'Intel Celeron N3060 1.6GHz - 2M (up to 2.48GHz)<br>
1x 4GB DDR3 Onboard (No upgrade)<br>
HDD 500GB 5400rpm 2.5'''' Sata<br>
Intel HD Graphics 400<br>
14'''' HD Glare, DVD RW, VGA, HDMI, Webcam Lan 100, Wifi N, Bluetooth 4.0, Reader<br>
1.75Kg - 3Cell<br>
USB 2.0, USB 3.0, USB 3.1 Type C (Gen 1) No OS<br>
', N'Trung Quốc', N'Cái', N'740_x441sa-wx0211.jpg', 149)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000011', N'NSP00002', N'Laptop Asus X540SA-XX318D (Celeron N3060) (Đen)', 6000000.0000, N'CPU : Intel Celeron N3060 1.6GHz - 2M (up to 2.48GHz)<br>
RAM : 1x 4GB DDR3L/1600 Onboard (No upgrade),<br>
HDD 500GB 5400rpm 2.5'''' Sata3<br>
Graphics : Intel HD Graphics 400<br>
Display : 15.6'''' HD,<br>
Optical and Multimedia : DVD RW, VGA, HDMI, Webcam Lan 100, Wifi N, Reader<br>
Weight and Battery : 1.9Kg - 3Cell<br>
Ports : USB 2.0, USB 3.0, USB 3.1 Type C<br>
OS : No OS<br>', N'Trung Quốc', N'Cái', N'3159_x403sa-wx235tT.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000012', N'NSP00002', N'Laptop Asus X454LA-WX292D (I3-5005U)', 9000000.0000, N'Laptop Asus X454LA-WX292D (I3-5005U)<br>
CPU : Intel Core i3 5005U 2.0GHz - 3M<br>
RAM : 1x 4GB DDR3L/1600 Onboard (còn 1slot)<br>
HDD 500GB 5400rpm 2.5'''' Sata<br>
Graphics : Intel HD Graphics 5500<br>
Display : 14'''' HD Glare<br>
Optical and Multimedia : DVD RW, HDMI, VGA (D-Sub), Webcam Lan 1G, Wifi N, Bluetooth 4.0, Reader<br>
Weight and Battery : 2.1Kg - 2Cell<br>
Ports : 1x USB 3.0, 2x USB 2.0<br>
No OS<br>', N'Trung Quốc', N'Cái', N'3159_x403sa-wx235tT.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000013', N'NSP00002', N'Laptop Asus UX390UA-GS036T (I7-7500U) (Xám)', 49000000.0000, N'CPU : Intel Core i7 7500U 2.7GHz - 4M (up to 3.5GHz)<br>
RAM : 1x 16GB LPDDR3 Onboard (No upgrade)<br>
SSD 512GB M.2 PCIEG3x4<br>
Graphics : Intel HD Graphics 620<br>
Display : 12.5'''' FHD Ultra Slim, Glare, Webcam Wifi AC, Bluetooth 4.1<br>
Weight and battery : 0.91Kg - 6Cell, 1x USB 3.1 Type C (Gen 1), FingerPrint<br>
OS : Windows 10 Home SL 64bits<br>
', N'Trung Quốc', N'Cái', N'4434_rog-g752-squareE.png', 130)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000014', N'NSP00002', N'Laptop Asus UX390UA-GS053T (I7-7500U) (Vàng)', 39000000.0000, N'CPU : Intel Core i7 7500U 2.7GHz - 4M (up to 3.5GHz)<br>
RAM : 1x 16GB LPDDR3 Onboard (No upgrade)<br>
SSD 512GB M.2 PCIEG3x4<br>
Graphics : Intel HD Graphics 620<br>
Display : 12.5'''' FHD Ultra Slim, Glare, Webcam Wifi AC, Bluetooth 4.1<br>
Weight and battery : 0.91Kg - 6Cell, 1x USB 3.1 Type C (Gen 1), FingerPrint<br>
OS : Windows 10 Home SL 64bits<br>', N'Trung Quốc', N'Cái', N'10360_gx700-squareE.png', 139)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000015', N'NSP00002', N'Laptop Asus G752VM-GC066T (I7-6700HQ) (Xám)', 33000000.0000, N'Intel Core i7 6700HQ 2.6GHz - 6M (up to 3.5GHz)<br>
2x 16GB DDR4/2400 (4 slots),<br>
HDD 1TB 7200rpm 2.5'''' Sata3 + SSD 256GB M.2 2280<br>
NVIDIA GTX 1060 6GB<br>
17.3'''' FHD IPS Glare, DVD RW, HDMI, LED_KB, Webcam Lan 1G, Wifi AC, Bluetooth 4.2, Reader<br>
4.4Kg - 6Cell, 4x USB 3.0, 1x USB 3.1 Type C, 1x Mini DisplayPort, 1x M.2 2280<br>
Windows 10 Home SL 64bits<br>
', N'Trung Quốc', N'Cái', N'26308_rog-g752-squareE.png', 50)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000040', N'NSP00013', N'Tai nghe chụp tai Genius HS-02BA', 140000.0000, N'Jack cắm:	3.5 mm<br>
Độ dài dây:	1m<br>
Phím tính năng:	Tăng/giảm âm lượng.<br>
Tính năng khác: không<br>', N'Mỹ', N'cái', N'tai-nghe-hpm-genius-hs-02b-4-300x300.jpg', 52)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000016', N'NSP00003', N'Laptop HP 15-ay071TU (X3B53PA) (Xám)', 7500000.0000, N'Máy xách tay/ Laptop HP 15-ay071TU (X3B53PA) (Xám)<br>
CPU : Pentium N3710 1.6GHz, 2MB upto 2.56GHz 4 cores không fan<br>
RAM : 4GB DDR3L chỉ 1 slot upto 8GHz<br>
HDD 500GB 5400rpm<br>
Graphics : Intel HD Graphics 405<br>
Display : 15.6" diagonal HD BrightView WLED-blacklit (1366 x 768)<br>
Optical : SuperMulti DVD burner DVD RW, HDMI, Camera Wireless b/g/n, bluetooth 4.0, 1 multi-format SD media card reader,<br>
Weight : 2.13kg, 4Cell Battery<br>
Ports : 1xUSB 3.0, 2xUSB 2.0, 1RJ-45 10/100, 1 headerphone/ microphone  cobo<br>
Free Dos<br>', N'Trung Quốc', N'Cái', N'1005_hp-spec-x0h27paA.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000017', N'NSP00003', N'Laptop HP 14-am060TU (X1H09PA) (Bạc)', 7000000.0000, N'Laptop HP 14-am060TU (X1H09PA) (Bạc)<br>
CPU : Intel Pentium N3710 1.6GHz - 2M (up to 2.56GHz)<br>
RAM : 1x 4GB DDR3L/1600 (chØ 1 slot)<br>
HDD 500GB 5400rpm Sata3<br>
Graphics : Intel HD Graphics 405<br>
Display :14'''' HD<br>
Optical and Multimedia : DVD RW, VGA, HDMI, Webcam HD Lan 100, Wifi N, Bluetooth 4.0, Reader<br>
Weight and Battery : 1.94Kg - 4 Cell<br>
Ports : USB 3.0, 2x USB 2.0 No OS<br>
', N'Trung Quốc', N'Cái', N'4089_laptop_hp_15_ay073tu_x3b55paA.jpg', 150)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000018', N'NSP00003', N'Laptop HP 15-ay073TU (X3B55PA) (Bạc)', 9500000.0000, N'CPU : Intel Core i3 5005U 2.0GHz - 3M<br>
Ram : 1x 4GB DDR3L<br>
HDD 500GB<br>
Graphics : Intel HD Graphics<br>
Display : 15.6'''' HD<br>
Optical ans Multimedia : DVD SM, HDMI, Webcam HD Lan, Wifi N, Bluetooth, Reader<br>
Weight and Battery : 2.07Kg - 4Cell,<br>
Ports : 2x USB 2.0, 1x USB 3.0<br>
OS : No OS<br>
', N'Trung Quốc', N'Cái', N'7903_11-k108tuU.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000019', N'NSP00003', N'Laptop HP 14-am049TU (X1G96PA) (Bạc)', 9000000.0000, N'Laptop HP 14-am049TU (X1G96PA) (Bạc)<br>
CPU : Intel Core i3 5005U 2.0GHz - 3M<br>
RAM : 1x 4GB DDR3L/1600 (2 slots)<br>
HDD 500GB 5400rpm Sata<br>
Graphics : Intel HD Graphics 5500<br>
Display : 14'''' HD<br>
Optical and Multimedia : DVD RW, VGA, HDMI, Webcam HD Lan 100, Wifi N, Bluetooth 4.0, Reader<br>
Weight and Battery : 1.94Kg - 4Cell<br>
Ports :  2x USB 2.0, 1x USB 3.0<br>
No OS<br>', N'Trung Quốc', N'Cái', N'12759_hp-envy-13-osS.jpg', 130)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000020', N'NSP00003', N'Laptop HP Pavilion x360 11-k108TU (P3D42PA) (Đỏ)', 12000000.0000, N'Laptop HP Pavilion x360 11-k108TU (P3D42PA) (Đỏ)<br>
Intel Pentium N3700  1.6GHz - 2M<br>
DDRAM 1x4GB/1600 (1 slot)<br>
HDD 500GB 5400rpm<br>
Intel HD Graphics<br>
11.6" IPS HD WLed Touch (1366x768) - HDMI - Webcam<br>
No DVD<br>
Lan 10/100 - Wifi - Bluetooth<br>
Reader - 2xUSB 3.0, USB 2.0<br>
Weight 1.45Kg - Battery 2 Cell<br>
OS Windows 10 Home SL 64bit <br>', N'Trung Quốc', N'Cái', N'13454_hp-folio-g11.jpg', 120)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000021', N'NSP00003', N'Laptop HP Envy 13-d019TU (P6M18PA) (Bạc)', 9800000.0000, N'Laptop HP Envy 13-d019TU (P6M18PA) (Bạc)<br>
Intel Core i7 6500U  2.5GHz - 4M<br>
DDRAM 8GB/1600 onboard (Ko upgrade)<br>
SSD 256GB (M.2 2280)<br>
Intel HD Graphics 520<br>
13.3" IPS QHD WLed (3200x1800) - HDMI - Webcam<br>
No DVD<br>
No Lan - Wifi AC - Bluetooth<br>
Reader - 3xUSB 3.0, FingerPrint, LED_KB<br>
Weight 1.36Kg - Battery 3Cell<br>
OS Windows 10 Home SL 64bit<br>
', N'Trung Quốc', N'Cái', N'24800_am049tu-x1g96pa_14672717766.jpg', 120)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000022', N'NSP00005', N'iPhone 7 Plus 256GB (JetBlack) ', 17900000.0000, N'HĐH: iOS 10
CPU: Apple A10 Fusion 4 nhân
RAM: 3 GB, ROM: 256 GB
Camera: 2x12 MP, Selfie: 7
PIN: 2900 mAh, SIM: 1 SIM iPhone 7 Plus 128GB (JetBlack) 25.190.000₫ Màn hình: 5.5", Retina HD
HĐH: iOS 10
CPU: Apple A10 Fusion 4 nhân
RAM: 3 GB, ROM: 128 GB
Camera: 2x12 MP, Selfie: 7 MP
PIN: 2900 mAh, SIM: 1 SIM iPhone 7 256GB (Gray) 24.590.000₫ Màn hình: 4.7", Retina HD', N'Mỹ', N'Cái', N'iphone-7-plus-13-300x300.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000023', N'NSP00005', N'iPhone 7 Plus 128GB (JetBlack)', 15000000.0000, N'Màn hình: 5.5", Retina HD<br>
HĐH: iOS 10<br>
CPU: Apple A10 Fusion 4 nhân<br>
RAM: 3 GB, ROM: 128 GB<br>
Camera: 2x12 MP, Selfie: 7 MP<br>
PIN: 2900 mAh, SIM: 1 SIM
', N'Mỹ', N'Cái', N'iphone-7-8-400x460.png', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000024', N'NSP00005', N'iPhone 7 256GB (Gray)', 15000000.0000, N'Màn hình: 4.7", Retina HD<br><br>
HĐH: iOS 10<br>
CPU: Apple A10 Fusion 4 nhân<br>
RAM: 2 GB, ROM: 256 GB<br>
Camera: 12 MP, Selfie: 7 MP<br>
PIN: 1960 mAh, SIM: 1 SIM
', N'Mỹ', N'Cái', N'iphone-7-plus-13-300x300.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000025', N'NSP00005', N'iPhone 6s Plus 64GB (Gold Pink)', 15000000.0000, N'Màn hình: 5.5", Retina HD<br>
HĐH: iOS 9<br>
CPU: Apple A9 2 nhân<br>
RAM: 2 GB, ROM: 64 GB<br>
Camera: 12 MP, Selfie: 5 MP<br>
PIN: 2750 mAh, SIM: 1 Sim

', N'Mỹ', N'Cái', N'iphone-6s-64gb-300x300.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000026', N'NSP00005', N'iPhone 6s 128GB (Gold Pink)', 17000000.0000, N'Màn hình: 4.7", Retina HD<br>
HĐH: iOS 9<br>
CPU: Apple A9 2 nhân 64-bit<br>
RAM:,ROM: 2 GB, 128 GB<br>
Camera:,Selfie: 12 MP, 5 MP<br>
PIN:,SIM: 1715 mAh, 1 Sim', N'Mỹ', N'Cái', N'iphone-7-8-400x460.png', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000027', N'NSP00005', N'iPhone 6s Plus 32GB (Gold Pink)', 18700000.0000, N'Màn hình: 5.5", Retina HD<br>
HĐH: iOS 9<br>
CPU: Apple A9 2 nhân<br>
RAM: 2 GB, ROM: 32 GB<br>
Camera: 12 MP, Selfie: 5 MP<br>
PIN: 2750 mAh, SIM: 1 Sim
', N'Mỹ', N'Cái', N'iphone-6s-64gb-300x300.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000028', N'NSP00006', N'Samsung Galaxy S7 Edge (Blue Coral)', 11900000.0000, N'Màn hình: 5.5", Quad HD<br>
HĐH: Android 6.0 (Marshmallow)<br>
CPU: Exynos 8890 8 nhân<br>
RAM: 4 GB, ROM: 32 GB<br>
Camera: 12 MP, Selfie: 5 MP<br>
PIN: 3600 mAh, SIM: 2 SIM
', N'Hàn', N'Cái', N'samsung-galaxy-s7-16-300x300.jpg', 120)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000029', N'NSP00006', N'Samsung Galaxy S7 Edge (Black)', 17000000.0000, N'Màn hình: 5.5", Quad HD<br>
HĐH: Android 6.0 (Marshmallow)<br>
CPU: Exynos 8890 8 nhân<br>
RAM: 4 GB, ROM: 32 GB<br>
Camera: 12 MP, Selfie: 5 MP<br>
PIN: 3600 mAh, SIM: 2 SIM
', N'Quốc tế', N'Cái', N'samsung-galaxy-s7-edge-black-26-300x300.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000030', N'NSP00006', N'Samsung Galaxy S7 Edge (Pink Gold Edition)', 19000000.0000, N'Màn hình: 5.5", Quad HD<br>
HĐH: Android 6.0 (Marshmallow)<br>
CPU: Exynos 8890 8 nhân<br>
RAM: 4 GB, ROM: 32 GB<br>
Camera: 12 MP, Selfie: 5 MP<br>
PIN: 3600 mAh, SIM: 2 SIM
', N'Mỹ', N'Cái', N'samsung-galaxy-s7-edge-pink-gold-edition-pp-300x300.jpg', 50)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000031', N'NSP00006', N'Samsung Galaxy S7 (Black)', 15000000.0000, N'Màn hình: 5.1", Quad HD<br>
HĐH: Android 6.0 (Marshmallow)<br>
CPU: Exynos 8890 8 nhân<br>
RAM: 4 GB, ROM: 32 GB<br>
Camera: 12 MP, Selfie: 5 MP<br>
PIN: 3000 mAh, SIM: 2 SIM', N'Mỹ', N'Cái', N'samsung-galaxy-s7-edge-blue-coral-edition-300x300.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000032', N'NSP00007', N'Asus Zenfone 3 ZE552KL (Black)', 8000000.0000, N'Màn hình: 5.5", Full HD<br>
HĐH: Android 6.0 (Marshmallow)<br>
CPU: Snapdragon 625 8 nhân<br>
RAM: 4 GB, ROM: 64 GB<br>
Camera: 16 MP, Selfie: 8 MP<br>
PIN: 3000 mAh, SIM: 2 SIM', N'Trung Quốc', N'Cái', N'asus-zenfone-3-blue-200x200.jpg', 100)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000033', N'NSP00007', N'Asus Zenfone 3 ZE520KL (Gold)', 7900000.0000, N'Màn hình: 5.2", Full HD<br>
HĐH: Android 6.0 (Marshmallow)<br>
CPU: Snapdragon 625 8 nhân<br>
RAM: 4 GB, ROM: 64 GB<br>
Camera: 16 MP, Selfie: 8 MP<br>
PIN: 2650 mAh, SIM: 2 SIM', N'Trung Quốc', N'Cái', N'asus-zenfone-3-blue-200x200.jpg', 47)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000034', N'NSP00010', N'Pin sạc dự phòng eSaver 5000 mAh Y322', 190000.0000, N'Hiệu suất sạc:	65%<br>
Đèn LED báo hiệu: Có<br>
Thời gian sạc:	3-4 giờ (dùng Adapter 2A), 5-6 giờ (dùng Adapter 1A)<br>
Nguồn vào: 5V-2.1A<br>
Cổng ra USB 1:	5V-2.1A<br>
Cổng ra USB 2:	Không.<br>
Kích thước (NxDxC): Dài 9cm x ngang 5cm x 2.5cm<br>
Tự ngắt khi sạc đầy điện thoại:	Không<br>
Trọng lượng:	<200gr<br>
Bộ bán hàng chuẩn:	Pin sạc dự phòng<br>', N'Trung Quốc', N'Cái', N'pin-sac-du-phong-esaver-5000-mah-y322-300x300.jpg', 50)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000035', N'NSP00010', N'Pin sạc dự phòng Polymer 10000mah eSaver Maya 10 G', 450000.0000, N'Hiệu suất sạc:	65%<br>
Đèn LED báo hiệu:	Có<br>
Thời gian sạc:	5-6 giờ (dùng adapter 2A), 10-11 giờ (dùng adapter 1A)<br>
Nguồn vào:	5V-1A/2.1A<br>
Cổng ra USB 1:	5V-1A<br>
Cổng ra USB 2:	5V-2.1A<br>
Kích thước (NxDxC):	155x75x14mm<br>
Tự ngắt khi sạc đầy điện thoại:	Không<br>
Trọng lượng:	<300gr<br>
Bộ bán hàng chuẩn:	1 pin sạc dự phòng<br>', N'Trung Quốc', N'Cái', N'pin-sac-du-phong-polymer-10000mah-esaver-maya-10-g-300x300.jpg', 200)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000037', N'NSP00011', N'Cáp Micro USB Pisen MU09-200', 40000.0000, N'Độ dài: 20cm<br>
Jack kết nối: Micro USB<br>
Tương thích: Các dòng Samsung, HTC, LG, Lumia, Oppo…<br>
Nguồn ra: 5V – 2A<br>
Nguồn vào: 5V – 2A<br>', N'abc', N'cái', N'cap-micro-usb-20cm-pisen-mu09-200-kg-300x300.png', 7)
INSERT [dbo].[SANPHAM] ([MASP], [MANHOMSP], [TENSP], [GIASP], [MOTASP], [XUATXU], [DONVITINH], [HINHANH], [SOLUONG]) VALUES (N'SP000038', N'NSP00012', N'Thẻ nhớ MicroSD 8GB Sandisk Class 4', 150000.0000, N'Dung lượng 8GB<br>
Tốc độ đọc 20Mb/s<br>
Tốc độ ghi 4-8.5Mb/s<br>
Sử dụng cho điện thoại, tablet<br>', N'Việt Nam', N'Cái', N'the-nho-micro-sdxc-sdhc-class-4-sandisk-8gbvv-7-300x300.jpg', 50)
SET IDENTITY_INSERT [dbo].[THONGTINNGUOINHAN] ON 

INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (1, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000001')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (2, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Qua bưu điện', N'Chuyển khoản ngân hàng', N'', N'DH000002')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (3, N'abc', N'abc vvv', N'012345', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000003')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (4, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000004')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (5, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000005')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (6, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000006')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (7, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000007')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (8, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000008')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (9, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000009')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (10, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000010')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (1008, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000012')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (1014, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000015')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (1028, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000029')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (1029, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000030')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (1030, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000031')
INSERT [dbo].[THONGTINNGUOINHAN] ([ID], [HOTEN], [DIACHI], [DIENTHOAI], [PHUONGTHUCGIAOHANG], [HINHTHUCTHANHTOAN], [YEUCAUKHAC], [MADH]) VALUES (1031, N'Lê Văn Phú', N'Tiền Giang', N'0981111111', N'Vận chuyển trực tiếp', N'Trả tiền trực tiếp', N'', N'DH000032')
SET IDENTITY_INSERT [dbo].[THONGTINNGUOINHAN] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_DONDATHANG]    Script Date: 6/2/2017 11:50:05 PM ******/
ALTER TABLE [dbo].[DONDATHANG] ADD  CONSTRAINT [PK_DONDATHANG] PRIMARY KEY NONCLUSTERED 
(
	[MADH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_DONGSANPHAM]    Script Date: 6/2/2017 11:50:05 PM ******/
ALTER TABLE [dbo].[DONGSANPHAM] ADD  CONSTRAINT [PK_DONGSANPHAM] PRIMARY KEY NONCLUSTERED 
(
	[MADONGSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_HOADON]    Script Date: 6/2/2017 11:50:05 PM ******/
ALTER TABLE [dbo].[HOADON] ADD  CONSTRAINT [PK_HOADON] PRIMARY KEY NONCLUSTERED 
(
	[MAHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_KHACHHANG]    Script Date: 6/2/2017 11:50:05 PM ******/
ALTER TABLE [dbo].[KHACHHANG] ADD  CONSTRAINT [PK_KHACHHANG] PRIMARY KEY NONCLUSTERED 
(
	[MAKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_KHUYENMAI]    Script Date: 6/2/2017 11:50:05 PM ******/
ALTER TABLE [dbo].[KHUYENMAI] ADD  CONSTRAINT [PK_KHUYENMAI] PRIMARY KEY NONCLUSTERED 
(
	[MAKM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_LOAIKHACHHANG]    Script Date: 6/2/2017 11:50:05 PM ******/
ALTER TABLE [dbo].[LOAIKHACHHANG] ADD  CONSTRAINT [PK_LOAIKHACHHANG] PRIMARY KEY NONCLUSTERED 
(
	[MALOAIKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_NHANVIEN]    Script Date: 6/2/2017 11:50:05 PM ******/
ALTER TABLE [dbo].[NHANVIEN] ADD  CONSTRAINT [PK_NHANVIEN] PRIMARY KEY NONCLUSTERED 
(
	[MANV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_NHOMSANPHAM]    Script Date: 6/2/2017 11:50:05 PM ******/
ALTER TABLE [dbo].[NHOMSANPHAM] ADD  CONSTRAINT [PK_NHOMSANPHAM] PRIMARY KEY NONCLUSTERED 
(
	[MANHOMSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_SANPHAM]    Script Date: 6/2/2017 11:50:05 PM ******/
ALTER TABLE [dbo].[SANPHAM] ADD  CONSTRAINT [PK_SANPHAM] PRIMARY KEY NONCLUSTERED 
(
	[MASP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CT_DONHANG]  WITH CHECK ADD  CONSTRAINT [FK_CT_DONHA_CT_DONHAN_DONDATHA] FOREIGN KEY([MADH])
REFERENCES [dbo].[DONDATHANG] ([MADH])
GO
ALTER TABLE [dbo].[CT_DONHANG] CHECK CONSTRAINT [FK_CT_DONHA_CT_DONHAN_DONDATHA]
GO
ALTER TABLE [dbo].[CT_DONHANG]  WITH CHECK ADD  CONSTRAINT [FK_CT_DONHA_CT_DONHAN_SANPHAM] FOREIGN KEY([MASP])
REFERENCES [dbo].[SANPHAM] ([MASP])
GO
ALTER TABLE [dbo].[CT_DONHANG] CHECK CONSTRAINT [FK_CT_DONHA_CT_DONHAN_SANPHAM]
GO
ALTER TABLE [dbo].[CT_HOADON]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOADO_CT_HOADON_HOADON] FOREIGN KEY([MAHD])
REFERENCES [dbo].[HOADON] ([MAHD])
GO
ALTER TABLE [dbo].[CT_HOADON] CHECK CONSTRAINT [FK_CT_HOADO_CT_HOADON_HOADON]
GO
ALTER TABLE [dbo].[CT_HOADON]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOADO_CT_HOADON_SANPHAM] FOREIGN KEY([MASP])
REFERENCES [dbo].[SANPHAM] ([MASP])
GO
ALTER TABLE [dbo].[CT_HOADON] CHECK CONSTRAINT [FK_CT_HOADO_CT_HOADON_SANPHAM]
GO
ALTER TABLE [dbo].[DANHGIA]  WITH CHECK ADD FOREIGN KEY([MASP])
REFERENCES [dbo].[SANPHAM] ([MASP])
GO
ALTER TABLE [dbo].[DONDATHANG]  WITH CHECK ADD  CONSTRAINT [FK_DONDATHA_DAT_KHACHHAN] FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHACHHANG] ([MAKH])
GO
ALTER TABLE [dbo].[DONDATHANG] CHECK CONSTRAINT [FK_DONDATHA_DAT_KHACHHAN]
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD  CONSTRAINT [FK_HOADON_KHACHHANG] FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHACHHANG] ([MAKH])
GO
ALTER TABLE [dbo].[HOADON] CHECK CONSTRAINT [FK_HOADON_KHACHHANG]
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD  CONSTRAINT [FK_HOADON_LAP2_NHANVIEN] FOREIGN KEY([MANV])
REFERENCES [dbo].[NHANVIEN] ([MANV])
GO
ALTER TABLE [dbo].[HOADON] CHECK CONSTRAINT [FK_HOADON_LAP2_NHANVIEN]
GO
ALTER TABLE [dbo].[KHACHHANG]  WITH CHECK ADD  CONSTRAINT [FK_KHACHHAN_THUOC_LOAIKHAC] FOREIGN KEY([MALOAIKH])
REFERENCES [dbo].[LOAIKHACHHANG] ([MALOAIKH])
GO
ALTER TABLE [dbo].[KHACHHANG] CHECK CONSTRAINT [FK_KHACHHAN_THUOC_LOAIKHAC]
GO
ALTER TABLE [dbo].[NHOMSANPHAM]  WITH CHECK ADD  CONSTRAINT [FK_NHOMSANP_GOM2_DONGSANP] FOREIGN KEY([MADONGSP])
REFERENCES [dbo].[DONGSANPHAM] ([MADONGSP])
GO
ALTER TABLE [dbo].[NHOMSANPHAM] CHECK CONSTRAINT [FK_NHOMSANP_GOM2_DONGSANP]
GO
ALTER TABLE [dbo].[SANPHAM]  WITH CHECK ADD  CONSTRAINT [FK_SANPHAM_GOM_NHOMSANP] FOREIGN KEY([MANHOMSP])
REFERENCES [dbo].[NHOMSANPHAM] ([MANHOMSP])
GO
ALTER TABLE [dbo].[SANPHAM] CHECK CONSTRAINT [FK_SANPHAM_GOM_NHOMSANP]
GO
ALTER TABLE [dbo].[THONGTINNGUOINHAN]  WITH CHECK ADD  CONSTRAINT [FK_TTNN_DDH] FOREIGN KEY([MADH])
REFERENCES [dbo].[DONDATHANG] ([MADH])
GO
ALTER TABLE [dbo].[THONGTINNGUOINHAN] CHECK CONSTRAINT [FK_TTNN_DDH]
GO
