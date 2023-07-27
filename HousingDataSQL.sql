

SELECT *
	FROM [Portfolio Project]..NashvilleHousingData

------------------------------------------------------------------------------------------------------------
			-- converting column SaleDate into standard date format
------------------------------------------------------------------------------------------------------------

SELECT SaleDateCoverted, CONVERT(date,SaleDate)
	FROM [Portfolio Project]..NashvilleHousingData


Alter Table [Portfolio Project]..NashvilleHousingData
	Add SaleDateCoverted Date;

Update [Portfolio Project]..NashvilleHousingData 
	SET SaleDateCoverted = CONVERT(date,SaleDate)

------------------------------------------------------------------------------------------------------------
			--Property address data
------------------------------------------------------------------------------------------------------------

SELECT *
	FROM [Portfolio Project]..NashvilleHousingData
	--WHERE PropertyAddress is NULL
	order by ParcelID

--self join to get PropertyAddress of the house having same parcelID
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
	FROM [Portfolio Project]..NashvilleHousingData a
	Join [Portfolio Project]..NashvilleHousingData b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
	WHERE a.PropertyAddress is NULL

--substitue the PropertyAddress from the house having same parcelID
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress,b.PropertyAddress) 
	FROM [Portfolio Project]..NashvilleHousingData a
	Join [Portfolio Project]..NashvilleHousingData b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
	WHERE a.PropertyAddress is NULL

Update a 
	SET PropertyAddress = ISNULL( a.PropertyAddress,b.PropertyAddress)
	FROM [Portfolio Project]..NashvilleHousingData a
	Join [Portfolio Project]..NashvilleHousingData b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
	WHERE a.PropertyAddress is NULL

------------------------------------------------------------------------------------------------------------
-- Transforming address in a proper format(Address, city, state)
------------------------------------------------------------------------------------------------------------

SELECT PropertyAddress
	FROM [Portfolio Project]..NashvilleHousingData
	--WHERE PropertyAddress is NULL

SELECT 
SUBSTRING (PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
	FROM [Portfolio Project]..NashvilleHousingData


Alter Table [Portfolio Project]..NashvilleHousingData
	Add PropertySplitAddress nvarchar(255);

Update [Portfolio Project]..NashvilleHousingData 
	SET PropertySplitAddress = SUBSTRING (PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1 )


Alter Table [Portfolio Project]..NashvilleHousingData
	Add PropertyCity nvarchar(255);

Update [Portfolio Project]..NashvilleHousingData 
	SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

------------------------------------------------------------------------------------------------------------
				-- Transforming owner's address
------------------------------------------------------------------------------------------------------------
SELECT * --OwnerAddress
	FROM [Portfolio Project]..NashvilleHousingData


SELECT 
	PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
	PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
	PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
	FROM [Portfolio Project]..NashvilleHousingData
;


Alter Table [Portfolio Project]..NashvilleHousingData
	Add OwnersAddress nvarchar(255);

Update [Portfolio Project]..NashvilleHousingData 
	SET OwnersAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


Alter Table [Portfolio Project]..NashvilleHousingData
	Add OwnerCity nvarchar(255);

Update [Portfolio Project]..NashvilleHousingData 
	SET OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)


Alter Table [Portfolio Project]..NashvilleHousingData
	Add OwnerState nvarchar(255);

Update [Portfolio Project]..NashvilleHousingData 
	SET OwnerState =  PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

-- Transforming SoldAsVacant Column as Y/N for Yes/No

SELECT Distinct(SoldAsVacant), COUNT((SoldAsVacant))
	FROM [Portfolio Project]..NashvilleHousingData 
	Group By SoldAsVacant
	order by 2


SELECT SoldAsVacant,
	CASE When SoldAsVacant = 'Y' Then 'Yes'
		 When SoldAsVacant = 'N' Then 'No'
		 ELSE SoldAsVacant
		 END
	FROM [Portfolio Project]..NashvilleHousingData 



Update [Portfolio Project]..NashvilleHousingData 
	SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
						    When SoldAsVacant = 'N' Then 'No'
							ELSE SoldAsVacant
						END
	FROM [Portfolio Project]..NashvilleHousingData 


------------------------------------------------------------------------------------------------------------
				------ Removing duplicates-----
------------------------------------------------------------------------------------------------------------

/*
Here's a step-by-step explanation of the code:

The code defines a CTE named RowNumCTE:

The CTE selects all columns from the table [Portfolio Project]..NashvilleHousingData.
It uses the ROW_NUMBER() window function to assign a sequential number to each row within partitions of data determined by specific columns.
The partitioning columns used are ParcelID, PropertyAddress, SalePrice, SaleDate, and LegalReference.
The rows within each partition are ordered by the UniqueID column in ascending order.
The main query starts with the DELETE statement:

The DELETE statement specifies that rows will be deleted from the RowNumCTE.
The WHERE clause is used to filter the rows to be deleted based on the row_num column from the CTE.
The condition row_num > 1 ensures that only rows with a row_num greater than 1 will be deleted.
The row_num greater than 1 means that the row is a duplicate within its partition since the ROW_NUMBER() function assigns 1 to the first row in each partition and increments the value for subsequent rows within the same partition.
By keeping only the row with row_num = 1 in each partition and deleting others, it effectively removes duplicates.
It is worth noting that the code includes a commented-out SELECT * statement before the DELETE. This seems to be a remnant of a previous attempt to view the data that would be deleted. When uncommented and executed, it would show the rows that are identified as duplicates by the CTE.
*/


WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	Partition By ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
	) row_num
	FROM [Portfolio Project]..NashvilleHousingData 
)
--Select * 
DELETE
	FROM RowNumCTE
	WHERE row_num > 1
	--Order By PropertyAddress

Select *
FROM [Portfolio Project]..NashvilleHousingData 


------------------------------------------------------------------------------------------------------------
				--DELETE unused columns
------------------------------------------------------------------------------------------------------------

SELECT *
	FROM [Portfolio Project]..NashvilleHousingData 

ALTER TABLE  [Portfolio Project]..NashvilleHousingData 
	DROP COLUMN OwnerAddress,
				TaxDistrict,
				PropertyAddress

ALTER TABLE  [Portfolio Project]..NashvilleHousingData 
	DROP COLUMN SaleDate

	  