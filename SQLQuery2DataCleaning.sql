SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
FROM [Portfolio Project].dbo.NashvilleHousing

UPDATE [Portfolio Project].dbo. NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE [Portfolio Project].dbo. NashvilleHousing
Add SaleDateConverted Date;

Update [Portfolio Project].dbo. NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate);

--Populate property address

Select *
FROM [Portfolio Project].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM [Portfolio Project].dbo.NashvilleHousing a 
JOIN [Portfolio Project].dbo.NashvilleHousing b 
	on a.ParcelID =b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project].dbo.NashvilleHousing a 
JOIN [Portfolio Project].dbo.NashvilleHousing b 
	on a.ParcelID =b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--Breaking out address into individual columns(address, city, state)

Select PropertyAddress
FROM [Portfolio Project].dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

FROM [Portfolio Project].dbo.NashvilleHousing


ALTER Table [Portfolio Project].dbo. NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio Project].dbo. NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [Portfolio Project].dbo. NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update [Portfolio Project].dbo. NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
From [Portfolio Project].dbo.NashvilleHousing

Select OwnerAddress
From [Portfolio Project].dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project].dbo. NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio Project].dbo. NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE [Portfolio Project].dbo. NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio Project].dbo. NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE [Portfolio Project].dbo. NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update [Portfolio Project].dbo. NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


Select *
From [Portfolio Project].dbo.NashvilleHousing

--Change Y and N to yes and no in 'sold as vacant' field

Select Distinct(SoldAsVacant), Count(SoldAsvacant)
From [Portfolio Project].dbo.NashvilleHousing
Group By SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant='Y' THEN 'YES'
	   When SoldAsVacant='N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project].dbo.NashvilleHousing

Update [Portfolio Project].dbo.NashvilleHousing
SET SoldAsVacant= CASE When SoldAsVacant='Y' THEN 'YES'
	   When SoldAsVacant='N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


--Remove duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio Project].dbo.NashvilleHousing
--order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num>1
Order by PropertyAddress


--Delete unused columns

Select *
From [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN SaleDate





Select *
From [Portfolio Project].dbo.NashvilleHousing