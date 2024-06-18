SELECT 
	 [Tanggal]
	 ,MONTH(CONVERT(DATE, Tanggal, 103)) AS Month
	,[Cabang]
	,[Area]
	,[Jumlah Teller]
	,[Jumlah Transaksi Teller]
	,[Rata-Rata Transaksi per Teller]
	,[Keterangan Teller]
	,[Jumlah CS]
	,[Jumlah Transaksi CS]
    ,[Rata-Rata Transaksi CS]
    ,[Jenis Transaksi Dominan Teller]
    ,[Jenis Transaksi Dominan CS]
    ,TRY_CAST([Nasabah CS terakhir dilayani] AS DECIMAL(4, 2)) AS [Nasabah CS terakhir dilayani]
    ,TRY_CAST([Nasabah Teller terakhir dilayani] AS DECIMAL(4, 2)) AS [Nasabah Teller terakhir dilayani]
FROM [Excel_Import].[dbo].[data transaksi teller dan cs]

-- TOP 3 RATA-RATA JUMLAH TRANSAKSI TELLER PER CABANG PER HARI
WITH rataan AS (
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	Cabang,
	SUM([Jumlah Transaksi Teller]) as Jumlah_Transaksi_Teller,
	COUNT(DATEPART(MONTH, Tanggal)) as Banyak_Hari,
	CAST(ROUND(SUM([Jumlah Transaksi Teller]) / COUNT(DATEPART(MONTH, Tanggal)), 0) AS INT) as Avg_per_Cabang_per_Hari
FROM [data transaksi teller dan cs]
GROUP BY DATEPART(MONTH, Tanggal), Cabang
),
top_3 AS (
SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY Bulan ORDER BY Avg_per_Cabang_per_Hari DESC) AS rn
FROM rataan
)
SELECT *
FROM top_3
WHERE rn <= 3
ORDER BY Bulan, rn

-- TOP 3 RATA-RATA JUMLAH TRANSAKSI CS PER CABANG PER HARI
WITH rataan AS (
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	Cabang,
	SUM([Jumlah Transaksi CS]) as Jumlah_Transaksi_Teller,
	COUNT(DATEPART(MONTH, Tanggal)) as Banyak_Hari,
	CAST(ROUND(SUM([Jumlah Transaksi CS]) / COUNT(DATEPART(MONTH, Tanggal)), 0) AS INT) as Avg_per_Cabang_per_Hari
FROM [data transaksi teller dan cs]
GROUP BY DATEPART(MONTH, Tanggal), Cabang
),
top_3 AS (
SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY Bulan ORDER BY Avg_per_Cabang_per_Hari DESC) AS rn
FROM rataan
)
SELECT *
FROM top_3
WHERE rn <= 3
ORDER BY Bulan, rn

-- TOP 3 RATA-RATA TRANSAKSI PER TELLER PER CABANG PER HARI
WITH rataan AS (
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	Cabang,
	SUM([Rata-Rata Transaksi per Teller]) as RataRata_Transaksi_per_Teller,
	COUNT(DATEPART(MONTH, Tanggal)) as Banyak_Hari,
	CAST(ROUND(SUM([Rata-Rata Transaksi per Teller]) / COUNT(DATEPART(MONTH, Tanggal)), 0) AS INT) as Avg_per_Teller_per_Cabang_per_Hari
FROM [data transaksi teller dan cs]
GROUP BY DATEPART(MONTH, Tanggal), Cabang
),
top_3 AS (
SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY Bulan ORDER BY Avg_per_Teller_per_Cabang_per_Hari DESC) AS rn
FROM rataan
)
SELECT *
FROM top_3
WHERE rn <= 3
ORDER BY Bulan, rn

-- TOP 3 RATA-RATA TRANSAKSI PER CS PER CABANG PER HARI
WITH rataan AS (
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	Cabang,
	SUM([Rata-Rata Transaksi CS]) as RataRata_Transaksi_per_Teller,
	COUNT(DATEPART(MONTH, Tanggal)) as Banyak_Hari,
	CAST(ROUND(SUM([Rata-Rata Transaksi CS]) / COUNT(DATEPART(MONTH, Tanggal)), 0) AS INT) as Avg_per_CS_per_Cabang_per_Hari
FROM [data transaksi teller dan cs]
GROUP BY DATEPART(MONTH, Tanggal), Cabang
),
top_3 AS (
SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY Bulan ORDER BY Avg_per_CS_per_Cabang_per_Hari DESC) AS rn
FROM rataan
)
SELECT *
FROM top_3
WHERE rn <= 3
ORDER BY Bulan, rn

-- CABANG DENGAN JUMLAH TRANSAKSI TELLER PALING BANYAK DAN PALING SEDIKIT TIAP BULAN
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	Cabang,
	MAX([Jumlah Transaksi Teller]) as Max_Jumlah_Transaksi_Teller,
	MIN([Jumlah Transaksi Teller]) as Min_Jumlah_Transaksi_Teller
FROM [data transaksi teller dan cs]
GROUP BY DATEPART(MONTH, Tanggal), Cabang
ORDER BY Bulan, Max_Jumlah_Transaksi_Teller DESC

-- CABANG DENGAN JUMLAH TRANSAKSI CS PALING BANYAK DAN PALING SEDIKIT TIAP BULAN
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	Cabang,
	MAX([Jumlah Transaksi CS]) as Max_Jumlah_Transaksi_CS,
	MIN([Jumlah Transaksi CS]) as Min_Jumlah_Transaksi_CS
FROM [data transaksi teller dan cs]
GROUP BY DATEPART(MONTH, Tanggal), Cabang
ORDER BY Bulan, Max_Jumlah_Transaksi_CS DESC

-- 
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	[Keterangan Teller],
	COUNT([Keterangan Teller]) as Freq
FROM [data transaksi teller dan cs]
GROUP BY DATEPART(MONTH, Tanggal), [Keterangan Teller]
ORDER BY Bulan, [Keterangan Teller] DESC

-- 3 CABANG YANG MEMILIKI UNDER CAPACITY SETIAP BULAN
WITH CTE AS (
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	Cabang,
	[Keterangan Teller] as Ket,
	COUNT([Keterangan Teller]) as Freq
FROM [data transaksi teller dan cs]
WHERE [Keterangan Teller] IN ('Under', 'Over')
GROUP BY DATEPART(MONTH, Tanggal), Cabang, [Keterangan Teller]
),
UNDER AS (
SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY Bulan, Ket ORDER BY Freq DESC) as rn
FROM CTE
)
SELECT *
FROM UNDER
WHERE rn <= 3
ORDER BY Bulan, Ket, rn

-- NASABAH TELLER TERAKHIR DILAYANI
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	CASE
		WHEN TRY_CAST([Nasabah Teller terakhir dilayani] AS DECIMAL(4, 2)) < 14.00 THEN '<14.00' 
		WHEN TRY_CAST([Nasabah Teller terakhir dilayani] AS DECIMAL(4, 2)) BETWEEN 14.00 AND 14.59 THEN '14.00-14.59'
		WHEN TRY_CAST([Nasabah Teller terakhir dilayani] AS DECIMAL(4, 2)) BETWEEN 15.00 AND 15.59 THEN '15.00-15.59'
		WHEN TRY_CAST([Nasabah Teller terakhir dilayani] AS DECIMAL(4, 2)) >= 16.00 THEN '>16.00'
		ELSE '-'
	END AS Waktu_Nasabah_Teller_terakhir_dilayani,
	--[Nasabah Teller terakhir dilayani],
	COUNT([Nasabah CS terakhir dilayani]) AS Freq
FROM [data transaksi teller dan cs]
GROUP BY
	DATEPART(MONTH, Tanggal),
	CASE
		WHEN TRY_CAST([Nasabah Teller terakhir dilayani] AS DECIMAL(4, 2)) < 14.00 THEN '<14.00' 
		WHEN TRY_CAST([Nasabah Teller terakhir dilayani] AS DECIMAL(4, 2)) BETWEEN 14.00 AND 14.59 THEN '14.00-14.59'
		WHEN TRY_CAST([Nasabah Teller terakhir dilayani] AS DECIMAL(4, 2)) BETWEEN 15.00 AND 15.59 THEN '15.00-15.59'
		WHEN TRY_CAST([Nasabah Teller terakhir dilayani] AS DECIMAL(4, 2)) >= 16.00 THEN '>16.00'
		ELSE '-'
	END
ORDER BY Bulan
	

-- NASABAH CS TERAKHIR DILAYANI
SELECT
	DATEPART(MONTH, Tanggal) AS Bulan,
	CASE
		WHEN TRY_CAST([Nasabah CS terakhir dilayani] AS DECIMAL(4, 2)) < 14.00 THEN '<14.00' 
		WHEN TRY_CAST([Nasabah CS terakhir dilayani] AS DECIMAL(4, 2)) BETWEEN 14.00 AND 14.59 THEN '14.00-14.59'
		WHEN TRY_CAST([Nasabah CS terakhir dilayani] AS DECIMAL(4, 2)) BETWEEN 15.00 AND 15.59 THEN '15.00-15.59'
		WHEN TRY_CAST([Nasabah CS terakhir dilayani] AS DECIMAL(4, 2)) >= 16.00 THEN '>16.00'
		ELSE '-'
	END AS Waktu_Nasabah_CS_terakhir_dilayani,
	--[Nasabah Teller terakhir dilayani],
	COUNT([Nasabah CS terakhir dilayani]) AS Freq
FROM [data transaksi teller dan cs]
GROUP BY
	DATEPART(MONTH, Tanggal),
	CASE
		WHEN TRY_CAST([Nasabah CS terakhir dilayani] AS DECIMAL(4, 2)) < 14.00 THEN '<14.00' 
		WHEN TRY_CAST([Nasabah CS terakhir dilayani] AS DECIMAL(4, 2)) BETWEEN 14.00 AND 14.59 THEN '14.00-14.59'
		WHEN TRY_CAST([Nasabah CS terakhir dilayani] AS DECIMAL(4, 2)) BETWEEN 15.00 AND 15.59 THEN '15.00-15.59'
		WHEN TRY_CAST([Nasabah CS terakhir dilayani] AS DECIMAL(4, 2)) >= 16.00 THEN '>16.00'
		ELSE '-'
	END
ORDER BY Bulan




