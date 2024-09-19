                                 #----------EXPLORATORY DATA ANALYSIS-------#                                  
										
                                            #---Data Exploration--#

USE hospital_db;

DESCRIBE facility;

DESCRIBE procedures;

DESCRIBE rating;
-----------------------------------------------------------
#Count Total Rows and Distinct Facilities

SELECT 
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT facility.Name) AS Distinct_Facility
FROM
    facility;

#Check Distribution of Facility Types

SELECT 
    facility.Type, COUNT(*) AS Count
FROM
    facility
GROUP BY facility.Type
ORDER BY count DESC;

# Summary Statistics for Procedure Costs

SELECT 
    ROUND(AVG(procedures.Heart_Attack_Cost)) AS avg_heart_attack_cost,
    MAX(procedures.Heart_Attack_Cost) AS max_heart_attack_cost,
    MIN(procedures.Heart_Attack_Cost) AS min_heart_attack_cost,
    ROUND(AVG(procedures.Heart_Failure_Cost)) AS avg_Heart_Failure_Cost,
    MAX(procedures.Heart_Failure_Cost) AS max_Heart_Failure_Cost,
    MIN(procedures.Heart_Failure_Cost) AS min_Heart_Failure_Cost
FROM
    procedures;
       
SELECT 
    ROUND(AVG(procedures.Hip_Knee_Cost)) AS avg_Hip_Knee_Cost,
    MAX(procedures.Hip_Knee_Cost) AS max_Hip_Knee_Cost,
    MIN(procedures.Hip_Knee_Cost) AS min_Hip_Knee_Cost
FROM
    procedures;       
       
SELECT 
    ROUND(AVG(procedures.Pneumonia_Cost)) AS avg_Pneumonia_Cost,
    MAX(procedures.Pneumonia_Cost) AS max_Pneumonia_Cost,
    MIN(procedures.Pneumonia_Cost) AS min_Pneumonia_Cost
FROM
    procedures;       
       
#Count of Ratings

SELECT 
    rating.Overall, COUNT(*) AS count
FROM
    rating
GROUP BY rating.Overall
ORDER BY rating.Overall;    

                                                   #----Data Cleaning----#  
                                                   
##-------Renaming/Atering The Table Column Names-------##

ALTER TABLE facility
RENAME COLUMN `Facility.Name` TO Name,
RENAME COLUMN `Facility.City` TO City,                                           
RENAME COLUMN `Facility.State` TO State,
RENAME COLUMN `Facility.Type` TO Type;
                                                                          
ALTER TABLE  procedures
RENAME COLUMN `Procedure.Heart Attack.Cost` TO Heart_Attack_Cost,
RENAME COLUMN `Procedure.Heart Attack.Quality` TO Heart_Attack_Quality,
RENAME COLUMN `Procedure.Heart Attack.Value` TO Heart_Attack_Value,
RENAME COLUMN `Procedure.Heart Failure.Cost` TO Heart_Failure_Cost,
RENAME COLUMN `Procedure.Heart Failure.Quality` TO Heart_Failure_Quality,
RENAME COLUMN `Procedure.Heart Failure.Value` TO Heart_Failure_Value,
RENAME COLUMN `Procedure.Hip Knee.Cost` TO Hip_Knee_Cost,
RENAME COLUMN `Procedure.Hip Knee.Quality` TO Hip_Knee_Quality,
RENAME COLUMN `Procedure.Hip Knee.Value` TO Hip_Knee_Value,
RENAME COLUMN `Procedure.Pneumonia.Cost` TO Pneumonia_Cost,
RENAME COLUMN `Procedure.Pneumonia.Quality` TO Pneumonia_Quality,
RENAME COLUMN `Procedure.Pneumonia.Value` TO Pneumonia_Value;																			      
 
ALTER TABLE  rating 
RENAME COLUMN `Rating.Effectiveness` TO Effectiveness,
RENAME COLUMN `Rating.Experience` TO Experience,
RENAME COLUMN `Rating.Imaging` TO Imaging,
RENAME COLUMN `Rating.Mortality` TO Mortality,
RENAME COLUMN `Rating.Overall` TO Overall,
RENAME COLUMN `Rating.Readmission` TO Readmission,
RENAME COLUMN `Rating.Safety` TO Safety,
RENAME COLUMN `Rating.Timeliness` TO Timeliness;


# Update Invalid Ratings (e.g., -1)

UPDATE rating 
SET 
    rating.Overall = NULL
WHERE
    rating.Overall = - 1;  

#Remove Rows with Zero Procedure Costs

DELETE FROM procedures 
WHERE
    procedures.Heart_Attack_Cost = 0
    OR procedures.Heart_Failure_Cost = 0
    OR procedures.Hip_Knee_Cost = 0
    OR procedures.Pneumonia_Cost = 0;
    
    #Remove Rows with Zero Ratings

DELETE FROM rating
WHERE
   Overall = 0
    OR Mortality = 0
    OR Safety = 0
    OR Readmission = 0
     OR Experience = 0
      OR Effectiveness = 0
       OR Timeliness = 0
        OR Imaging = 0;
        
# The ratings column that contains values such as 'above', 'below', 'same', and 'none',
#i have coverted them into ordinal values like 3 for 'above', 2 for 'same', 1 for 'below', and 0 for 'none' 

UPDATE rating                                                  
SET 
       rating.Mortality = 0
    WHERE
    rating.Mortality = 'None'; 

 UPDATE rating 
SET 
       rating.Mortality = 3
    WHERE
    rating.Mortality = 'above'; 

                                               #-------Data Integration--------#
                                               


#Create a New Column for Average Procedure Cost

alter table procedures
add column overall_procedure_avg_cost real;

UPDATE procedures 
SET 
    overall_procedure_avg_cost = ((procedures.Heart_Attack_Cost + procedures.Heart_Failure_Cost 
    + procedures.Hip_Knee_Cost + procedures.Pneumonia_Cost) / 4);
    
# Combine Quality Ratings into a Single Column   

ALTER TABLE procedures
ADD COLUMN Combined_Quality TEXT;

UPDATE procedures
SET Combined_Quality = concat(
    procedures.Heart_Attack_Quality,', ', 
    procedures.Heart_Failure_Quality,', ', 
    procedures.Hip_Knee_Quality,', ', 
    procedures.Pneumonia_Quality);

                                            #----Statistical Analysis----#  
                                            
#Correlation Between Overall Rating and Procedure Costs  

SELECT 
    rating.Overall,
    AVG(procedures.Heart_Attack_Cost) AS avg_Heart_Attack_Cost,
    AVG(procedures.Heart_Failure_Cost) AS avg_Heart_Failure_Cost,
    AVG(procedures.Hip_Knee_Cost) AS avg_Hip_Knee_Cost,
    AVG(procedures.Pneumonia_Cost) AS avg_Pneumonia_Cost
FROM
    procedures
        JOIN
    rating ON procedures.Facility_ID = rating.Facility_ID
GROUP BY rating.Overall
ORDER BY rating.Overall;                                       

#Distribution of Ratings by Facility Type

SELECT 
    facility.Type, rating.Overall, COUNT(*) AS count
FROM
    facility
        JOIN
    rating ON facility.Facility_ID = rating.Facility_ID
GROUP BY facility.Type , rating.Overall
ORDER BY facility.Type , rating.Overall;

SELECT 
    Heart_Attack_Quality, COUNT(*) AS count
FROM
    procedures
GROUP BY Heart_Attack_Quality
ORDER BY count DESC; 

#Top 10 Hospitals by Overall Rating

SELECT 
    f.Name, f.City, f.State, r.Overall
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
ORDER BY r.Overall DESC
LIMIT 10; 

#-----Track Patient Records---------#

#Total Number of Patients Per Facility

SELECT 
    Name, COUNT(*) AS Total_Patients
FROM
    facility
GROUP BY Name
ORDER BY Total_patients DESC; 
----------------------------------------------------
#Patient Distribution by State:

SELECT 
    State, COUNT(*) AS Patient_Per_State
FROM
    facility
GROUP BY State
ORDER BY Patient_Per_State DESC;  #HERE TX STAND FOR TEXAS WITH 403 TOTAL PATIENTS
--------------------------------------------------------------------------------------
                #----Evaluate Healthcare Metrics----#
                
#Average Rating of Facilities:

SELECT 
    facility.Name, AVG(rating.Overall) AS Avg_Overall_Rating
FROM
    facility
        JOIN
    rating ON facility.Facility_ID = rating.Facility_ID
GROUP BY facility.Name
ORDER BY Avg_Overall_Rating DESC;

#----Identify Facilities with Low Safety Ratings:------#

SELECT 
    facility.Name,
    facility.State, 
    rating.Safety AS low_safety_ratings
FROM
    facility
        JOIN
    rating ON facility.Facility_ID = rating.Facility_ID
WHERE
    Safety = 'Below'
GROUP BY facility.Name , facility.State , low_safety_ratings;

#---Calculate Average Cost of Each Procedures:--#

SELECT 
    f.Name, AVG(p.Heart_Attack_Cost) AS avg_heart_attack_cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
GROUP BY f.Name
ORDER BY avg_heart_attack_cost DESC;
---------
SELECT 
    f.Name, AVG(p.Heart_Failure_Cost) AS avg_Heart_Failure_Cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
GROUP BY f.Name
ORDER BY avg_Heart_Failure_Cost DESC;
----------
SELECT 
    f.Name, AVG(p.Hip_Knee_Cost) AS avg_Hip_Knee_Cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
GROUP BY f.Name
ORDER BY avg_Hip_Knee_Cost DESC;
-----------
SELECT 
    f.Name, AVG(p.Pneumonia_Cost) AS avg_Pneumonia_Cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
GROUP BY f.Name
ORDER BY avg_Pneumonia_Cost DESC;
                          
                          #-----Identify Areas for Improvement-----#
                          
#Facilities with High Readmission Rates:

SELECT DISTINCT
    f.Name, f.State, r.Readmission, r.Overall AS Overall_Rating
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
WHERE
    Readmission = 'Above' AND r.Overall = 5
ORDER BY Overall_Rating DESC;

#Patient Distribution by State(TOP 5):

SELECT 
    f.State, COUNT(f.State) AS Patient_from_each_state
FROM
    facility f
GROUP BY f.State
ORDER BY Patient_from_each_state DESC
LIMIT 5;

                                 #---Ranking Facilities by Procedure Cost-----#
 
 #Rank Facilities by Heart Attack Procedure Cost
 
SELECT 
    f.Name, 
    f.City, 
    f.State, 
    p.Heart_Attack_Cost, 
    RANK() OVER (ORDER BY p.Heart_Attack_Cost DESC) AS Cost_Rank
FROM 
    facility f
JOIN 
    procedures p 
    ON f.Facility_ID = p.Facility_ID
ORDER BY 
    Cost_Rank;

 
 #Ranking Facilities by Overall Rating within Each State
 
SELECT 
    f.Name, 
    f.State, 
    r.Overall AS overall_rating, 
    RANK() OVER (PARTITION BY f.State ORDER BY r.Overall) AS State_Rank
FROM 
    facility f
JOIN 
    rating r 
    ON f.Facility_ID = r.Facility_ID
ORDER BY 
    f.State, 
    State_Rank;


                                    #------Calculating Running Totals and Averages-------#

#Running Total of Heart Attack Procedure Costs

SELECT 
    f.Name, 
    f.City, 
    f.State, 
    p.Heart_Attack_Cost,
    SUM(p.Heart_Attack_Cost) OVER (ORDER BY p.Heart_Attack_Cost) AS Running_total_cost
FROM 
    facility f
JOIN 
    procedures p 
    ON f.Facility_ID = p.Facility_ID
ORDER BY 
    Running_total_cost;


#Moving Average of Heart Failure Procedure Cost

SELECT 
    f.Name, 
    f.City, 
    f.State, 
    p.Heart_Failure_Cost,
    AVG(p.Heart_Failure_Cost) OVER (ORDER BY p.Heart_Failure_Cost) AS Moving_Avg_cost
FROM 
    facility f
JOIN 
    procedures p 
    ON f.Facility_ID = p.Facility_ID
ORDER BY 
    Moving_Avg_cost;


                                  #-----Cumulative Metrics----#
                                  
#Cumulative Count of Facilities by Rating

SELECT 
    f.Name, 
    f.City, 
    f.State, 
    r.Overall,
    COUNT(*) OVER (ORDER BY r.Overall) AS cumulative_count
FROM 
    facility f                                 
JOIN 
    rating r 
    ON f.Facility_ID = r.Facility_ID
ORDER BY 
    cumulative_count;


#Cumulative Average of Procedure Costs by Facility Type

SELECT 
    f.Type,
    f.Name,
    p.Pneumonia_Cost,
    AVG(p.Pneumonia_Cost) OVER (PARTITION BY f.Type ORDER BY f.Name) AS cumulative_avg_cost
FROM 
    facility f
JOIN 
    procedures p 
    ON f.Facility_ID = p.Facility_ID
ORDER BY 
    f.Type,
    f.Name;


                                  #-----Identifying Top and Bottom Performers----#

#Top 5 Facilities by Hip/Knee Procedure Cost within Each City                                  

WITH RankedFacilities AS (
    SELECT 
        f.Name,
        f.City,
        f.State,
        p.Hip_Knee_Cost,
        RANK() OVER (PARTITION BY f.City ORDER BY p.Hip_Knee_Cost DESC) AS City_cost_rank
    FROM 
        procedures p                                   
    JOIN 
        facility f ON p.Facility_ID = f.Facility_ID
)
SELECT 
    Name,
    City,
    State,
    Hip_Knee_Cost,
    City_cost_rank
FROM 
    RankedFacilities
WHERE 
    City_cost_rank <= 5
ORDER BY 
    City, City_cost_rank limit 5;

#Bottom 5 Facilities by Overall Rating

WITH RankedFacilities AS (
    SELECT 
        f.Name,
        f.City,
        f.State,
        r.Overall,
        RANK() OVER (ORDER BY r.Overall asc) AS rating_rank
    FROM 
        rating r                                   
    JOIN 
        facility f ON r.Facility_ID = f.Facility_ID
)
SELECT 
    Name,
    City,
    State,
    Overall,
    rating_rank
FROM 
    RankedFacilities
WHERE 
   rating_rank <= 5
ORDER BY 
    City, rating_rank limit 5;