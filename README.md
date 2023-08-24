# HousingDataRevive - Housing Data Cleaning Project

In this data analytics project, we have used a comprehensive dataset of housing properties. The aim is to uncover valuable insights about housing properties, their transactions, and related attributes. 
Our objective is to perform a thorough analysis of the data using SQL to gain insights and prepare the dataset for further analysis. This analysis will provide a foundation for more advanced data exploration and modeling in the field of housing market trends and property evaluation.The dataset includes attributes such as the owner's address, property address, owner's name, sale date, sale price, total rooms, and more. 

## Data Cleaning Process

1. Converting the SaleDate into Standard Date Format: SQL's date manipulation functions are used. This step ensures consistency in date representation for accurate analysis.

2. Explore property address Data: Involves examining address-related attributes to identify patterns, inconsistencies, or missing values that might require cleaning and standardization. Also separating address into individual columns such as Address, City, State.

3. Self-Join for PropertyAddress: We will perform a self-join operation on the dataset to retrieve the property address of houses sharing the same parcelID. This step allows us to gain insights into properties with multiple units or structures.

4. Transforming Owner's Address: Similar to the property address, we will also work on transforming and standardizing the owner's address data. This ensures uniformity and accuracy in the owner's address information.

6. Removing Duplicates: Duplicate entries can skew analysis results. We will identify and remove duplicate rows from the dataset based on unique identifiers such as parcelID or owner's name. This step guarantees that each record represents a unique property or transaction.

7. Deleting Unused Columns: We will identify and delete columns that are not contributing to the analysis. This action simplifies the dataset structure while improving query performance.

##Data Sources

 The original dataset is stored in an Excel file called NashvilleHousingData.xlsx. This file is located in the root directory of the repository.
