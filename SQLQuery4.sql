Select *
FROM PortfolioProject..NashvilleHousing NashvilleHousing

--Standardising Date Format
Select SaleDate, Convert(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date

Update PortfolioProject..NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

Select *
From PortfolioProject.dbo.NashvilleHousing

--Populating Property Address
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is not null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.UniqueID <> b.UniqueID
 where a.PropertyAddress is NULL

  
  --Breakdown of Address into Columns (Address, City, State)
SELECT
 SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress)-1) As Address,
 SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) As Address
 From PortfolioProject.dbo.NashvilleHousing 

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 Add PropertySplitAddress Nvarchar(255);

 UPDATE PortfolioProject.dbo.NashvilleHousing
 Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress)-1)

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 Add PropertySplitCity nvarchar(255);

 UPDATE PortfolioProject.dbo.NashvilleHousing
 Set PropertySplitCity = SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress))

 
 --Breakdown of Owner Address
 Select
 PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
 PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
 PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
 From PortfolioProject.dbo.NashvilleHousing

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 Add OwnerSplitAddress Nvarchar(255);

 UPDATE PortfolioProject.dbo.NashvilleHousing
 Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 Add OwnerSplitCity nvarchar(255);

 UPDATE PortfolioProject.dbo.NashvilleHousing
 Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 Add OwnerSplitState nvarchar(255);

 UPDATE PortfolioProject.dbo.NashvilleHousing
 Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

 

 --Changing Y and N to Yes and No
 Select SoldAsVacant
 ,CASE when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END
 From PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END
	   Select*
	   FRom PortfolioProject.dbo.NashvilleHousing

--To Remove Duplicate Entries
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
      PARTITION BY ParcelID,
	               PropertyAddress,
	               SaleDate,
				   SalePrice,
				   LegalReference
				   ORDER BY
				   UniqueID) as row_num
 FROM PortfolioProject.dbo.NashvilleHousing)

 
 