/*

Cleaning Data in SQL Queries

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Substring, ParseName, REPLACE, Converting Data Types

*/


Select *
From sqlproject..NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted
From sqlproject..NashvilleHousing

update sqlproject..NashvilleHousing
set SaleDate = CONVERT(date, SaleDate)


-- If above query doesn't Update properly

Alter table sqlproject..NashvilleHousing
add SaleDateConverted date;

update sqlproject..NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)






 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


Select *
From sqlproject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From sqlproject..NashvilleHousing a
JOIN sqlproject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From sqlproject..NashvilleHousing a
JOIN sqlproject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null







--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

-- Breaking out Property Adress

Select PropertyAddress
From sqlproject..NashvilleHousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from sqlproject..NashvilleHousing



Alter table sqlproject..NashvilleHousing
add PropertySplitAdress nvarchar(255);

update sqlproject..NashvilleHousing
set PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter table sqlproject..NashvilleHousing
add PropertySplitCity nvarchar(255);

update sqlproject..NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From sqlproject..NashvilleHousing






-- Breaking out Owner Adress

Select OwnerAddress
From sqlproject..NashvilleHousing

Select 
PARSENAME(REPLACE( OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE( OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE( OwnerAddress, ',', '.') , 1)
From sqlproject..NashvilleHousing



Alter table sqlproject..NashvilleHousing
add OwnerSplitAdress nvarchar(255);

Alter table sqlproject..NashvilleHousing
add OwnerSplitCity nvarchar(255);

Alter table sqlproject..NashvilleHousing
add OwnerSplitState nvarchar(255);


update sqlproject..NashvilleHousing
set OwnerSplitAdress = PARSENAME(REPLACE( OwnerAddress, ',', '.') , 3)

update sqlproject..NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE( OwnerAddress, ',', '.') , 2)

update sqlproject..NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE( OwnerAddress, ',', '.') , 1)







--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant)
From sqlproject..NashvilleHousing




Select SoldAsVacant,
 CASE when SoldAsVacant = 'N' then 'No'
	  when SoldAsVacant = 'Y' then 'Yes'
	  else SoldAsVacant
	  end
From sqlproject..NashvilleHousing




update sqlproject..NashvilleHousing
set SoldAsVacant =  CASE when SoldAsVacant = 'N' then 'No'
						 when SoldAsVacant = 'Y' then 'Yes'
						 else SoldAsVacant
						 end

						 



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


WITH RowNumCTE  AS(
select *,
	ROW_NUMBER() over (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from sqlproject..NashvilleHousing
)

delete
from RowNumCTE
where row_num>1



Select *
From sqlproject..NashvilleHousing





---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From sqlproject..NashvilleHousing


ALTER TABLE sqlproject..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate






