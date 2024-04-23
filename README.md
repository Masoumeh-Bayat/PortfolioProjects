# PortfolioProjects
## Table of Contents

- [Data Cleaning with SQL](#Data_Cleaning_with_SQL)
  
  - Data Format Standardization
  
  - [Populate Property Address Data](#Populate_Property)       
  
- [SQL Data Exploration]


## Data Cleaning with SQL

```
select *
from PortfolioProject.dbo.NashvilHousing
```


### Data Format Standardization
Convert SaleDate into Date format

```
ALTER TABLE [dbo].[NashvilHousing]
add SaleDateConverted Date;

update [dbo].[NashvilHousing]
set SaleDateConverted = CONVERT(date,SaleDate)
```

### Populate Property
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
