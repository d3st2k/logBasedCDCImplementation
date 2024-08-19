
-- Insert a new record in the Person table
INSERT INTO [LogCDCDatabase].[dbo].[Person] VALUES ('Fisteku', 'Filani', '2000-01-01', 'filanfisteku@gmail.com', '+38349123123', 'RBKO-Pejton');

-- Delete a record from the Person table
DELETE FROM [LogCDCDatabase].[dbo].[Person] WHERE PersonID = 1003;

SELECT * FROM [LogCDCDatabase].[dbo].[Person];

-- Check the CDC table
SELECT * FROM [cdc].[dbo_Person_CT];
