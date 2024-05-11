SELECT *
FROM DabiraPortfolioProject..[Nashville Housing]

SELECT SaleDateconverted, CONVERT(Date, SaleDate)
FROM DabiraPortfolioProject..[Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD SaleDateconverted DATE

UPDATE [Nashville Housing]
SET SaleDateconverted = CONVERT(Date, SaleDate)

SELECT *
FROM DabiraPortfolioProject..[Nashville Housing]
--WHERE PropertyAddress is NUll
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM DabiraPortfolioProject..[Nashville Housing] AS a
JOIN DabiraPortfolioProject..[Nashville Housing] AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is Null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM DabiraPortfolioProject..[Nashville Housing] AS a
JOIN DabiraPortfolioProject..[Nashville Housing] AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is Null

SELECT PropertyAddress
FROM DabiraPortfolioProject..[Nashville Housing]
--WHERE PropertyAddress is NUll
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM DabiraPortfolioProject..[Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD PropertyAddressSplit nvarchar(255)

UPDATE [Nashville Housing]
SET PropertyAddressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE [Nashville Housing]
ADD PropertycitySplit nvarchar(255)

UPDATE [Nashville Housing]
SET PropertycitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT OwnerAddress
FROM DabiraPortfolioProject..[Nashville Housing]

SELECT
PARSENAME(REPLACE(OwnerAddress,',', '.') ,3) 
, PARSENAME(REPLACE(OwnerAddress,',', '.') ,2) 
, PARSENAME(REPLACE(OwnerAddress,',', '.') ,1) 
FROM DabiraPortfolioProject..[Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD OwnerAddressSplit nvarchar(255)

UPDATE [Nashville Housing]
SET OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)

ALTER TABLE [Nashville Housing]
ADD OwnerAddresscity nvarchar(255)

UPDATE [Nashville Housing]
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)

ALTER TABLE [Nashville Housing]
ADD OwnerAddressState nvarchar(255)

UPDATE [Nashville Housing]
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)

SELECT DISTINCT(SoldAsVacant), COUNT(Soldasvacant)
FROM DabiraPortfolioProject..[Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	   WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM DabiraPortfolioProject..[Nashville Housing]

UPDATE [Nashville Housing]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	   WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
ORDER BY uniqueID) row_num

FROM DabiraPortfolioProject..[Nashville Housing]
--ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


--DELETE
--FROM RowNumCTE
--WHERE row_num > 1

ALTER TABLE DabiraPortfolioProject..[Nashville Housing]
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress

ALTER TABLE DabiraPortfolioProject..[Nashville Housing]
DROP COLUMN SaleDate


















