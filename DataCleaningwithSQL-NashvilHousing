/*

Cleaning Data in SQL Queries

*/
select *
from PortfolioProject.dbo.NashvilHousing

--Data Format Standardization
	--Convert SaleDate into Date format
		--Sometimes the Updtae query do not do the job
			--So we write alter command with update
update NashvilHousing
set SaleDate = convert(date,SaleDate)

ALTER TABLE [dbo].[NashvilHousing]
add SaleDateConverted Date;

update [dbo].[NashvilHousing]
set SaleDateConverted = CONVERT(date,SaleDate)


--Populate Property Address Data
	--Looking into table shows that there are some fileds with null for property address which can not be accepted.
		--After being concise, it is clear that we have some fileds that have same parcel id, but one has property address and the other do not.
			-- So, we should populate these two, as they are in fact one.
				--We join the table to itself

select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilHousing a
join PortfolioProject.dbo.NashvilHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilHousing a
join PortfolioProject.dbo.NashvilHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out PropertyAddress Individual Columns(Address, City)
	-- first we want to seperate address to two part that will be seperetaed by cama.(by the help of SUBSTRING and CHARINDEX)
		--Add new columns to seperate address into two part(PropertySplitAddress,PropertySplitCity)
			--update table
select SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1) address1, SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress)+1,LEN(PropertyAddress)) address2
from PortfolioProject.dbo.NashvilHousing

Alter table [dbo].[NashvilHousing]
add PropertySplitAddress nvarchar(255)

update [dbo].[NashvilHousing]
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1)


Alter table NashvilHousing
add PropertySplitCity nvarchar(255)

update NashvilHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress)+1,LEN(PropertyAddress))


--Make 3 column out of OwnerAddress(OwnerSplitAddress,OwnerSplitCity,OwnerSplitState)
	--Using PARSENAME instead of SUBSTRING and CHARINDEX
select PARSENAME(REPLACE(OwnerAddress,',','.'),3) OwnerSplitAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) OwnerSplitState
from PortfolioProject.dbo.NashvilHousing

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

--Change Y and N to Yes and No in "Sold as Vacant" field
	--In the column 'Sold as Vacant' if we get a query with DISTINCT Function, it shows that there are 4 things(Yes,Y,No,N)
		--We should make the answers Just (Yes,NO)
			-- We do this by Case Statement
select distinct(SoldAsVacant) , count(SoldAsVacant) repetition
from NashvilHousing
group by SoldAsVacant
order by repetition

select SoldAsVacant
,CASE when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  Else SoldAsVacant
	  End
from NashvilHousing

update NashvilHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  Else SoldAsVacant
	  End

--Remove Duplicates
	--(It is not recommended to delete data from the data set permanently, instead we could use temp table when we want to omit some data)
		--here we delete duplicates, We can do this in many different ways(RANK,ORDER RANK,ROW_NUMBER), one of them that we use is Writing a CTE
			--When we want to remove duplicates, first we need to identify them> We can use RANK,ORDER RANK,ROW NUMBER
				--Writing a CTE with ROW_NUMBER
					--We need to partition data also to find duplicates (We should partition according to the field(ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference) that must be unique, otherwise there duplicated)
						--Be aware that ROW_NUMBER is a windows Function
							/*A window function performs a calculation across a set of table rows that are somehow
							related to the current row. This is comparable to the type of calculation that can be 
							done with an aggregate function. But unlike regular aggregate functions, use of a window
							function does not cause rows to become grouped into a single output row — the rows 
							retain their separate identities. Behind the scenes, the window function is able to 
							access more than just the current row of the query result.*/
with RowNumCTE as(
select *,
	ROW_NUMBER() over(
	partition by ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
	order by 
		UniqueID
		) row_num
from PortfolioProject.dbo.NashvilHousing
)
select *
from RowNumCTE
where row_num>1
order by ParcelID

		--For Delete the Duplicates
with RowNumCTE as(
select *,
	ROW_NUMBER() over(
	partition by ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
	order by 
		UniqueID
		) row_num
from PortfolioProject.dbo.NashvilHousing
)
delete
from RowNumCTE
where row_num>1


--Delete Unused Columns
	--Do not do it on row data, Just do for views
		-- As we splited address to be more useful, so we delete the originals
Alter table PortfolioProject.dbo.NashvilHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress
