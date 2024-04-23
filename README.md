# PortfolioProjects
## Table of Contents

- [Data Cleaning with SQL]
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
