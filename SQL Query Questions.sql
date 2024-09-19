#Count the number of hospitals by facility type.

SELECT 
    type, COUNT(*) AS Hospital_counts
FROM
    facility
GROUP BY Type;

# Find the hospitals with the highest overall rating (5 stars) in each state.

SELECT 
    f.Name, f.State, r.Overall AS highest_rating
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
WHERE
    r.Overall = 5
GROUP BY f.Name , f.State;

# List hospitals where the mortality rating is below the national average.

SELECT 
    f.Name,f.City, f.State,r.Mortality as Mortality_Rating
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
WHERE
    r.Mortality = 1;
    
    # Compare the average overall rating between government and private hospitals
    
    SELECT 
    f.Type, AVG(r.overall) AS Avg_Ovr_Rating
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
WHERE
    f.Type IN ('Private' , 'Government')
GROUP BY f.Type;
    
    # Find the hospitals with the highest average cost for each procedure (Heart Attack, Heart Failure, Pneumonia, Hip/Knee).
    
    #---------Heart Attack---------#
    
    SELECT 
    f.Name, p.Heart_Attack_Cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
ORDER BY p.Heart_Attack_Cost DESC
LIMIT 10;

    #---------Heart Failure---------#
	
    SELECT 
    f.Name, p.Heart_Failure_Cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
ORDER BY p.Heart_Failure_Cost DESC
LIMIT 10;
   
   #---------Pneumonia---------#
 SELECT 
    f.Name, p.Pneumonia_Cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
ORDER BY p.Pneumonia_Cost DESC
LIMIT 10; 
    
    #---------Hip/Knee---------#
    
  SELECT 
    f.Name, p.Hip_Knee_Cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
ORDER BY p.Hip_Knee_Cost DESC
LIMIT 10; 
    
    #List hospitals that offer the value (Lower cost) for heart attack procedures.
    
    SELECT 
    f.Name, p.Heart_Attack_Cost, p.Heart_Attack_Value
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
WHERE
    p.Heart_Attack_Value = 'Lower'
ORDER BY p.Heart_Attack_Cost ASC;
    
    #List hospitals that offer the value (Lower cost) for Pneumonia_Cost procedures.
    
    SELECT 
    f.Name, p.Pneumonia_Cost, p.Pneumonia_Value
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
WHERE
    p.Pneumonia_Value = 'Lower'
ORDER BY p.Pneumonia_Value ASC;
    
    #List hospitals that offer the value (Lower cost) for Hip_Knee_Cost procedures.
    
       SELECT 
    f.Name, p.Hip_Knee_Cost, p.Hip_Knee_Value
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
WHERE
    p.Hip_Knee_Value = 'Lower'
ORDER BY p.Hip_Knee_Cost ASC;

#Compare hospitals' safety ratings across different states.

SELECT 
    f.State,
    COUNT(CASE
        WHEN r.Safety = 3 THEN 1
    END) AS Above_safety,
    COUNT(CASE
        WHEN r.Safety = 1 THEN 1
    END) AS Below_safety
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
GROUP BY f.State;

#Compare the effectiveness of care ratings between different hospital types.

SELECT 
    f.Type,
    COUNT(CASE
        WHEN r.Effectiveness = 3 THEN 1
    END) AS Above_Effect,
    COUNT(CASE
        WHEN r.Effectiveness = 1 THEN 1
    END) AS Below_Effect
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
GROUP BY f.Type;

# Identify hospitals where readmission rates are below the national average.

SELECT 
    f.Name, f.City, f.State, r.Readmission
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
WHERE
    r.Readmission = 1;

#Calculate the average cost of care for heart attack, heart failure, pneumonia, and hip/knee procedures by state.

SELECT 
    f.State,
    AVG(p.Heart_Attack_Cost) AS Avg_Heart_Attack_Cost,
    AVG(p.Heart_Failure_Cost) AS Avg_Heart_Failure_Cost,
    AVG(p.Hip_Knee_Cost) AS Avg_Hip_Knee_Cost,
    AVG(p.Pneumonia_Cost) AS Avg_Pneumonia_Cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = f.Facility_ID
GROUP BY f.State;

#Find hospitals where the patient experience is rated above national averages.

SELECT 
    f.Name, f.City, f.State, r.Experience AS Experience_rating
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
WHERE
    Experience = 3;

#List hospitals where timeliness of care is rated as above national average.

SELECT 
    f.Name, f.City, f.State, r.Timeliness AS Timeliness_rating
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
WHERE
    Timeliness = 3;

#Identify hospitals with the most effective use of imaging (rated above the national average).

SELECT 
    f.Name, f.City, f.State, r.Imaging AS Imaging_rating
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
WHERE
    Imaging = 3;

#Compare the cost and quality of care for heart failure across hospitals.

SELECT 
    f.Name, p.Heart_Failure_Cost, p.Heart_Failure_Quality
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
WHERE
    p.Heart_Failure_Quality = 'Average'
ORDER BY p.Heart_Failure_Cost ASC;

#Hospitals with Value (Lower) & Cost for Pneumonia Treatment

SELECT 
    f.Name, p.Pneumonia_Cost, p.Pneumonia_Value
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
WHERE
    p.Pneumonia_Value = 'Lower'
ORDER BY p.Pneumonia_Cost ASC;

#Find hospitals with the best value for hip/knee procedures based on cost and quality.

SELECT 
    f.Name,
    p.Hip_Knee_Cost,
    p.Hip_Knee_Quality,
    p.Hip_Knee_Value
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
WHERE
    p.Hip_Knee_Value = 'Lower'
ORDER BY p.Hip_Knee_Cost ASC;

#Top 5 Hospitals with Best Overall Ratings in Each State

SELECT 
    f.Name, f.State, r.Overall
FROM
    facility f
        JOIN
    rating r ON f.Facility_ID = r.Facility_ID
WHERE
    r.Overall = 5
ORDER BY f.State , r.Overall limit 5;

#Analyze the relationship between heart attack cost and mortality rating.

SELECT 
    f.Name, p.Heart_Attack_Cost, r.Mortality AS Mortality_Rating
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID
        JOIN
    rating r ON p.Facility_ID = r.Facility_ID
WHERE
    r.Mortality IN ('3' , '1')
ORDER BY p.Heart_Attack_Cost DESC;

#Identify the most expensive and cheapest hospitals for each procedure.

SELECT 
    MAX(p.Heart_Attack_Cost) AS Max_heart_attack_cost,
    MIN(p.Heart_Attack_Cost) AS Min_heart_attack_cost,
    MAX(p.Hip_Knee_Cost) AS Max_Hip_Knee_Cost,
    MIN(p.Hip_Knee_Cost) AS Min_Hip_Knee_Cost
FROM
    facility f
        JOIN
    procedures p ON f.Facility_ID = p.Facility_ID;
