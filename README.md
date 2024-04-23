# PortfolioProjects
## Table of Contents

- [Data Cleaning with SQL](#Data_Cleaning_with_SQL
  
  - Data Format Standardization
  
  - [Populate Property Address Data]      
  
- [SQL Data Exploration]


## Data Cleaning with SQL

```
select *
from PortfolioProject.dbo.NashvilHousing
```


### Data Format Standardization
Convert SaleDate into Date format

```
select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)
```

--If it doesn't Update properly

```
ALTER TABLE [dbo].[NashvilHousing]
add SaleDateConverted Date;

update [dbo].[NashvilHousing]
set SaleDateConverted = CONVERT(date,SaleDate)
```

### Populate Property Address Data
There are some fileds with null for property!

The table has some fileds with same parcel id, but one has property address and the other do not. So, we should populate these two.

```
select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilHousing a
join PortfolioProject.dbo.NashvilHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null
```
```
update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilHousing a
join PortfolioProject.dbo.NashvilHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null
```

### Breaking out Property Address into Individual Columns(Address, City, State)

```
select SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1) address1,
SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress)+1,LEN(PropertyAddress)) address2
from PortfolioProject.dbo.NashvilHousing
```
```
Alter table [dbo].[NashvilHousing]
add PropertySplitAddress nvarchar(255)

update [dbo].[NashvilHousing]
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1)


Alter table NashvilHousing
add PropertySplitCity nvarchar(255)

update NashvilHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress)+1,LEN(PropertyAddress))
```

#### Make 3 columns out of OwnerAddress(OwnerSplitAddress,OwnerSplitCity,OwnerSplitState)
```
select PARSENAME(REPLACE(OwnerAddress,',','.'),3) OwnerSplitAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) OwnerSplitState
from PortfolioProject.dbo.NashvilHousing
```
```
Alter table NashvilHousing
add OwnerSplitAddress nvarchar(255)

alter table NashvilHousing
add OwnerSplitCity nvarchar(255)

alter table NashvilHousing
add OwnerSplitState nvarchar(255)

update NashvilHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

update NashvilHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

update NashvilHousing
set OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)
```

## Change Y and N to Yes and No in "Sold as Vacant" field
```
select distinct(SoldAsVacant) , count(SoldAsVacant) repetition
from NashvilHousing
group by SoldAsVacant
order by repetition
```
```
select SoldAsVacant
,CASE when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  Else SoldAsVacant
	  End
from NashvilHousing
```

```
update NashvilHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  Else SoldAsVacant
	  End
```
